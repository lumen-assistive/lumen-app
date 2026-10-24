import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/onboarding/onboarding_answers.dart';
import 'package:lumen_app/src/onboarding/onboarding_controller.dart';
import 'package:lumen_app/src/theme/ui_mode.dart';

void main() {
  group('OnboardingController.computeOutcome', () {
    test(
        'vision difficulty selects voice-first high-contrast mode and enables vedere',
        () {
      final answers = OnboardingAnswers()..visionDifficulty = true;

      final outcome = OnboardingController.computeOutcome(answers);

      expect(outcome.uiMode, UiMode.voiceFirstHighContrast);
      expect(outcome.enabledModuleIds, contains('vedere'));
    });

    test(
        'hearing difficulty alone selects visual-with-vibration mode and enables sentire',
        () {
      final answers = OnboardingAnswers()..hearingDifficulty = true;

      final outcome = OnboardingController.computeOutcome(answers);

      expect(outcome.uiMode, UiMode.visualWithVibration);
      expect(outcome.enabledModuleIds, contains('sentire'));
    });

    test(
      'vision difficulty takes priority over hearing difficulty for ui mode',
      () {
        final answers = OnboardingAnswers()
          ..visionDifficulty = true
          ..hearingDifficulty = true;

        final outcome = OnboardingController.computeOutcome(answers);

        expect(outcome.uiMode, UiMode.voiceFirstHighContrast);
        expect(outcome.enabledModuleIds, containsAll(['vedere', 'sentire']));
      },
    );

    test(
        'simple complexity preference is honored absent vision or hearing difficulty',
        () {
      final answers = OnboardingAnswers()
        ..complexityPreference = ComplexityPreference.simple;

      final outcome = OnboardingController.computeOutcome(answers);

      expect(outcome.uiMode, UiMode.simple);
    });

    test(
        'complete is the default outcome with no stated difficulty and no modules enabled',
        () {
      final answers = OnboardingAnswers();

      final outcome = OnboardingController.computeOutcome(answers);

      expect(outcome.uiMode, UiMode.complete);
      expect(outcome.enabledModuleIds, isEmpty);
    });

    test(
        'safety and caregiver answers enable protezione and famiglia independently',
        () {
      final answers = OnboardingAnswers()
        ..wantsSafety = true
        ..wantsCaregiverSharing = true;

      final outcome = OnboardingController.computeOutcome(answers);

      expect(outcome.enabledModuleIds, containsAll(['protezione', 'famiglia']));
      expect(outcome.enabledModuleIds, hasLength(2));
    });
  });
}
