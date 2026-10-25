import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../home/home_screen.dart';
import '../modules/famiglia_screen.dart';
import '../modules/leggere_screen.dart';
import '../modules/muoversi_screen.dart';
import '../modules/parlare_screen.dart';
import '../modules/protezione_screen.dart';
import '../modules/ricordare_screen.dart';
import '../modules/sentire_screen.dart';
import '../modules/vedere_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../settings/settings_screen.dart';
import '../storage/module_config_repository.dart';
import '../storage/user_profile.dart';
import '../storage/user_profile_repository.dart';

/// Maps a module id to the real screen that hosts it.
///
/// Every one of Lumen's eight modules has one, backed directly by that
/// module's plugin package; see `lib/src/modules/` for each screen's
/// honest disclosure of what it does and does not demonstrate.
Widget buildModuleScreen(String moduleId) {
  return switch (moduleId) {
    'vedere' => const VedereScreen(),
    'sentire' => const SentireScreen(),
    'protezione' => const ProtezioneScreen(),
    'famiglia' => const FamigliaScreen(),
    'parlare' => const ParlareScreen(),
    'leggere' => const LeggereScreen(),
    'ricordare' => const RicordareScreen(),
    'muoversi' => const MuoversiScreen(),
    _ => throw ArgumentError.value(moduleId, 'moduleId', 'Unknown module id'),
  };
}

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
            onOpenModule: (moduleId) => context.go('/home/$moduleId'),
          ),
        ),
      ),
      GoRoute(
        path: '/home/:moduleId',
        builder: (context, state) =>
            buildModuleScreen(state.pathParameters['moduleId']!),
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
