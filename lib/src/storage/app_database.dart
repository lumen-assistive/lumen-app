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

  /// Returns the JSON document a module stored under [moduleId], or
  /// `null` if it has stored nothing yet.
  ///
  /// Modules keep their own state (people, reminders, calendar events,
  /// phrase usage) as one opaque JSON string each, so adding or changing
  /// what a module remembers never needs a schema migration.
  Future<String?> loadModuleData(String moduleId);

  Future<void> saveModuleData(String moduleId, String json);
}
