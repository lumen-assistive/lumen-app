import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lumen_plugin_safety/lumen_plugin_safety.dart';
import 'package:lumen_plugin_safety/lumen_plugin_safety_testing.dart';

import '../l10n/app_strings.dart';
import '../services/app_services.dart';
import '../services/motion_window.dart';
import 'widgets/module_header.dart';
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

/// Safety module screen.
///
/// Runs the real `ScamFilter`, `FallDetector`, and `SosController` from
/// `lumen_plugin_safety`. The SOS flow is wired to `FakeSmsSender`,
/// the package's own testing stand-in: `lumen_plugin_safety` ships
/// no real `SmsSender` implementation at all (see the package README),
/// so this screen can run a full countdown and reach the "ready to
/// send" point but can never send a real message, by construction.
/// Fall detection can also run on the phone's live accelerometer; a real
/// platform SMS channel is not implemented in this app yet.
class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  final ScamFilter _scamFilter = const ScamFilter();
  final FallDetector _fallDetector = const FallDetector();
  final CheckInScheduler _checkInScheduler = CheckInScheduler();
  static const _checkInInterval = Duration(hours: 12);
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
  String? _checkInResult;
  Timer? _sosTicker;
  bool _sosInProgress = false;

  bool _liveFall = false;
  StreamSubscription<MotionSample>? _liveSubscription;
  Timer? _liveTimer;
  final MotionWindow _liveWindow = MotionWindow();

  @override
  void dispose() {
    _messageController.dispose();
    _sosTicker?.cancel();
    _liveSubscription?.cancel();
    _liveTimer?.cancel();
    super.dispose();
  }

  void _runScamFilter() {
    final assessment = _scamFilter.assess(_messageController.text);
    setState(() {
      _scamResult = assessment.reasonEn;
    });
  }

  void _runFallDetector(List<AccelerometerSample> samples) {
    final detected = _fallDetector.detect(samples);
    final strings = AppStrings.of(context);
    setState(() {
      _fallResult = detected == null
          ? strings('safetyFallNotDetected')
          : strings('safetyFallDetected');
    });
  }

  /// Starts or stops feeding the real fall detector from the phone's
  /// accelerometer. The detector judges a stretch of readings, so the last
  /// ten seconds are kept and re-evaluated twice a second.
  void _setLiveFall(bool enabled) {
    final strings = AppStrings.of(context);
    _liveSubscription?.cancel();
    _liveTimer?.cancel();
    _liveWindow.clear();
    if (!enabled) {
      setState(() {
        _liveFall = false;
        _fallResult = null;
      });
      return;
    }
    final services = AppServices.of(context);
    _liveSubscription = services.motion.samples().listen(_liveWindow.add);
    _liveTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      final detected = _fallDetector.detect([
        for (final sample in _liveWindow.samples)
          AccelerometerSample(
            x: sample.x,
            y: sample.y,
            z: sample.z,
            timestamp: sample.timestamp,
          ),
      ]);
      if (detected == null || !mounted) return;
      // Clearing the window stops one fall from being reported again on
      // every following tick while its samples are still in the window.
      _liveWindow.clear();
      services.haptics.vibrate(const [400, 150, 400, 150, 400]);
      setState(() => _fallResult = AppStrings.of(context)('safetyLiveFall'));
    });
    setState(() {
      _liveFall = true;
      _fallResult = strings('safetyLiveWatching');
    });
  }

  void _checkIn() {
    _checkInScheduler.checkIn();
    _refreshCheckInStatus();
  }

  void _refreshCheckInStatus() {
    final strings = AppStrings.of(context);
    final overdue = _checkInScheduler.isOverdue(_checkInInterval);
    setState(() {
      _checkInResult = overdue
          ? strings('safetyCheckInOverdue')
          : strings('safetyCheckInOk');
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
      SosState.idle => strings('safetySosIdle'),
      SosState.countdown => strings('safetySosCountdown'),
      SosState.sent => strings('safetySosSent'),
      SosState.cancelled => strings('safetySosCancelled'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ModuleHeader(moduleId: 'safety'),
          const SizedBox(height: 16),
          ModuleNote(text: strings('safetyNote')),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('safetyScamTitle'),
            children: [
              TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: strings('safetyScamHint'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _runScamFilter,
                  child: Text(strings('safetyScamButton')),
                ),
              ),
              if (_scamResult != null) ToolOutput(text: _scamResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('safetyFallTitle'),
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _runFallDetector(_steadySamples),
                      child: Text(strings('safetyFallSteadyButton')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _runFallDetector(_fallSamples),
                      child: Text(strings('safetyFallSimulateButton')),
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(strings('safetyLiveToggle')),
                value: _liveFall,
                onChanged: _setLiveFall,
              ),
              if (_fallResult != null) ToolOutput(text: _fallResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('safetyCheckInTitle'),
            children: [
              Text(strings('safetyCheckInHint')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _checkIn,
                      child: Text(strings('safetyCheckInButton')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _refreshCheckInStatus,
                      child: Text(strings('safetyCheckInStatusButton')),
                    ),
                  ),
                ],
              ),
              if (_checkInResult != null) ToolOutput(text: _checkInResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('safetySosTitle'),
            children: [
              ToolOutput(text: _sosStateLabel(strings)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _sosInProgress ? null : _startSos,
                      child: Text(strings('safetySosStartButton')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _sosInProgress ? _cancelSos : null,
                      child: Text(strings('safetySosCancelButton')),
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
