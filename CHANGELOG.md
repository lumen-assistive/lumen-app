# Changelog

All notable changes to this project are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

## [0.5.0]

### Added

- The Android platform (`android/`), so the app can be built as an APK, with
  release signing driven by an untracked `android/key.properties` and a
  debug-key fallback when it is absent.
- Published, signed release APKs for arm64-v8a, armeabi-v7a, x86_64 and a
  universal build.

### Changed

- Redesigned the whole interface as a flat, light "paper and ink" look:
  ink outlines instead of shadows, solid color blocks instead of
  gradients, glows and translucent tints. The home screen is a
  two-column grid of solid module tiles under a large headline;
  onboarding is left-aligned with a progress bar and a module block per
  question; settings uses outlined groups with a `ModuleBadge` per module.
- Module screens are themed per module through `ModuleScope`, which sets
  the module fill as the scheme's accent, with a solid `ModuleHeader`
  banner, flat `ToolCard` and `ToolOutput` components, `StyledDropdown`
  and short entrance motion (`FadeSlideIn`).
- Replaced `ModuleGlowBadge` with `ModuleBadge`, a rounded square in the
  module color.
- Contrast tests now check ink on the paper, the card surface, every
  module fill and the brand yellow.
- The interface is now English only; the Italian locale was removed.
- Rewrote the README and added `docs/design-system.md`.
- Refreshed every screenshot and added ones for onboarding and settings.

### Added

- Five-question onboarding flow deciding UI mode and enabled modules
  (`OnboardingController`).
- Four adaptive UI modes built in `AppTheme`.
- Generic module host (`HomeScreen`) driven by `ModuleInfo` metadata.
- Settings screen: UI mode, text scale, per-module enable/consent
  toggles, medical/safety disclaimer, developer mode and diagnostics.
- `AppDatabase` persistence contract with `InMemoryAppDatabase` and a
  production-ready `SqlCipherAppDatabase`.
- `AppConsentStore` and `AppCapabilityGate` implementing `lumen_core`'s
  contracts.
- Localization via `AppStrings`.

### Known limitations

- No voice input in onboarding, no live sensor input, no
  durable encrypted storage wired into `main()` yet, no real OS
  permission requests, no signed release build, no manual screen
  reader testing performed. See README for the full list and why.
