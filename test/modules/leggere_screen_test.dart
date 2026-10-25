import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/leggere_screen.dart';

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
  testWidgets('splits the default sample word into real syllables', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const LeggereScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dividi in sillabe'));
    await tester.pumpAndSettle();

    expect(find.text('pa-tria'), findsOneWidget);
  });

  testWidgets('the real SM-2 scheduler advances after a perfect recall', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const LeggereScreen()));
    await tester.pumpAndSettle();

    final qualityButtonFinder = find.widgetWithText(OutlinedButton, '5');
    await tester.ensureVisible(qualityButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(qualityButtonFinder);
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Prossimo ripasso tra 1 giorno/i, facilita 2.60'),
      findsOneWidget,
    );
  });
}
