import 'package:flutter/foundation.dart';

import 'app_database.dart';
import 'user_profile.dart';

/// Loads and saves the single [UserProfile], notifying listeners
/// (such as the root app widget, to rebuild with a new theme) when it
/// changes.
class UserProfileRepository extends ChangeNotifier {
  UserProfileRepository(this._database);

  final AppDatabase _database;
  UserProfile? _profile;

  /// The current profile, or `null` before [load] completes or when
  /// onboarding has not been finished yet.
  UserProfile? get profile => _profile;

  bool get hasCompletedOnboarding => _profile != null;

  Future<void> load() async {
    _profile = await _database.loadUserProfile();
    notifyListeners();
  }

  Future<void> save(UserProfile profile) async {
    await _database.saveUserProfile(profile);
    _profile = profile;
    notifyListeners();
  }
}
