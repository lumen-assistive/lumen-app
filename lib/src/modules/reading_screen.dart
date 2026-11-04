import 'package:flutter/material.dart';
import 'package:lumen_plugin_reading/lumen_plugin_reading.dart';

import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import 'widgets/module_header.dart';
import 'widgets/module_note.dart';
import 'widgets/tool_card.dart';

/// Reading module screen.
///
/// Runs the real `ItalianSyllableSplitter` and
/// `SpacedRepetitionScheduler` from `lumen_plugin_reading`. Reading
/// scanned text aloud and dyslexia-specific text adaptation beyond
/// syllable splitting are not implemented.
class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  static const _splitter = ItalianSyllableSplitter();
  static const _scheduler = SpacedRepetitionScheduler();
  static const _readingTimeEstimator = ReadingTimeEstimator();

  final _wordController = TextEditingController(text: 'patria');
  String? _syllableResult;

  final _readingTextController = TextEditingController(
    text:
        'The cat sleeps on the sofa. The dog runs in the garden with the cat. '
        'It is raining heavily today. The cat and the dog play together in the garden.',
  );
  String? _readingTimeResult;

  int _repetitionCount = 0;
  int _intervalDays = 1;
  double _easinessFactor = 2.5;
  String? _flashcardResult;

  @override
  void dispose() {
    _wordController.dispose();
    _readingTextController.dispose();
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

  void _runReadingTimeEstimator() {
    final minutes = _readingTimeEstimator
        .estimateMinutesForText(_readingTextController.text);
    final strings = AppStrings.of(context);
    setState(() {
      _readingTimeResult = strings('readingTimeResult')
          .replaceAll('{minutes}', minutes.toString());
    });
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
      _flashcardResult = strings('readingFlashcardResult')
          .replaceAll('{days}', outcome.intervalDays.toString())
          .replaceAll('{ease}', outcome.easinessFactor.toStringAsFixed(2))
          .replaceAll('{streak}', outcome.repetitionCount.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ModuleHeader(moduleId: 'reading'),
          const SizedBox(height: 16),
          ModuleNote(text: strings('readingNote')),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('readingSyllableTitle'),
            children: [
              TextField(
                controller: _wordController,
                decoration: InputDecoration(
                  labelText: strings('readingSyllableHint'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _runSplitter,
                  child: Text(strings('readingSyllableButton')),
                ),
              ),
              if (_syllableResult != null) ToolOutput(text: _syllableResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('readingFlashcardTitle'),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.ink, width: 2),
                ),
                child: Text(
                  strings('readingFlashcardPrompt'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Text(strings('readingFlashcardQualityHint')),
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
          const SizedBox(height: 16),
          ToolCard(
            title: strings('readingTimeTitle'),
            children: [
              TextField(
                controller: _readingTextController,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: strings('readingTimeHint'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _runReadingTimeEstimator,
                  child: Text(strings('readingTimeButton')),
                ),
              ),
              if (_readingTimeResult != null)
                ToolOutput(text: _readingTimeResult!),
            ],
          ),
        ],
      ),
    );
  }
}
