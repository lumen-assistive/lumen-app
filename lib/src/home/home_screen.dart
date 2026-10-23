import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../onboarding/module_catalog.dart';
import '../storage/user_profile.dart';

/// Lists the modules the user enabled during onboarding or from
/// settings.
///
/// This hosts modules generically: it shows each enabled module's
/// localized name and a short status line, but does not yet embed any
/// module-specific screen (a camera preview, an audio capture view,
/// and so on). The plugin packages this release depends on
/// (`lumen-plugin-vedere`, `-sentire`, `-protezione`, `-famiglia`) ship
/// business logic only, with no Flutter UI of their own yet; wiring a
/// real per-module screen is a follow-up phase once a plugin ships
/// one.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.profile,
    required this.onOpenSettings,
  });

  final UserProfile profile;
  final VoidCallback onOpenSettings;

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
                      trailing: Chip(
                        label: Text(strings('homeModuleStatusActive')),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
