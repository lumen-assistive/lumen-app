import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../onboarding/module_catalog.dart';
import '../storage/user_profile.dart';
import '../modules/widgets/module_glow_badge.dart';
import '../theme/app_colors.dart';
import '../theme/logo_mark.dart';

/// Lists the modules the user enabled during onboarding or from
/// settings.
///
/// Tapping an enabled module opens its real screen (see
/// `lib/src/modules/`), backed directly by that module's plugin
/// package rather than a generic placeholder. Rendered as a flat,
/// bordered, divided list rather than shadowed cards, matching
/// lumen-website's identity.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.profile,
    required this.onOpenSettings,
    required this.onOpenModule,
  });

  final UserProfile profile;
  final VoidCallback onOpenSettings;
  final void Function(String moduleId) onOpenModule;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final enabledModules = availableModules
        .where((module) => profile.enabledModuleIds.contains(module.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LogoMark(size: 26, color: AppColors.glow),
            const SizedBox(width: 10),
            Text(strings('homeTitle')),
          ],
        ),
        actions: [
          Semantics(
            button: true,
            label: strings('settingsTitle'),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: onOpenSettings,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: enabledModules.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    strings('homeNoModules'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: enabledModules.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final module = enabledModules[index];
                  return _ModuleCard(
                    module: module,
                    onTap: () => onOpenModule(module.id),
                  );
                },
              ),
      ),
    );
  }
}

/// One module as a rounded card tinted with its signature color, so the
/// list reads as eight distinct places rather than one repeated row.
class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module, required this.onTap});

  final ModuleInfo module;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.moduleColorOf(module.id);
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(24);
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: color.withValues(alpha: 0.28)),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [color.withValues(alpha: 0.16), AppColors.surface],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            constraints: const BoxConstraints(minHeight: 88),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                ModuleGlowBadge(moduleId: module.id, diameter: 52),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        module.name(context),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        module.description(context),
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
