import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/storage/open_app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final opened = await openAppDatabase();
  runApp(LumenApp(database: opened.database, isDurable: opened.isDurable));
}
