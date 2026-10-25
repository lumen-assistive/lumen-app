import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/consent/app_consent_store.dart';
import 'package:lumen_app/src/storage/in_memory_app_database.dart';
import 'package:lumen_app/src/storage/module_config_repository.dart';

void main() {
  group('AppConsentStore', () {
    test('reports no consent for a module that has never granted it', () {
      final repository = ModuleConfigRepository(InMemoryAppDatabase());
      final consentStore = AppConsentStore(repository);

      expect(consentStore.hasConsent('family', 'share-status'), isFalse);
    });

    test('reports consent once the module config grants it', () async {
      final repository = ModuleConfigRepository(InMemoryAppDatabase());
      final consentStore = AppConsentStore(repository);
      await repository.setConsentGranted('family', true);

      expect(consentStore.hasConsent('family', 'share-status'), isTrue);
      expect(consentStore.hasConsent('family', 'any-other-key'), isTrue);
    });

    test('consent is scoped per module', () async {
      final repository = ModuleConfigRepository(InMemoryAppDatabase());
      final consentStore = AppConsentStore(repository);
      await repository.setConsentGranted('family', true);

      expect(consentStore.hasConsent('safety', 'share-status'), isFalse);
    });
  });
}
