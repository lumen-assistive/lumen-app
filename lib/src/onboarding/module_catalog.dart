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
    id: 'vedere',
    nameKey: 'moduleNameVedere',
    descriptionKey: 'moduleDescriptionVedere',
  ),
  ModuleInfo(
    id: 'sentire',
    nameKey: 'moduleNameSentire',
    descriptionKey: 'moduleDescriptionSentire',
  ),
  ModuleInfo(
    id: 'protezione',
    nameKey: 'moduleNameProtezione',
    descriptionKey: 'moduleDescriptionProtezione',
  ),
  ModuleInfo(
    id: 'famiglia',
    nameKey: 'moduleNameFamiglia',
    descriptionKey: 'moduleDescriptionFamiglia',
  ),
  ModuleInfo(
    id: 'parlare',
    nameKey: 'moduleNameParlare',
    descriptionKey: 'moduleDescriptionParlare',
  ),
  ModuleInfo(
    id: 'leggere',
    nameKey: 'moduleNameLeggere',
    descriptionKey: 'moduleDescriptionLeggere',
  ),
  ModuleInfo(
    id: 'ricordare',
    nameKey: 'moduleNameRicordare',
    descriptionKey: 'moduleDescriptionRicordare',
  ),
  ModuleInfo(
    id: 'muoversi',
    nameKey: 'moduleNameMuoversi',
    descriptionKey: 'moduleDescriptionMuoversi',
  ),
];
