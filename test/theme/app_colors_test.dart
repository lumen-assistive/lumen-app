import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/theme/app_colors.dart';
import 'package:lumen_plugin_vision/lumen_plugin_vision.dart';

RgbColor _fromColor(Color color) => RgbColor(
    (color.r * 255).round(), (color.g * 255).round(), (color.b * 255).round());

void main() {
  const checker = ContrastChecker();

  test('the brand accent clears WCAG AAA against the background', () {
    final result = checker.check(
        _fromColor(AppColors.amber), _fromColor(AppColors.background));
    expect(result.passes(WcagLevel.aaa), isTrue,
        reason: 'ratio was ${result.ratio}');
  });

  test('the high-contrast accent clears WCAG AAA against the background', () {
    final result = checker.check(_fromColor(AppColors.amberHighContrast),
        _fromColor(AppColors.background));
    expect(result.passes(WcagLevel.aaa), isTrue,
        reason: 'ratio was ${result.ratio}');
  });

  test('text clears WCAG AAA against both surfaces', () {
    final onBackground = checker.check(
        _fromColor(AppColors.text), _fromColor(AppColors.background));
    final onSurface = checker.check(
        _fromColor(AppColors.text), _fromColor(AppColors.surface));
    expect(onBackground.passes(WcagLevel.aaa), isTrue,
        reason: 'background ratio was ${onBackground.ratio}');
    expect(onSurface.passes(WcagLevel.aaa), isTrue,
        reason: 'surface ratio was ${onSurface.ratio}');
  });

  test(
      'every module color clears real WCAG non-text contrast (3:1) against '
      'the background and the surface', () {
    for (final entry in AppColors.moduleColors.entries) {
      final onBackground = checker.check(
          _fromColor(entry.value), _fromColor(AppColors.background));
      final onSurface =
          checker.check(_fromColor(entry.value), _fromColor(AppColors.surface));
      expect(onBackground.ratio, greaterThanOrEqualTo(3.0),
          reason: '${entry.key} on background was only ${onBackground.ratio}');
      expect(onSurface.ratio, greaterThanOrEqualTo(3.0),
          reason: '${entry.key} on surface was only ${onSurface.ratio}');
    }
  });

  test('moduleColorOf falls back to the brand accent for an unknown id', () {
    expect(AppColors.moduleColorOf('not-a-module'), AppColors.amber);
  });
}
