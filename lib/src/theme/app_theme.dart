import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'ui_mode.dart';

/// Builds the app's [ThemeData] for a given [UiMode].
///
/// One light, flat theme: ink on paper, outlines instead of shadows,
/// solid fills instead of gradients. `voiceFirstHighContrast` and
/// `simple` only enlarge the base text, since the palette already sits
/// at AAA contrast for every text pairing.
abstract final class AppTheme {
  /// Minimum touch target size used throughout the app, per the
  /// project's accessibility requirements.
  static const double minTouchTarget = 48;

  /// Height of a primary action button.
  static const double buttonHeight = 56;

  static const String fontFamily = 'Atkinson Hyperlegible';

  /// Width of an ink outline on cards, tiles and buttons.
  static const double outlineWidth = 2;

  static ThemeData resolve(UiMode uiMode) {
    final baseTextScale = switch (uiMode) {
      UiMode.voiceFirstHighContrast => 1.3,
      UiMode.simple => 1.15,
      UiMode.visualWithVibration => 1.0,
      UiMode.complete => 1.0,
    };

    const scheme = ColorScheme.light(
      primary: AppColors.ink,
      onPrimary: AppColors.background,
      secondary: AppColors.amber,
      onSecondary: AppColors.ink,
      surface: AppColors.background,
      onSurface: AppColors.ink,
      error: AppColors.critical,
      onError: AppColors.surface,
      outline: AppColors.ink,
      outlineVariant: AppColors.hairline,
    );

    const inkSide = BorderSide(color: AppColors.ink, width: outlineWidth);
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    );
    const buttonText = TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 16,
    );

    OutlineInputBorder inputBorder(double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.ink, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      visualDensity: VisualDensity.standard,
      fontFamily: fontFamily,
      splashFactory: InkRipple.splashFactory,
      textTheme:
          Typography.material2021(platform: TargetPlatform.android).black.apply(
                fontFamily: fontFamily,
                fontSizeFactor: baseTextScale,
                bodyColor: AppColors.ink,
                displayColor: AppColors.ink,
              ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        leadingWidth: 72,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: inkSide,
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.hairline,
        thickness: 1,
        space: 1,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.ink,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: inkSide,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(buttonHeight),
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.background,
          elevation: 0,
          shape: buttonShape,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(buttonHeight),
          foregroundColor: AppColors.ink,
          backgroundColor: AppColors.surface,
          side: inkSide,
          shape: buttonShape,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          textStyle: buttonText,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.ink, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: const TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        labelStyle: const TextStyle(color: AppColors.muted),
        border: inputBorder(1.5),
        enabledBorder: inputBorder(1.5),
        focusedBorder: inputBorder(3),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(AppColors.ink),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.amber
              : AppColors.surface,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(AppColors.ink),
        trackOutlineWidth: const WidgetStatePropertyAll(2),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.ink,
        inactiveTrackColor: AppColors.hairline,
        thumbColor: AppColors.ink,
        overlayColor: Colors.transparent,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.ink,
        tileColor: Colors.transparent,
      ),
    );
  }
}
