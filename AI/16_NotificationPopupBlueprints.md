# Kumele — Notification Popup Blueprints (Android/Flutter)

Exact size/font/color/image spec for every popup the Notifications screen can present, extracted
directly from the live SwiftUI source (iPhone + iPad only — tvOS `#if` branches excluded).

**Full interactive version (all 13 popups, per-card tables, diagrams):**
https://claude.ai/code/artifact/ddd02774-060a-4948-b76e-55093440439e

**Companion docs:** [`12_AndroidFlutterAPIGuide.md`](12_AndroidFlutterAPIGuide.md) for the
Notifications API calls these popups render data from.

**Units:** all numbers below are SwiftUI points = Flutter logical pixels (`dp` at reference
density) — use directly, no conversion.

---

## 1. Design tokens

| Token | Light | Dark | Used for |
|---|---|---|---|
| `bgColor` | `#FFFFFF` | `#0D0D0D` | Wide detail card background (Family D) |
| `bgAlertColor` | `#FFFFFF` | `#000000` | Compact/modal card background (Families A/B) |
| `authBgColor` | `#000000` | `#FFFFFF` | Primary button background |
| `authTextColor` | `#FFFFFF` | `#000000` | Primary button text — inverse of `authBgColor` |
| `textColor` | `#000000` | `#FFFFFF` | Primary text; also used as a flat 10%-opacity scrim |
| `bgBottomAlert` | `#FFFFFF` | `#454545` | Footer button-row strip (Join event, Ad detail) |

Font family: **Plus Jakarta Sans**, weights Light/Regular/Medium/SemiBold/Bold (`.appFont(_:size:)`
in the Swift source). Same Google Font used throughout the rest of the app.

Two scrim recipes, used interchangeably by family (noted per popup below):
- **Layered**: `Color.black.opacity(colorScheme == .dark ? 0.72 : 0.26)`
- **Flat**: `Color("textColor").opacity(0.10)`

---

## 2. The four structural families

Build these as reusable Flutter widgets, then pass content per popup — don't rebuild the shell
13 times.

### Family A — Compact alert card
`maxWidth: 320`, `padding(24)`, `cornerRadius: 22`, background `bgAlertColor`, layered scrim,
`.padding(.horizontal, 16)` margin from screen edge. Close button `24×24`.
**Members:** Birthday (iPhone only, see §3 diff), Event cancelled, Reward medal, Generic message.

### Family B — Modal sheet card
`maxWidth: min(screenWidth - 32, 420)`, background `bgAlertColor`. iPhone: card fills the sheet,
`cornerRadius 0`, no shadow. iPad: floats over a flat scrim, `cornerRadius 12`, `shadow radius 10`.
**Members:** Welcome (padding 26), Confirm action (padding 26, centered), Success/error toast
(padding 50, `.sheet` with `presentationDetents([.medium, .height(350)])`, auto-dismiss 2.0s).

### Family C — Ad tap-through card
One-off recipe, sized from its own math rather than a fixed cap:
`cardWidth = min(screenWidth - 32, 420)`, `imageWidth = cardWidth - 40`,
`imageHeight = imageWidth * 170/345`. `padding(20)`, `cornerRadius 20`, drop shadow
(`black 18% / radius 24 / y 8`), flat scrim. Close button floats over the image's top-right corner:
`15×15`, `padding 7`, `cornerRadius 7`, `offset(x: 6, y: -6)`.
**Members:** Ad tap-through (from the notification ad rail).

### Family D — Wide detail card
`maxWidth: min(screenWidth - 32, 620)`, `maxHeight: min(screenHeight - 32, 581)`,
`padding(.top, 20)` only, background `bgColor`, `cornerRadius 20`, flat scrim. Close button jumps
to `40–42×40–42`. Banner/content image is `540:222` aspect ratio, `cornerRadius 16`.
**Members:** Join event, Event detail, ~~Ad detail~~ (dead code — see §4).

---

## 3. iPhone → iPad diffs

- **Birthday popup breaks the family pattern on iPad.** iPhone uses Family A (title/body/footer
  19/15/12pt). iPad uses Family D instead — same three labels jump to 26/20/30pt, close button
  24pt → 40pt. Every sibling Family-A popup stays small and consistent on both platforms; this one
  doesn't. Confirm with product whether to replicate the iPad oddity or normalize both to Family A
  before porting.
- **Success/error toast**: iPhone wires 4 trigger points (join error, join success, payment error,
  generic notification error). iPad only wires 2 (success, notification error) — join/payment
  failures on iPad fall through to the generic error message instead of their own. Same component
  either way.
- **Blog-tap routing** differs in plumbing (iPad presents `BlogDetailView` locally; iPhone routes
  out to a top-level presenter) but lands on the same screen — not a visual spec difference.

## 4. Dead code — don't port

`AdsDetailView_iPhone.swift` / `AdsDetailView_iPad.swift` (Decline/Install Now full ad detail) have
**zero call sites** anywhere in the repo. `AdDetailPopupView` (Family C) is what's actually shown
when an ad is tapped. Low priority; see the full artifact if you want its numbers anyway.

---

## 5. Image & icon assets

| Asset | Size | Used in |
|---|---|---|
| `dummyBirthdate` | 270:125 (iPhone) / 540:222 (iPad) | Birthday |
| `close` | 15–24pt compact · 40–42pt wide card | nearly every popup |
| `icMegaphone` | 56×56 | Event cancelled, Generic message |
| `icBlogComment` | 56×56 | Generic message (blog variant) |
| `confeti.gif` | height 140, animated | Reward medal |
| `gift_dark` / `gift_light` (Lottie) | 28×28 | Birthday |
| `medalDark` / `medalLight` (Lottie) | 58×58 | Reward medal |
| `hot_chocolate_dark` / `_light` (Lottie) | 75×75 | Welcome |
| `success_dark` / `success_light` (Lottie) | 121×121 | Toast (success) |
| `warningLight.gif` | 121×121, animated | Toast (error) |
| `icAccount` | 80×80 | Confirm action |
| `icDollar` / `icClock` / `icProfileGroup` / `icPinLocation` | 18×18 | Join event (meta row) |
| Ad image/video (remote) | see Family C math, or 540:222 | Ad card, Ad detail |
| Event/category banner (remote) | 540:222 | Join event, Event detail |

Full per-popup tables (fonts, padding, every field) are in the artifact linked at the top.
