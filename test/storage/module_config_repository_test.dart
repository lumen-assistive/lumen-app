import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/storage/in_memory_app_database.dart';
import 'package:lumen_app/src/storage/module_config_repository.dart';

void main() {
  group('ModuleConfigRepository', () {
    test(
        'configFor returns a disabled, no-consent default for an unconfigured module',
        () {
      final repository = ModuleConfigRepository(InMemoryAppDatabase());

      final config = repository.configFor('vision');

      expect(config.enabled, isFalse);
      expect(config.consentGranted, isFalse);
    });

    test('setEnabled persists and is reflected in configFor', () async {
      final repository = ModuleConfigRepository(InMemoryAppDatabase());

      await repository.setEnabled('hearing', true);

      expect(repository.configFor('hearing').enabled, isTrue);
    });

    test('setConsentGranted does not affect the enabled flag', () async {
      final repository = ModuleConfigRepository(InMemoryAppDatabase());
      await repository.setEnabled('family', true);

      await repository.setConsentGranted('family', true);

      final config = repository.configFor('family');
      expect(config.enabled, isTrue);
      expect(config.consentGranted, isTrue);
    });

    test('save notifies listeners', () async {
      final repository = ModuleConfigRepository(InMemoryAppDatabase());
      var notified = false;
      repository.addListener(() => notified = true);

      await repository.setEnabled('safety', true);

      expect(notified, isTrue);
    });

    test(
      'configs reflects every saved configuration keyed by module id',
      () async {
        final repository = ModuleConfigRepository(InMemoryAppDatabase());

        await repository.setEnabled('vision', true);
        await repository.setEnabled('hearing', true);

        expect(repository.configs.keys, containsAll(['vision', 'hearing']));
      },
    );
  });
}
