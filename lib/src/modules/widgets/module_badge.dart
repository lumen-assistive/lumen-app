import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/module_icon.dart';

/// A module's icon in ink, on a rounded square filled with that
/// module's solid color and outlined in ink.
///
/// Used wherever a module is named outside its own tile: the settings
/// list and the module header. Flat on purpose: no glow, no gradient.
class ModuleBadge extends StatelessWidget {
  const ModuleBadge({super.key, required this.moduleId, this.size = 48});

  final String moduleId;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.moduleColorOf(moduleId),
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Center(
        child: IconTheme(
          data: const IconThemeData(color: AppColors.ink),
          child: ModuleIcon(moduleId: moduleId, size: size * 0.5),
        ),
      ),
    );
  }
}
