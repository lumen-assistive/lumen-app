import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../onboarding/module_catalog.dart';
import '../storage/user_profile.dart';
import '../theme/app_theme.dart';
import '../theme/module_icon.dart';

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
    final border = AppTheme.borderOf(Theme.of(context).brightness);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings('homeTitle')),
        actions: [
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
            : ListView.builder(
                itemCount: enabledModules.length,
                itemBuilder: (context, index) {
                  final module = enabledModules[index];
                  final isFirst = index == 0;
                  return _ModuleRow(
                    module: module,
                    topBorder: isFirst,
                    borderColor: border,
                    onTap: () => onOpenModule(module.id),
                  );
                },
              ),
      ),
    );
  }
}

class _ModuleRow extends StatelessWidget {
  const _ModuleRow({
    required this.module,
    required this.topBorder,
    required this.borderColor,
    required this.onTap,
  });

  final ModuleInfo module;
  final bool topBorder;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              top: topBorder ? BorderSide(color: borderColor) : BorderSide.none,
              bottom: BorderSide(color: borderColor),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ModuleIcon(moduleId: module.id, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      module.name(context),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      module.description(context),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
