# Changelog

All notable changes to this project are documented in this file. The
format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

### Changed

- Redesigned the whole interface as a dark-only identity shared with the
  project website: a branded home with one tinted card per module,
  tap-only onboarding with a progress bar and module badges, grouped
  settings, and a glowing module badge motif.
- Module screens are themed per module through `ModuleScope`, with a
  `ModuleHeader` banner, flat `ToolCard` and `ToolOutput` components,
  `StyledDropdown` and short entrance motion.
- The interface is now English only; the Italian locale was removed.
- Rewrote the README and added `docs/design-system.md`.
- Refreshed every screenshot and added one for onboarding.

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
