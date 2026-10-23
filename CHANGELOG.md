# Changelog

All notable changes to this project are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

### Added

- Five-question onboarding flow deciding UI mode and enabled modules
  (`OnboardingController`).
- Four adaptive UI modes with original light/dark theming (`AppTheme`).
- Generic module host (`HomeScreen`) driven by `ModuleInfo` metadata.
- Settings screen: UI mode, text scale, per-module enable/consent
  toggles, medical/safety disclaimer, developer mode and diagnostics.
- `AppDatabase` persistence contract with `InMemoryAppDatabase` and a
  production-ready `SqlCipherAppDatabase`.
- `AppConsentStore` and `AppCapabilityGate` implementing `lumen_core`'s
  contracts.
- Italian-first, English-fallback localization via `AppStrings`.

### Known limitations

- No voice input in onboarding, no per-module feature screens, no
  durable encrypted storage wired into `main()` yet, no real OS
  permission requests, no signed release build, no manual screen
  reader testing performed. See README for the full list and why.
