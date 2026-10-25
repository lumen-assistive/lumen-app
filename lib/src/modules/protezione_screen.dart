import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lumen_plugin_protezione/lumen_plugin_protezione.dart';
import 'package:lumen_plugin_protezione/lumen_plugin_protezione_testing.dart';

import '../l10n/app_strings.dart';
import 'widgets/module_note.dart';
import 'widgets/tool_card.dart';

List<AccelerometerSample> _samplesFrom(
    List<(int, double)> offsetsAndMagnitudes) {
  final base = DateTime(2026, 1, 1, 8);
  return [
    for (final (offsetMs, magnitude) in offsetsAndMagnitudes)
      AccelerometerSample(
        x: 0,
        y: 0,
        z: magnitude,
        timestamp: base.add(Duration(milliseconds: offsetMs)),
      ),
  ];
}

final _steadySamples = _samplesFrom([
  (0, 9.8),
  (200, 10.1),
  (400, 9.6),
  (600, 9.9),
  (800, 10.0),
  (1000, 9.7),
]);

final _fallSamples = _samplesFrom([
  (0, 9.8),
  (100, 1.0),
  (200, 0.9),
  (300, 1.0),
  (400, 0.8),
  (450, 0.9),
  (500, 30.0),
  (600, 9.5),
  (800, 10.0),
  (1000, 9.7),
  (1200, 10.1),
  (1400, 9.6),
  (1600, 9.9),
  (1800, 10.0),
  (2000, 9.8),
  (2200, 9.9),
]);

/// Protezione (Safety) module screen.
///
/// Runs the real `ScamFilter`, `FallDetector`, and `SosController` from
/// `lumen_plugin_protezione`. The SOS flow is wired to `FakeSmsSender`,
/// the package's own testing stand-in: `lumen_plugin_protezione` ships
/// no real `SmsSender` implementation at all (see the package README),
/// so this screen can run a full countdown and reach the "ready to
/// send" point but can never send a real message, by construction.
/// Live accelerometer input and a real platform SMS channel are not
/// implemented in this app yet.
class ProtezioneScreen extends StatefulWidget {
  const ProtezioneScreen({super.key});

  @override
  State<ProtezioneScreen> createState() => _ProtezioneScreenState();
}

class _ProtezioneScreenState extends State<ProtezioneScreen> {
  final ScamFilter _scamFilter = const ScamFilter();
  final FallDetector _fallDetector = const FallDetector();
  final FakeSmsSender _smsSender = FakeSmsSender();
  late final SosController _sosController = SosController(
    smsSender: _smsSender,
    cancelWindow: const Duration(seconds: 5),
  );

  final _messageController = TextEditingController(
    text: 'Il tuo conto e bloccato. Invia subito il codice OTP per sbloccarlo.',
  );

  String? _scamResult;
  String? _fallResult;
  Timer? _sosTicker;
  bool _sosInProgress = false;

  @override
  void dispose() {
    _messageController.dispose();
    _sosTicker?.cancel();
    super.dispose();
  }

  void _runScamFilter() {
    final assessment = _scamFilter.assess(_messageController.text);
    final isItalian = Localizations.localeOf(context).languageCode == 'it';
    setState(() {
      _scamResult = isItalian ? assessment.reasonIt : assessment.reasonEn;
    });
  }

  void _runFallDetector(List<AccelerometerSample> samples) {
    final detected = _fallDetector.detect(samples);
    final strings = AppStrings.of(context);
    setState(() {
      _fallResult = detected == null
          ? strings('protezioneFallNotDetected')
          : strings('protezioneFallDetected');
    });
  }

  void _startSos() {
    if (_sosController.state == SosState.countdown) return;
    if (_sosController.state != SosState.idle) _sosController.reset();
    setState(() => _sosInProgress = true);
    _sosTicker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (mounted) setState(() {});
    });
    _sosController.trigger(
      message: 'Lumen SOS: help needed.',
      recipients: const ['+390000000000'],
    ).then((_) {
      _sosTicker?.cancel();
      if (mounted) setState(() => _sosInProgress = false);
    });
  }

  void _cancelSos() {
    _sosController.cancel();
  }

  String _sosStateLabel(AppStrings strings) {
    return switch (_sosController.state) {
      SosState.idle => strings('protezioneSosIdle'),
      SosState.countdown => strings('protezioneSosCountdown'),
      SosState.sent => strings('protezioneSosSent'),
      SosState.cancelled => strings('protezioneSosCancelled'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings('moduleNameProtezione'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModuleNote(text: strings('protezioneNote')),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('protezioneScamTitle'),
            children: [
              TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: strings('protezioneScamHint'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _runScamFilter,
                  child: Text(strings('protezioneScamButton')),
                ),
              ),
              if (_scamResult != null) ToolOutput(text: _scamResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('protezioneFallTitle'),
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _runFallDetector(_steadySamples),
                      child: Text(strings('protezioneFallSteadyButton')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _runFallDetector(_fallSamples),
                      child: Text(strings('protezioneFallSimulateButton')),
                    ),
                  ),
                ],
              ),
              if (_fallResult != null) ToolOutput(text: _fallResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('protezioneSosTitle'),
            children: [
              ToolOutput(text: _sosStateLabel(strings)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _sosInProgress ? null : _startSos,
                      child: Text(strings('protezioneSosStartButton')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _sosInProgress ? _cancelSos : null,
                      child: Text(strings('protezioneSosCancelButton')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
