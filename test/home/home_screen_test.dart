import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/home/home_screen.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/storage/user_profile.dart';
import 'package:lumen_app/src/theme/ui_mode.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('it'),
    localizationsDelegates: [
      AppStrings.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: AppStrings.supportedLocales,
    home: child,
  );
}

void main() {
  testWidgets('tapping an enabled module tile opens that module', (
    tester,
  ) async {
    String? openedModuleId;

    await tester.pumpWidget(
      _wrap(
        HomeScreen(
          profile: const UserProfile(
            uiMode: UiMode.complete,
            enabledModuleIds: {'vision'},
            textScale: 1,
          ),
          onOpenSettings: () {},
          onOpenModule: (moduleId) => openedModuleId = moduleId,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Vedere'));
    await tester.pumpAndSettle();

    expect(openedModuleId, 'vision');
  });

  testWidgets('shows the empty state when no module is enabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        HomeScreen(
          profile: const UserProfile(
            uiMode: UiMode.complete,
            enabledModuleIds: {},
            textScale: 1,
          ),
          onOpenSettings: () {},
          onOpenModule: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
          'Nessun modulo attivo. Vai nelle impostazioni per attivarne uno.'),
      findsOneWidget,
    );
  });
}
