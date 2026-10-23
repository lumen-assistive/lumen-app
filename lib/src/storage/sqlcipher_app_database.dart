import 'package:sqflite_sqlcipher/sqflite.dart';

import 'app_database.dart';
import 'module_config.dart';
import 'user_profile.dart';
import '../theme/ui_mode.dart';

/// Production [AppDatabase], encrypted at rest with SQLCipher.
///
/// Not exercised by this repository's test suite: `flutter test` runs
/// on a host with no platform channel, and `sqflite_sqlcipher` needs a
/// real Android, iOS, or desktop runtime to open an encrypted
/// database. It is exercised through [InMemoryAppDatabase] in tests
/// instead; verifying this class end to end requires running the app
/// on a real device or emulator, which has not been done in this
/// environment. Review this class with extra care for exactly that
/// reason.
class SqlCipherAppDatabase implements AppDatabase {
  SqlCipherAppDatabase({required this.databasePath, required this.passphrase});

  /// Full path to the database file, typically under the app's
  /// documents directory (for example via `path_provider`, which is
  /// not yet wired into this repository; see the README).
  final String databasePath;

  /// The SQLCipher passphrase. Callers are responsible for generating
  /// and storing this securely (for example with `flutter_secure_storage`,
  /// not yet wired into this repository; see the README) and must
  /// never hardcode a real passphrase in source.
  final String passphrase;

  Database? _database;

  Future<Database> _open() async {
    final existing = _database;
    if (existing != null) return existing;

    final database = await openDatabase(
      databasePath,
      password: passphrase,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_profile (
            id INTEGER PRIMARY KEY CHECK (id = 0),
            ui_mode TEXT NOT NULL,
            enabled_module_ids TEXT NOT NULL,
            text_scale REAL NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE module_config (
            module_id TEXT PRIMARY KEY,
            enabled INTEGER NOT NULL,
            consent_granted INTEGER NOT NULL
          )
        ''');
      },
    );
    _database = database;
    return database;
  }

  @override
  Future<UserProfile?> loadUserProfile() async {
    final db = await _open();
    final rows = await db.query('user_profile', where: 'id = 0', limit: 1);
    if (rows.isEmpty) return null;
    final row = rows.first;
    return UserProfile(
      uiMode: UiMode.values.byName(row['ui_mode']! as String),
      enabledModuleIds: (row['enabled_module_ids']! as String)
          .split(',')
          .where((id) => id.isNotEmpty)
          .toSet(),
      textScale: row['text_scale']! as double,
    );
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    final db = await _open();
    await db.insert('user_profile', {
      'id': 0,
      'ui_mode': profile.uiMode.name,
      'enabled_module_ids': profile.enabledModuleIds.join(','),
      'text_scale': profile.textScale,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<Map<String, ModuleConfig>> loadModuleConfigs() async {
    final db = await _open();
    final rows = await db.query('module_config');
    return {
      for (final row in rows)
        row['module_id']! as String: ModuleConfig(
          moduleId: row['module_id']! as String,
          enabled: (row['enabled']! as int) != 0,
          consentGranted: (row['consent_granted']! as int) != 0,
        ),
    };
  }

  @override
  Future<void> saveModuleConfig(ModuleConfig config) async {
    final db = await _open();
    await db.insert('module_config', {
      'module_id': config.moduleId,
      'enabled': config.enabled ? 1 : 0,
      'consent_granted': config.consentGranted ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
