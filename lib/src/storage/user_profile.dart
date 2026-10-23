import 'package:meta/meta.dart';

import '../theme/ui_mode.dart';

/// The result of onboarding, and the source of truth for the app's
/// current appearance.
@immutable
class UserProfile {
  const UserProfile({
    required this.uiMode,
    required this.enabledModuleIds,
    required this.textScale,
  });

  /// A fresh profile for a device that has not completed onboarding,
  /// used only as a safe default before the first save.
  factory UserProfile.initial() => const UserProfile(
    uiMode: UiMode.complete,
    enabledModuleIds: <String>{},
    textScale: 1,
  );

  final UiMode uiMode;
  final Set<String> enabledModuleIds;

  /// Multiplier applied on top of [AppTheme]'s mode-driven base text
  /// scale, from the settings slider. `1.0` means "use the mode's
  /// default unchanged".
  final double textScale;

  UserProfile copyWith({
    UiMode? uiMode,
    Set<String>? enabledModuleIds,
    double? textScale,
  }) {
    return UserProfile(
      uiMode: uiMode ?? this.uiMode,
      enabledModuleIds: enabledModuleIds ?? this.enabledModuleIds,
      textScale: textScale ?? this.textScale,
    );
  }
}
