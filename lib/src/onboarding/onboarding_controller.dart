import '../theme/ui_mode.dart';
import 'onboarding_answers.dart';

/// The modules to enable and the UI mode to use, derived from
/// [OnboardingAnswers].
class OnboardingOutcome {
  const OnboardingOutcome({
    required this.uiMode,
    required this.enabledModuleIds,
  });

  final UiMode uiMode;
  final Set<String> enabledModuleIds;
}

/// Turns raw onboarding answers into a concrete [OnboardingOutcome].
///
/// A stated vision difficulty takes priority over a stated hearing
/// difficulty when choosing [UiMode], since it determines whether the
/// person can reliably perceive the screen at all; a hearing
/// difficulty alone is better served by the fully visual, vibration-led
/// mode. When neither applies, the explicit complexity preference from
/// the final question decides between `simple` and `complete`.
abstract final class OnboardingController {
  static OnboardingOutcome computeOutcome(OnboardingAnswers answers) {
    final uiMode = switch (answers) {
      OnboardingAnswers(visionDifficulty: true) =>
        UiMode.voiceFirstHighContrast,
      OnboardingAnswers(hearingDifficulty: true) => UiMode.visualWithVibration,
      OnboardingAnswers(complexityPreference: ComplexityPreference.simple) =>
        UiMode.simple,
      _ => UiMode.complete,
    };

    final enabledModuleIds = <String>{
      if (answers.visionDifficulty) 'vision',
      if (answers.hearingDifficulty) 'hearing',
      if (answers.wantsSafety) 'safety',
      if (answers.wantsCaregiverSharing) 'family',
    };

    return OnboardingOutcome(
      uiMode: uiMode,
      enabledModuleIds: enabledModuleIds,
    );
  }
}
