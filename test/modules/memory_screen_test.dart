import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/memory_screen.dart';

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
  testWidgets('adds a real person to the directory without consent', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2400, 7200);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap(const MemoryScreen()));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Add person'));

    await tester.tap(find.text('Add person'));
    await tester.pumpAndSettle();

    expect(find.text('Person added.'), findsOneWidget);
    expect(find.textContaining('consent not given'), findsOneWidget);
  });

  testWidgets('adds a real reminder due immediately and finds it due', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2400, 7200);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap(const MemoryScreen()));
    await tester.pumpAndSettle();

    final addReminderButtonFinder =
        find.widgetWithText(ElevatedButton, 'Add reminder');
    await tester.scrollUntilVisible(
      addReminderButtonFinder,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(addReminderButtonFinder, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.textContaining('Due now: Take medicine'), findsOneWidget);
  });
}
