import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_strings.dart';
import 'routing/app_router.dart';
import 'storage/app_database.dart';
import 'storage/module_config_repository.dart';
import 'storage/user_profile.dart';
import 'storage/user_profile_repository.dart';
import 'theme/app_theme.dart';

/// Root widget.
///
/// Owns the repositories for the lifetime of the app and loads stored
/// state once before building the router, so a returning user is
/// never shown onboarding again.
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
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
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
        return MaterialApp.router(
          onGenerateTitle: (context) => AppStrings.of(context)('appTitle'),
          theme: AppTheme.resolve(profile.uiMode, Brightness.light),
          darkTheme: AppTheme.resolve(profile.uiMode, Brightness.dark),
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
