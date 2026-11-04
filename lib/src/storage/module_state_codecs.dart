import 'package:lumen_plugin_family/lumen_plugin_family.dart';
import 'package:lumen_plugin_memory/lumen_plugin_memory.dart';

/// JSON conversions for the plugin types module screens remember between
/// launches.
///
/// Kept apart from the screens so the formats are unit tested without a
/// widget tree. Every `fromJson` is tolerant of missing or wrongly typed
/// fields and returns `null` instead of throwing, because stored data
/// outlives the app version that wrote it and a bad record must never
/// stop a screen from opening.

Map<String, Object?> personToJson(PersonProfile person) => {
      'id': person.id,
      'name': person.name,
      'relationship': person.relationship,
      'notes': person.notes,
      'consentGiven': person.consentGiven,
      'consentTimestamp': person.consentTimestamp?.millisecondsSinceEpoch,
    };

PersonProfile? personFromJson(Object? json) {
  if (json is! Map) return null;
  final id = json['id'];
  final name = json['name'];
  final relationship = json['relationship'];
  if (id is! String || name is! String || relationship is! String) return null;
  final stamp = json['consentTimestamp'];
  return PersonProfile(
    id: id,
    name: name,
    relationship: relationship,
    notes: json['notes'] is String ? json['notes'] as String : '',
    consentGiven: json['consentGiven'] == true,
    consentTimestamp:
        stamp is int ? DateTime.fromMillisecondsSinceEpoch(stamp) : null,
  );
}

Map<String, Object?> reminderToJson(Reminder reminder) => {
      'id': reminder.id,
      'title': reminder.title,
      'dueAt': reminder.dueAt.millisecondsSinceEpoch,
      'recurrence': reminder.recurrence.name,
      'completed': reminder.completed,
    };

Reminder? reminderFromJson(Object? json) {
  if (json is! Map) return null;
  final id = json['id'];
  final title = json['title'];
  final dueAt = json['dueAt'];
  if (id is! String || title is! String || dueAt is! int) return null;
  return Reminder(
    id: id,
    title: title,
    dueAt: DateTime.fromMillisecondsSinceEpoch(dueAt),
    recurrence: ReminderRecurrence.values.asNameMap()[json['recurrence']] ??
        ReminderRecurrence.none,
    completed: json['completed'] == true,
  );
}

Map<String, Object?> eventToJson(CalendarEvent event) => {
      'id': event.id,
      'title': event.title,
      'start': event.start.millisecondsSinceEpoch,
      'end': event.end.millisecondsSinceEpoch,
      'notes': event.notes,
      'recurrence': event.recurrence.name,
    };

CalendarEvent? eventFromJson(Object? json) {
  if (json is! Map) return null;
  final id = json['id'];
  final title = json['title'];
  final start = json['start'];
  final end = json['end'];
  if (id is! String || title is! String || start is! int || end is! int) {
    return null;
  }
  return CalendarEvent(
    id: id,
    title: title,
    start: DateTime.fromMillisecondsSinceEpoch(start),
    end: DateTime.fromMillisecondsSinceEpoch(end),
    notes: json['notes'] is String ? json['notes'] as String : null,
    recurrence: CalendarRecurrence.values.asNameMap()[json['recurrence']] ??
        CalendarRecurrence.none,
  );
}

/// Decodes a JSON list through [fromJson], skipping entries that do not
/// decode.
List<T> decodeList<T>(Object? json, T? Function(Object?) fromJson) {
  if (json is! List) return const [];
  return [
    for (final item in json)
      if (fromJson(item) case final T value) value,
  ];
}

/// The largest number of phrase uses kept in the usage log. The usage
/// tracker weighs recent use, so an old tail adds nothing but size.
const maxUsageLogLength = 300;
