import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/mobility_screen.dart';

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
    'the real GaitStabilityMonitor tells a steady walk from an unsteady one',
    (tester) async {
      tester.view.physicalSize = const Size(2400, 7200);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(_wrap(const MobilityScreen()));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Simulate steady walk'));

      await tester.tap(find.text('Simulate steady walk'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Steady rhythm'), findsOneWidget);

      await tester.ensureVisible(find.text('Simulate unsteady walk'));

      await tester.tap(find.text('Simulate unsteady walk'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('possible stumble risk'),
        findsOneWidget,
      );
    },
  );

  testWidgets('saves a real mobility profile with the default aid type', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2400, 7200);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap(const MobilityScreen()));
    await tester.pumpAndSettle();

    final saveButtonFinder =
        find.widgetWithText(ElevatedButton, 'Save profile');
    await tester.ensureVisible(saveButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(saveButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Profile saved.'), findsOneWidget);
  });
}
