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

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: -300,
            left: -200,
            right: -200,
            height: 700,
            child: IgnorePointer(child: _HeroGlow()),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Row(
                  children: [
                    const LogoMark(size: 30, color: AppColors.glow),
                    const SizedBox(width: 10),
                    Text(
                      strings('appTitle'),
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Spacer(),
                    Semantics(
                      button: true,
                      label: strings('settingsTitle'),
                      child: IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        onPressed: onOpenSettings,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  strings('homeHeadline'),
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  strings('homeSubtitle'),
                  style: textTheme.bodyLarge?.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Text(
                      strings('homeTitle').toUpperCase(),
                      style: textTheme.labelLarge?.copyWith(
                        color: AppColors.muted,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceRaised,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        '${enabledModules.length}',
                        style: textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (enabledModules.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      strings('homeNoModules'),
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium,
                    ),
                  )
                else
                  for (final module in enabledModules) ...[
                    _ModuleCard(
                      module: module,
                      onTap: () => onOpenModule(module.id),
                    ),
                    const SizedBox(height: 12),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The large soft amber glow behind the home header, the same motif as
/// the splash screen and the website's hero.
class _HeroGlow extends StatelessWidget {
  const _HeroGlow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 0.5,
          colors: [
            AppColors.glow.withValues(alpha: 0.3),
            AppColors.glow.withValues(alpha: 0),
          ],
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
