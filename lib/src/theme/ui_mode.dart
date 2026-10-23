/// The adaptive interface mode Lumen renders in, chosen during
/// onboarding and changeable later from settings.
enum UiMode {
  /// Voice-first, maximum contrast, large text and controls: for people
  /// with low vision.
  voiceFirstHighContrast,

  /// Fully visual, with vibration feedback standing in for audio cues:
  /// for deaf and hard-of-hearing users.
  visualWithVibration,

  /// A reduced, essential layout: for elderly users or anyone who wants
  /// fewer choices on screen.
  simple,

  /// The full interface with every available option visible: for
  /// students and power users.
  complete,
}
