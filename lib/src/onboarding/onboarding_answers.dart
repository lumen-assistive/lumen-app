/// How much of the interface the user wants to see, as chosen on the
/// final onboarding question.
enum ComplexityPreference { simple, complete }

/// Raw answers collected during the five onboarding questions.
class OnboardingAnswers {
  bool visionDifficulty = false;
  bool hearingDifficulty = false;
  bool wantsSafety = false;
  bool wantsCaregiverSharing = false;
  ComplexityPreference complexityPreference = ComplexityPreference.complete;
}
