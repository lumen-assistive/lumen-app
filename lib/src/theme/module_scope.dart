import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_theme.dart';

/// Re-themes a module's screen with that module's signature color and
/// paints a soft glow of it behind the page.
///
/// Every control inside (filled and tonal buttons, input focus rings,
/// switches, sliders, chips, result boxes) picks the color up through
/// the normal theme lookups, so module screens need no per-widget color
/// code and each module feels like its own place while staying inside
/// one design system.
class ModuleScope extends StatelessWidget {
  const ModuleScope({super.key, required this.moduleId, required this.child});

  final String moduleId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.moduleColorOf(moduleId);
    final base = Theme.of(context);
    final themed = base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: color,
        onPrimary: AppColors.background,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTheme.minTouchTarget + 6),
          backgroundColor: color,
          foregroundColor: AppColors.background,
          elevation: 0,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 28),
          textStyle: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTheme.minTouchTarget + 6),
          backgroundColor: color.withValues(alpha: 0.12),
          foregroundColor: AppColors.text,
          side: BorderSide(color: color.withValues(alpha: 0.45)),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          textStyle: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? color : AppColors.muted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? color.withValues(alpha: 0.35)
              : AppColors.surfaceRaised,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(AppColors.border),
      ),
      sliderTheme: SliderThemeData(activeTrackColor: color, thumbColor: color),
      chipTheme: base.chipTheme.copyWith(
        side: BorderSide(color: color.withValues(alpha: 0.4)),
        backgroundColor: color.withValues(alpha: 0.12),
      ),
    );

    return Theme(
      data: themed,
      child: ColoredBox(
        color: AppColors.background,
        child: Stack(
          children: [
            Positioned(
              top: -300,
              left: -200,
              right: -200,
              height: 700,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      radius: 0.5,
                      colors: [
                        color.withValues(alpha: 0.28),
                        color.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
