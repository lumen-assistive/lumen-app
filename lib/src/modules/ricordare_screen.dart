import 'package:flutter/material.dart';
import 'package:lumen_plugin_ricordare/lumen_plugin_ricordare.dart';

import '../l10n/app_strings.dart';
import 'widgets/module_note.dart';
import 'widgets/tool_card.dart';

/// Ricordare (Remember) module screen.
///
/// Runs the real `PersonDirectory` and `ReminderScheduler` from
/// `lumen_plugin_ricordare`. Actual on-device face recognition is not
/// implemented: this screen only manages the consent-gated metadata
/// a future recognition feature would need, consistent with the
/// project's privacy commitment that recognition will only ever run
/// on-device with explicit consent.
class RicordareScreen extends StatefulWidget {
  const RicordareScreen({super.key});

  @override
  State<RicordareScreen> createState() => _RicordareScreenState();
}

class _RicordareScreenState extends State<RicordareScreen> {
  final PersonDirectory _personDirectory = PersonDirectory();
  final ReminderScheduler _reminderScheduler = ReminderScheduler();

  final _nameController = TextEditingController(text: 'Maria');
  final _relationshipController = TextEditingController(text: 'daughter');
  bool _consentGiven = false;
  String? _personResult;
  int _nextPersonId = 1;

  final _reminderTitleController = TextEditingController(
    text: 'Take medicine',
  );
  final _reminderMinutesController = TextEditingController(text: '0');
  String? _reminderResult;
  int _nextReminderId = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    _reminderTitleController.dispose();
    _reminderMinutesController.dispose();
    super.dispose();
  }

  void _addPerson() {
    final strings = AppStrings.of(context);
    try {
      _personDirectory.upsert(
        PersonProfile(
          id: 'person-${_nextPersonId++}',
          name: _nameController.text,
          relationship: _relationshipController.text,
          consentGiven: _consentGiven,
          consentTimestamp: _consentGiven ? DateTime.now() : null,
        ),
      );
      setState(() => _personResult = strings('ricordarePersonAdded'));
    } on PersonProfileConsentError catch (error) {
      setState(() => _personResult = error.message);
    }
  }

  void _addReminder() {
    final minutes = int.tryParse(_reminderMinutesController.text) ?? 0;
    _reminderScheduler.add(
      Reminder(
        id: 'reminder-${_nextReminderId++}',
        title: _reminderTitleController.text,
        dueAt: DateTime.now().add(Duration(minutes: minutes)),
      ),
    );
    _checkDueReminders();
  }

  void _checkDueReminders() {
    final due = _reminderScheduler.dueReminders();
    final strings = AppStrings.of(context);
    setState(() {
      _reminderResult = due.isEmpty
          ? strings('ricordareReminderNoneDue')
          : strings('ricordareReminderDue').replaceAll(
              '{titles}',
              due.map((reminder) => reminder.title).join(', '),
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings('moduleNameRicordare'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModuleNote(text: strings('ricordareNote')),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('ricordarePersonTitle'),
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: strings('ricordarePersonNameHint'),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _relationshipController,
                decoration: InputDecoration(
                  labelText: strings('ricordarePersonRelationshipHint'),
                ),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _consentGiven,
                onChanged: (value) =>
                    setState(() => _consentGiven = value ?? false),
                title: Text(strings('ricordarePersonConsent')),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addPerson,
                  child: Text(strings('ricordarePersonButton')),
                ),
              ),
              if (_personResult != null) ToolOutput(text: _personResult!),
              for (final person in _personDirectory.all())
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${person.name} (${person.relationship}): '
                    '${person.consentGiven ? strings('ricordareConsentGiven') : strings('ricordareConsentNotGiven')}',
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('ricordareReminderTitle'),
            children: [
              TextField(
                controller: _reminderTitleController,
                decoration: InputDecoration(
                  labelText: strings('ricordareReminderTitleHint'),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reminderMinutesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: strings('ricordareReminderMinutesHint'),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addReminder,
                      child: Text(strings('ricordareReminderAddButton')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _checkDueReminders,
                      child: Text(strings('ricordareReminderCheckButton')),
                    ),
                  ),
                ],
              ),
              if (_reminderResult != null) ToolOutput(text: _reminderResult!),
            ],
          ),
        ],
      ),
    );
  }
}
