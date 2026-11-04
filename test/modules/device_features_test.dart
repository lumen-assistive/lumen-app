import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/hearing_screen.dart';
import 'package:lumen_app/src/modules/memory_screen.dart';
import 'package:lumen_app/src/modules/mobility_screen.dart';
import 'package:lumen_app/src/modules/safety_screen.dart';
import 'package:lumen_app/src/modules/speech_screen.dart';
import 'package:lumen_app/src/services/app_services.dart';
import 'package:lumen_app/src/storage/in_memory_app_database.dart';
import 'package:lumen_app/src/storage/module_data_repository.dart';
import 'package:lumen_app/src/storage/module_data_scope.dart';

class _RecordingSpeaker implements TextSpeaker {
  final List<String> spoken = [];

  @override
  Future<bool> speak(String text) async {
    spoken.add(text);
    return true;
  }

  @override
  Future<void> stop() async {}
}

class _RecordingHaptics implements Haptics {
  _RecordingHaptics({this.available = true});

  final bool available;
  final List<List<int>> patterns = [];

  @override
  Future<bool> get isAvailable async => available;

  @override
  Future<void> vibrate(List<int> patternMs) async => patterns.add(patternMs);
}

class _ControlledMotion implements MotionSource {
  final StreamController<MotionSample> controller =
      StreamController<MotionSample>.broadcast();

  @override
  Stream<MotionSample> samples() => controller.stream;
}

Widget _wrap(
  Widget child, {
  AppServices? services,
  ModuleDataRepository? repository,
}) {
  Widget home = child;
  if (services != null) {
    home = AppServicesScope(services: services, child: home);
  }
  if (repository != null) {
    home = ModuleDataScope(repository: repository, child: home);
  }
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: [
      AppStrings.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: AppStrings.supportedLocales,
    home: home,
  );
}

void _tall(WidgetTester tester) {
  tester.view.physicalSize = const Size(2400, 9000);
  addTearDown(tester.view.resetPhysicalSize);
}

List<MotionSample> _fall() {
  final base = DateTime(2026, 1, 1, 8);
  MotionSample at(int ms, double magnitude) => MotionSample(
        x: 0,
        y: 0,
        z: magnitude,
        timestamp: base.add(Duration(milliseconds: ms)),
      );
  return [
    for (var ms = 0; ms <= 400; ms += 50) at(ms, 0.5),
    at(450, 30),
    for (var ms = 500; ms <= 2600; ms += 50) at(ms, 9.8),
  ];
}

void main() {
  testWidgets('tapping a phrase speaks it aloud', (tester) async {
    _tall(tester);
    final speaker = _RecordingSpeaker();
    await tester.pumpWidget(
      _wrap(
        const SpeechScreen(),
        services: AppServices(
          speaker: speaker,
          haptics: const SilentHaptics(),
          motion: const SilentMotionSource(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ActionChip, 'Water').first);
    await tester.pumpAndSettle();
    expect(speaker.spoken, ['Water']);
  });

  testWidgets('phrase usage is remembered across launches', (tester) async {
    _tall(tester);
    final database = InMemoryAppDatabase();
    final first = ModuleDataRepository(database);
    await tester.pumpWidget(_wrap(const SpeechScreen(), repository: first));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ActionChip, 'Water').first);
    await tester.pumpAndSettle();

    final second = ModuleDataRepository(database);
    await second.load(['speech']);
    await tester.pumpWidget(
      _wrap(SpeechScreen(key: UniqueKey()), repository: second),
    );
    await tester.pumpAndSettle();
    expect(find.text('Top suggestions'), findsOneWidget);
  });

  testWidgets('a reminder added in one launch is due in the next', (
    tester,
  ) async {
    _tall(tester);
    final database = InMemoryAppDatabase();
    final first = ModuleDataRepository(database);
    await tester.pumpWidget(_wrap(const MemoryScreen(), repository: first));
    await tester.pumpAndSettle();
    final add = find.widgetWithText(ElevatedButton, 'Add reminder');
    await tester.ensureVisible(add);
    await tester.tap(add);
    await tester.pumpAndSettle();

    final second = ModuleDataRepository(database);
    await second.load(['memory']);
    await tester.pumpWidget(
      _wrap(MemoryScreen(key: UniqueKey()), repository: second),
    );
    await tester.pumpAndSettle();
    final check = find.widgetWithText(OutlinedButton, 'Check due reminders');
    await tester.ensureVisible(check);
    await tester.tap(check);
    await tester.pumpAndSettle();
    expect(find.textContaining('Due now: Take medicine'), findsOneWidget);
  });

  testWidgets('the hearing alert vibrates the device with its pattern', (
    tester,
  ) async {
    _tall(tester);
    final haptics = _RecordingHaptics();
    await tester.pumpWidget(
      _wrap(
        const HearingScreen(),
        services: AppServices(
          speaker: const SilentTextSpeaker(),
          haptics: haptics,
          motion: const SilentMotionSource(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final button = find.widgetWithText(ElevatedButton, 'Show and vibrate');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(haptics.patterns, hasLength(1));
    expect(haptics.patterns.single, isNotEmpty);
  });

  testWidgets('the hearing alert says so when there is no vibrator', (
    tester,
  ) async {
    _tall(tester);
    await tester.pumpWidget(
      _wrap(
        const HearingScreen(),
        services: AppServices(
          speaker: const SilentTextSpeaker(),
          haptics: _RecordingHaptics(available: false),
          motion: const SilentMotionSource(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final button = find.widgetWithText(ElevatedButton, 'Show and vibrate');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.textContaining('no vibrator'), findsOneWidget);
  });

  testWidgets('live accelerometer mode reports a fall and vibrates', (
    tester,
  ) async {
    _tall(tester);
    final motion = _ControlledMotion();
    final haptics = _RecordingHaptics();
    await tester.pumpWidget(
      _wrap(
        const SafetyScreen(),
        services: AppServices(
          speaker: const SilentTextSpeaker(),
          haptics: haptics,
          motion: motion,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final toggle =
        find.widgetWithText(SwitchListTile, 'Use the live accelerometer');
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pump();
    expect(find.textContaining('Watching for a fall'), findsOneWidget);

    for (final sample in _fall()) {
      motion.controller.add(sample);
    }
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Fall detected from live sensor data.'), findsOneWidget);
    expect(haptics.patterns, isNotEmpty);

    await tester.tap(toggle);
    await tester.pump();
    await motion.controller.close();
  });

  testWidgets('live gait mode analyses real samples every two seconds', (
    tester,
  ) async {
    _tall(tester);
    final motion = _ControlledMotion();
    await tester.pumpWidget(
      _wrap(
        const MobilityScreen(),
        services: AppServices(
          speaker: const SilentTextSpeaker(),
          haptics: const SilentHaptics(),
          motion: motion,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final toggle =
        find.widgetWithText(SwitchListTile, 'Use the live accelerometer');
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pump();

    final base = DateTime(2026, 1, 1, 8);
    // A steady walk: a step peak every 500 ms for ten steps.
    for (var step = 0; step < 10; step++) {
      for (final (offset, magnitude) in [(0, 9.0), (100, 13.0), (200, 9.0)]) {
        motion.controller.add(
          MotionSample(
            x: 0,
            y: 0,
            z: magnitude,
            timestamp: base.add(Duration(milliseconds: step * 500 + offset)),
          ),
        );
      }
    }
    await tester.pump(const Duration(seconds: 2));
    expect(find.textContaining('steps detected'), findsOneWidget);
    expect(find.textContaining('Steady rhythm'), findsOneWidget);

    await tester.tap(toggle);
    await tester.pump();
    await motion.controller.close();
  });
}
