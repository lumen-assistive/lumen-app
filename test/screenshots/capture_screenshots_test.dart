import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:lumen_app/src/home/home_screen.dart';
import 'package:lumen_app/src/l10n/app_strings.dart';
import 'package:lumen_app/src/modules/family_screen.dart';
import 'package:lumen_app/src/modules/reading_screen.dart';
import 'package:lumen_app/src/modules/mobility_screen.dart';
import 'package:lumen_app/src/modules/speech_screen.dart';
import 'package:lumen_app/src/modules/safety_screen.dart';
import 'package:lumen_app/src/modules/memory_screen.dart';
import 'package:lumen_app/src/modules/hearing_screen.dart';
import 'package:lumen_app/src/modules/vision_screen.dart';
import 'package:lumen_app/src/onboarding/module_catalog.dart';
import 'package:lumen_app/src/onboarding/onboarding_screen.dart';
import 'package:lumen_app/src/settings/settings_screen.dart';
import 'package:lumen_app/src/storage/in_memory_app_database.dart';
import 'package:lumen_app/src/storage/module_config_repository.dart';
import 'package:lumen_app/src/storage/user_profile.dart';
import 'package:lumen_app/src/storage/user_profile_repository.dart';
import 'package:lumen_app/src/theme/app_theme.dart';
import 'package:lumen_app/src/theme/module_scope.dart';
import 'package:lumen_app/src/theme/ui_mode.dart';

/// Captures real screenshots of the app's own widget tree, for use in the
/// organization profile and the website: not hand-drawn mockups, the same
/// widgets that ship in the app, rendered once and saved as PNG.
///
/// `flutter test` renders with a fallback test font by default (real text
/// shows as boxes), which would make the captured images unreadable;
/// `golden_toolkit`'s `loadAppFonts` loads the real bundled fonts first so
/// the output looks like the app actually looks. These tests write their
/// PNG unconditionally rather than comparing against a golden baseline
/// (`matchesGoldenFile`'s usual job): the goal here is a real artifact to
/// display, not a pixel-exact regression gate, which would be fragile
/// across machines with different font rendering.
const _outputDir = 'docs/screenshots';

ThemeData _screenshotTheme() => AppTheme.resolve(UiMode.complete);

Widget _wrap(Widget child, GlobalKey boundaryKey) {
  return RepaintBoundary(
    key: boundaryKey,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _screenshotTheme(),
      locale: const Locale('en'),
      localizationsDelegates: [
        AppStrings.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppStrings.supportedLocales,
      home: child,
    ),
  );
}

Future<void> _tapButtonWithText(WidgetTester tester, String text) async {
  var finder = find.widgetWithText(ElevatedButton, text);
  if (finder.evaluate().isEmpty) {
    finder = find.widgetWithText(OutlinedButton, text);
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _tapChipWithText(WidgetTester tester, String text) async {
  final finder = find.widgetWithText(ActionChip, text);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _captureScreen(
  WidgetTester tester,
  Widget child,
  String fileName, {
  Future<void> Function(WidgetTester tester)? interact,
  String? moduleId,
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  final boundaryKey = GlobalKey();
  await tester.pumpWidget(_wrap(
    moduleId == null ? child : ModuleScope(moduleId: moduleId, child: child),
    boundaryKey,
  ));
  await tester.pumpAndSettle();

  if (interact != null) {
    await interact(tester);
  }

  if (moduleId != null) {
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 6000));
    await tester.pumpAndSettle();
  }

  // RenderRepaintBoundary.toImage() rasterizes on the engine's raster
  // thread via a real Future, which the fake-async zone widget tests
  // normally run in cannot resolve: it must run inside `runAsync`.
  await tester.runAsync(() async {
    final boundary = boundaryKey.currentContext!.findRenderObject()!
        as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    final file = File('$_outputDir/$fileName');
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(bytes);
  });
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testWidgets('captures the onboarding screen', (tester) async {
    await _captureScreen(
      tester,
      OnboardingScreen(onComplete: (_) {}),
      'onboarding.png',
    );
  });

  testWidgets('captures the settings screen', (tester) async {
    final database = InMemoryAppDatabase();
    final userProfileRepository = UserProfileRepository(database);
    final moduleConfigRepository = ModuleConfigRepository(database);
    await userProfileRepository.load();
    await moduleConfigRepository.load();
    await _captureScreen(
      tester,
      SettingsScreen(
        userProfileRepository: userProfileRepository,
        moduleConfigRepository: moduleConfigRepository,
      ),
      'settings.png',
    );
  });

  testWidgets('captures the home screen with all eight modules enabled', (
    tester,
  ) async {
    final profile = UserProfile(
      uiMode: UiMode.complete,
      enabledModuleIds: availableModules.map((module) => module.id).toSet(),
      textScale: 1,
    );
    await _captureScreen(
      tester,
      HomeScreen(
        profile: profile,
        onOpenSettings: () {},
        onOpenModule: (_) {},
      ),
      'home.png',
    );
  });

  testWidgets('captures the Vision screen with both tools run', (
    tester,
  ) async {
    await _captureScreen(tester, const VisionScreen(), 'vedere.png',
        moduleId: 'vision', interact: (tester) async {
      await _tapButtonWithText(tester, 'Find the expiry date');
      await _tapButtonWithText(tester, 'Name color');
    });
  });

  testWidgets('captures the Hearing screen with both tools run', (
    tester,
  ) async {
    await _captureScreen(tester, const HearingScreen(), 'sentire.png',
        moduleId: 'hearing', interact: (tester) async {
      await _tapButtonWithText(tester, 'Summarize');
      await _tapButtonWithText(tester, 'Show and vibrate');
    });
  });

  testWidgets(
      'captures the Safety screen with the scam filter and fall '
      'detector run', (tester) async {
    await _captureScreen(tester, const SafetyScreen(), 'protezione.png',
        moduleId: 'safety', interact: (tester) async {
      await _tapButtonWithText(tester, 'Check message');
      await _tapButtonWithText(tester, 'Simulate a fall');
    });
  });

  testWidgets('captures the Family screen with a pairing code and status set', (
    tester,
  ) async {
    await _captureScreen(tester, const FamilyScreen(), 'famiglia.png',
        moduleId: 'family', interact: (tester) async {
      await _tapButtonWithText(tester, 'Generate code');
      await _tapButtonWithText(tester, 'All ok');
    });
  });

  testWidgets('captures the Speech screen with a couple of phrases used', (
    tester,
  ) async {
    await _captureScreen(tester, const SpeechScreen(), 'parlare.png',
        moduleId: 'speech', interact: (tester) async {
      await _tapChipWithText(tester, 'Water');
      await _tapChipWithText(tester, 'Thank you');
    });
  });

  testWidgets(
      'captures the Reading screen with the splitter and a flashcard '
      'review run', (tester) async {
    await _captureScreen(tester, const ReadingScreen(), 'leggere.png',
        moduleId: 'reading', interact: (tester) async {
      await _tapButtonWithText(tester, 'Split into syllables');
      await _tapButtonWithText(tester, '5');
    });
  });

  testWidgets('captures the Memory screen with a person and a reminder added', (
    tester,
  ) async {
    await _captureScreen(tester, const MemoryScreen(), 'ricordare.png',
        moduleId: 'memory', interact: (tester) async {
      await _tapButtonWithText(tester, 'Add person');
      await _tapButtonWithText(tester, 'Add reminder');
    });
  });

  testWidgets('captures the Mobility screen with a steady walk simulated', (
    tester,
  ) async {
    await _captureScreen(tester, const MobilityScreen(), 'muoversi.png',
        moduleId: 'mobility', interact: (tester) async {
      await _tapButtonWithText(tester, 'Simulate steady walk');
    });
  });
}
