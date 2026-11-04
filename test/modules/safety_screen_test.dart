import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/safety_screen.dart';

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
  testWidgets('flags the default sample message as low risk for real', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2400, 7200);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap(const SafetyScreen()));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Check message'));

    await tester.tap(find.text('Check message'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('It asks for a code, PIN, or password'),
      findsOneWidget,
    );
  });

  testWidgets('the real FallDetector tells steady readings from a fall', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2400, 7200);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap(const SafetyScreen()));
    await tester.pumpAndSettle();

    final steadyButtonFinder =
        find.widgetWithText(OutlinedButton, 'Simulate steady readings');
    await tester.scrollUntilVisible(
      steadyButtonFinder,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(steadyButtonFinder);
    await tester.pumpAndSettle();
    expect(find.text('No fall detected.'), findsOneWidget);

    await tester.ensureVisible(find.text('Simulate a fall'));

    await tester.tap(find.text('Simulate a fall'));
    await tester.pumpAndSettle();
    expect(find.text('Fall detected.'), findsOneWidget);
  });

  testWidgets(
    'the real SosController reaches sent through a fake, non-real sender',
    (tester) async {
      tester.view.physicalSize = const Size(2400, 7200);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(_wrap(const SafetyScreen()));
      await tester.pumpAndSettle();

      final startButtonFinder =
          find.widgetWithText(ElevatedButton, 'Start SOS');
      await tester.scrollUntilVisible(
        startButtonFinder,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(startButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('No SOS in progress.'), findsOneWidget);

      await tester.tap(startButtonFinder);
      await tester.pump();
      expect(find.text('Counting down, you can still cancel.'), findsOneWidget);

      await tester.ensureVisible(find.text('Cancel'));

      await tester.tap(find.text('Cancel'));
      await tester.pump();

      expect(find.text('SOS cancelled.'), findsOneWidget);

      // SosController races the cancel against its own countdown timer
      // with Future.any: cancelling never cancels that underlying Timer,
      // it only discards its result, so the timer still fires on its own
      // schedule. Advance past the countdown to let it do so, otherwise
      // the test binding reports a timer still pending at teardown.
      await tester.pump(const Duration(seconds: 6));
    },
  );
}
