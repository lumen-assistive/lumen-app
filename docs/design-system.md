# Design system

The visual identity of `lumen-app`, written from the real theme code in
`lib/src/theme/` and `lib/src/modules/widgets/`.

## Principles

- **Paper and ink.** A warm off-white page, near-black ink, and nothing
  in between that blurs: no gradients, no glows, no translucent tints and
  no card shadows. Structure comes from 2 pixel ink outlines and from
  large blocks of a single solid color.
- **One color per module.** Each of the eight modules owns a solid fill,
  used for its tile on the home screen, its header banner and, inside its
  screen, its tool markers, result blocks and switches. Everything else
  is ink and paper, so the app stays one consistent system.
- **Legibility first.** One typeface designed for low vision, large touch
  targets, and text that stays at AAA contrast on every surface it is
  used on.
- **One light theme.** The app has a single theme, not a system-dependent
  light and dark pair.

## Color

Defined in `AppColors` (`lib/src/theme/app_colors.dart`).

| Token | Hex | Use |
|---|---|---|
| `background` | `#F3EEE3` | The page: warm off-white paper. |
| `surface` | `#FFFCF5` | Cards and inputs, slightly lighter than the page. |
| `ink` | `#1A1815` | Primary text, icons and structural outlines. |
| `muted` | `#5B554A` | Secondary text. |
| `hairline` | `#D3CBB8` | Quiet dividers and the module note outline. |
| `amber` | `#F2B138` | The brand yellow: logo dot fills, the safety disclaimer block. Always a fill with ink on top, never text. |
| `critical` | `#C1272D` | Urgent states such as a fall or SOS. |

Module fills, from `AppColors.moduleColors`:

| Module | Hex |
|---|---|
| Vision | `#5CC8E0` |
| Hearing | `#B9A2FF` |
| Safety | `#FF8FA3` |
| Family | `#FF9FCB` |
| Speech | `#FFA860` |
| Reading | `#7ADB98` |
| Memory | `#9FA9FF` |
| Mobility | `#F2C94E` |

`AppColors.moduleColorOf(id)` returns the brand yellow for an unknown id.

### Contrast

`test/theme/app_colors_test.dart` checks the palette with the real
`ContrastChecker` from `lumen_plugin_vision` instead of asserting by
eye:

- ink clears WCAG AAA on the page and on the card surface;
- muted text clears WCAG AA on both;
- the critical color clears WCAG AA as text on the page;
- ink on every module fill and on the brand yellow clears WCAG AAA.

Because module colors are only ever fills with ink on top, no pairing of
a module color as text exists.

## Typography

Atkinson Hyperlegible, bundled in `assets/fonts/` in Regular (400) and
Bold (700), with its SIL Open Font License alongside. Headings use bold
with negative letter spacing; the home headline is the largest text in
the app. Section labels on the home and settings screens are small,
bold, uppercase and widely spaced.

## UI modes

`AppTheme.resolve(UiMode)` builds the theme. `voiceFirstHighContrast` and
`simple` enlarge the base text by a factor of 1.3 and 1.15 respectively
and make the home screen show one wide tile per row instead of two.
`visualWithVibration` and `complete` use the default size. The palette is
the same in every mode, since it already sits at AAA contrast. The user
can also scale text from the settings slider.

## Module color scope

`ModuleScope` (`lib/src/theme/module_scope.dart`) wraps a module screen
and sets the color scheme's `secondary` to the module fill. The module
widgets (`ToolCard`, `ToolOutput`) and the switch and chip themes read
it, so module screens contain no per-widget color code. Buttons, outlines
and paper are identical across modules. The router applies the scope when
it builds a module screen.

## Components

| Component | File | Role |
|---|---|---|
| `ModuleBadge` | `modules/widgets/module_badge.dart` | A module's ink icon on a rounded square filled with its color, outlined in ink. Used in settings. |
| `ModuleIcon` | `theme/module_icon.dart` | An original stroke icon per module, drawn with `CustomPainter`. |
| `LogoMark` | `theme/logo_mark.dart` | The open-arc brand mark, drawn as vector geometry. |
| `ModuleHeader` | `modules/widgets/module_header.dart` | The banner that opens each module screen: a solid block in the module color with a large icon, the name and the description. |
| `ModuleNote` | `modules/widgets/module_note.dart` | A quiet hairline box disclosing what a screen does and does not demonstrate. |
| `ToolCard` | `modules/widgets/tool_card.dart` | A paper card with an ink outline and a small module-colored square before the title, grouping one tool. |
| `ToolOutput` | `modules/widgets/tool_card.dart` | A result block filled with the module color, with ink text. |
| `StyledDropdown` | `modules/widgets/styled_dropdown.dart` | A dropdown drawn like a text field. |
| `FadeSlideIn` | `theme/fade_slide_in.dart` | A short fade and rise on first build; skipped when the platform asks to reduce motion. |

## Shape and spacing

Cards and tiles use radius 20 to 28, buttons, inputs, chips and
dropdowns radius 12 to 14. Primary buttons are ink with paper text;
secondary buttons are paper with an ink outline. Buttons are 56 logical
pixels tall (`AppTheme.buttonHeight`), above the 48 pixel minimum
(`AppTheme.minTouchTarget`). Outlines are 2 pixels
(`AppTheme.outlineWidth`). Screens use a 16 to 24 pixel gutter and 12 to
16 pixels between cards.

## Motion

Motion is short and purposeful: list entrances use a fade and a small
rise with a slightly longer duration for later items, giving a gentle
cascade without timers. Nothing animates continuously.

## Accessibility

Interactive elements carry `Semantics` labels, touch targets meet the
48 pixel minimum and text scales dynamically. TalkBack and VoiceOver have
not been manually exercised, which is required QA before any release.
