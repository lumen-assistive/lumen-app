import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/consent/app_capability_gate.dart';
import 'package:lumen_sdk/lumen_sdk.dart';

void main() {
  group('AppCapabilityGate', () {
    test('reports capabilities as not granted by default', () {
      final gate = AppCapabilityGate();

      expect(gate.hasCapabilities([PluginCapability.camera]), isFalse);
    });

    test('reports granted capabilities as satisfied, requiring every one', () {
      final gate = AppCapabilityGate()
        ..grantCapability(PluginCapability.camera);

      expect(gate.hasCapabilities([PluginCapability.camera]), isTrue);
      expect(
        gate.hasCapabilities([
          PluginCapability.camera,
          PluginCapability.microphone,
        ]),
        isFalse,
      );
    });

    test('revokeCapability removes a previously granted capability', () {
      final gate = AppCapabilityGate()
        ..grantCapability(PluginCapability.microphone);

      gate.revokeCapability(PluginCapability.microphone);

      expect(gate.hasCapabilities([PluginCapability.microphone]), isFalse);
    });

    test('an empty capability list is always satisfied', () {
      final gate = AppCapabilityGate();

      expect(gate.hasCapabilities(const []), isTrue);
    });
  });
}
