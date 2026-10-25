import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../onboarding/module_catalog.dart';
import '../storage/user_profile.dart';

/// Lists the modules the user enabled during onboarding or from
/// settings.
///
/// Tapping an enabled module opens its real screen (see
/// `lib/src/modules/`), backed directly by that module's plugin
/// package rather than a generic placeholder.
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
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: enabledModules.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final module = enabledModules[index];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        module.name(context),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(module.description(context)),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => onOpenModule(module.id),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
