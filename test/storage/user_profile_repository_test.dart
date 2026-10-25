import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/storage/in_memory_app_database.dart';
import 'package:lumen_app/src/storage/user_profile.dart';
import 'package:lumen_app/src/storage/user_profile_repository.dart';
import 'package:lumen_app/src/theme/ui_mode.dart';

void main() {
  group('UserProfileRepository', () {
    test('load reports null before any profile has been saved', () async {
      final repository = UserProfileRepository(InMemoryAppDatabase());

      await repository.load();

      expect(repository.profile, isNull);
      expect(repository.hasCompletedOnboarding, isFalse);
    });

    test('save persists and exposes the profile immediately', () async {
      final repository = UserProfileRepository(InMemoryAppDatabase());
      const profile = UserProfile(
        uiMode: UiMode.simple,
        enabledModuleIds: {'vision'},
        textScale: 1.2,
      );

      await repository.save(profile);

      expect(repository.profile, same(profile));
      expect(repository.hasCompletedOnboarding, isTrue);
    });

    test('save notifies listeners', () async {
      final repository = UserProfileRepository(InMemoryAppDatabase());
      var notified = false;
      repository.addListener(() => notified = true);

      await repository.save(UserProfile.initial());

      expect(notified, isTrue);
    });

    test(
        'a saved profile survives a reload through a fresh repository instance backed by the same database',
        () async {
      final database = InMemoryAppDatabase();
      final writer = UserProfileRepository(database);
      const profile = UserProfile(
        uiMode: UiMode.complete,
        enabledModuleIds: {'family'},
        textScale: 1,
      );
      await writer.save(profile);

      final reader = UserProfileRepository(database);
      await reader.load();

      expect(reader.profile?.uiMode, UiMode.complete);
      expect(reader.profile?.enabledModuleIds, {'family'});
    });
  });
}
