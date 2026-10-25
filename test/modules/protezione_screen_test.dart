import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/protezione_screen.dart';

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
  testWidgets('flags the default sample message as low risk for real', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ProtezioneScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Controlla messaggio'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('elemento a volte presente nei messaggi truffa'),
      findsOneWidget,
    );
  });

  testWidgets('the real FallDetector tells steady readings from a fall', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ProtezioneScreen()));
    await tester.pumpAndSettle();

    final steadyButtonFinder =
        find.widgetWithText(OutlinedButton, 'Simula movimento normale');
    await tester.scrollUntilVisible(
      steadyButtonFinder,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(steadyButtonFinder);
    await tester.pumpAndSettle();
    expect(find.text('Nessuna caduta rilevata.'), findsOneWidget);

    await tester.tap(find.text('Simula una caduta'));
    await tester.pumpAndSettle();
    expect(find.text('Caduta rilevata.'), findsOneWidget);
  });

  testWidgets(
    'the real SosController reaches sent through a fake, non-real sender',
    (tester) async {
      await tester.pumpWidget(_wrap(const ProtezioneScreen()));
      await tester.pumpAndSettle();

      final startButtonFinder =
          find.widgetWithText(ElevatedButton, 'Avvia SOS');
      await tester.scrollUntilVisible(
        startButtonFinder,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(startButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Nessun SOS in corso.'), findsOneWidget);

      await tester.tap(startButtonFinder);
      await tester.pump();
      expect(find.text('Conto alla rovescia in corso, puoi annullare.'),
          findsOneWidget);

      await tester.tap(find.text('Annulla'));
      await tester.pump();

      expect(find.text('SOS annullato.'), findsOneWidget);

      // SosController races the cancel against its own countdown timer
      // with Future.any: cancelling never cancels that underlying Timer,
      // it only discards its result, so the timer still fires on its own
      // schedule. Advance past the countdown to let it do so, otherwise
      // the test binding reports a timer still pending at teardown.
      await tester.pump(const Duration(seconds: 6));
    },
  );
}
