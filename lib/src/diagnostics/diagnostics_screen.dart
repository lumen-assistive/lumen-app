import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lumen_core/lumen_core.dart';
import 'package:pub_semver/pub_semver.dart';

import '../consent/app_capability_gate.dart';
import '../consent/app_consent_store.dart';
import '../l10n/app_strings.dart';
import '../storage/in_memory_app_database.dart';
import '../storage/module_config_repository.dart';

/// A developer-only screen showing what `lumen-core`'s plugin manager
/// actually knows right now.
///
/// No plugin is registered with a live `PluginManager` in this
/// release (see the README: the plugin packages ship business logic
/// only so far, with no Flutter UI to host), so this screen honestly
/// shows an empty plugin list rather than a fabricated one. Battery
/// drain and latency figures are not estimated or invented: both
/// require on-device instrumentation (`lumen-models`' benchmark
/// harness, and platform battery APIs) that this screen does not have
/// access to, so both read "not available yet" until that exists.
class DiagnosticsScreen extends StatelessWidget {
  const DiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    final pluginManager = PluginManager(
      eventBus: InMemoryEventBus(),
      modelRegistry: LocalModelRegistry(
        catalog: const [],
        modelsDirectory: Directory.systemTemp,
      ),
      capabilityGate: AppCapabilityGate(),
      consentStore: AppConsentStore(
        ModuleConfigRepository(InMemoryAppDatabase()),
      ),
      sdkVersion: Version.parse('0.1.0'),
    );

    return Scaffold(
      appBar: AppBar(title: Text(strings('diagnosticsTitle'))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (pluginManager.registeredPluginIds.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  strings('diagnosticsNoPlugins'),
                  textAlign: TextAlign.center,
                ),
              )
            else
              for (final pluginId in pluginManager.registeredPluginIds)
                ListTile(
                  title: Text(pluginId),
                  subtitle: Text('${pluginManager.stateOf(pluginId)}'),
                ),
            const Divider(height: 32),
            ListTile(
              title: Text(strings('diagnosticsBatteryLabel')),
              trailing: Text(strings('diagnosticsNotAvailable')),
            ),
            ListTile(
              title: Text(strings('diagnosticsLatencyLabel')),
              trailing: Text(strings('diagnosticsNotAvailable')),
            ),
          ],
        ),
      ),
    );
  }
}
