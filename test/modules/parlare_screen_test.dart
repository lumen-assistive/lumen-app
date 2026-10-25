import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/parlare_screen.dart';

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
    'tapping a real phrase shows it and records a usage suggestion',
    (tester) async {
      await tester.pumpWidget(_wrap(const ParlareScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Acqua').first);
      await tester.pumpAndSettle();

      expect(find.text('Acqua'), findsWidgets);
      await tester.scrollUntilVisible(
        find.text('Suggerimenti principali'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Suggerimenti principali'), findsOneWidget);
    },
  );
}
