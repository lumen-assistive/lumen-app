import 'package:flutter/material.dart';
import 'package:lumen_plugin_family/lumen_plugin_family.dart';

import '../l10n/app_strings.dart';
import '../theme/module_icon.dart';
import 'widgets/module_note.dart';
import 'widgets/tool_card.dart';

/// Famiglia e caregiver (Family and caregivers) module screen.
///
/// Runs the real `PairingCodeGenerator`, `InMemoryCalendarStore`, and
/// `DailyStatusTracker` from `lumen_plugin_family`. Actual delivery
/// to a paired caregiver device, through `lumen-server`, is not wired
/// up in this app yet: everything below runs on this device only.
class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final PairingCodeGenerator _pairingCodeGenerator = PairingCodeGenerator();
  final CalendarStore _calendarStore = InMemoryCalendarStore();
  final DailyStatusTracker _dailyStatusTracker = DailyStatusTracker();
  final CaregiverNotificationComposer _notificationComposer =
      const CaregiverNotificationComposer();

  final _eventTitleController = TextEditingController(text: 'Doctor visit');
  final _eventMinutesController = TextEditingController(text: '60');

  String? _pairingResult;
  List<CalendarEvent> _events = [];
  String? _statusResult;
  String? _notificationResult;
  int _nextEventId = 1;

  @override
  void dispose() {
    _eventTitleController.dispose();
    _eventMinutesController.dispose();
    super.dispose();
  }

  void _generatePairingCode() {
    final result = _pairingCodeGenerator.generate(now: DateTime.now());
    final strings = AppStrings.of(context);
    setState(() {
      _pairingResult = strings('familyPairingResult')
          .replaceAll('{code}', result.code)
          .replaceAll(
              '{minutes}', _pairingCodeGenerator.validity.inMinutes.toString());
    });
  }

  Future<void> _addEvent() async {
    final minutes = int.tryParse(_eventMinutesController.text) ?? 0;
    final start = DateTime.now().add(Duration(minutes: minutes));
    await _calendarStore.add(
      CalendarEvent(
        id: 'event-${_nextEventId++}',
        title: _eventTitleController.text,
        start: start,
        end: start.add(const Duration(minutes: 30)),
      ),
    );
    final events = await _calendarStore.listBetween(
      DateTime.now().subtract(const Duration(days: 1)),
      DateTime.now().add(const Duration(days: 30)),
    );
    if (!mounted) return;
    setState(() => _events = events);
  }

  String _describeStatus(DailyStatusValue value) {
    final strings = AppStrings.of(context);
    return switch (value) {
      DailyStatusValue.ok => strings('familyStatusOkResult'),
      DailyStatusValue.needsAttention => strings('familyStatusAttentionResult'),
      DailyStatusValue.unknown => strings('familyStatusUnknownResult'),
    };
  }

  void _setStatus(DailyStatusValue value) {
    _dailyStatusTracker.setToday(value);
    setState(() {
      _statusResult = _describeStatus(_dailyStatusTracker.statusForToday());
    });
  }

  void _composeNotification() {
    final now = DateTime.now();
    final status = DailyStatus(
      date: DateTime(now.year, now.month, now.day),
      value: _dailyStatusTracker.statusForToday(),
    );
    final text = _notificationComposer.compose(
      status: status,
      upcomingEvents: _events,
    );
    setState(() => _notificationResult = text);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ModuleIcon(moduleId: 'family', size: 22),
            const SizedBox(width: 10),
            Text(strings('moduleNameFamily')),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModuleNote(text: strings('familyNote')),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('familyPairingTitle'),
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _generatePairingCode,
                  child: Text(strings('familyPairingButton')),
                ),
              ),
              if (_pairingResult != null) ToolOutput(text: _pairingResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('familyCalendarTitle'),
            children: [
              TextField(
                controller: _eventTitleController,
                decoration: InputDecoration(
                  labelText: strings('familyCalendarTitleHint'),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _eventMinutesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: strings('familyCalendarMinutesHint'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addEvent,
                  child: Text(strings('familyCalendarButton')),
                ),
              ),
              for (final event in _events)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('${event.title}: ${event.start}'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('familyStatusTitle'),
            children: [
              ToolOutput(
                text: _statusResult ??
                    _describeStatus(_dailyStatusTracker.statusForToday()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _setStatus(DailyStatusValue.ok),
                      child: Text(strings('familyStatusOkButton')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          _setStatus(DailyStatusValue.needsAttention),
                      child: Text(strings('familyStatusAttentionButton')),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('familyNotificationTitle'),
            children: [
              Text(strings('familyNotificationHint')),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _composeNotification,
                  child: Text(strings('familyNotificationButton')),
                ),
              ),
              if (_notificationResult != null)
                ToolOutput(text: _notificationResult!),
            ],
          ),
        ],
      ),
    );
  }
}
