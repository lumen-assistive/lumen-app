import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/routing/app_router.dart';
import 'package:lumen_app/src/storage/in_memory_app_database.dart';
import 'package:lumen_app/src/storage/module_config_repository.dart';
import 'package:lumen_app/src/storage/user_profile.dart';
import 'package:lumen_app/src/storage/user_profile_repository.dart';
import 'package:lumen_app/src/theme/ui_mode.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1200, 2600);
  tester.view.devicePixelRatio = 2.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final database = InMemoryAppDatabase();
  final profiles = UserProfileRepository(database);
  final configs = ModuleConfigRepository(database);
  await profiles.load();
  await configs.load();
  await profiles.save(
    const UserProfile(
      uiMode: UiMode.complete,
      enabledModuleIds: {'vision'},
      textScale: 1,
    ),
  );
  final router = buildRouter(
    userProfileRepository: profiles,
    moduleConfigRepository: configs,
  );
  await tester.pumpWidget(
    MaterialApp.router(
      routerConfig: router,
      locale: const Locale('en'),
      localizationsDelegates: [
        AppStrings.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppStrings.supportedLocales,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a module opens on top of home and back returns to it', (
    tester,
  ) async {
    await _pumpApp(tester);
    expect(find.text("A little light, when it's needed."), findsOneWidget);

    await tester.tap(find.text('Vision'));
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text("A little light, when it's needed."), findsOneWidget);
  });

  testWidgets('settings opens on top of home and back returns to it', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text("A little light, when it's needed."), findsOneWidget);
  });
}
