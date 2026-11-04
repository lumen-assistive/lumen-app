# Design system

The visual identity of `lumen-app`, written from the real theme code in
`lib/src/theme/` and `lib/src/modules/widgets/`. It shares its identity
with the project website: a warm glow against near-black.

## Principles

- **Dark by design.** "Lumen" means light, so the product is a warm glow
  on a near-black surface. The app has one theme, not a system-dependent
  light and dark pair.
- **One brand accent, one color per module.** Amber carries actions and
  links. Each of the eight modules also owns a signature color, used for
  its badge, its glow and, inside its screen, its buttons and results.
- **Flat, bordered, no elevation.** Definition comes from a hairline
  border, a tint or a deliberate glow. There are no card shadows.
- **Legibility first.** One typeface designed for low vision, large touch
  targets, and a high-contrast tier for the people who need it most.

## Color

Defined in `AppColors` (`lib/src/theme/app_colors.dart`).

| Token | Hex | Use |
|---|---|---|
| `background` | `#0D0B08` | The page. |
| `surface` | `#17140F` | Cards and result boxes. |
| `surfaceRaised` | `#221E16` | Fills raised above a card: inputs, chips, dropdowns, secondary buttons. Fill only, never text. |
| `text` | `#F3EFE2` | Primary text, warm off-white to avoid glare. |
| `muted` | `#B7AE99` | Secondary text. |
| `border` | `#3A3424` | Hairlines. |
| `amber` | `#E3A94A` | Brand accent: buttons, links, small marks. |
| `glow` | `#F5B942` | A more saturated amber reserved for large soft glows. |
| `amberHighContrast` | `#F2C878` | Accent for the high-contrast tier. |
| `critical` | `#E5484D` | Urgent states such as a fall or SOS. Distinct from every module color. |
| `warning` | `#E8A33D` | Warning states, for example the medical disclaimer. |

Module colors, from `AppColors.moduleColors`:

| Module | Hex |
|---|---|
| Vision | `#22B8D4` |
| Hearing | `#9D7CF5` |
| Safety | `#F2637B` |
| Family | `#F070AC` |
| Speech | `#F3914F` |
| Reading | `#4FCB7C` |
| Memory | `#8B93F7` |
| Mobility | `#D9A93B` |

`AppColors.moduleColorOf(id)` returns the amber accent for an unknown id.

### Contrast

`test/theme/app_colors_test.dart` checks the palette with the real
`ContrastChecker` from `lumen_plugin_vision` instead of asserting by
eye: the amber accent and the high-contrast accent both clear WCAG AAA
against the background, text clears AAA against both surfaces, and every
module color clears 3:1 against both surfaces.

## Typography

Atkinson Hyperlegible, bundled in `assets/fonts/` in Regular (400) and
Bold (700), with its SIL Open Font License alongside. Headings use bold
with slightly negative letter spacing. Section labels on the home and
settings screens are small, bold, uppercase and widely spaced.

## UI modes

`AppTheme.resolve(UiMode)` builds the theme. `voiceFirstHighContrast` and
`simple` use the high-contrast accent and enlarge the base text, by a
factor of 1.3 and 1.15 respectively. `visualWithVibration` and `complete`
use the standard accent at the default size. The user can also scale text
from the settings slider.

## Module color scope

`ModuleScope` (`lib/src/theme/module_scope.dart`) wraps a module screen
and re-themes it with that module's color:

- `primary` becomes the module color, so filled buttons, input focus
  rings, switches, sliders and chips follow it through normal theme
  lookups. Module screens contain no per-widget color code.
- Secondary (outlined) buttons become a tinted, bordered pill in the
  module color.
- The scaffold and app bar become transparent so a soft radial glow in
  the module color shows behind the page.

The router applies it when it builds a module screen.

## Components

| Component | File | Role |
|---|---|---|
| `ModuleGlowBadge` | `modules/widgets/module_glow_badge.dart` | A dark circle with a ring and soft glow in the module color, holding its icon. Used in the home list, the module header and settings. |
| `ModuleIcon` | `theme/module_icon.dart` | An original stroke icon per module, drawn with `CustomPainter`. |
| `LogoMark` | `theme/logo_mark.dart` | The open-arc brand mark, drawn as vector geometry. |
| `ModuleHeader` | `modules/widgets/module_header.dart` | The banner that opens each module screen: badge, name and description on a tinted gradient panel. |
| `ModuleNote` | `modules/widgets/module_note.dart` | A quiet outlined box disclosing what a screen does and does not demonstrate. |
| `ToolCard` | `modules/widgets/tool_card.dart` | A flat card with an accent bar and title that groups one tool. |
| `ToolOutput` | `modules/widgets/tool_card.dart` | A tinted result box with an accent edge. |
| `StyledDropdown` | `modules/widgets/styled_dropdown.dart` | A dropdown drawn like a text field. |
| `FadeSlideIn` | `theme/fade_slide_in.dart` | A short fade and rise on first build; skipped when the platform asks to reduce motion. |

## Shape and spacing

Cards use radius 24 to 32, inputs 18, and buttons and chips are full
pills. Buttons are at least `AppTheme.minTouchTarget` (48 logical
pixels) tall, plus a few pixels for primary actions. Screens use a 16 to
20 pixel gutter and 12 to 16 pixels between cards.

## Motion

Motion is short and purposeful: list entrances use a fade and a small
rise with a slightly longer duration for later items, giving a gentle
cascade without timers. Nothing animates continuously.

## Accessibility

Interactive elements carry `Semantics` labels, touch targets meet the
48 pixel minimum and text scales dynamically. TalkBack and VoiceOver have
not been manually exercised, which is required QA before any release.
