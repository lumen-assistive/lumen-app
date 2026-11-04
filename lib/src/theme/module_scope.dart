import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Gives a module's screen that module's solid color as its accent.
///
/// Sets the scheme's `secondary` to the module fill, which the module
/// widgets (`ToolCard`, `ToolOutput`, `ModuleHeader`) and the switch,
/// chip and slider themes read, so a module screen needs no per-widget
/// color code. Everything else (ink buttons, outlines, paper) stays
/// identical across modules, which keeps the app one consistent system.
class ModuleScope extends StatelessWidget {
  const ModuleScope({super.key, required this.moduleId, required this.child});

  final String moduleId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.moduleColorOf(moduleId);
    final base = Theme.of(context);
    return Theme(
      data: base.copyWith(
        colorScheme: base.colorScheme.copyWith(
          secondary: color,
          onSecondary: AppColors.ink,
        ),
        switchTheme: base.switchTheme.copyWith(
          trackColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? color
                : AppColors.surface,
          ),
        ),
        chipTheme: base.chipTheme.copyWith(backgroundColor: AppColors.surface),
      ),
      child: child,
    );
  }
}
