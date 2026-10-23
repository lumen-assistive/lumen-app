import 'package:meta/meta.dart';

/// Per-module settings and consent state.
@immutable
class ModuleConfig {
  const ModuleConfig({
    required this.moduleId,
    required this.enabled,
    required this.consentGranted,
  });

  factory ModuleConfig.disabled(String moduleId) =>
      ModuleConfig(moduleId: moduleId, enabled: false, consentGranted: false);

  final String moduleId;
  final bool enabled;

  /// Whether the user has consented to this module sharing data with a
  /// paired caregiver, the single consent flag `lumen_core`'s
  /// `ConsentStore` contract checks before a module publishes an alert
  /// meant for Famiglia.
  final bool consentGranted;

  ModuleConfig copyWith({bool? enabled, bool? consentGranted}) {
    return ModuleConfig(
      moduleId: moduleId,
      enabled: enabled ?? this.enabled,
      consentGranted: consentGranted ?? this.consentGranted,
    );
  }
}
