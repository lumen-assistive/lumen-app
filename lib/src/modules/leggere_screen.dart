import 'package:flutter/material.dart';
import 'package:lumen_plugin_leggere/lumen_plugin_leggere.dart';

import '../l10n/app_strings.dart';
import 'widgets/module_note.dart';
import 'widgets/tool_card.dart';

/// Leggere e Studiare (Read and Study) module screen.
///
/// Runs the real `ItalianSyllableSplitter` and
/// `SpacedRepetitionScheduler` from `lumen_plugin_leggere`. Reading
/// scanned text aloud and dyslexia-specific text adaptation beyond
/// syllable splitting are not implemented.
class LeggereScreen extends StatefulWidget {
  const LeggereScreen({super.key});

  @override
  State<LeggereScreen> createState() => _LeggereScreenState();
}

class _LeggereScreenState extends State<LeggereScreen> {
  static const _splitter = ItalianSyllableSplitter();
  static const _scheduler = SpacedRepetitionScheduler();

  final _wordController = TextEditingController(text: 'patria');
  String? _syllableResult;

  int _repetitionCount = 0;
  int _intervalDays = 1;
  double _easinessFactor = 2.5;
  String? _flashcardResult;

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

  void _runSplitter() {
    final words = _wordController.text.trim().split(RegExp(r'\s+'));
    final result = words
        .where((word) => word.isNotEmpty)
        .map((word) => _splitter.split(word).join('-'))
        .join(' ');
    setState(() => _syllableResult = result);
  }

  void _reviewFlashcard(int quality) {
    final outcome = _scheduler.review(
      quality: quality,
      previousRepetitionCount: _repetitionCount,
      previousIntervalDays: _intervalDays,
      previousEasinessFactor: _easinessFactor,
    );
    final strings = AppStrings.of(context);
    setState(() {
      _repetitionCount = outcome.repetitionCount;
      _intervalDays = outcome.intervalDays;
      _easinessFactor = outcome.easinessFactor;
      _flashcardResult = strings('leggereFlashcardResult')
          .replaceAll('{days}', outcome.intervalDays.toString())
          .replaceAll('{ease}', outcome.easinessFactor.toStringAsFixed(2))
          .replaceAll('{streak}', outcome.repetitionCount.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings('moduleNameLeggere'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModuleNote(text: strings('leggereNote')),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('leggereSyllableTitle'),
            children: [
              TextField(
                controller: _wordController,
                decoration: InputDecoration(
                  labelText: strings('leggereSyllableHint'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _runSplitter,
                  child: Text(strings('leggereSyllableButton')),
                ),
              ),
              if (_syllableResult != null) ToolOutput(text: _syllableResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('leggereFlashcardTitle'),
            children: [
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    strings('leggereFlashcardPrompt'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(strings('leggereFlashcardQualityHint')),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var quality = 0; quality <= 5; quality++)
                    OutlinedButton(
                      onPressed: () => _reviewFlashcard(quality),
                      child: Text('$quality'),
                    ),
                ],
              ),
              if (_flashcardResult != null) ToolOutput(text: _flashcardResult!),
            ],
          ),
        ],
      ),
    );
  }
}
