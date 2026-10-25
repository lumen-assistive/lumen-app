import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/hearing_screen.dart';

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
  testWidgets('summarizes the default sample transcript for real', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const HearingScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Riassumi'));
    await tester.pumpAndSettle();

    expect(find.textContaining('gatto'), findsWidgets);
    expect(find.textContaining('Nessuna frase'), findsNothing);
  });

  testWidgets('maps a real sound label to a vibration presentation', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const HearingScreen()));
    await tester.pumpAndSettle();

    final alertButtonFinder =
        find.widgetWithText(ElevatedButton, 'Mostra presentazione');
    await tester.scrollUntilVisible(
      alertButtonFinder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(alertButtonFinder);
    await tester.pumpAndSettle();

    expect(find.textContaining('Vibrazione:'), findsOneWidget);
  });
}
