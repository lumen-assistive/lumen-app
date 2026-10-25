import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/muoversi_screen.dart';

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
  testWidgets(
    'the real GaitStabilityMonitor tells a steady walk from an unsteady one',
    (tester) async {
      await tester.pumpWidget(_wrap(const MuoversiScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Simula camminata regolare'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Ritmo regolare'), findsOneWidget);

      await tester.tap(find.text('Simula camminata irregolare'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('possibile rischio di inciampo'),
        findsOneWidget,
      );
    },
  );

  testWidgets('saves a real mobility profile with the default aid type', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const MuoversiScreen()));
    await tester.pumpAndSettle();

    final saveButtonFinder =
        find.widgetWithText(ElevatedButton, 'Salva profilo');
    await tester.ensureVisible(saveButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(saveButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Profilo salvato.'), findsOneWidget);
  });
}
