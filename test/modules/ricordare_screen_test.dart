import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/ricordare_screen.dart';

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
  testWidgets('adds a real person to the directory without consent', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const RicordareScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Aggiungi persona'));
    await tester.pumpAndSettle();

    expect(find.text('Persona aggiunta.'), findsOneWidget);
    expect(find.textContaining('consenso non dato'), findsOneWidget);
  });

  testWidgets('adds a real reminder due immediately and finds it due', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const RicordareScreen()));
    await tester.pumpAndSettle();

    final addReminderButtonFinder =
        find.widgetWithText(ElevatedButton, 'Aggiungi promemoria');
    await tester.scrollUntilVisible(
      addReminderButtonFinder,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(addReminderButtonFinder, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.textContaining('Take medicine'), findsOneWidget);
  });
}
