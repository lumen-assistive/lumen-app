import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'app_database.dart';
import 'in_memory_app_database.dart';
import 'sqlcipher_app_database.dart';

/// The result of opening the app's storage.
class OpenedDatabase {
  const OpenedDatabase({required this.database, required this.isDurable});

  final AppDatabase database;

  /// `false` when the encrypted database could not be opened and the app
  /// fell back to memory, so state will not survive a restart.
  final bool isDurable;
}

const _passphraseKey = 'lumen.database.passphrase';

/// Opens the encrypted on-device database.
///
/// The SQLCipher passphrase is 32 random bytes generated on first launch
/// and stored in the Android keystore through `flutter_secure_storage`; it
/// never appears in source or in the database directory. The file lives in
/// the app's private support directory, which other apps cannot read.
///
/// If anything fails (keystore unavailable, directory not writable), the
/// app still starts on an [InMemoryAppDatabase] rather than crashing: a
/// usable app that forgets its settings is better than one that cannot
/// open at all. [OpenedDatabase.isDurable] tells the caller which it got.
Future<OpenedDatabase> openAppDatabase({
  FlutterSecureStorage storage = const FlutterSecureStorage(),
}) async {
  try {
    var passphrase = await storage.read(key: _passphraseKey);
    if (passphrase == null) {
      final random = Random.secure();
      passphrase = base64UrlEncode(
        List<int>.generate(32, (_) => random.nextInt(256)),
      );
      await storage.write(key: _passphraseKey, value: passphrase);
    }
    final directory = await getApplicationSupportDirectory();
    await directory.create(recursive: true);
    final database = SqlCipherAppDatabase(
      databasePath: '${directory.path}${Platform.pathSeparator}lumen.db',
      passphrase: passphrase,
    );
    // Opening here, not lazily on first use, so a corrupt or unreadable
    // database is detected now and the fallback below can still apply.
    await database.loadUserProfile();
    return OpenedDatabase(database: database, isDurable: true);
  } on Object {
    return OpenedDatabase(database: InMemoryAppDatabase(), isDurable: false);
  }
}
