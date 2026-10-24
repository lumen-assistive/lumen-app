import 'package:flutter/material.dart';

import '../diagnostics/diagnostics_screen.dart';
import '../l10n/app_strings.dart';
import '../onboarding/module_catalog.dart';
import '../storage/module_config_repository.dart';
import '../storage/user_profile.dart';
import '../storage/user_profile_repository.dart';
import '../theme/ui_mode.dart';

/// Lets the user change UI mode, text scale, and per-module
/// enablement and consent, and exposes the developer diagnostics
/// screen behind an explicit toggle.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.userProfileRepository,
    required this.moduleConfigRepository,
  });

  final UserProfileRepository userProfileRepository;
  final ModuleConfigRepository moduleConfigRepository;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _developerModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.userProfileRepository,
        widget.moduleConfigRepository,
      ]),
      builder: (context, _) {
        final profile =
            widget.userProfileRepository.profile ?? UserProfile.initial();
        return Scaffold(
          appBar: AppBar(title: Text(strings('settingsTitle'))),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionHeader(strings('settingsSectionAppearance')),
              ListTile(
                title: Text(strings('settingsUiMode')),
                subtitle: Text(_uiModeLabel(strings, profile.uiMode)),
                trailing: DropdownButton<UiMode>(
                  value: profile.uiMode,
                  onChanged: (mode) {
                    if (mode == null) return;
                    widget.userProfileRepository.save(
                      profile.copyWith(uiMode: mode),
                    );
                  },
                  items: UiMode.values
                      .map(
                        (mode) => DropdownMenuItem(
                          value: mode,
                          child: Text(_uiModeLabel(strings, mode)),
                        ),
                      )
                      .toList(),
                ),
              ),
              ListTile(
                title: Text(strings('settingsTextScale')),
                subtitle: Slider(
                  value: profile.textScale,
                  min: 1,
                  max: 2,
                  divisions: 4,
                  label: profile.textScale.toStringAsFixed(2),
                  onChanged: (value) {
                    widget.userProfileRepository.save(
                      profile.copyWith(textScale: value),
                    );
                  },
                ),
              ),
              const Divider(height: 32),
              _SectionHeader(strings('settingsSectionModules')),
              for (final module in availableModules)
                _ModuleSettingsTile(
                  module: module,
                  moduleConfigRepository: widget.moduleConfigRepository,
                ),
              const Divider(height: 32),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings('settingsDisclaimerTitle'),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        strings('settingsDisclaimerBody'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 32),
              _SectionHeader(strings('settingsDeveloperSection')),
              SwitchListTile(
                title: Text(strings('settingsDeveloperModeToggle')),
                value: _developerModeEnabled,
                onChanged: (value) =>
                    setState(() => _developerModeEnabled = value),
              ),
              if (_developerModeEnabled)
                ListTile(
                  title: Text(strings('diagnosticsTitle')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DiagnosticsScreen(),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  String _uiModeLabel(AppStrings strings, UiMode mode) => switch (mode) {
        UiMode.voiceFirstHighContrast =>
          strings('uiModeVoiceFirstHighContrast'),
        UiMode.visualWithVibration => strings('uiModeVisualWithVibration'),
        UiMode.simple => strings('uiModeSimple'),
        UiMode.complete => strings('uiModeComplete'),
      };
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(label, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _ModuleSettingsTile extends StatelessWidget {
  const _ModuleSettingsTile({
    required this.module,
    required this.moduleConfigRepository,
  });

  final ModuleInfo module;
  final ModuleConfigRepository moduleConfigRepository;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final config = moduleConfigRepository.configFor(module.id);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            SwitchListTile(
              title: Text(module.name(context)),
              subtitle: Text(module.description(context)),
              value: config.enabled,
              onChanged: (value) =>
                  moduleConfigRepository.setEnabled(module.id, value),
            ),
            SwitchListTile(
              title: Text(strings('settingsModuleConsent')),
              value: config.consentGranted,
              onChanged: (value) =>
                  moduleConfigRepository.setConsentGranted(module.id, value),
            ),
          ],
        ),
      ),
    );
  }
}
