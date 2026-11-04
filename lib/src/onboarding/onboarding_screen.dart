import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/logo_mark.dart';
import '../theme/module_icon.dart';
import 'onboarding_answers.dart';
import 'onboarding_controller.dart';

/// The five-question onboarding flow.
///
/// Answers are collected with large, high-contrast, screen-reader
/// labeled buttons. Voice input is not implemented in this release:
/// doing so needs on-device speech recognition wired through
/// `lumen-core`'s native bridges, which do not exist yet (see that
/// repository's README), so every question is answered by tap here
/// rather than presenting a microphone control that would not work.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  final ValueChanged<OnboardingOutcome> onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _answers = OnboardingAnswers();
  int _step = 0;

  static const _stepCount = 5;

  void _advance() {
    if (_step == _stepCount - 1) {
      widget.onComplete(OnboardingController.computeOutcome(_answers));
      return;
    }
    setState(() => _step += 1);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final moduleId = switch (_step) {
      0 => 'vision',
      1 => 'hearing',
      2 => 'safety',
      3 => 'family',
      _ => null,
    };
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: -300,
            left: -200,
            right: -200,
            height: 700,
            child: IgnorePointer(child: _Glow()),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const LogoMark(size: 26, color: AppColors.glow),
                      const SizedBox(width: 10),
                      Text(
                        strings('onboardingTitle'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        '${_step + 1} / $_stepCount',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      for (var i = 0; i < _stepCount; i++) ...[
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: 5,
                            decoration: BoxDecoration(
                              color: i <= _step
                                  ? AppColors.amber
                                  : AppColors.surfaceRaised,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        if (i < _stepCount - 1) const SizedBox(width: 6),
                      ],
                    ],
                  ),
                  Expanded(
                    child: switch (_step) {
                      0 => _YesNoQuestion(
                          moduleId: moduleId,
                          titleKey: 'onboardingQuestionVisionTitle',
                          onAnswer: (value) {
                            _answers.visionDifficulty = value;
                            _advance();
                          },
                        ),
                      1 => _YesNoQuestion(
                          moduleId: moduleId,
                          titleKey: 'onboardingQuestionHearingTitle',
                          onAnswer: (value) {
                            _answers.hearingDifficulty = value;
                            _advance();
                          },
                        ),
                      2 => _YesNoQuestion(
                          moduleId: moduleId,
                          titleKey: 'onboardingQuestionSafetyTitle',
                          onAnswer: (value) {
                            _answers.wantsSafety = value;
                            _advance();
                          },
                        ),
                      3 => _YesNoQuestion(
                          moduleId: moduleId,
                          titleKey: 'onboardingQuestionCaregiverTitle',
                          onAnswer: (value) {
                            _answers.wantsCaregiverSharing = value;
                            _advance();
                          },
                        ),
                      _ => _ComplexityQuestion(
                          onAnswer: (preference) {
                            _answers.complexityPreference = preference;
                            _advance();
                          },
                        ),
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 0.5,
          colors: [
            AppColors.glow.withValues(alpha: 0.28),
            AppColors.glow.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

/// A large glowing badge showing the module a question is about, or the
/// brand mark when the question is not about one module.
class _QuestionBadge extends StatelessWidget {
  const _QuestionBadge({required this.moduleId});

  final String? moduleId;

  @override
  Widget build(BuildContext context) {
    final color =
        moduleId == null ? AppColors.glow : AppColors.moduleColorOf(moduleId!);
    return Center(
      child: Container(
        width: 112,
        height: 112,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 56,
              spreadRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: moduleId == null
              ? LogoMark(size: 48, color: color)
              : IconTheme(
                  data: IconThemeData(color: color),
                  child: ModuleIcon(moduleId: moduleId!, size: 50),
                ),
        ),
      ),
    );
  }
}

class _YesNoQuestion extends StatelessWidget {
  const _YesNoQuestion({
    required this.moduleId,
    required this.titleKey,
    required this.onAnswer,
  });

  final String? moduleId;
  final String titleKey;
  final ValueChanged<bool> onAnswer;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _QuestionBadge(moduleId: moduleId),
        const SizedBox(height: 36),
        Text(
          strings(titleKey),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.2,
                letterSpacing: -0.4,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 36),
        _OnboardingButton(
          label: strings('answerYes'),
          primary: true,
          onPressed: () => onAnswer(true),
        ),
        const SizedBox(height: 14),
        _OnboardingButton(
          label: strings('answerNo'),
          onPressed: () => onAnswer(false),
        ),
      ],
    );
  }
}

class _ComplexityQuestion extends StatelessWidget {
  const _ComplexityQuestion({required this.onAnswer});

  final ValueChanged<ComplexityPreference> onAnswer;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _QuestionBadge(moduleId: null),
        const SizedBox(height: 36),
        Text(
          strings('onboardingQuestionComplexityTitle'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.2,
                letterSpacing: -0.4,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 36),
        _OnboardingButton(
          label: strings('answerComplexitySimple'),
          primary: true,
          onPressed: () => onAnswer(ComplexityPreference.simple),
        ),
        const SizedBox(height: 14),
        _OnboardingButton(
          label: strings('answerComplexityComplete'),
          onPressed: () => onAnswer(ComplexityPreference.complete),
        ),
      ],
    );
  }
}

class _OnboardingButton extends StatelessWidget {
  const _OnboardingButton({
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    const size = Size.fromHeight(64);
    const textStyle = TextStyle(fontSize: 19, fontWeight: FontWeight.w700);
    return Semantics(
      button: true,
      label: label,
      child: primary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(minimumSize: size),
              child: Text(label, style: textStyle),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                minimumSize: size,
                backgroundColor: AppColors.surfaceRaised,
              ),
              child: Text(label, style: textStyle),
            ),
    );
  }
}
