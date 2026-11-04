import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/hearing_screen.dart';

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
  testWidgets('summarizes the default sample transcript for real', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2400, 7200);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap(const HearingScreen()));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Summarize'));

    await tester.tap(find.text('Summarize'));
    await tester.pumpAndSettle();

    expect(find.textContaining('gatto'), findsWidgets);
    expect(find.textContaining('No sentences recognized'), findsNothing);
  });

  testWidgets('maps a real sound label to a vibration presentation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2400, 7200);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap(const HearingScreen()));
    await tester.pumpAndSettle();

    final alertButtonFinder =
        find.widgetWithText(ElevatedButton, 'Show presentation');
    await tester.scrollUntilVisible(
      alertButtonFinder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(alertButtonFinder);
    await tester.pumpAndSettle();

    expect(find.textContaining('Vibration:'), findsOneWidget);
  });
}
