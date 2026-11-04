import 'package:flutter/material.dart';

/// Lumen's color palette.
///
/// Dark by design, not just by default: "Lumen" means light, so the
/// product is a warm glow against near-black, the same reasoning
/// lumen-website's parallel redesign uses. One amber brand accent
/// still carries every action and link; each module additionally gets
/// its own signature color, used for that module's icon badge and the
/// soft glow behind it, so the module list reads as lively and varied
/// rather than a single flat accent repeated eight times. Flat and
/// bordered throughout: no card elevation, definition comes from a
/// hairline border or a deliberate glow, never a generic shadow.
abstract final class AppColors {
  /// The app's one surface color: deep warm near-black.
  static const Color background = Color(0xFF0D0B08);

  /// A slightly raised surface, one step lighter than [background], for
  /// a result box or a secondary section.
  static const Color surface = Color(0xFF17140F);

  /// A fill one step above [surface], for inputs, chips and secondary
  /// buttons that must read as raised from a [surface] card. Used for
  /// fills only, never for text, so it carries no contrast requirement.
  static const Color surfaceRaised = Color(0xFF221E16);

  /// Primary text and icon color: warm off-white, never pure white, to
  /// avoid the harsh glare pure white produces on a near-black surface.
  static const Color text = Color(0xFFF3EFE2);

  /// Muted secondary text.
  static const Color muted = Color(0xFFB7AE99);

  /// Hairline border color.
  static const Color border = Color(0xFF3A3424);

  /// The brand accent: used for buttons, links, and small marks.
  static const Color amber = Color(0xFFE3A94A);

  /// A brighter, more saturated amber reserved specifically for large
  /// soft glow and blur effects (behind a badge, behind the hero mark):
  /// a glow this size reads as muddy at [amber]'s lower saturation, so
  /// the two are kept distinct rather than reusing one color for both
  /// a small flat accent and a large diffuse one.
  static const Color glow = Color(0xFFF5B942);

  /// Primary accent for the high-contrast tier: brightened from
  /// [amber] so it clears WCAG 2.2 AAA (7:1) against [background], the
  /// real value computed and verified in
  /// `test/theme/app_colors_test.dart` with the real `ContrastChecker`
  /// from `lumen_plugin_vision` rather than asserted on sight.
  static const Color amberHighContrast = Color(0xFFF2C878);

  /// Critical alert color (falls, SOS), kept distinct from every
  /// module color and the brand accent so an urgent state is never
  /// mistaken for routine module identity or decoration.
  static const Color critical = Color(0xFFE5484D);

  /// Warning alert color, between informational and critical.
  static const Color warning = Color(0xFFE8A33D);

  /// One signature color per module, used for that module's icon badge
  /// stroke and glow on the home screen and its own screen's header.
  /// Each clears real WCAG 3:1 non-text contrast against both
  /// [background] and [surface] (verified in
  /// `test/theme/app_colors_test.dart` with the real `ContrastChecker`,
  /// not asserted on sight), and stays visually distinct from
  /// [critical] so no module's identity is ever mistaken for a live
  /// emergency alert.
  static const Map<String, Color> moduleColors = {
    'vision': Color(0xFF22B8D4),
    'hearing': Color(0xFF9D7CF5),
    'safety': Color(0xFFF2637B),
    'family': Color(0xFFF070AC),
    'speech': Color(0xFFF3914F),
    'reading': Color(0xFF4FCB7C),
    'memory': Color(0xFF8B93F7),
    'mobility': Color(0xFFD9A93B),
  };

  /// The signature color for [moduleId], or [amber] if [moduleId] is
  /// not one of the eight known modules.
  static Color moduleColorOf(String moduleId) =>
      moduleColors[moduleId] ?? amber;
}
