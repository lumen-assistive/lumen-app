import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'ui_mode.dart';

/// Builds the [ThemeData] for a given [UiMode] and [Brightness].
///
/// `voiceFirstHighContrast` and `simple` use the high-contrast color
/// scheme and a larger base text size regardless of the requested
/// brightness, since both modes prioritize legibility over matching
/// the device's light/dark preference exactly.
///
/// Flat and bordered throughout, matching lumen-website's identity: no
/// card elevation, no shadows, definition comes from a hairline border
/// instead, and the amber accent is used only for actions and results,
/// never as decoration.
abstract final class AppTheme {
  /// Minimum touch target size used throughout the app, per the
  /// project's accessibility requirements.
  static const double minTouchTarget = 48;

  static const String fontFamily = 'Atkinson Hyperlegible';

  static ThemeData resolve(UiMode uiMode, Brightness brightness) {
    final highContrast =
        uiMode == UiMode.voiceFirstHighContrast || uiMode == UiMode.simple;
    final baseTextScale = switch (uiMode) {
      UiMode.voiceFirstHighContrast => 1.3,
      UiMode.simple => 1.15,
      UiMode.visualWithVibration => 1.0,
      UiMode.complete => 1.0,
    };

    final palette = _Palette.resolve(brightness);
    final accent = highContrast ? AppColors.amberHighContrast : palette.accent;

    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
      surface: palette.paper,
      onSurface: palette.ink,
      primary: accent,
      onPrimary:
          brightness == Brightness.dark ? AppColors.inkDark : Colors.white,
      error: AppColors.critical,
      outline: palette.border,
    );

    final borderSide = BorderSide(color: palette.border);
    final outlineShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: borderSide,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.standard,
      fontFamily: fontFamily,
      textTheme:
          Typography.material2021(platform: TargetPlatform.android).black.apply(
                fontFamily: fontFamily,
                fontSizeFactor: baseTextScale,
                bodyColor: scheme.onSurface,
                displayColor: scheme.onSurface,
              ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: palette.paper,
        foregroundColor: palette.ink,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: palette.paper,
        shape: outlineShape,
        margin: EdgeInsets.zero,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: accent,
        tileColor: Colors.transparent,
      ),
      dividerTheme:
          DividerThemeData(color: palette.border, thickness: 1, space: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(minTouchTarget),
          backgroundColor: accent,
          foregroundColor:
              brightness == Brightness.dark ? AppColors.inkDark : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(minTouchTarget),
          foregroundColor: palette.ink,
          side: borderSide,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.paperDim,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: borderSide,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: borderSide,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: accent, width: 2),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? accent : scheme.outline,
        ),
      ),
      sliderTheme:
          SliderThemeData(activeTrackColor: accent, thumbColor: accent),
    );
  }

  /// The surface used for a result box or a secondary section, one step
  /// dimmer than the main surface, matching the website's
  /// `--paper-dim`.
  static Color paperDimOf(BuildContext context, Brightness brightness) =>
      _Palette.resolve(brightness).paperDim;

  static Color borderOf(Brightness brightness) =>
      _Palette.resolve(brightness).border;
}

class _Palette {
  const _Palette({
    required this.paper,
    required this.paperDim,
    required this.ink,
    required this.border,
    required this.accent,
  });

  final Color paper;
  final Color paperDim;
  final Color ink;
  final Color border;
  final Color accent;

  static _Palette resolve(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const _Palette(
        paper: AppColors.inkDark,
        paperDim: Color(0xFF231F16),
        ink: AppColors.inkTextDark,
        border: AppColors.borderDark,
        accent: AppColors.amberDark,
      );
    }
    return const _Palette(
      paper: AppColors.paperLight,
      paperDim: Color(0xFFF1ECE0),
      ink: AppColors.ink,
      border: AppColors.borderLight,
      accent: AppColors.amberLight,
    );
  }
}
