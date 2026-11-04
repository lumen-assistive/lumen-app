import 'package:flutter/material.dart';

import '../../onboarding/module_catalog.dart';
import '../../theme/app_colors.dart';
import '../../theme/module_icon.dart';

/// The banner at the top of every module screen: one solid block in the
/// module's color with a large ink icon, the module's name and a one
/// line description.
class ModuleHeader extends StatelessWidget {
  const ModuleHeader({super.key, required this.moduleId});

  final String moduleId;

  @override
  Widget build(BuildContext context) {
    final module = availableModules.firstWhere((m) => m.id == moduleId);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.moduleColorOf(moduleId),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTheme(
            data: const IconThemeData(color: AppColors.ink),
            child: ModuleIcon(moduleId: moduleId, size: 44),
          ),
          const SizedBox(height: 28),
          Text(
            module.name(context),
            style: textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Text(module.description(context), style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}
