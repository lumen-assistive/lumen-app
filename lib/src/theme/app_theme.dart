import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'ui_mode.dart';

/// Builds the app's [ThemeData] for a given [UiMode].
///
/// Dark is the app's one and only theme, not a system-dependent
/// variant: see `AppColors`'s doc comment for why. `voiceFirstHighContrast`
/// and `simple` swap in the brighter high-contrast accent and a larger
/// base text size, since both modes prioritize legibility above
/// everything else.
///
/// Flat and bordered throughout: no card elevation, no generic
/// shadows, definition comes from a hairline border or a deliberate
/// glow behind a module icon badge. Buttons are true pills, matching
/// the product's visual reference this round.
abstract final class AppTheme {
  /// Minimum touch target size used throughout the app, per the
  /// project's accessibility requirements.
  static const double minTouchTarget = 48;

  static const String fontFamily = 'Atkinson Hyperlegible';

  static ThemeData resolve(UiMode uiMode) {
    final highContrast =
        uiMode == UiMode.voiceFirstHighContrast || uiMode == UiMode.simple;
    final baseTextScale = switch (uiMode) {
      UiMode.voiceFirstHighContrast => 1.3,
      UiMode.simple => 1.15,
      UiMode.visualWithVibration => 1.0,
      UiMode.complete => 1.0,
    };

    final accent = highContrast ? AppColors.amberHighContrast : AppColors.amber;

    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.dark,
      surface: AppColors.background,
      onSurface: AppColors.text,
      primary: accent,
      onPrimary: AppColors.background,
      error: AppColors.critical,
      outline: AppColors.border,
    );

    const borderSide = BorderSide(color: AppColors.border);
    const pillShape = StadiumBorder(side: borderSide);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.standard,
      fontFamily: fontFamily,
      textTheme:
          Typography.material2021(platform: TargetPlatform.android).white.apply(
                fontFamily: fontFamily,
                fontSizeFactor: baseTextScale,
                bodyColor: scheme.onSurface,
                displayColor: scheme.onSurface,
              ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: AppColors.surfaceRaised,
          foregroundColor: AppColors.text,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          side: borderSide,
        ),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.surfaceRaised,
        side: borderSide,
        shape: StadiumBorder(),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
          color: AppColors.text,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: borderSide,
        ),
        margin: EdgeInsets.zero,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.amber,
        tileColor: Colors.transparent,
      ),
      dividerTheme: const DividerThemeData(
          color: AppColors.border, thickness: 1, space: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(minTouchTarget + 6),
          backgroundColor: accent,
          foregroundColor: AppColors.background,
          elevation: 0,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 28),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(minTouchTarget + 6),
          foregroundColor: AppColors.text,
          side: borderSide,
          shape: pillShape,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceRaised,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: borderSide,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: borderSide,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: accent, width: 2),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? accent : AppColors.muted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? accent.withValues(alpha: 0.35)
              : AppColors.surfaceRaised,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(AppColors.border),
      ),
      sliderTheme:
          SliderThemeData(activeTrackColor: accent, thumbColor: accent),
    );
  }

  static Color borderOf() => AppColors.border;
}
