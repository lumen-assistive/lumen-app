import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/reading_screen.dart';

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
  testWidgets('splits the default sample word into real syllables', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2400, 7200);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap(const ReadingScreen()));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Split into syllables'));

    await tester.tap(find.text('Split into syllables'));
    await tester.pumpAndSettle();

    expect(find.text('pa-tria'), findsOneWidget);
  });

  testWidgets('the real SM-2 scheduler advances after a perfect recall', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2400, 7200);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap(const ReadingScreen()));
    await tester.pumpAndSettle();

    final qualityButtonFinder = find.widgetWithText(OutlinedButton, '5');
    await tester.ensureVisible(qualityButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(qualityButtonFinder);
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Next review in 1 day(s), easiness 2.60'),
      findsOneWidget,
    );
  });
}
