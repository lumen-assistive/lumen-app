import 'package:flutter/material.dart';
import 'package:lumen_plugin_famiglia/lumen_plugin_famiglia.dart';

import '../l10n/app_strings.dart';
import 'widgets/module_note.dart';
import 'widgets/tool_card.dart';

/// Famiglia e caregiver (Family and caregivers) module screen.
///
/// Runs the real `PairingCodeGenerator`, `InMemoryCalendarStore`, and
/// `DailyStatusTracker` from `lumen_plugin_famiglia`. Actual delivery
/// to a paired caregiver device, through `lumen-server`, is not wired
/// up in this app yet: everything below runs on this device only.
class FamigliaScreen extends StatefulWidget {
  const FamigliaScreen({super.key});

  @override
  State<FamigliaScreen> createState() => _FamigliaScreenState();
}

class _FamigliaScreenState extends State<FamigliaScreen> {
  final PairingCodeGenerator _pairingCodeGenerator = PairingCodeGenerator();
  final CalendarStore _calendarStore = InMemoryCalendarStore();
  final DailyStatusTracker _dailyStatusTracker = DailyStatusTracker();

  final _eventTitleController = TextEditingController(text: 'Doctor visit');
  final _eventMinutesController = TextEditingController(text: '60');

  String? _pairingResult;
  List<CalendarEvent> _events = [];
  String? _statusResult;
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
      _pairingResult = strings('famigliaPairingResult')
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
      DailyStatusValue.ok => strings('famigliaStatusOkResult'),
      DailyStatusValue.needsAttention =>
        strings('famigliaStatusAttentionResult'),
      DailyStatusValue.unknown => strings('famigliaStatusUnknownResult'),
    };
  }

  void _setStatus(DailyStatusValue value) {
    _dailyStatusTracker.setToday(value);
    setState(() {
      _statusResult = _describeStatus(_dailyStatusTracker.statusForToday());
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings('moduleNameFamiglia'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModuleNote(text: strings('famigliaNote')),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('famigliaPairingTitle'),
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _generatePairingCode,
                  child: Text(strings('famigliaPairingButton')),
                ),
              ),
              if (_pairingResult != null) ToolOutput(text: _pairingResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('famigliaCalendarTitle'),
            children: [
              TextField(
                controller: _eventTitleController,
                decoration: InputDecoration(
                  labelText: strings('famigliaCalendarTitleHint'),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _eventMinutesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: strings('famigliaCalendarMinutesHint'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addEvent,
                  child: Text(strings('famigliaCalendarButton')),
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
            title: strings('famigliaStatusTitle'),
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
                      child: Text(strings('famigliaStatusOkButton')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          _setStatus(DailyStatusValue.needsAttention),
                      child: Text(strings('famigliaStatusAttentionButton')),
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
