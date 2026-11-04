import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/settings/settings_screen.dart';
import 'package:lumen_app/src/storage/in_memory_app_database.dart';
import 'package:lumen_app/src/storage/module_config_repository.dart';
import 'package:lumen_app/src/storage/user_profile.dart';
import 'package:lumen_app/src/storage/user_profile_repository.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: [
      AppStrings.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: AppStrings.supportedLocales,
    home: child,
  );
}

void main() {
  testWidgets(
    'toggling a module enabled switch persists through the repository',
    (tester) async {
      final database = InMemoryAppDatabase();
      final userProfileRepository = UserProfileRepository(database);
      final moduleConfigRepository = ModuleConfigRepository(database);
      await userProfileRepository.load();
      await moduleConfigRepository.load();

      await tester.pumpWidget(
        _wrap(
          SettingsScreen(
            userProfileRepository: userProfileRepository,
            moduleConfigRepository: moduleConfigRepository,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(moduleConfigRepository.configFor('vision').enabled, isFalse);

      await tester.tap(find.widgetWithText(SwitchListTile, 'Vision'));
      await tester.pumpAndSettle();

      expect(moduleConfigRepository.configFor('vision').enabled, isTrue);
    },
  );

  testWidgets('developer mode toggle reveals the diagnostics entry', (
    tester,
  ) async {
    final database = InMemoryAppDatabase();
    final userProfileRepository = UserProfileRepository(database);
    final moduleConfigRepository = ModuleConfigRepository(database);
    await userProfileRepository.load();
    await moduleConfigRepository.load();

    await tester.pumpWidget(
      _wrap(
        SettingsScreen(
          userProfileRepository: userProfileRepository,
          moduleConfigRepository: moduleConfigRepository,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final developerToggleFinder = find.widgetWithText(
      SwitchListTile,
      'Developer mode',
    );
    await tester.scrollUntilVisible(
      developerToggleFinder,
      200,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Diagnostics'), findsNothing);

    await tester.tap(developerToggleFinder);
    await tester.pumpAndSettle();

    expect(find.text('Diagnostics'), findsOneWidget);
  });

  testWidgets('changing the text scale slider persists the new value', (
    tester,
  ) async {
    final database = InMemoryAppDatabase();
    final userProfileRepository = UserProfileRepository(database);
    final moduleConfigRepository = ModuleConfigRepository(database);
    await userProfileRepository.load();
    await moduleConfigRepository.load();
    await userProfileRepository.save(UserProfile.initial());

    await tester.pumpWidget(
      _wrap(
        SettingsScreen(
          userProfileRepository: userProfileRepository,
          moduleConfigRepository: moduleConfigRepository,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final initialScale = userProfileRepository.profile!.textScale;

    await tester.drag(find.byType(Slider), const Offset(80, 0));
    await tester.pumpAndSettle();

    expect(userProfileRepository.profile!.textScale, isNot(initialScale));
  });
}
