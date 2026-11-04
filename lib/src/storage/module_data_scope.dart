import 'package:flutter/widgets.dart';

import 'module_data_repository.dart';

/// Makes the [ModuleDataRepository] available to module screens.
///
/// Screens look it up with [maybeOf] and simply do not persist when it is
/// absent, which is the case in widget tests that pump a single screen.
class ModuleDataScope extends InheritedWidget {
  const ModuleDataScope({
    super.key,
    required this.repository,
    required super.child,
  });

  final ModuleDataRepository repository;

  static ModuleDataRepository? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ModuleDataScope>()?.repository;

  @override
  bool updateShouldNotify(ModuleDataScope oldWidget) =>
      repository != oldWidget.repository;
}
