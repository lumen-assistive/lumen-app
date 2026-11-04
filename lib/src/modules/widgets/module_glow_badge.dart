import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/module_icon.dart';

/// A module's icon, drawn inside a dark circular badge with a soft glow
/// in that module's signature color behind it.
///
/// Used on the home screen's module list and again at the top of each
/// module's own screen, so a module's identity (its color and icon)
/// reads consistently everywhere it appears, the same glowing-circle
/// motif as the app's splash moment in `lib/src/app.dart`, just smaller
/// and in a module color instead of the brand amber.
class ModuleGlowBadge extends StatelessWidget {
  const ModuleGlowBadge({
    super.key,
    required this.moduleId,
    this.diameter = 48,
  });

  final String moduleId;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.moduleColorOf(moduleId);
    return SizedBox(
      width: diameter,
      height: diameter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: color.withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: diameter * 0.6,
              spreadRadius: diameter * 0.05,
            ),
          ],
        ),
        child: Center(
          child: IconTheme(
            data: IconThemeData(color: color),
            child: ModuleIcon(moduleId: moduleId, size: diameter * 0.46),
          ),
        ),
      ),
    );
  }
}
