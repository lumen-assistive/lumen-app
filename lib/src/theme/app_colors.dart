import 'package:flutter/material.dart';

/// Lumen's color palette.
///
/// Paper and ink: warm off-white paper, near-black ink, and one solid
/// flat color per module. There are no gradients, glows or translucent
/// tints anywhere; structure comes from ink-black outlines and from
/// large blocks of a single color, which keeps edges crisp for people
/// with low vision and keeps every text pairing at a high, easily
/// verified contrast ratio.
abstract final class AppColors {
  /// The page: warm off-white paper.
  static const Color background = Color(0xFFF3EEE3);

  /// Cards and inputs: slightly lighter than the page so they lift off
  /// it without needing a shadow.
  static const Color surface = Color(0xFFFFFCF5);

  /// Primary text, icons and structural outlines: warm near-black ink.
  static const Color ink = Color(0xFF1A1815);

  /// Muted secondary text. Passes WCAG AA (4.5:1) on [background].
  static const Color muted = Color(0xFF5B554A);

  /// A quiet divider, for separators that must not compete with the
  /// ink outlines.
  static const Color hairline = Color(0xFFD3CBB8);

  /// The brand yellow: the logo's dot, progress and the warning block.
  /// Always used as a fill with [ink] on top, never as text.
  static const Color amber = Color(0xFFF2B138);

  /// Critical alert color (falls, SOS). Passes WCAG AA against
  /// [background] when used for text.
  static const Color critical = Color(0xFFC1272D);

  /// One solid fill per module. Every one carries [ink] text and icons
  /// at WCAG AAA contrast (7:1), checked in
  /// `test/theme/app_colors_test.dart` with the real `ContrastChecker`
  /// from `lumen_plugin_vision`.
  static const Map<String, Color> moduleColors = {
    'vision': Color(0xFF5CC8E0),
    'hearing': Color(0xFFB9A2FF),
    'safety': Color(0xFFFF8FA3),
    'family': Color(0xFFFF9FCB),
    'speech': Color(0xFFFFA860),
    'reading': Color(0xFF7ADB98),
    'memory': Color(0xFF9FA9FF),
    'mobility': Color(0xFFF2C94E),
  };

  /// The fill for [moduleId], or [amber] if [moduleId] is not one of
  /// the eight known modules.
  static Color moduleColorOf(String moduleId) =>
      moduleColors[moduleId] ?? amber;
}
