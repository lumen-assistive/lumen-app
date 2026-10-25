import 'package:flutter/material.dart';
import 'package:lumen_plugin_speech/lumen_plugin_speech.dart';

import '../l10n/app_strings.dart';
import '../theme/module_icon.dart';
import 'widgets/module_note.dart';
import 'widgets/tool_card.dart';

/// Parlare (Speak) module screen.
///
/// Runs the real `PhraseBoard` and `PhraseUsageTracker` from
/// `lumen_plugin_speech`. Real text-to-speech output and bundled
/// pictogram images are not implemented: tapping a phrase here shows
/// it large on screen and records its use, it does not speak it aloud.
class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final PhraseBoard _phraseBoard = PhraseBoard();
  final PhraseUsageTracker _usageTracker = PhraseUsageTracker();
  final SentenceBuilder _sentenceBuilder = const SentenceBuilder();

  Phrase? _selectedPhrase;
  List<Phrase> _suggestions = [];
  final List<Phrase> _sentencePhrases = [];
  String? _sentenceResult;

  void _selectPhrase(Phrase phrase) {
    _usageTracker.recordUse(phrase.id);
    final topIds = _usageTracker.topSuggestions(limit: 3);
    setState(() {
      _selectedPhrase = phrase;
      _sentencePhrases.add(phrase);
      _suggestions = topIds
          .map((id) => _phraseBoard.byId(id))
          .whereType<Phrase>()
          .toList();
    });
  }

  void _buildSentence(bool isItalian) {
    final sentence = _sentenceBuilder.compose(
      _sentencePhrases,
      locale: isItalian ? SentenceLocale.it : SentenceLocale.en,
    );
    setState(() => _sentenceResult = sentence);
  }

  void _clearSentence() {
    setState(() {
      _sentencePhrases.clear();
      _sentenceResult = null;
    });
  }

  String _categoryLabel(AppStrings strings, PhraseCategory category) {
    return switch (category) {
      PhraseCategory.needs => strings('speechCategoryNeeds'),
      PhraseCategory.greetings => strings('speechCategoryGreetings'),
      PhraseCategory.emotions => strings('speechCategoryEmotions'),
      PhraseCategory.emergency => strings('speechCategoryEmergency'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isItalian = Localizations.localeOf(context).languageCode == 'it';
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ModuleIcon(moduleId: 'speech', size: 22),
            const SizedBox(width: 10),
            Text(strings('moduleNameSpeech')),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModuleNote(text: strings('speechNote')),
          const SizedBox(height: 16),
          if (_selectedPhrase != null)
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  isItalian ? _selectedPhrase!.textIt : _selectedPhrase!.textEn,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          for (final category in PhraseCategory.values)
            ToolCard(
              title: _categoryLabel(strings, category),
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final phrase in _phraseBoard.byCategory(category))
                      ActionChip(
                        label: Text(isItalian ? phrase.textIt : phrase.textEn),
                        onPressed: () => _selectPhrase(phrase),
                      ),
                  ],
                ),
              ],
            ),
          if (_suggestions.isNotEmpty)
            ToolCard(
              title: strings('speechSuggestionsTitle'),
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final phrase in _suggestions)
                      Chip(
                        label: Text(isItalian ? phrase.textIt : phrase.textEn),
                      ),
                  ],
                ),
              ],
            ),
          ToolCard(
            title: strings('speechSentenceTitle'),
            children: [
              Text(strings('speechSentenceHint')),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final phrase in _sentencePhrases)
                    Chip(
                        label: Text(isItalian ? phrase.textIt : phrase.textEn)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _sentencePhrases.isEmpty
                          ? null
                          : () => _buildSentence(isItalian),
                      child: Text(strings('speechSentenceBuildButton')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _sentencePhrases.isEmpty ? null : _clearSentence,
                      child: Text(strings('speechSentenceClearButton')),
                    ),
                  ),
                ],
              ),
              if (_sentenceResult != null) ToolOutput(text: _sentenceResult!),
            ],
          ),
        ],
      ),
    );
  }
}
