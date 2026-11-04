# Changelog

All notable changes to this project are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

## [0.6.0]

### Fixed

- The 0.5.0 release build crashed on launch: release shrinking renamed
  fields of SQLCipher's `SQLiteDatabase` that its native library looks up by
  name. Keep rules in `android/app/proguard-rules.pro` fix it.
- Opening a module or settings replaced the navigation stack, so there was no
  back arrow and the Android back button left the app. They are now pushed on
  top of home.
- Enabling a module in settings changed its switch but not the list on the
  home screen. The profile's enabled set is now updated as well.
- Sentence building on the Speech screen did not call its handler.

### Added

- Durable encrypted storage wired in at startup: a per-install random
  passphrase in the Android keystore (`flutter_secure_storage`), the database
  under the app's private directory (`path_provider`), and a memory fallback.
  A `module_data` table keeps each module's own JSON document.
- Memory (people, reminders), Family (calendar events, daily status), Speech
  (phrase usage), Reading (review progress) and Mobility (profile) now persist.
- Text-to-speech for phrases, sentences and reading text (`flutter_tts`).
- Real vibration for Hearing sound alerts (`vibration`).
- A live accelerometer switch on Safety and Mobility feeding the real fall
  detector and gait monitor (`sensors_plus`), alongside the simulated data.
- Navigation and settings tests, persistence tests, and tests with fake
  speech, vibration and motion services.

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
