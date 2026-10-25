import 'package:flutter/material.dart';

/// Lumen's color palette.
///
/// Matches lumen-website's identity exactly (see that repository's
/// `Layout.astro`), so the brand reads as one product across the app
/// and the site: a warm paper and ink palette with a single amber
/// accent, used only where it carries meaning. No gradients, no
/// glassmorphism, no card shadows.
abstract final class AppColors {
  /// Primary accent for the light theme's regular tier, identical to
  /// the website's `--lumen` light value.
  static const Color amberLight = Color(0xFF8F5C13);

  /// Primary accent for the dark theme's regular tier, identical to
  /// the website's `--lumen` dark value.
  static const Color amberDark = Color(0xFFE3A94A);

  /// Primary accent for the high-contrast tier, darkened from
  /// [amberLight] until it clears WCAG 2.2 AAA (7:1) against both
  /// [paperLight] and white: see `test/theme/app_colors_test.dart`,
  /// which verifies this with the real `ContrastChecker` from
  /// `lumen_plugin_vision` rather than asserting an unverified number.
  static const Color amberHighContrast = Color(0xFF5C3A0C);

  /// Deep ink surface for the dark theme, identical to the website's
  /// `--paper` dark value.
  static const Color inkDark = Color(0xFF19170F);

  /// Ink text/surface color for the light theme, identical to the
  /// website's `--ink` light value.
  static const Color ink = Color(0xFF1C1A16);

  /// Warm paper surface for the light theme, identical to the
  /// website's `--paper` light value.
  static const Color paperLight = Color(0xFFFDFBF5);

  /// Ink text color for the dark theme, identical to the website's
  /// `--ink` dark value.
  static const Color inkTextDark = Color(0xFFF3EFE2);

  /// Muted secondary text, identical to the website's `--muted` light
  /// value.
  static const Color mutedLight = Color(0xFF6B655A);

  /// Muted secondary text for the dark theme, identical to the
  /// website's `--muted` dark value.
  static const Color mutedDark = Color(0xFFB7AE99);

  /// Hairline border color for the light theme, identical to the
  /// website's `--border` light value.
  static const Color borderLight = Color(0xFFE3DDCC);

  /// Hairline border color for the dark theme, identical to the
  /// website's `--border` dark value.
  static const Color borderDark = Color(0xFF3A3424);

  /// Critical alert color (falls, SOS), kept distinct from the accent
  /// so urgent states are never mistaken for routine ones. Not part of
  /// the website's palette: this app has safety states the marketing
  /// site does not.
  static const Color critical = Color(0xFFB3261E);

  /// Warning alert color, between informational and critical. Not
  /// part of the website's palette, for the same reason as [critical].
  static const Color warning = Color(0xFF8A5B00);
}
