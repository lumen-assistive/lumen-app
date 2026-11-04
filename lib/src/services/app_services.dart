import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';

/// Speaks text aloud.
abstract class TextSpeaker {
  /// Speaks [text], replacing anything already being spoken. Returns
  /// `false` if the device has no usable speech engine.
  Future<bool> speak(String text);

  Future<void> stop();
}

/// Plays vibration patterns.
abstract class Haptics {
  /// Whether this device has a vibrator at all.
  Future<bool> get isAvailable;

  /// Vibrates following [patternMs], which alternates vibrate and pause
  /// durations in milliseconds, starting with a vibration.
  Future<void> vibrate(List<int> patternMs);
}

/// One raw accelerometer reading in m/s^2, gravity included.
class MotionSample {
  const MotionSample({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  final double x;
  final double y;
  final double z;
  final DateTime timestamp;
}

/// A live stream of accelerometer readings.
abstract class MotionSource {
  Stream<MotionSample> samples();
}

/// [TextSpeaker] backed by the platform text-to-speech engine through
/// `flutter_tts`.
class DeviceTextSpeaker implements TextSpeaker {
  final FlutterTts _tts = FlutterTts();
  bool _configured = false;

  @override
  Future<bool> speak(String text) async {
    try {
      if (!_configured) {
        await _tts.setLanguage('en-US');
        _configured = true;
      }
      await _tts.stop();
      final result = await _tts.speak(text);
      return result == 1;
    } on Object {
      return false;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _tts.stop();
    } on Object {
      return;
    }
  }
}

/// [Haptics] backed by the device vibrator through the `vibration` plugin.
class DeviceHaptics implements Haptics {
  @override
  Future<bool> get isAvailable async {
    try {
      return await Vibration.hasVibrator();
    } on Object {
      return false;
    }
  }

  @override
  Future<void> vibrate(List<int> patternMs) async {
    if (patternMs.isEmpty || !await isAvailable) return;
    // The plugin treats the first entry as an initial wait, so a leading
    // zero makes the first pattern entry a vibration, as callers expect.
    await Vibration.vibrate(pattern: [0, ...patternMs]);
  }
}

/// [MotionSource] backed by the device accelerometer through
/// `sensors_plus`.
///
/// The plain accelerometer (gravity included) is used on purpose: the
/// fall and gait detectors are tuned against raw magnitudes where a
/// device at rest reads about 9.8, not against gravity-free readings.
class DeviceMotionSource implements MotionSource {
  @override
  Stream<MotionSample> samples() {
    return accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).map(
      (event) => MotionSample(
        x: event.x,
        y: event.y,
        z: event.z,
        timestamp: DateTime.now(),
      ),
    );
  }
}

/// A [TextSpeaker] that does nothing, used in tests and when no engine is
/// wired in.
class SilentTextSpeaker implements TextSpeaker {
  const SilentTextSpeaker();

  @override
  Future<bool> speak(String text) async => false;

  @override
  Future<void> stop() async {}
}

class SilentHaptics implements Haptics {
  const SilentHaptics();

  @override
  Future<bool> get isAvailable async => false;

  @override
  Future<void> vibrate(List<int> patternMs) async {}
}

class SilentMotionSource implements MotionSource {
  const SilentMotionSource();

  @override
  Stream<MotionSample> samples() => const Stream.empty();
}

/// The device capabilities module screens use, grouped so screens ask for
/// them in one place and tests can replace them with fakes.
class AppServices {
  const AppServices({
    required this.speaker,
    required this.haptics,
    required this.motion,
  });

  /// Services that do nothing: the default when no [AppServicesScope] is
  /// present, which keeps a screen pumped alone in a widget test working.
  const AppServices.silent()
      : speaker = const SilentTextSpeaker(),
        haptics = const SilentHaptics(),
        motion = const SilentMotionSource();

  /// Services backed by the real device.
  factory AppServices.device() => AppServices(
        speaker: DeviceTextSpeaker(),
        haptics: DeviceHaptics(),
        motion: DeviceMotionSource(),
      );

  final TextSpeaker speaker;
  final Haptics haptics;
  final MotionSource motion;

  static AppServices of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<AppServicesScope>()
          ?.services ??
      const AppServices.silent();
}

class AppServicesScope extends InheritedWidget {
  const AppServicesScope({
    super.key,
    required this.services,
    required super.child,
  });

  final AppServices services;

  @override
  bool updateShouldNotify(AppServicesScope oldWidget) =>
      services != oldWidget.services;
}
