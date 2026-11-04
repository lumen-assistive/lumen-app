import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../onboarding/module_catalog.dart';
import '../storage/user_profile.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/module_icon.dart';
import '../theme/ui_mode.dart';
import '../theme/fade_slide_in.dart';
import '../theme/logo_mark.dart';

/// Lists the modules the user enabled during onboarding or from
/// settings.
///
/// A poster-like layout: the wordmark, a large headline, then every
/// module as a solid block of its own color, two per row. Simple and
/// high-contrast interface modes use one wide block per row instead,
/// since their larger text needs the room. Tapping a block opens the
/// module's real screen (see `lib/src/modules/`).
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
    final textTheme = Theme.of(context).textTheme;
    final enabledModules = availableModules
        .where((module) => profile.enabledModuleIds.contains(module.id))
        .toList();
    final singleColumn = profile.uiMode == UiMode.simple ||
        profile.uiMode == UiMode.voiceFirstHighContrast;
    final columns = singleColumn ? 1 : 2;

    final rows = <Widget>[];
    for (var i = 0; i < enabledModules.length; i += columns) {
      final tiles = <Widget>[];
      for (var c = 0; c < columns; c++) {
        final index = i + c;
        if (c > 0) tiles.add(const SizedBox(width: 12));
        tiles.add(
          Expanded(
            child: index < enabledModules.length
                ? FadeSlideIn(
                    duration: Duration(milliseconds: 380 + 60 * index),
                    child: _ModuleTile(
                      module: enabledModules[index],
                      onTap: () => onOpenModule(enabledModules[index].id),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        );
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: tiles,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Row(
              children: [
                const LogoMark(size: 28, color: AppColors.ink),
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
            const SizedBox(height: 32),
            Text(
              strings('homeHeadline'),
              style: textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.0,
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 14),
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
                const SizedBox(width: 12),
                const Expanded(child: Divider()),
                const SizedBox(width: 12),
                Text(
                  '${enabledModules.length}',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
              ...rows,
          ],
        ),
      ),
    );
  }
}

/// One module as a solid block of its own color: ink icon, name and a
/// short description, outlined in ink.
class _ModuleTile extends StatelessWidget {
  const _ModuleTile({required this.module, required this.onTap});

  final ModuleInfo module;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(24);
    return Material(
      color: AppColors.moduleColorOf(module.id),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(
          color: AppColors.ink,
          width: AppTheme.outlineWidth,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconTheme(
                    data: const IconThemeData(color: AppColors.ink),
                    child: ModuleIcon(moduleId: module.id, size: 36),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_outward_rounded, color: AppColors.ink),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                module.name(context),
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                module.description(context),
                style: textTheme.bodySmall?.copyWith(height: 1.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
