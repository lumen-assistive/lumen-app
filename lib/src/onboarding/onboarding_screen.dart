import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
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
    final textTheme = Theme.of(context).textTheme;
    final moduleId = switch (_step) {
      0 => 'vision',
      1 => 'hearing',
      2 => 'safety',
      3 => 'family',
      _ => null,
    };
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const LogoMark(size: 26, color: AppColors.ink),
                  const SizedBox(width: 10),
                  Text(
                    strings('onboardingTitle'),
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_step + 1} / $_stepCount',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  for (var i = 0; i < _stepCount; i++) ...[
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              i <= _step ? AppColors.ink : AppColors.hairline,
                          borderRadius: BorderRadius.circular(4),
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
    );
  }
}

/// The large block that opens a question: the module the question is
/// about in its solid color, or the brand yellow with the logo mark
/// when the question is not about one module.
class _QuestionBadge extends StatelessWidget {
  const _QuestionBadge({required this.moduleId});

  final String? moduleId;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: moduleId == null
              ? AppColors.amber
              : AppColors.moduleColorOf(moduleId!),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.ink,
            width: AppTheme.outlineWidth,
          ),
        ),
        child: Center(
          child: moduleId == null
              ? const LogoMark(size: 44, color: AppColors.ink)
              : IconTheme(
                  data: const IconThemeData(color: AppColors.ink),
                  child: ModuleIcon(moduleId: moduleId!, size: 48),
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
      children: [
        const SizedBox(height: 40),
        _QuestionBadge(moduleId: moduleId),
        const SizedBox(height: 28),
        Text(
          strings(titleKey),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.1,
                letterSpacing: -0.8,
              ),
          textAlign: TextAlign.left,
        ),
        const Spacer(),
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
      children: [
        const SizedBox(height: 40),
        const _QuestionBadge(moduleId: null),
        const SizedBox(height: 28),
        Text(
          strings('onboardingQuestionComplexityTitle'),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.1,
                letterSpacing: -0.8,
              ),
          textAlign: TextAlign.left,
        ),
        const Spacer(),
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
    const size = Size.fromHeight(68);
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
              ),
              child: Text(label, style: textStyle),
            ),
    );
  }
}
