import 'package:flutter/material.dart';
import 'package:lumen_plugin_mobility/lumen_plugin_mobility.dart';

import '../l10n/app_strings.dart';
import '../theme/module_icon.dart';
import 'widgets/module_note.dart';
import 'widgets/tool_card.dart';

List<AccelerometerSample> _walkFromStepOffsets(List<int> offsetsMs) {
  final base = DateTime(2026, 1, 1, 8);
  final samples = <AccelerometerSample>[
    AccelerometerSample(
      x: 0,
      y: 0,
      z: 9.0,
      timestamp: base.subtract(const Duration(milliseconds: 150)),
    ),
  ];
  for (final offset in offsetsMs) {
    final stepTime = base.add(Duration(milliseconds: offset));
    samples.add(
      AccelerometerSample(
        x: 0,
        y: 0,
        z: 9.0,
        timestamp: stepTime.subtract(const Duration(milliseconds: 120)),
      ),
    );
    samples.add(AccelerometerSample(x: 0, y: 0, z: 13.0, timestamp: stepTime));
  }
  return samples;
}

final _steadyWalk =
    _walkFromStepOffsets([0, 600, 1200, 1800, 2400, 3000, 3600, 4200]);
final _unsteadyWalk =
    _walkFromStepOffsets([0, 300, 1200, 1500, 2700, 3000, 4500, 4800]);

/// Muoversi (Move) module screen.
///
/// Runs the real `GaitStabilityMonitor` from `lumen_plugin_mobility`
/// over two preset accelerometer windows, and the real
/// `MobilityProfile` data model with its validator. There is no live
/// accelerometer feed in this app yet, the same reason
/// `lumen_plugin_safety`'s `FallDetector` also works on injected
/// samples rather than a live sensor.
class MobilityScreen extends StatefulWidget {
  const MobilityScreen({super.key});

  @override
  State<MobilityScreen> createState() => _MobilityScreenState();
}

class _MobilityScreenState extends State<MobilityScreen> {
  static const _monitor = GaitStabilityMonitor();
  static const _breakPlanner = RestBreakPlanner();

  String? _gaitResult;

  final _walkMinutesController = TextEditingController(text: '40');
  String? _breakPlanResult;

  MobilityAidType _aidType = MobilityAidType.none;
  GuidanceVerbosity _verbosity = GuidanceVerbosity.standard;
  final _notesController = TextEditingController();
  String? _profileResult;

  @override
  void dispose() {
    _notesController.dispose();
    _walkMinutesController.dispose();
    super.dispose();
  }

  void _runGaitMonitor(List<AccelerometerSample> samples) {
    final result = _monitor.analyze(samples);
    final strings = AppStrings.of(context);
    setState(() {
      _gaitResult = strings('mobilityGaitResult')
          .replaceAll('{steps}', result.stepCount.toString())
          .replaceAll(
            '{cadence}',
            result.cadenceStepsPerMinute.toStringAsFixed(0),
          )
          .replaceAll(
            '{irregular}',
            result.isIrregular
                ? strings('mobilityGaitIrregular')
                : strings('mobilityGaitSteady'),
          );
    });
  }

  void _planBreaks() {
    final minutes = int.tryParse(_walkMinutesController.text) ?? 0;
    final points = _breakPlanner.breakPoints(
      totalDuration: Duration(minutes: minutes),
      verbosity: _verbosity,
    );
    final strings = AppStrings.of(context);
    setState(() {
      _breakPlanResult = points.isEmpty
          ? strings('mobilityBreaksNone')
          : strings('mobilityBreaksResult').replaceAll(
              '{minutes}',
              points.map((point) => point.inMinutes.toString()).join(', '),
            );
    });
  }

  void _saveProfile() {
    final profile = MobilityProfile(
      aidType: _aidType,
      guidanceVerbosity: _verbosity,
      notes: _notesController.text,
    );
    final error = validateMobilityProfile(profile);
    final strings = AppStrings.of(context);
    setState(() {
      _profileResult =
          error == null ? strings('mobilityProfileSaved') : error.message;
    });
  }

  String _aidLabel(AppStrings strings, MobilityAidType type) {
    return switch (type) {
      MobilityAidType.none => strings('mobilityAidNone'),
      MobilityAidType.cane => strings('mobilityAidCane'),
      MobilityAidType.wheelchair => strings('mobilityAidWheelchair'),
      MobilityAidType.walker => strings('mobilityAidWalker'),
      MobilityAidType.other => strings('mobilityAidOther'),
    };
  }

  String _verbosityLabel(AppStrings strings, GuidanceVerbosity verbosity) {
    return switch (verbosity) {
      GuidanceVerbosity.minimal => strings('mobilityVerbosityMinimal'),
      GuidanceVerbosity.standard => strings('mobilityVerbosityStandard'),
      GuidanceVerbosity.detailed => strings('mobilityVerbosityDetailed'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ModuleIcon(moduleId: 'mobility', size: 22),
            const SizedBox(width: 10),
            Text(strings('moduleNameMobility')),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModuleNote(text: strings('mobilityNote')),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('mobilityGaitTitle'),
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _runGaitMonitor(_steadyWalk),
                      child: Text(strings('mobilityGaitSteadyButton')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _runGaitMonitor(_unsteadyWalk),
                      child: Text(strings('mobilityGaitUnsteadyButton')),
                    ),
                  ),
                ],
              ),
              if (_gaitResult != null) ToolOutput(text: _gaitResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('mobilityProfileTitle'),
            children: [
              DropdownButton<MobilityAidType>(
                isExpanded: true,
                value: _aidType,
                items: MobilityAidType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(_aidLabel(strings, type)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _aidType = value);
                },
              ),
              const SizedBox(height: 8),
              DropdownButton<GuidanceVerbosity>(
                isExpanded: true,
                value: _verbosity,
                items: GuidanceVerbosity.values
                    .map(
                      (verbosity) => DropdownMenuItem(
                        value: verbosity,
                        child: Text(_verbosityLabel(strings, verbosity)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _verbosity = value);
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: strings('mobilityProfileNotesHint'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text(strings('mobilityProfileButton')),
                ),
              ),
              if (_profileResult != null) ToolOutput(text: _profileResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('mobilityBreaksTitle'),
            children: [
              Text(strings('mobilityBreaksHint')),
              const SizedBox(height: 8),
              TextField(
                controller: _walkMinutesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: strings('mobilityBreaksMinutesHint'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _planBreaks,
                  child: Text(strings('mobilityBreaksButton')),
                ),
              ),
              if (_breakPlanResult != null) ToolOutput(text: _breakPlanResult!),
            ],
          ),
        ],
      ),
    );
  }
}
