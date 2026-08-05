# Kumele — NFT Module: Pixel-Perfect UI Guide (Android/Flutter)

Full visual/interaction spec for the NFT module, extracted directly from the live SwiftUI source
(not from Figma — Figma has drifted from what's actually shipped in a few places, noted inline
where that happened). Covers both form factors: the iPhone card-deck experience and the iPad
grid/sheet experience, which are **deliberately different layouts**, not the same screen scaled —
build both, don't try to make one responsive into the other.

**Companion docs:** [`12_AndroidFlutterAPIGuide.md`](12_AndroidFlutterAPIGuide.md) has the NFT
API calls (`GET /nfts/rewards`, `/nfts/mine`, `/nfts/marketplace`, `POST /nfts/{id}/claim`,
`POST /nfts/{id}/purchase`) this UI is wired to.

**Units:** all numbers below are SwiftUI points, which map 1:1 to Flutter logical pixels (`dp` on
Android at the reference density) — use the numbers directly, no conversion needed.

---

## 1. Design tokens

### 1.1 Colors

Every color is a light/dark pair (this app has no separate "high contrast" variant). Hex values
pulled directly from the asset catalog, not eyeballed.

| Token | Light | Dark | Used for |
|---|---|---|---|
| `textColor` | `#000000` | `#FFFFFF` | Primary text/icon color everywhere in this module |
| `bgColor` | `#FFFFFF` | `#0D0D0D` | Screen/sheet background (iPad detail sheet) |
| `bgShopColor` | `#E3E3E3` | `#0D0D0D` | Shop segmented-pager track background; iPad compact-card background |
| `bgSelectedShop` | `#FFFFFF` | `#000000` | Active segment pill background in the top Shop pager |
| `bgContent` | `#F0F0F0` | `#454545` | iPad "Rewards/Claimed/Marketplace" section card background |
| `bgHomeArrow` | `#FFFFFF` | `#6B6B6B` | Circular icon-button backgrounds (expand chevron, chevron-nav, preview's map-pin chevron) |
| `authTextColor` | `#FFFFFF` | `#000000` | Text on the primary black/white pill buttons (Claim/Buy/Close Preview) |
| `authBgColor` | `#000000` | `#FFFFFF` | Background of the primary black/white pill buttons — inverse of `authTextColor`, always high-contrast against it |
| Card hairline border (light only) | `rgb(238, 236, 236)` ≈ `#EEECEC` | none (0-width) | 1pt stroke around the collapsed/expanded NFT card — **light mode only**, the dark-mode card has no border at all, it sits directly on the near-black canvas |
| System background | iOS `UIColor.systemBackground` — effectively white / near-black | | Card content background, screen background behind the deck |

Peek-card colors (the two stacked cards behind the active one in the iPhone swipe deck) — these are
**flat, undetailed silhouettes**, not darkened copies of the real card content:

| Slot | Light | Dark |
|---|---|---|
| 2nd card ("Md") | `#D6D4D4` | `#808080` |
| 3rd card ("Sm") | `#A9A9A9` | `#4D4A4A` |

Wallet-signing sheet uses two hardcoded (non-themed) brand gradients, same in both modes:
- Signature icon: linear gradient `#9945FF → #14F195` (top-leading → bottom-trailing)
- "Open Phantom Wallet" button: linear gradient `#9945FF → #6B2FBA` (leading → trailing)

### 1.2 Typography

Font family: **Plus Jakarta Sans** (a Google Font — available via Flutter's `google_fonts` package
or as bundled static `.ttf`/`.otf` files; the iOS app bundles static font files per weight rather
than using a variable font). Weights actually used in this module: Regular, Medium, SemiBold, Bold.

| Role | Weight | Size (iPhone) | Size (iPad) |
|---|---|---|---|
| Inner tab label (Rewards/Claimed/Market Place), active | SemiBold | 16 | — (iPad has no inner tab bar, see §3) |
| Inner tab label, inactive | Regular | 16 | — |
| Card title (NFT name), collapsed | Bold | 25 | 26 |
| Card title (NFT name), expanded | Bold | 30 | — |
| "Description" / "NFT Details" section headers | Bold | 28 (iPhone) | SemiBold, 20 (iPad) |
| Body / detail row text | Regular | 15 | 15 |
| Detail row value | SemiBold | 15 | 15 |
| Price/ticket row text | Regular | 16 | 16 |
| NFT type badge chip | SemiBold | 12 | 13 |
| Primary button label (Claim/Buy/Close Preview) | Regular | 16 | 16 |
| NFT Preview title | Bold | 30 | — |
| NFT Preview meta row text | Regular | 17 | — |
| NFT Preview host name | Bold | 22 | — |
| NFT Preview stat chip text | Bold / Regular | 15 / 12 | — |
| Wallet sheet title | Bold | 20 | — |
| Wallet sheet body | Regular | 14 | — |
| Wallet sheet button label | SemiBold | 16 | — |
| iPad section header ("Rewards" etc.) | Bold | 20 | |
| iPad compact card title | Bold | 14 | |
| iPad compact card price | Light | 13 | |

### 1.3 Shape & shadow tokens

| Token | Value |
|---|---|
| Card corner radius (collapsed/expanded NFT card) | 26pt, continuous corner style |
| Card hairline border | 1pt, light mode only (see color table) |
| Primary pill button corner radius | 8pt (iPhone card actions, iPhone Close Preview) / 12pt (iPad action bar) |
| Icon-button circle background | `Circle()` — fully round |
| Icon-button shadow (expand toggle, chevron-nav buttons) | `black @ 16% opacity, blur radius 23.66, offset (0, 3.38)` on iPhone; `black @ 16% opacity, blur radius 12, offset (0, 2)` on iPad's chevron-nav |
| Top card shadow (deck) | `black @ 4% opacity, blur radius 20, offset (0, -4)` — **upward** shadow, only on the interactive top card, not the peek cards |
| iPad detail sheet bottom action bar shadow | `black @ 9% opacity, blur radius 22, offset (0, -2.5)` |
| Preview toggle switch (track) | `RoundedRectangle(13pt radius)`, 44×26, filled `textColor @ 35% opacity` |
| Preview toggle switch (thumb) | `Circle()`, 18×18, filled `textColor`, 4pt inset from the track edge, slides leading↔trailing |
| Segmented pager (top of Shop) | Outer track: `bgShopColor`, 8pt corner radius, 55pt max height. Each of the 3 segments: 8pt internal padding, then its own 8pt-corner-radius background — `bgSelectedShop` if active, `bgShopColor` (i.e. invisible against the track) if inactive |

---

## 2. Screen map

```
Shop tab
└── Top segmented pager: "Subscriptions" | "Guest tickets" | "NFTs"   ← 3rd segment opens this module
    └── NFTs segment
        ├── iPhone: ShopNFTsView_iPhone — inner 3-tab bar + swipeable card deck
        │     └── tap "Buy"/"Claim"/expand-chevron → same view expands in place (no navigation)
        │     └── tap "NFT Preview" toggle (Claimed tab only, expanded mode) → overlay replaces card content
        │     └── pending on-chain tx → half-sheet "Wallet Signature Required"
        └── iPad: ShopNFTsView_iPad — 3 stacked sections, each a horizontal scroll row
              └── tap any card → full-height sheet, NFTDetailView_iPad
                    └── tap "NFT Preview" toggle → same overlay as iPhone, swapped in
                    └── pending on-chain tx → same half-sheet
```

---

## 3. iPhone — Shop → NFTs segment (`ShopNFTsView_iPhone`)

### 3.1 Layout skeleton

```
VStack(spacing: 0)
├── inner tab bar (Rewards | Claimed | Market Place)         — see §3.2
│     .padding(.bottom, 4)
├── error banner area (claim / purchase error text, red, 12pt regular)
│     .padding(.top, 6 if any banner visible, else 0)
└── content area  .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding(.top, 12)
      .background(systemBackground)
      → ProgressView() while loading
      → "Something went wrong loading NFTs." (14pt regular) on failure
      → empty-state text (14pt regular) per tab — see §3.6
      → NFTPagedCarousel (the swipe deck) once loaded
```
Outer screen padding (applied one level up, in `ShopView_iPhone`): 16pt horizontal, 16pt bottom.

### 3.2 Inner tab bar

Three equal-width buttons in an `HStack(spacing: 0)`, each `.frame(maxWidth: .infinity)`:

```
VStack(spacing: 8)
├── Text(title)              — SemiBold 16 active / Regular 16 inactive, textColor (45% opacity if inactive)
└── Rectangle, height 2      — fill textColor, opacity 1 if active else 0 (reserves the space either way)
```
Tabs: **Rewards** (index 0) · **Claimed** (index 1) · **Market Place** (index 2). No pill/background
on this tab bar — just label + underline, unlike the outer Shop segmented pager which uses filled
pill backgrounds.

### 3.3 The card deck (collapsed mode)

This is the centerpiece — get this exactly right, it's the most visually distinctive part of the
module.

**Sizing.** Wrapped in a `GeometryReader`. Card height = `min(availableHeight * 0.92, 560)`. Card
width is capped at **329pt** (Figma's literal card width on a 375pt-wide mock) regardless of device
width — on a wide phone this leaves visible margin on the trailing side of the card, which is where
the dot indicator column sits.

**Layout:** `HStack(alignment: .top, spacing: 12)` — dot column (only if >1 NFT) on the leading
edge, then the card deck. The dot column is vertically centered on the card
(`padding(.top, cardHeight/2 - dotColumnHalfHeight)`).

**Stack composition:** up to 3 cards visible at once — 1 interactive top card + 2 "peek" cards
behind it. All 3 share the same 26pt-radius rounded rect clip.

| Stack slot | Scale | Vertical offset (bottom-reveal) | Interactive? | Shadow |
|---|---|---|---|---|
| Top (slot 0) | 1.0 | 0 | Yes — drag + tap zones | `black 4%, blur 20, y -4` |
| Peek 1 (slot 1) | 0.93 | +6.2% of card height | No (`allowsHitTesting(false)`) | none |
| Peek 2 (slot 2) | 0.86 | +12.4% of card height | No | none |

Peek cards render as **flat silhouettes**, not scaled-down real content: the actual card content is
still composed underneath (same view builder) but covered with a solid-color `RoundedRectangle`
overlay in the peek colors from §1.1, at opacity `1 - dragProgress` for slot 1 and
`max(0.7, 1 - dragProgress)` for slot 2 (so slot 2 never fully disappears mid-drag).

Stacking order is achieved purely by SwiftUI declaration order (front card's content declared
last) — no manual z-index. All values (scale/offset) interpolate continuously with drag progress,
not in discrete jumps.

**Gesture (vertical drag-to-dismiss):**
- Primary axis is **vertical** (not the more common horizontal swipe-card pattern — confirm this
  is intentional before "fixing" it to horizontal).
- Drag translation directly drives the top card's offset every frame.
- Rotation = `horizontalTranslation / 20` degrees — straying sideways during a vertical drag tilts
  the card slightly, for a natural off-axis feel.
- Dismiss threshold: **120pt** of vertical translation. Past that on release, the card flies off
  screen (700pt travel distance) in the drag direction and the next card is promoted.
- Under threshold: spring back to `.zero` — `interactiveSpring(response: 0.4, dampingFraction: 0.75)`.
- Successful dismiss uses `interactiveSpring(response: 0.52, dampingFraction: 0.78)` for the fly-off,
  then swaps the front index in an **unanimated** transaction exactly 0.42s later (once the card is
  off-screen) — don't animate the index swap itself, or the promoted card visibly inherits the
  dismissed card's motion.
- The deck is **cyclic**: swiping past the last card wraps to the first.

**Tap-to-advance:** left third and right third of the image area (top 260pt of the card) are
invisible tap zones that trigger the exact same "advance" animation as a successful drag-up. Must
be implemented as a **foreground overlay**, not a catcher behind the content — any opaque
background-filled view makes its whole frame hit-testable in SwiftUI/UIKit-style hit testing, so a
zone placed behind real content is unreachable. (This bit the iOS build twice during development —
worth calling out explicitly so Flutter doesn't repeat it. In Flutter, a `GestureDetector` with
`HitTestBehavior.opaque` layered as a `Positioned` on top of the image, at 1/3-width columns on
each side, achieves the same thing.)

### 3.4 Card content (shared between collapsed & expanded modes)

```
VStack(alignment: .leading, spacing: 0)
├── Image area — 260pt tall, full card width
│     ├── NFT image, aspect-fit (NOT fill — see note below), centered
│     ├── type badge chip, top-trailing, 12pt inset
│     │     "SemiBold 12, authTextColor on authBgColor, 12h/6v padding, capsule shape"
│     └── (collapsed mode only) invisible tap-advance zones, left/right thirds
└── VStack(alignment: .leading, spacing: 18), padding 16
      ├── HStack: NFT name (Bold 25/30) ── Spacer ── share button (36×36 tappable, icShareReverse icon, 8pt padding, authBgColor circle-ish rounded-8 background)
      ├── HStack: icTicket icon 20×20 — price/status text (Regular 16) ── Spacer ── expand chevron button (only rendered contextually, see below)
      ├── [expanded only] Divider, then Description section, NFT Details section, and (Claimed tab only) the Preview toggle row
      └── action button — "Claim" or "Buy" (only one is ever present per tab), 124×42, Regular 16, authTextColor-on-authBgColor, 8pt corner radius, centered under the content column
```

**Image mode — important, don't default to `.fill`:** the NFT image uses **aspect-fit**, not
aspect-fill. Most catalog items are square badge/medal artwork that Figma shows fully visible with
letterboxed padding around it (not cropped) — aspect-fill would crop badge edges. A wide/landscape
test asset in the catalog also renders in full, uncropped, under `.fit`. There's no backend field
distinguishing "badge" vs "photo" NFTs, so `.fit` was chosen as the one mode that's correct for
both cases — replicate that reasoning, don't reintroduce `.fill`.

**Price/status text logic** (applies identically on iPad):
1. `"Owned"` if the NFT is already owned
2. else `"Coming Soon"` if flagged
3. else `"Free"` if flagged free
4. else the formatted currency price (`NumberFormatter`, currency style, NFT's own currency code
   or `EUR` fallback)
5. else empty string

**Action button visibility** is mutually exclusive and tab-dependent:
- **Rewards tab**: "Claim" button shown unless already owned (owned → no button at all on iPhone,
  vs. iPad which shows a disabled "Owned" button — see the iPad section for that difference).
- **Claimed tab**: no action button at all.
- **Market Place tab**: "Buy" button shown unless owned or coming-soon.
Button shows a loading label (`"Claiming…"` / `"Buying…"`) and disables itself while its action is
in flight.

### 3.5 Expand/collapse behavior

Tapping the chevron-in-a-circle button (§1.3 icon-button style, `chevronDown`/`chevronUp` icon)
toggles between:
- **Collapsed**: the fixed-height swipe deck from §3.3, content clipped to the card height.
- **Expanded**: the deck is replaced entirely by a single scrollable card (an outer `ScrollView`
  wraps just the front card, no dot column, no deck mechanics) so the card can grow to its natural
  content height and reveal the Description/NFT Details/Preview-toggle sections. Title font also
  grows from 25pt to 30pt in this mode. Transition uses `.easeInOut(duration: 0.3)`.

Swiping to a different card (drag-dismiss) automatically collapses back to deck mode first.

### 3.6 Dot indicator (leading column, deck mode only, >1 NFT)

- Caps at **12 dots max** regardless of catalog size — a real catalog of ~16 items previously
  rendered a dot column taller than the card itself; don't remove this cap.
- The visible window of dots is **centered on the current card**, not always dots 0–11 — it's a
  sliding window that re-centers as the user advances.
- Active dot: 12pt circle. Inactive dot: 7pt circle. 8pt spacing between dots, `textColor` fill for
  both (only the size differs, not color/opacity).
- Tapping a dot jumps the deck straight to that card, animated through the *same* fly-off/reveal
  motion as a normal swipe (not an abrupt snap) — also collapses expanded mode first.
- Dot transitions use `.spring(response: 0.3, dampingFraction: 0.7)`.

### 3.7 Empty / loading / error states

Centered, `.frame(maxWidth: .infinity, maxHeight: .infinity)`, no illustration — just text:
- Loading: plain `ProgressView()` (system spinner).
- Error: `"Something went wrong loading NFTs."` — 14pt regular, `textColor`.
- Empty, per tab: `"No reward NFTs yet."` / `"You haven't claimed any NFTs yet."` / `"No NFTs in the marketplace right now."` — same 14pt regular styling.

### 3.8 NFT Preview overlay

Reachable only from the **Claimed** tab, in **expanded** mode, via the "NFT Preview" toggle row.
Replaces the card's content entirely (same card chrome/corner-radius container) with a mock
"how this looks on your profile" preview. Not a separate screen/route — a content swap inside the
same card view.

```
VStack(alignment: .leading, spacing: 0)
├── VStack(spacing: 20), padding: 18 horizontal / 24 top / 14 bottom
│     ├── titleRow: "NFT Preview" (Bold 30) ── Spacer ── share button (39×39 tappable incl. 9pt padding)
│     ├── metaSection:
│     │     ├── HStack: icTicket 20×20 + price text (Regular 17)  [+ person.2.fill SF Symbol + "N guests" if attendance data exists]
│     │     └── [if location known] HStack: mappin.circle.fill SF Symbol (17pt semibold, 35% opacity) + "City, Country" (Regular 17) ── Spacer ── chevronRight icon button (opens Apple Maps for that location)
│     └── [if NFT has name/description] eventSummary: "🌟 <name>" (Bold 16) + description (Regular 15, 3pt line spacing)
├── profilePreviewCard — ZStack, padding 18 horizontal
│     ├── background: RoundedRectangle 18pt radius, fill bgHomeArrow, inset 56pt from the top (so the avatar overlaps its top edge)
│     └── VStack(spacing: 12)
│           ├── HStack: 96×96 circular avatar placeholder (SF Symbol person.crop.circle.fill, 30% opacity) + stat chip (offset x:-10 y:18, overlapping the avatar's bottom-right)
│           └── VStack(spacing: 10), padding 22h/24bottom
│                 ├── HStack: "Host" (Bold 22) + 36×36 NFT thumbnail image + badge/current-badge text (Regular 17)
│                 ├── "About <name>: " (Bold 15) + first-sentence-of-bio-or-username (Regular 15), same line via Text concatenation
│                 └── [if bio has more than the first sentence] full bio text (Regular 15, 3pt line spacing, 14pt top padding)
└── closeButton, 28pt top padding: "Close Preview" — 194×50, Regular 16, authTextColor-on-authBgColor, 8pt radius, centered full-width
```

**Stat chip** (overlapping the avatar): `VStack(alignment: .leading, spacing: 2)`, min-width 174,
14h/8v padding, background `rgb(255, 199, 46)` ≈ `#FFC72E`, 6pt corner radius. Content, all **black**
text regardless of theme (this chip does not follow dark mode):
- `"<N> followers"` — Bold 15
- `"★ <rating> Overall Ratings"` — Regular 12 (only if a rating exists)
- `"<N> Events Attended"` — Regular 12

Data sources: current user's own profile (`GET /users/profile`) + `HistoryStatsService.myStats()` —
this preview always shows the *signed-in user's own* profile/stats mocked up as if the NFT were
their host badge, not the NFT's actual creator/owner.

### 3.9 Wallet transaction signing sheet

A `.sheet` presented with `presentationDetents([.medium])` whenever a purchase/claim response
contains a pending on-chain transaction needing a wallet signature.

```
VStack(spacing: 24), padding 24h / 32 bottom, background bgColor, top-aligned
├── drag handle: RoundedRectangle 3pt radius, 40×4, fill white-60%-opacity @ 40%, 12pt top padding
├── SF Symbol "signature", 48pt, filled with the purple→green gradient (§1.1)
├── VStack(spacing: 8)
│     ├── "Wallet Signature Required" — Bold 20, centered
│     └── <dynamic message from the API response> — Regular 14, 65% opacity, centered, 8pt horizontal padding
└── VStack(spacing: 12)
      ├── "Open Phantom Wallet" button — full width, 15pt vertical padding, purple gradient (§1.1) background,
      │     12pt corner radius, white text, SemiBold 16 + wallet.pass.fill SF Symbol leading icon.
      │     Tapping opens the Phantom deep link (`https://phantom.app/ul/v1/signAndSendTransaction`)
      │     and dismisses the sheet — this does NOT wait for a callback confirming the sign succeeded.
      └── "Dismiss" text button — Regular 14, 50% opacity, no background
```
Both buttons dismiss the sheet; only "Open Phantom Wallet" also fires the deep link.

---

## 4. iPad — Shop → NFTs segment

iPad does **not** reuse the iPhone's swipe-deck component at all — it's a completely different,
more traditional layout: three stacked sections, each a horizontally-scrollable row of compact
cards, tapping any card opens a full detail sheet.

### 4.1 `ShopNFTsView_iPad` — section list

```
ScrollView (vertical)
  VStack(alignment: .leading, spacing: 24), vertical padding 8
  ├── [error banners if present — 13pt regular red text]
  ├── Section "Rewards"
  ├── Section "Claimed"
  └── Section "Marketplace"
```

Each **section** card:
```
VStack(alignment: .leading, spacing: 16), padding 20, background bgContent + 20pt corner radius
├── Text(title) — Bold 20, textColor
└── content:
      ├── loading → ProgressView, 20pt vertical padding
      ├── error → "Something went wrong loading NFTs." (14pt regular)
      ├── empty → per-tab empty message (14pt regular) — same three strings as iPhone §3.7
      └── loaded → NFTHorizontalRow
```

### 4.2 `NFTHorizontalRow` — chevron-navigated horizontal scroller

```
HStack(spacing: 12)
├── left chevron button (chevronLeft icon, 20×20, 10pt padding, bgHomeArrow circle, shadow black-16%/blur-12/y-2)
│     — disabled + 30% opacity if ≤1 item
├── ScrollView(.horizontal, no indicators)
│     HStack(spacing: 16) of NFTCompactCardView, each pinned to `cardWidth` (default 220pt;
│     the "Other NFTs" row inside the detail sheet passes 180pt instead — narrower, see §4.4)
└── right chevron button — same style, opposite direction
```
Chevron taps animate-scroll one card at a time (`ScrollViewProxy.scrollTo(..., anchor: .leading)`),
they don't just nudge — they snap the next/previous card to the leading edge.

### 4.3 `NFTCompactCardView`

```
Button → VStack(alignment: .leading, spacing: 8), padding 10, background bgShopColor + 16pt radius
├── image area, 140pt tall, aspect-FILL (compact card uses fill, unlike the detail views' fit — deliberate, this is a thumbnail context)
│     └── type badge chip, top-trailing 8pt inset: SemiBold 11, white on black-85%-opacity, capsule, 10h/5v padding
├── NFT name — Bold 14, 1 line, truncated
└── HStack: icTicket 16×16 + price/status text — Light 13
```
Note the font weight here is **Light**, not Regular — the only place in this module that uses the
Light weight; don't substitute Regular by habit.

### 4.4 `NFTDetailView_iPad` — full detail sheet

Presented via `.sheet(item:)`, content-capped at **600pt max width**, centered (a plain full-size
sheet would otherwise stretch a 320pt hero image into a distorted wide banner on large iPads —
don't skip the width cap).

```
ScrollView
  VStack(alignment: .leading, spacing: 0)
  ├── HStack: Spacer + close button (32×32 "close" icon), 20pt top/trailing padding
  ├── Hero image: 320pt tall, full content width, background bgShopColor, clipped,
  │     20pt corner radius, 24pt horizontal padding
  │     └── type badge, top-trailing 16pt inset: SemiBold 13, white on black-85%, capsule, 14h/8v padding
  └── VStack(alignment: .leading, spacing: 16), padding 24
        ├── HStack: NFT name (Bold 26) ── Spacer ── share button (40×40 incl. 10pt padding, authBgColor bg, 10pt radius)
        ├── HStack: icTicket 20×20 + price/status text (Regular 16)
        ├── Divider
        ├── Description section — "Description" (SemiBold 20) + body (Regular 15, 70% opacity)
        ├── NFT Details section — "NFT Details" (SemiBold 20) + 4 rows: Token ID / Token Standard / Blockchain / Creator
        ├── Preview toggle row — "NFT Preview" (Bold 17) ── Spacer ── same switch control as §1.3
        └── [Marketplace source only, if related NFTs exist] "Other NFTs" (SemiBold 20) + NFTHorizontalRow at cardWidth 180
safeAreaInset(edge: .bottom):
  actionButtons, 24h/16v padding, 600pt max-width capped + centered, background bgContent,
  shadow black-9%/blur-22/y--2.5
  └── HStack(spacing: 16)
        ├── "Decline" — outlined only (1pt textColor stroke, 12pt radius), textColor text, Regular 16, dismisses the sheet
        └── primary action — filled authBgColor/authTextColor pill, 12pt radius, Regular 16, disabled+60%-opacity when inactive
```

**Primary action button text/state, by `NFTDetailSource`** — this is the one place iPad's button
logic differs from iPhone's (iPhone has *no* button at all when owned; iPad always shows one, just
disabled):

| Source screen | Owned | Not owned |
|---|---|---|
| Rewards | "Owned" (disabled) | "Claim" / "Claiming…" |
| Claimed | "Claimed" (always disabled) | — (not reachable from this source) |
| Marketplace | "Owned" (disabled) | "Buy" / "Buying…", or "Coming Soon" (disabled) if flagged |

Tapping a card in the "Other NFTs" row swaps this same sheet's content to the selected related NFT
in place — it does not push a second sheet.

The wallet-signing half-sheet (§3.9) is identical on iPad, presented from this same view.

---

## 5. Assets checklist

Icons (need Flutter equivalents — either export these exact PNG/SVG assets from
`Kumele/Assets.xcassets/` or source visually-matching Material/custom icons):

| Asset | Used for |
|---|---|
| `icTicket` | Price/ticket icon, all screens |
| `icShareReverse` | Share button |
| `chevronUp` / `chevronDown` | Expand/collapse toggle (iPhone) |
| `chevronLeft` / `chevronRight` | Horizontal row nav (iPad), map-pin link (preview) |
| `close` | Detail sheet close button (iPad) |

SF Symbols used (need Material Icons or a custom icon font equivalent):

| SF Symbol | Used for |
|---|---|
| `person.2.fill` | Guest count in NFT Preview |
| `mappin.circle.fill` | Location row in NFT Preview |
| `person.crop.circle.fill` | Avatar placeholder in NFT Preview |
| `photo.fill` | Broken/missing-image placeholder (iPad detail) |
| `signature` | Wallet-signing sheet hero icon |
| `wallet.pass.fill` | "Open Phantom Wallet" button icon |

Font: **Plus Jakarta Sans**, weights Regular/Medium/SemiBold/Bold (Light also used once, in the
iPad compact card price).

---

## 6. Behavioral notes worth preserving deliberately

These are things that look like they could be "cleaned up" but are deliberate fixes for real bugs
hit during iOS development — worth knowing so equivalent Flutter bugs aren't reintroduced:

1. **Tap-to-advance zones must be foreground overlays, not background catcher views** (§3.3) — an
   opaque background-filled sibling underneath real content is unreachable to touches in both
   SwiftUI and Flutter's hit-testing model.
2. **Don't animate the front-card index swap itself** during a dismiss transition — animate the
   fly-off offset, then swap the index in a single unanimated frame once off-screen. Animating both
   makes the newly-promoted card visibly inherit the old card's flight motion.
3. **Aspect-fit, not aspect-fill, for the hero/card NFT image** (§3.4) — the catalog is mostly
   square badge art that must show in full; fill would crop it.
4. **Dot indicator must cap and window itself** (§3.6) — an uncapped one-dot-per-item list breaks
   the layout on any catalog beyond ~12 items.
5. **The card width cap (329pt) matters even though it looks arbitrary** — without it the deck
   greedily fills available width on larger/wider screens and the dot column loses its margin.
6. **Peek cards are flat color silhouettes, not tinted/darkened real content** — this was tried
   first on iOS and looked wrong against the real Figma reference; don't reintroduce it as an
   "optimization" to reuse the same card view for peek slots.
