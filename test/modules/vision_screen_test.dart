import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/vision_screen.dart';

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
  testWidgets('finds the real expiry date in the default sample text', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const VisionScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Trova la data di scadenza'));
    await tester.pumpAndSettle();

    expect(find.textContaining('2026-12-25'), findsOneWidget);
  });

  testWidgets('names the real nearest color for the default RGB values', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const VisionScreen()));
    await tester.pumpAndSettle();

    final colorButtonFinder =
        find.widgetWithText(ElevatedButton, 'Riconosci colore');
    await tester.ensureVisible(colorButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(colorButtonFinder);
    await tester.pumpAndSettle();

    expect(find.textContaining('rosso'), findsOneWidget);
  });
}
