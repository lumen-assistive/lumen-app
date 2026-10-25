import 'package:flutter/material.dart';
import 'package:lumen_plugin_sentire/lumen_plugin_sentire.dart';

import '../l10n/app_strings.dart';
import 'widgets/module_note.dart';
import 'widgets/tool_card.dart';

/// Sentire (Hear) module screen.
///
/// Runs the real `Summarizer` and `AlertPresentationMapper` from
/// `lumen_plugin_sentire`. Live offline captioning and real sound
/// classification need a microphone bridge and on-device models that
/// do not exist in this app yet; see `sentireNote` below and the
/// package README.
class SentireScreen extends StatefulWidget {
  const SentireScreen({super.key});

  @override
  State<SentireScreen> createState() => _SentireScreenState();
}

class _SentireScreenState extends State<SentireScreen> {
  final _summarizer = Summarizer();
  final _alertMapper = AlertPresentationMapper();

  final _transcriptController = TextEditingController(
    text: 'Il gatto dorme sul divano. Il cane corre in giardino con il gatto. '
        'Oggi piove molto a Milano. Il gatto e il cane giocano insieme in giardino.',
  );

  String? _summaryResult;
  String _selectedSoundLabel = 'smoke_alarm';
  String? _alertResult;

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
          ? strings('sentireSummaryEmpty')
          : sentences.join(' ');
    });
  }

  void _runAlertMapper() {
    final presentation = _alertMapper.presentationFor(_selectedSoundLabel);
    final strings = AppStrings.of(context);
    setState(() {
      _alertResult = strings('sentireAlertResult')
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
      appBar: AppBar(title: Text(strings('moduleNameSentire'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModuleNote(text: strings('sentireNote')),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('sentireSummaryTitle'),
            children: [
              TextField(
                controller: _transcriptController,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: strings('sentireSummaryHint'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _runSummarizer,
                  child: Text(strings('sentireSummaryButton')),
                ),
              ),
              if (_summaryResult != null) ToolOutput(text: _summaryResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('sentireAlertTitle'),
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
                  child: Text(strings('sentireAlertButton')),
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
