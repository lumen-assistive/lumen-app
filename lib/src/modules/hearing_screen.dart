import 'package:flutter/material.dart';
import 'package:lumen_plugin_hearing/lumen_plugin_hearing.dart';

import '../l10n/app_strings.dart';
import 'widgets/module_note.dart';
import 'widgets/tool_card.dart';

/// Sentire (Hear) module screen.
///
/// Runs the real `Summarizer` and `AlertPresentationMapper` from
/// `lumen_plugin_hearing`. Live offline captioning and real sound
/// classification need a microphone bridge and on-device models that
/// do not exist in this app yet; see `hearingNote` below and the
/// package README.
class HearingScreen extends StatefulWidget {
  const HearingScreen({super.key});

  @override
  State<HearingScreen> createState() => _HearingScreenState();
}

class _HearingScreenState extends State<HearingScreen> {
  final _summarizer = Summarizer();
  final _alertMapper = AlertPresentationMapper();
  final CaptionFormatter _captionFormatter = const CaptionFormatter();

  final _transcriptController = TextEditingController(
    text: 'Il gatto dorme sul divano. Il cane corre in giardino con il gatto. '
        'Oggi piove molto a Milano. Il gatto e il cane giocano insieme in giardino.',
  );

  String? _summaryResult;
  String _selectedSoundLabel = 'smoke_alarm';
  String? _alertResult;
  String? _captionResult;

  static const _sampleSoundLabels = [
    'doorbell',
    'smoke_alarm',
    'siren',
    'baby_crying',
  ];

  @override
  void dispose() {
    _transcriptController.dispose();
    super.dispose();
  }

  void _runSummarizer() {
    final sentences = _summarizer.summarize(
      _transcriptController.text,
      maxSentences: 3,
    );
    final strings = AppStrings.of(context);
    setState(() {
      _summaryResult = sentences.isEmpty
          ? strings('hearingSummaryEmpty')
          : sentences.join(' ');
    });
  }

  void _runCaptionFormatter() {
    final lines = _captionFormatter.wrap(
      _transcriptController.text,
      maxCharactersPerLine: 32,
    );
    setState(() {
      _captionResult = lines.join('\n');
    });
  }

  void _runAlertMapper() {
    final presentation = _alertMapper.presentationFor(_selectedSoundLabel);
    final strings = AppStrings.of(context);
    setState(() {
      _alertResult = strings('hearingAlertResult')
          .replaceAll('{pattern}', presentation.vibrationPatternMs.join(', '))
          .replaceAll(
            '{flash}',
            presentation.useFlash ? strings('answerYes') : strings('answerNo'),
          )
          .replaceAll('{severity}', presentation.severity.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings('moduleNameHearing'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModuleNote(text: strings('hearingNote')),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('hearingSummaryTitle'),
            children: [
              TextField(
                controller: _transcriptController,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: strings('hearingSummaryHint'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _runSummarizer,
                  child: Text(strings('hearingSummaryButton')),
                ),
              ),
              if (_summaryResult != null) ToolOutput(text: _summaryResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('hearingCaptionTitle'),
            children: [
              Text(strings('hearingCaptionHint')),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _runCaptionFormatter,
                  child: Text(strings('hearingCaptionButton')),
                ),
              ),
              if (_captionResult != null) ToolOutput(text: _captionResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('hearingAlertTitle'),
            children: [
              DropdownButton<String>(
                isExpanded: true,
                value: _selectedSoundLabel,
                items: _sampleSoundLabels
                    .map(
                      (label) =>
                          DropdownMenuItem(value: label, child: Text(label)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedSoundLabel = value);
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _runAlertMapper,
                  child: Text(strings('hearingAlertButton')),
                ),
              ),
              if (_alertResult != null) ToolOutput(text: _alertResult!),
            ],
          ),
        ],
      ),
    );
  }
}
