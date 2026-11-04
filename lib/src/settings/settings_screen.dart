import 'package:flutter/material.dart';

import '../diagnostics/diagnostics_screen.dart';
import '../l10n/app_strings.dart';
import '../onboarding/module_catalog.dart';
import '../storage/module_config_repository.dart';
import '../storage/user_profile.dart';
import '../storage/user_profile_repository.dart';
import '../modules/widgets/module_glow_badge.dart';
import '../theme/app_colors.dart';
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
              _SettingsCard(
                children: [
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
                ],
              ),
              const SizedBox(height: 28),
              _SectionHeader(strings('settingsSectionModules')),
              for (final module in availableModules)
                _ModuleSettingsTile(
                  module: module,
                  moduleConfigRepository: widget.moduleConfigRepository,
                ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings('settingsDisclaimerTitle'),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            strings('settingsDisclaimerBody'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
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
      padding: const EdgeInsets.only(left: 4, top: 4, bottom: 10),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.muted,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
      ),
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
    final color = AppColors.moduleColorOf(module.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), AppColors.surface],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            SwitchListTile(
              secondary: ModuleGlowBadge(moduleId: module.id, diameter: 44),
              activeThumbColor: color,
              title: Text(module.name(context)),
              subtitle: Text(module.description(context)),
              value: config.enabled,
              onChanged: (value) =>
                  moduleConfigRepository.setEnabled(module.id, value),
            ),
            SwitchListTile(
              activeThumbColor: color,
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

/// A rounded, bordered group for related appearance settings.
class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(children: children),
    );
  }
}
