import 'package:flutter/material.dart';

/// Fades a child in while sliding it up a short distance the first time
/// it is built.
///
/// Lists use a slightly longer [duration] for later items, which gives
/// a gentle cascade without needing a shared controller or any timers.
/// Motion is skipped entirely when the platform asks to reduce it.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 420),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 18),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
