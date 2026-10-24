import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'ui_mode.dart';

/// Builds the [ThemeData] for a given [UiMode] and [Brightness].
///
/// `voiceFirstHighContrast` and `simple` use the high-contrast color
/// scheme and a larger base text size regardless of the requested
/// brightness, since both modes prioritize legibility over matching
/// the device's light/dark preference exactly.
abstract final class AppTheme {
  /// Minimum touch target size used throughout the app, per the
  /// project's accessibility requirements.
  static const double minTouchTarget = 48;

  static ThemeData resolve(UiMode uiMode, Brightness brightness) {
    final highContrast =
        uiMode == UiMode.voiceFirstHighContrast || uiMode == UiMode.simple;
    final baseTextScale = switch (uiMode) {
      UiMode.voiceFirstHighContrast => 1.3,
      UiMode.simple => 1.15,
      UiMode.visualWithVibration => 1.0,
      UiMode.complete => 1.0,
    };

    final scheme = _colorScheme(brightness, highContrast: highContrast);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.standard,
      textTheme:
          Typography.material2021(platform: TargetPlatform.android).black.apply(
                fontSizeFactor: baseTextScale,
                bodyColor: scheme.onSurface,
                displayColor: scheme.onSurface,
              ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(minTouchTarget),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.outline,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        thumbColor: scheme.primary,
      ),
    );
  }

  static ColorScheme _colorScheme(
    Brightness brightness, {
    required bool highContrast,
  }) {
    final accent = highContrast ? AppColors.amberHighContrast : AppColors.amber;
    if (brightness == Brightness.dark) {
      return ColorScheme.fromSeed(
        seedColor: accent,
        brightness: Brightness.dark,
        surface: AppColors.ink,
        error: AppColors.critical,
      );
    }
    return ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.light,
      surface: AppColors.cream,
      error: AppColors.critical,
    );
  }
}
