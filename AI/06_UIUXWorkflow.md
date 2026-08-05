# Kumele — UI/UX Improvement Workflow

Read [01_ProjectArchitecture.md](01_ProjectArchitecture.md) and [04_CodingRules.md](04_CodingRules.md) first. This file is specifically about the UI/UX polish work called out in the root handoff docs.

## The one rule that governs everything here

From `HANDOFF.md`:

> **Wahyu mobile UI/UX is canonical.** Start development from this package and preserve the accepted iPhone/iPad screen layouts, visual language, fonts, and interactions. This release-preparation pass intentionally made no SwiftUI layout or visual-design changes.

and:

> Some screens still need to be created and the existing UI needs a dedicated polish pass.

These two statements aren't in tension — they define the scope precisely:

- **In scope**: finishing incomplete/missing screens, fixing visual bugs (misaligned elements, wrong spacing, broken states, missing loading/empty/error states, inconsistent styling *within* the existing design language), wiring static/mock UI up to real data without changing its layout, and general polish (consistent padding, animation smoothness, accessibility basics).
- **Out of scope without explicit sign-off**: redesigning a screen's layout, changing the visual language (fonts/colors/spacing system), replacing the `_iPhone`/`_iPad` structure, or "modernizing" a flow's UX pattern. If a screen looks unpolished but its layout is clearly intentional, don't restyle it — flag it and ask.

If a screen you're touching also exists in the separate "Sinan" handoff, remember: **do not port Sinan's mobile presentation code.** Only its networking/model/service layer is an approved donor (see doc 01 §"Read this alongside...").

## Step 1 — Inventory before touching anything

Before changing a screen, check whether it's a genuine gap or a data-wiring gap masquerading as a UI problem:

1. Does the screen have a real ViewModel/Service behind it, or is it one of the UI-only areas listed in [01_ProjectArchitecture.md §9](01_ProjectArchitecture.md#9-tab-bar--feature-map) (Chat, Notifications, Payments, Profile, Shop, HistoryStatistics, FindHobbies)? A screen that "looks broken" because it's showing static `dummyImage`/`dummyEvent` sample data is an **API integration task** (see [05_ImplementedAPIs.md](05_ImplementedAPIs.md) for current status), not a UI/UX task — fix the data source, not the layout.
2. Does the screen exist for both `_iPhone` and `_iPad`? Check both — they're independent implementations (doc 01 §3), so a fix on one doesn't propagate to the other. If you fix a bug in `HomeView_iPhone.swift`, check `HomeView_iPad.swift` for the same issue.
3. Is the screen shared with `Kumele TV`? Check doc 01 §1's shared-file list — if the file is TV-shared, verify the fix doesn't break the TV layout (TV has different navigation/interaction patterns — remote-control focus vs. touch).
4. Is there an existing but unused component that already solves this? Check `Kumele/Views/Components/` before writing a new one — this project has existing primitives for alerts (`PopUpAlert.swift`, `WarningAlertView.swift`), loading/error states (`ErrorPageView.swift`), pickers, dropdowns, etc. Reuse them.

## Step 2 — Common gaps to look for (from the architecture research)

These are known, concrete UI gaps found during codebase review — a reasonable starting punch list rather than a vague "polish everything":

- **Loading states**: `ErrorPageView.swift` handles the error/retry case, but check whether every API-wired screen (`HomeView`, `BlogView`, `BlogDetailView`) also has a distinct loading/spinner state, not just error and loaded.
- **Empty states**: what does `HomeView`/`BlogView` show when a real API legitimately returns zero items? With everything mocked today, this path is never exercised — once you un-stub an endpoint (see doc 02), verify the empty case has a designed state, not a blank screen.
- **`ProfileView_iPad`'s inconsistent folder naming** (`Views/iPad/ProfileView/` instead of `Views/iPad/Profile/` like every other feature) — cosmetic, low priority, but don't "fix" it by moving files without checking nothing else references the path assumption; per doc 04, don't rename/move files unless required.
- **Two-factor auth has two disconnected implementations** (`AuthViewModel.verification()` vs. `TwoFactorAuthenticateViewModel.verifyCode()` — see doc 02 §3). If asked to polish the 2FA screen, first confirm with the user which of the two is actually in the live navigation path — polishing the dead one wastes effort.
- **`NotificationCardView.swift`** has a suppressed line (`Text("")//notification.appName)` in the Watch app) — a visible half-finished UI element.

## Step 3 — Workflow for each screen/fix

1. **Reproduce it in the simulator first.** Per the standing instruction for UI work: start the app, navigate to the actual screen, and see the problem yourself before changing code. Screenshots/description alone aren't enough to confirm a fix.
2. **Identify whether it's `_iPhone`, `_iPad`, or both.** Fix both if the bug is genuinely present in both — don't assume parity.
3. **Make the minimal visual change** using the existing design tokens already in use on that screen (check `Assets.xcassets` color sets like `bgColor`, `textColor`, `bgButtonColor` etc. rather than hardcoding new colors; check `Fonts/Inter`/`Fonts/Plus_Jakarta_Sans` for the existing type scale rather than introducing a new font).
4. **Re-run the golden path and adjacent screens in the simulator.** A layout fix (e.g. padding/frame change) can silently affect a shared component used elsewhere (`Views/Components/*` are reused across many screens) — check other consumers of any shared component you touch.
5. **Check both light/dark mode** if the app supports both (`@AppStorage("isDarkMode")` drives `.preferredColorScheme` in `ContentView` per doc 01 §3) — verify a color/contrast fix doesn't only look right in one mode.
6. **Test on both a compact (iPhone) and regular (iPad) simulator**, since the two are independent view trees.

## Step 4 — When a screen needs to be created from scratch

For genuinely missing screens (per `HANDOFF.md`: "Some screens still need to be created"):

1. Find the nearest existing analogous screen and follow its exact structure — same `_iPhone`/`_iPad` split, same use of `TabViewModel` for presentation state, same component reuse (buttons, text fields, alerts from `Views/Components/`).
2. Confirm with the user what data will back the screen — if it needs a new API, coordinate with [04_CodingRules.md](04_CodingRules.md)'s naming/structure conventions and [08_APICompleteReference.md](08_APICompleteReference.md) for the endpoint's curl/response shape, so the Service/ViewModel and the View land together, not the UI first with mock data that then needs a second pass.
3. Get a design reference (Figma, existing screen in the accepted UI, or explicit direction from the user) before laying out a new screen — don't invent a new visual pattern unprompted.

## Step 5 — Verification before calling it done

- Actually run the app in the simulator (not just SwiftUI previews) and exercise the golden path and at least one edge case (empty state, long text truncation, small/large device size) for anything you touched.
- Check both `_iPhone` and `_iPad`.
- Check both color schemes if applicable.
- If the fix touched a file shared with `Kumele TV` (doc 01 §1), launch the TV target too and confirm nothing regressed there — TV's focus-engine navigation is a different interaction model from touch, so a padding/frame change that looks fine on iPhone can still misbehave on tvOS.
- Report what you verified (not just what you changed) — e.g. "confirmed on iPhone 17 simulator, iPad Air simulator, light and dark mode" — matching the standing instruction to actually test UI changes rather than only asserting they should work.
