import 'module_config.dart';
import 'user_profile.dart';

/// Persistence contract for the app's local, encrypted data.
///
/// Two implementations exist: [InMemoryAppDatabase] for tests, and a
/// SQLCipher-backed implementation for production. Both are consumed
/// only through this interface by [UserProfileRepository] and
/// [ModuleConfigRepository], so widget and unit tests never depend on
/// a real database.
abstract class AppDatabase {
  /// Returns the stored profile, or `null` if onboarding has not been
  /// completed yet.
  Future<UserProfile?> loadUserProfile();

  Future<void> saveUserProfile(UserProfile profile);

  /// Returns every stored module configuration, keyed by module id.
  /// Modules with no stored configuration yet are simply absent from
  /// the map; callers treat that as "disabled, no consent".
  Future<Map<String, ModuleConfig>> loadModuleConfigs();

  Future<void> saveModuleConfig(ModuleConfig config);
}
