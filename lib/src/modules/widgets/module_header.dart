import 'package:flutter/material.dart';

import '../../onboarding/module_catalog.dart';
import '../../theme/app_colors.dart';
import 'module_glow_badge.dart';

/// The banner at the top of every module screen: the module's glowing
/// badge, its name and a one-line description, on a panel softly tinted
/// with that module's signature color.
///
/// Replaces a plain app bar title so each module opens with a clear
/// identity instead of a bare list of controls.
class ModuleHeader extends StatelessWidget {
  const ModuleHeader({super.key, required this.moduleId});

  final String moduleId;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.moduleColorOf(moduleId);
    final module = availableModules.firstWhere((m) => m.id == moduleId);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: color.withValues(alpha: 0.35)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.3),
            color.withValues(alpha: 0.06),
          ],
        ),
      ),
      child: Row(
        children: [
          ModuleGlowBadge(moduleId: moduleId, diameter: 72),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.name(context),
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  module.description(context),
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
