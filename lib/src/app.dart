import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_strings.dart';
import 'routing/app_router.dart';
import 'storage/app_database.dart';
import 'storage/module_config_repository.dart';
import 'storage/user_profile.dart';
import 'storage/user_profile_repository.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';
import 'theme/logo_mark.dart';
import 'theme/ui_mode.dart';

/// Root widget.
///
/// Owns the repositories for the lifetime of the app and loads stored
/// state once before building the router, so a returning user is
/// never shown onboarding again. While that load is in progress, shows
/// the brand mark rather than a bare spinner.
class LumenApp extends StatefulWidget {
  const LumenApp({super.key, required this.database});

  final AppDatabase database;

  @override
  State<LumenApp> createState() => _LumenAppState();
}

class _LumenAppState extends State<LumenApp> {
  late final UserProfileRepository _userProfileRepository =
      UserProfileRepository(widget.database);
  late final ModuleConfigRepository _moduleConfigRepository =
      ModuleConfigRepository(widget.database);
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _userProfileRepository.load();
    await _moduleConfigRepository.load();
    if (mounted) setState(() => _loaded = true);
  }

  @override
  void dispose() {
    _userProfileRepository.dispose();
    _moduleConfigRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      final loadingTheme = AppTheme.resolve(UiMode.complete);
      return MaterialApp(
        theme: loadingTheme,
        darkTheme: loadingTheme,
        themeMode: ThemeMode.light,
        home: const _LoadingScreen(),
      );
    }

    final router = buildRouter(
      userProfileRepository: _userProfileRepository,
      moduleConfigRepository: _moduleConfigRepository,
    );

    return AnimatedBuilder(
      animation: _userProfileRepository,
      builder: (context, animatedBuilderChild) {
        final profile = _userProfileRepository.profile ?? UserProfile.initial();
        final theme = AppTheme.resolve(profile.uiMode);
        return MaterialApp.router(
          onGenerateTitle: (context) => AppStrings.of(context)('appTitle'),
          theme: theme,
          darkTheme: theme,
          themeMode: ThemeMode.light,
          routerConfig: router,
          localizationsDelegates: [
            AppStrings.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppStrings.supportedLocales,
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(profile.textScale),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}

/// Shown while the user's saved profile loads from encrypted storage:
/// the brand mark in ink on paper, so even this brief moment reads as
/// Lumen rather than generic Flutter loading UI.
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(child: LogoMark(size: 72, color: AppColors.ink)),
    );
  }
}
