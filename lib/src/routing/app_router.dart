import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../home/home_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../settings/settings_screen.dart';
import '../storage/module_config_repository.dart';
import '../storage/user_profile.dart';
import '../storage/user_profile_repository.dart';

/// Builds the app's router.
///
/// Starts on onboarding unless [userProfileRepository] already has a
/// saved profile, in which case it starts on the home module host.
GoRouter buildRouter({
  required UserProfileRepository userProfileRepository,
  required ModuleConfigRepository moduleConfigRepository,
}) {
  return GoRouter(
    initialLocation:
        userProfileRepository.hasCompletedOnboarding ? '/home' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingScreen(
          onComplete: (outcome) async {
            await userProfileRepository.save(
              UserProfile(
                uiMode: outcome.uiMode,
                enabledModuleIds: outcome.enabledModuleIds,
                textScale: 1,
              ),
            );
            for (final moduleId in outcome.enabledModuleIds) {
              await moduleConfigRepository.setEnabled(moduleId, true);
            }
            if (context.mounted) context.go('/home');
          },
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => AnimatedBuilder(
          animation: userProfileRepository,
          builder: (context, child) => HomeScreen(
            profile: userProfileRepository.profile ?? UserProfile.initial(),
            onOpenSettings: () => context.go('/settings'),
          ),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsScreen(
          userProfileRepository: userProfileRepository,
          moduleConfigRepository: moduleConfigRepository,
        ),
      ),
    ],
  );
}
