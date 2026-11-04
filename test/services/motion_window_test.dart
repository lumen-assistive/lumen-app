import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/services/app_services.dart';
import 'package:lumen_app/src/services/motion_window.dart';

MotionSample _at(int ms) => MotionSample(
      x: 0,
      y: 0,
      z: 9.8,
      timestamp: DateTime(2026, 1, 1).add(Duration(milliseconds: ms)),
    );

void main() {
  test('keeps samples inside the window and drops older ones', () {
    final window = MotionWindow(maxAge: const Duration(seconds: 1));
    for (var ms = 0; ms <= 2500; ms += 500) {
      window.add(_at(ms));
    }
    expect(window.samples.first.timestamp, _at(1500).timestamp);
    expect(window.length, 3);
  });

  test('clear empties the window', () {
    final window = MotionWindow()..add(_at(0));
    window.clear();
    expect(window.length, 0);
  });
}
