import 'package:sqflite_sqlcipher/sqflite.dart';

import 'app_database.dart';
import 'module_config.dart';
import 'user_profile.dart';
import '../theme/ui_mode.dart';

/// Production [AppDatabase], encrypted at rest with SQLCipher.
///
/// Not exercised by `flutter test`: the host test runner has no platform
/// channel, and `sqflite_sqlcipher` needs a real Android, iOS, or desktop
/// runtime to open an encrypted database. Widget and unit tests use
/// [InMemoryAppDatabase] instead. This class has been run end to end in
/// an Android emulator (create, write, kill the app, relaunch, read), but
/// not yet on physical hardware.
class SqlCipherAppDatabase implements AppDatabase {
  SqlCipherAppDatabase({required this.databasePath, required this.passphrase});

  /// Full path to the database file, under the app's private support
  /// directory (see `openAppDatabase`).
  final String databasePath;

  /// The SQLCipher passphrase: generated once per install and kept in the
  /// platform keystore (see `openAppDatabase`). Never hardcode a real
  /// passphrase in source.
  final String passphrase;

  Database? _database;

  Future<Database> _open() async {
    final existing = _database;
    if (existing != null) return existing;

    final database = await openDatabase(
      databasePath,
      password: passphrase,
      version: 2,
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
        await _createModuleData(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) await _createModuleData(db);
      },
    );
    _database = database;
    return database;
  }

  static Future<void> _createModuleData(Database db) {
    return db.execute('''
      CREATE TABLE IF NOT EXISTS module_data (
        module_id TEXT PRIMARY KEY,
        json TEXT NOT NULL
      )
    ''');
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
    await db.insert(
        'user_profile',
        {
          'id': 0,
          'ui_mode': profile.uiMode.name,
          'enabled_module_ids': profile.enabledModuleIds.join(','),
          'text_scale': profile.textScale,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
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
    await db.insert(
        'module_config',
        {
          'module_id': config.moduleId,
          'enabled': config.enabled ? 1 : 0,
          'consent_granted': config.consentGranted ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<String?> loadModuleData(String moduleId) async {
    final db = await _open();
    final rows = await db.query(
      'module_data',
      where: 'module_id = ?',
      whereArgs: [moduleId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['json']! as String;
  }

  @override
  Future<void> saveModuleData(String moduleId, String json) async {
    final db = await _open();
    await db.insert(
      'module_data',
      {'module_id': moduleId, 'json': json},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
