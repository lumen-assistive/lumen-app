import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/theme/app_colors.dart';
import 'package:lumen_plugin_vision/lumen_plugin_vision.dart';

RgbColor _fromColor(Color color) => RgbColor(
    (color.r * 255).round(), (color.g * 255).round(), (color.b * 255).round());

void main() {
  const checker = ContrastChecker();

  test('the regular-tier light accent clears WCAG AA against paper', () {
    final result = checker.check(
        _fromColor(AppColors.amberLight), _fromColor(AppColors.paperLight));
    expect(result.passes(WcagLevel.aa), isTrue,
        reason: 'ratio was ${result.ratio}');
  });

  test('the regular-tier dark accent clears WCAG AA against the dark surface',
      () {
    final result = checker.check(
        _fromColor(AppColors.amberDark), _fromColor(AppColors.inkDark));
    expect(result.passes(WcagLevel.aa), isTrue,
        reason: 'ratio was ${result.ratio}');
  });

  test('the high-contrast accent clears WCAG AAA against paper and white', () {
    final onPaper = checker.check(_fromColor(AppColors.amberHighContrast),
        _fromColor(AppColors.paperLight));
    final onWhite = checker.check(
        _fromColor(AppColors.amberHighContrast), const RgbColor(255, 255, 255));
    expect(onPaper.passes(WcagLevel.aaa), isTrue,
        reason: 'paper ratio was ${onPaper.ratio}');
    expect(onWhite.passes(WcagLevel.aaa), isTrue,
        reason: 'white ratio was ${onWhite.ratio}');
  });

  test('ink and paper clear WCAG AAA against each other in both themes', () {
    final light = checker.check(
        _fromColor(AppColors.ink), _fromColor(AppColors.paperLight));
    final dark = checker.check(
        _fromColor(AppColors.inkTextDark), _fromColor(AppColors.inkDark));
    expect(light.passes(WcagLevel.aaa), isTrue,
        reason: 'light ratio was ${light.ratio}');
    expect(dark.passes(WcagLevel.aaa), isTrue,
        reason: 'dark ratio was ${dark.ratio}');
  });
}
