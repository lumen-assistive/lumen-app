import 'app_services.dart';

/// A rolling window of the most recent accelerometer samples.
///
/// The fall and gait detectors judge a stretch of readings, not a single
/// one, so live mode keeps the last few seconds and hands that window to
/// the detector on a timer. Old samples are dropped as new ones arrive so
/// memory stays bounded however long live mode runs.
class MotionWindow {
  MotionWindow({this.maxAge = const Duration(seconds: 10)});

  final Duration maxAge;
  final List<MotionSample> _samples = [];

  List<MotionSample> get samples => List.unmodifiable(_samples);

  int get length => _samples.length;

  void add(MotionSample sample) {
    _samples.add(sample);
    final cutoff = sample.timestamp.subtract(maxAge);
    while (_samples.isNotEmpty && _samples.first.timestamp.isBefore(cutoff)) {
      _samples.removeAt(0);
    }
  }

  void clear() => _samples.clear();
}
