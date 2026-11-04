import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/theme/app_colors.dart';
import 'package:lumen_plugin_vision/lumen_plugin_vision.dart';

RgbColor _fromColor(Color color) => RgbColor(
    (color.r * 255).round(), (color.g * 255).round(), (color.b * 255).round());

void main() {
  const checker = ContrastChecker();

  ContrastResult ratio(Color foreground, Color background) =>
      checker.check(_fromColor(foreground), _fromColor(background));

  test('ink clears WCAG AAA on the paper and the card surface', () {
    for (final background in [AppColors.background, AppColors.surface]) {
      final result = ratio(AppColors.ink, background);
      expect(result.passes(WcagLevel.aaa), isTrue,
          reason: 'ratio was ${result.ratio}');
    }
  });

  test('muted text clears WCAG AA on the paper and the card surface', () {
    for (final background in [AppColors.background, AppColors.surface]) {
      final result = ratio(AppColors.muted, background);
      expect(result.passes(WcagLevel.aa), isTrue,
          reason: 'ratio was ${result.ratio}');
    }
  });

  test('the critical color clears WCAG AA as text on the paper', () {
    final result = ratio(AppColors.critical, AppColors.background);
    expect(result.passes(WcagLevel.aa), isTrue,
        reason: 'ratio was ${result.ratio}');
  });

  test('ink on every module fill and on the brand yellow clears AAA', () {
    final fills = {...AppColors.moduleColors, 'brand': AppColors.amber};
    for (final entry in fills.entries) {
      final result = ratio(AppColors.ink, entry.value);
      expect(result.passes(WcagLevel.aaa), isTrue,
          reason: '${entry.key} gave only ${result.ratio}');
    }
  });

  test('moduleColorOf falls back to the brand yellow for an unknown id', () {
    expect(AppColors.moduleColorOf('not-a-module'), AppColors.amber);
  });
}
