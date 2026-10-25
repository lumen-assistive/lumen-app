import 'package:flutter/material.dart';
import 'package:lumen_plugin_parlare/lumen_plugin_parlare.dart';

import '../l10n/app_strings.dart';
import 'widgets/module_note.dart';
import 'widgets/tool_card.dart';

/// Parlare (Speak) module screen.
///
/// Runs the real `PhraseBoard` and `PhraseUsageTracker` from
/// `lumen_plugin_parlare`. Real text-to-speech output and bundled
/// pictogram images are not implemented: tapping a phrase here shows
/// it large on screen and records its use, it does not speak it aloud.
class ParlareScreen extends StatefulWidget {
  const ParlareScreen({super.key});

  @override
  State<ParlareScreen> createState() => _ParlareScreenState();
}

class _ParlareScreenState extends State<ParlareScreen> {
  final PhraseBoard _phraseBoard = PhraseBoard();
  final PhraseUsageTracker _usageTracker = PhraseUsageTracker();

  Phrase? _selectedPhrase;
  List<Phrase> _suggestions = [];

  void _selectPhrase(Phrase phrase) {
    _usageTracker.recordUse(phrase.id);
    final topIds = _usageTracker.topSuggestions(limit: 3);
    setState(() {
      _selectedPhrase = phrase;
      _suggestions = topIds
          .map((id) => _phraseBoard.byId(id))
          .whereType<Phrase>()
          .toList();
    });
  }

  String _categoryLabel(AppStrings strings, PhraseCategory category) {
    return switch (category) {
      PhraseCategory.needs => strings('parlareCategoryNeeds'),
      PhraseCategory.greetings => strings('parlareCategoryGreetings'),
      PhraseCategory.emotions => strings('parlareCategoryEmotions'),
      PhraseCategory.emergency => strings('parlareCategoryEmergency'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isItalian = Localizations.localeOf(context).languageCode == 'it';
    return Scaffold(
      appBar: AppBar(title: Text(strings('moduleNameParlare'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModuleNote(text: strings('parlareNote')),
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
              title: strings('parlareSuggestionsTitle'),
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
        ],
      ),
    );
  }
}
