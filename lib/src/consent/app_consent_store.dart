import 'package:lumen_core/lumen_core.dart';

import '../storage/module_config_repository.dart';

/// [ConsentStore] backed by [ModuleConfigRepository].
///
/// Lumen's MVP tracks a single consent flag per module (sharing with a
/// paired caregiver) rather than per fine-grained consent key, so
/// every `consentKey` maps to the same stored flag for now. Splitting
/// into per-key consent is a natural extension once a module actually
/// needs more than one kind of consent.
class AppConsentStore implements ConsentStore {
  AppConsentStore(this._moduleConfigRepository);

  final ModuleConfigRepository _moduleConfigRepository;

  @override
  bool hasConsent(String pluginId, String consentKey) {
    return _moduleConfigRepository.configFor(pluginId).consentGranted;
  }
}
