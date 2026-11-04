import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/storage/module_state_codecs.dart';
import 'package:lumen_plugin_family/lumen_plugin_family.dart';
import 'package:lumen_plugin_memory/lumen_plugin_memory.dart';

void main() {
  test('a person survives a JSON round trip, consent included', () {
    final person = PersonProfile(
      id: 'person-3',
      name: 'Maria',
      relationship: 'daughter',
      notes: 'Visits on Sundays',
      consentGiven: true,
      consentTimestamp: DateTime(2026, 11, 4, 10, 30),
    );
    final decoded = personFromJson(personToJson(person))!;
    expect(decoded.id, person.id);
    expect(decoded.name, person.name);
    expect(decoded.notes, person.notes);
    expect(decoded.consentGiven, isTrue);
    expect(decoded.consentTimestamp, person.consentTimestamp);
  });

  test('a reminder keeps its due time, recurrence and completion', () {
    final reminder = Reminder(
      id: 'reminder-2',
      title: 'Take medicine',
      dueAt: DateTime(2026, 11, 5, 8),
      recurrence: ReminderRecurrence.daily,
      completed: true,
    );
    final decoded = reminderFromJson(reminderToJson(reminder))!;
    expect(decoded.dueAt, reminder.dueAt);
    expect(decoded.recurrence, ReminderRecurrence.daily);
    expect(decoded.completed, isTrue);
  });

  test('a calendar event keeps its span and recurrence', () {
    final event = CalendarEvent(
      id: 'event-1',
      title: 'Doctor visit',
      start: DateTime(2026, 11, 6, 9),
      end: DateTime(2026, 11, 6, 9, 30),
      recurrence: CalendarRecurrence.weekly,
    );
    final decoded = eventFromJson(eventToJson(event))!;
    expect(decoded.end.difference(decoded.start), const Duration(minutes: 30));
    expect(decoded.recurrence, CalendarRecurrence.weekly);
  });

  test('malformed records decode to null instead of throwing', () {
    expect(personFromJson('nope'), isNull);
    expect(personFromJson({'id': 1, 'name': 'x', 'relationship': 'y'}), isNull);
    expect(reminderFromJson({'id': 'a', 'title': 'b'}), isNull);
    expect(eventFromJson(<String, Object?>{}), isNull);
  });

  test('decodeList skips entries that do not decode', () {
    final people = decodeList(
      [
        {'id': 'p1', 'name': 'A', 'relationship': 'friend'},
        'garbage',
        {'id': 'p2', 'name': 'B', 'relationship': 'friend'},
      ],
      personFromJson,
    );
    expect(people.map((person) => person.id), ['p1', 'p2']);
    expect(decodeList('not a list', personFromJson), isEmpty);
  });

  test('an unknown recurrence name falls back to none', () {
    final decoded = reminderFromJson({
      'id': 'r',
      'title': 't',
      'dueAt': 0,
      'recurrence': 'monthly',
    })!;
    expect(decoded.recurrence, ReminderRecurrence.none);
  });
}
