import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/family_screen.dart';

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
  testWidgets('generates a real six-digit pairing code', (tester) async {
    await tester.pumpWidget(_wrap(const FamilyScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Genera codice'));
    await tester.pumpAndSettle();

    expect(find.textContaining(RegExp(r'Codice: \d{6}')), findsOneWidget);
  });

  testWidgets('adds a real calendar event and lists it', (tester) async {
    await tester.pumpWidget(_wrap(const FamilyScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Aggiungi evento'));
    await tester.pumpAndSettle();

    // Matches the added event's list entry ("Doctor visit: <time>"), not
    // the input field, which still shows the plain "Doctor visit" seed
    // text after submitting.
    expect(find.textContaining('Doctor visit:'), findsOneWidget);
  });

  testWidgets('sets and shows the real daily status', (tester) async {
    await tester.pumpWidget(_wrap(const FamilyScreen()));
    await tester.pumpAndSettle();

    final okButtonFinder = find.widgetWithText(ElevatedButton, 'Tutto ok');
    await tester.scrollUntilVisible(
      okButtonFinder,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(okButtonFinder);
    await tester.pumpAndSettle();
    expect(find.text('Nessuno stato impostato per oggi.'), findsOneWidget);

    await tester.tap(okButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Stato di oggi: tutto ok'), findsOneWidget);
  });
}
