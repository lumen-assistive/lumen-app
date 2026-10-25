import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/onboarding/onboarding_controller.dart';
import 'package:lumen_app/src/onboarding/onboarding_screen.dart';
import 'package:lumen_app/src/theme/ui_mode.dart';

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
  testWidgets('answering all five questions reports the expected outcome', (
    tester,
  ) async {
    OnboardingOutcome? outcome;
    await tester.pumpWidget(
      _wrap(OnboardingScreen(onComplete: (value) => outcome = value)),
    );
    await tester.pumpAndSettle();

    // Q1: vision difficulty -> yes.
    await tester.tap(find.text('Si'));
    await tester.pumpAndSettle();

    // Q2: hearing difficulty -> no.
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();

    // Q3: safety -> yes.
    await tester.tap(find.text('Si'));
    await tester.pumpAndSettle();

    // Q4: caregiver sharing -> no.
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();

    // Q5: complexity -> complete.
    await tester.tap(find.text('Completa, con tutte le opzioni'));
    await tester.pumpAndSettle();

    expect(outcome, isNotNull);
    expect(outcome!.uiMode, UiMode.voiceFirstHighContrast);
    expect(outcome!.enabledModuleIds, containsAll(['vision', 'safety']));
    expect(outcome!.enabledModuleIds, isNot(contains('hearing')));
    expect(outcome!.enabledModuleIds, isNot(contains('family')));
  });

  testWidgets(
    'answering no to everything and choosing simple yields no modules',
    (tester) async {
      OnboardingOutcome? outcome;
      await tester.pumpWidget(
        _wrap(OnboardingScreen(onComplete: (value) => outcome = value)),
      );
      await tester.pumpAndSettle();

      for (var i = 0; i < 4; i++) {
        await tester.tap(find.text('No'));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Semplice ed essenziale'));
      await tester.pumpAndSettle();

      expect(outcome, isNotNull);
      expect(outcome!.uiMode, UiMode.simple);
      expect(outcome!.enabledModuleIds, isEmpty);
    },
  );
}
