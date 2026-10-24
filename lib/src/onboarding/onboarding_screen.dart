import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text(strings('onboardingTitle'))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: switch (_step) {
            0 => _YesNoQuestion(
                titleKey: 'onboardingQuestionVisionTitle',
                onAnswer: (value) {
                  _answers.visionDifficulty = value;
                  _advance();
                },
              ),
            1 => _YesNoQuestion(
                titleKey: 'onboardingQuestionHearingTitle',
                onAnswer: (value) {
                  _answers.hearingDifficulty = value;
                  _advance();
                },
              ),
            2 => _YesNoQuestion(
                titleKey: 'onboardingQuestionSafetyTitle',
                onAnswer: (value) {
                  _answers.wantsSafety = value;
                  _advance();
                },
              ),
            3 => _YesNoQuestion(
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
      ),
    );
  }
}

class _YesNoQuestion extends StatelessWidget {
  const _YesNoQuestion({required this.titleKey, required this.onAnswer});

  final String titleKey;
  final ValueChanged<bool> onAnswer;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          strings(titleKey),
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _OnboardingButton(
          label: strings('answerYes'),
          onPressed: () => onAnswer(true),
        ),
        const SizedBox(height: 16),
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
        Text(
          strings('onboardingQuestionComplexityTitle'),
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _OnboardingButton(
          label: strings('answerComplexitySimple'),
          onPressed: () => onAnswer(ComplexityPreference.simple),
        ),
        const SizedBox(height: 16),
        _OnboardingButton(
          label: strings('answerComplexityComplete'),
          onPressed: () => onAnswer(ComplexityPreference.complete),
        ),
      ],
    );
  }
}

class _OnboardingButton extends StatelessWidget {
  const _OnboardingButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTheme.minTouchTarget * 1.5),
        ),
        child: Text(label, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
