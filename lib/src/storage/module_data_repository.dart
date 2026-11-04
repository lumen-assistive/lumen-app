import 'dart:convert';

import 'app_database.dart';

/// Reads and writes the JSON document each module keeps about itself.
///
/// Every module's document is loaded once at startup into a cache, so a
/// module screen can restore its state synchronously in `initState`
/// instead of showing an empty screen while a database read completes.
/// Writes update the cache first and then the database, so a screen
/// that is rebuilt right after saving never sees stale data.
class ModuleDataRepository {
  ModuleDataRepository(this._database);

  final AppDatabase _database;
  final Map<String, Map<String, Object?>> _cache = {};

  /// Loads the stored documents for [moduleIds]. A document that fails to
  /// parse is dropped rather than crashing the app: losing one module's
  /// remembered state is better than being unable to start.
  Future<void> load(Iterable<String> moduleIds) async {
    for (final id in moduleIds) {
      final raw = await _database.loadModuleData(id);
      if (raw == null) continue;
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, Object?>) _cache[id] = decoded;
      } on FormatException {
        continue;
      }
    }
  }

  /// The stored document for [moduleId], or an empty map if there is none.
  Map<String, Object?> read(String moduleId) =>
      _cache[moduleId] ?? const <String, Object?>{};

  Future<void> write(String moduleId, Map<String, Object?> document) async {
    _cache[moduleId] = document;
    await _database.saveModuleData(moduleId, jsonEncode(document));
  }
}
