import 'package:flutter/foundation.dart';

import 'app_database.dart';
import 'module_config.dart';

/// Loads and saves per-module configuration, notifying listeners when
/// it changes.
class ModuleConfigRepository extends ChangeNotifier {
  ModuleConfigRepository(this._database);

  final AppDatabase _database;
  Map<String, ModuleConfig> _configs = {};

  /// Every stored module configuration, keyed by module id. A module
  /// absent from this map has never been configured and is treated as
  /// disabled with no consent granted.
  Map<String, ModuleConfig> get configs => Map.unmodifiable(_configs);

  ModuleConfig configFor(String moduleId) =>
      _configs[moduleId] ?? ModuleConfig.disabled(moduleId);

  Future<void> load() async {
    _configs = await _database.loadModuleConfigs();
    notifyListeners();
  }

  Future<void> save(ModuleConfig config) async {
    await _database.saveModuleConfig(config);
    _configs = {..._configs, config.moduleId: config};
    notifyListeners();
  }

  Future<void> setEnabled(String moduleId, bool enabled) async {
    await save(configFor(moduleId).copyWith(enabled: enabled));
  }

  Future<void> setConsentGranted(String moduleId, bool consentGranted) async {
    await save(configFor(moduleId).copyWith(consentGranted: consentGranted));
  }
}
