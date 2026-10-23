import 'package:flutter/material.dart';

/// Lumen's color palette.
///
/// Deliberately not a generic Material purple-gradient template: a
/// warm amber accent on deep ink/cream neutrals, chosen for strong
/// contrast at both regular and high-contrast tiers rather than for
/// decoration. No gradients, no glassmorphism.
abstract final class AppColors {
  /// Primary accent, used for calls to action in the regular tier.
  static const Color amber = Color(0xFFB45309);

  /// Primary accent, boosted for the high-contrast tier to clear WCAG
  /// 2.2 AAA contrast against both light and dark surfaces.
  static const Color amberHighContrast = Color(0xFF7A3B00);

  /// Deep ink surface used for dark and high-contrast dark themes.
  static const Color ink = Color(0xFF14110D);

  /// Warm cream surface used for light and high-contrast light themes.
  static const Color cream = Color(0xFFFFFBF2);

  /// Critical alert color (falls, SOS), kept distinct from the accent
  /// so urgent states are never mistaken for routine ones.
  static const Color critical = Color(0xFFB3261E);

  /// Warning alert color, between informational and critical.
  static const Color warning = Color(0xFF8A5B00);
}
