import 'package:lumen_sdk/lumen_sdk.dart';
import 'package:lumen_core/lumen_core.dart';

/// [CapabilityGate] backed by a simple in-memory set of granted
/// capabilities.
///
/// This does not yet request real operating system permissions: no
/// plugin is wired into a live `PluginManager` in this release (see
/// the README), so there is nothing to gate in production yet. This
/// class exists so the integration point is real and tested now,
/// ready for a follow-up phase that wires actual platform permission
/// requests (camera, microphone, SMS, location) into
/// [grantCapability] and [revokeCapability].
class AppCapabilityGate implements CapabilityGate {
  final Set<PluginCapability> _granted = {};

  void grantCapability(PluginCapability capability) => _granted.add(capability);

  void revokeCapability(PluginCapability capability) =>
      _granted.remove(capability);

  @override
  bool hasCapabilities(List<PluginCapability> capabilities) {
    return capabilities.every(_granted.contains);
  }
}
