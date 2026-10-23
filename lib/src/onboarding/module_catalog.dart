import 'package:flutter/widgets.dart';

import '../l10n/app_strings.dart';

/// Static metadata about a module the app can host.
///
/// Only modules with a real, shipped plugin repository appear here.
/// Parlare, Leggere e Studiare, Ricordare, and Muoversi are on the
/// project roadmap but have no repository yet, so they are
/// deliberately absent rather than offered as a toggle that does
/// nothing.
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
];
