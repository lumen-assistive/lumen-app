import 'package:flutter/widgets.dart';

import '../l10n/app_strings.dart';

/// Static metadata about a module the app can host.
///
/// All eight of Lumen's modules have a real, shipped plugin package
/// now (`lumen-plugins`), so all eight appear here. Each module's
/// screen, reached from the home module host, honestly discloses
/// which of its original features are demonstrated with real business
/// logic today and which still need a camera, microphone, live sensor
/// feed, real text-to-speech, or real SMS sending that does not exist
/// in this environment yet.
class ModuleInfo {
  const ModuleInfo({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
  });

  /// Stable identifier, matching the corresponding plugin's
  /// `PluginManifest.id` once it is wired in.
  final String id;

  final String nameKey;
  final String descriptionKey;

  String name(BuildContext context) => AppStrings.of(context)(nameKey);

  String description(BuildContext context) =>
      AppStrings.of(context)(descriptionKey);
}

/// Every module currently available to enable during onboarding or
/// from settings.
const List<ModuleInfo> availableModules = [
  ModuleInfo(
    id: 'vision',
    nameKey: 'moduleNameVision',
    descriptionKey: 'moduleDescriptionVision',
  ),
  ModuleInfo(
    id: 'hearing',
    nameKey: 'moduleNameHearing',
    descriptionKey: 'moduleDescriptionHearing',
  ),
  ModuleInfo(
    id: 'safety',
    nameKey: 'moduleNameSafety',
    descriptionKey: 'moduleDescriptionSafety',
  ),
  ModuleInfo(
    id: 'family',
    nameKey: 'moduleNameFamily',
    descriptionKey: 'moduleDescriptionFamily',
  ),
  ModuleInfo(
    id: 'speech',
    nameKey: 'moduleNameSpeech',
    descriptionKey: 'moduleDescriptionSpeech',
  ),
  ModuleInfo(
    id: 'reading',
    nameKey: 'moduleNameReading',
    descriptionKey: 'moduleDescriptionReading',
  ),
  ModuleInfo(
    id: 'memory',
    nameKey: 'moduleNameMemory',
    descriptionKey: 'moduleDescriptionMemory',
  ),
  ModuleInfo(
    id: 'mobility',
    nameKey: 'moduleNameMobility',
    descriptionKey: 'moduleDescriptionMobility',
  ),
];
