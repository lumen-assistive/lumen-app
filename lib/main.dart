import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/storage/in_memory_app_database.dart';

// Runs on InMemoryAppDatabase for now: SqlCipherAppDatabase (see
// lib/src/storage/sqlcipher_app_database.dart) is ready, but wiring it
// in needs a real per-device passphrase (for example via
// flutter_secure_storage) and a real documents-directory path (for
// example via path_provider), neither of which is a dependency of
// this package yet. Shipping with working in-memory storage now is
// preferable to shipping a build that crashes on launch or fakes
// persistence it does not have; state simply does not survive an app
// restart until that wiring lands.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(LumenApp(database: InMemoryAppDatabase()));
}
