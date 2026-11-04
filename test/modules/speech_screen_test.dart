import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/speech_screen.dart';
import 'package:lumen_app/src/modules/widgets/tool_card.dart';

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
  testWidgets(
    'tapping a real phrase shows it and records a usage suggestion',
    (tester) async {
      tester.view.physicalSize = const Size(2400, 7200);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(_wrap(const SpeechScreen()));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Water').first);

      await tester.tap(find.text('Water').first);
      await tester.pumpAndSettle();

      expect(find.text('Water'), findsWidgets);
      await tester.scrollUntilVisible(
        find.text('Top suggestions'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Top suggestions'), findsOneWidget);
    },
  );

  testWidgets('builds a sentence from the selected phrases', (tester) async {
    tester.view.physicalSize = const Size(2400, 7200);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap(const SpeechScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ActionChip, 'Water').first);
    await tester.pumpAndSettle();

    final buildButton = find.widgetWithText(ElevatedButton, 'Build sentence');
    await tester.ensureVisible(buildButton);
    await tester.tap(buildButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('Water'), findsWidgets);
    expect(find.byType(ToolOutput), findsOneWidget);
  });
}
