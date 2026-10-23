import 'app_database.dart';
import 'module_config.dart';
import 'user_profile.dart';

/// In-memory [AppDatabase] used throughout widget and unit tests, and
/// as a safe default before a real device's SQLCipher database is
/// wired up.
class InMemoryAppDatabase implements AppDatabase {
  UserProfile? _profile;
  final Map<String, ModuleConfig> _moduleConfigs = {};

  @override
  Future<UserProfile?> loadUserProfile() async => _profile;

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    _profile = profile;
  }

  @override
  Future<Map<String, ModuleConfig>> loadModuleConfigs() async =>
      Map.unmodifiable(_moduleConfigs);

  @override
  Future<void> saveModuleConfig(ModuleConfig config) async {
    _moduleConfigs[config.moduleId] = config;
  }
}
