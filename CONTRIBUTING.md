# Contributing to lumen-app

See the organization-wide
[CONTRIBUTING.md](https://github.com/lumen-assistive/.github/blob/main/CONTRIBUTING.md)
for the general workflow. This file only covers what is specific to
this repository.

## Setup

```
flutter pub get
git config core.hooksPath .githooks
```

## Before sending a pull request

```
flutter analyze --fatal-infos
flutter test
```

Both must pass; CI runs the same commands on every push and pull
request. If Flutter does not work in your local environment, push to a
branch and let CI verify instead of guessing.

## Accessibility and consent requirements

Any change to onboarding, the home screen, or settings must keep every
interactive element reachable with a screen reader (`Semantics`
labels), keep touch targets at or above `AppTheme.minTouchTarget`, and
keep dynamic text scaling working. Any change that adds a new kind of
data sharing must go through `AppConsentStore`/`ModuleConfigRepository`
consent, never bypass it.

## Adding a real plugin dependency

This release deliberately does not depend on any `lumen-plugin-*`
package yet, since none ships Flutter UI. When a plugin repository
adds one, wire it in by registering a real `LumenPlugin` instance with
a `PluginManager` (see `lib/src/diagnostics/diagnostics_screen.dart`
for how one is already constructed, currently with nothing registered)
rather than inventing a parallel integration path.
