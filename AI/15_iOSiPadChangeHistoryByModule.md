# iOS/iPadOS Change History, By Module

This file is a module-organized summary of every real change, fix, and addition made to the main **Kumele** iOS/iPadOS app (iPhone + iPad) across the full Claude Code session history from 2026-07-24 through 2026-08-05, generated 2026-08-05. It is derived entirely from `AI/09_ChangeLog.md`, which remains the source of truth for full narrative detail, root-cause reasoning, and exact file paths per entry — this file compresses each entry down to the essential fact (what was broken/missing, what it now does) and groups by feature area instead of strict chronology. Doc-only passes (AI/*.md rewrites, the Next.js web audit, the Android/Flutter API guides) changed no app code and are omitted except for this mention. The separate "Kumele TV" and "Kumele Watch App" Xcode targets have their own extensive change history in the same changelog and are not detailed here.

## 1. Networking & Infrastructure

- Added centralized DEBUG-only request/response logging in `APIClient.execute`, covering every current and future API call automatically (2026-07-24).
- Centralized ~150 previously-inline endpoint path literals into `Kumele/Core/APIConstants.swift`, organized as nested enums by feature area (2026-07-24).
- Fixed `APIClient.decode()` collapsing every 401 response into a generic "Please sign in to continue" message even for unauthenticated calls (login, passkey ceremonies), discarding the backend's real error text (2026-07-24).
- Fixed `AuthTokens` silently dropping `email`/`role`/`emailVerified`, all required fields in the real backend response (2026-07-25).
- Migrated the passkey RP ID / Associated Domain / production API host from `iblocktechs.com` to `kumele.com`; also caught and fixed a live regression where Release builds were silently hitting the staging server instead of production, and restored the HTTPS-only precondition guard (2026-07-27).
- Temporarily pointed the Release build config at the staging server (marked with `TODO(PRODUCTION)` for reversal) at explicit user request, since production wasn't ready; relaxed the HTTPS-only guard and added an ATS cleartext exception accordingly (2026-07-27).
- Fixed a "Publishing changes from background threads is not allowed" runtime warning — `APIClient`'s session-expiry/notification-route broadcasts weren't dispatched to the main thread (2026-07-27).
- Removed a leftover debug `print()` statement that logged the user's raw JWT access token to the console (2026-07-29).

## 2. Auth & Onboarding

- Fixed a decode bug that silently emptied the login screen's language picker (backend sends a bare string array, not objects) (2026-07-24).
- Fixed verify-email OTP errors never reaching the user due to SwiftUI's single-sheet-stacking limitation (2026-07-24).
- Implemented the previously-missing `POST /auth/verify-reset-otp` and `GET /auth/me` endpoints (2026-07-24).
- Fixed forgot-password to actually verify the OTP before resetting the password (was sending the raw OTP as the reset token); fixed the mislabeled "Enter reset token" field (2026-07-24).
- Fixed the same sheet-stacking bug in the forgot-password flow (2026-07-24).
- Replaced splash-screen session bootstrap to validate the session via `GET /auth/me` instead of trusting a cached, unverified local user blob (2026-07-24).
- Fixed login silently skipping the unverified-email check (a dead code branch never fired); now checks `emailVerified` and shows the OTP sheet correctly (2026-07-24).
- Fixed missing hobby icons on the "Choose Interests" screen by falling back to the parent category's icon (2026-07-24).
- Fixed passkey device registration always sending the literal string `"iPhone"` as the device name; added real per-model device name resolution (2026-07-25).
- Fixed the same sheet-stacking bug in the passkey sign-up/sign-in flow (2026-07-25).
- Built the "Set up your profile" onboarding screen (avatar picker, debounced live username-availability check, About Me field), inserted after "Earn Medals" and before Home (2026-07-29).
- Added a "Sign In Successful" popup after login, deferring navigation until the popup finished displaying instead of tearing it down mid-animation (2026-07-29).
- Fixed `send-verification-email` never being called after sign-up, leaving new users on an OTP screen with no code ever sent (2026-07-29).
- Fixed `ProfileSetupView` wrongly reappearing on login for users who already had username/phone/bio saved (2026-08-01).
- Fixed login getting stuck with no screen transition when onboarding was incomplete but the profile itself was already complete; added a single `continueFromEarnMedals()` chokepoint (2026-08-01).
- Fixed hobby selections never persisting to the backend — the `setHobbies()` call had been left commented out, so onboarding could never actually complete server-side (2026-08-01).

## 3. Profile & Settings

- Fixed bio edits not appearing instantly on the Profile screen — `EditProfileView_iPhone` was mutating its own private `ProfileViewModel` instead of the shared injected one (2026-07-27).
- Fixed the crash ("No ObservableObject of type ProfileViewModel found") introduced by the fix above, due to environment-object scope loss through nested views (2026-07-27).
- Wired the real identity QR code into `ChatQrCodeView_iPhone`/`_iPad`, replacing a static dummy image asset (2026-07-25).
- Added decoding for `profileCompleteness` (percentage/missing/completed fields), which the backend sent but the model silently dropped (2026-07-25).
- Fixed `ProfileReferFriendView` showing a hardcoded fake referral code; wired to the user's real `referralCode` (2026-07-25).
- Implemented avatar upload — added `ProfileViewModel.uploadAvatar`, wired the avatar buttons in `EditProfileView_iPhone`/`_iPad` and the shared `ProfileHeaderView` to show the real photo instead of a dummy placeholder (2026-07-27).
- Fixed `EditProfileView_iPad` never having `ProfileViewModel` injected at all — the bio field was always empty and "Update" silently did nothing (2026-07-27).
- Fixed a third stray dummy QR code placeholder in `ProfileHeaderView` (2026-07-27).
- Added missing success confirmations for password change and account deletion, both of which previously succeeded silently with no user feedback (2026-07-27).
- Fixed the QR code endpoint's response decoding — the model was missing the backend's actual key (`qrCodeUrl`), causing "QR code unavailable" despite a successful API call (2026-07-27).
- Fixed the dead "Copy to clipboard" tile in the Refer Friend sharing-options row — it showed a "Copied!" success alert without ever actually copying anything (2026-07-30).

## 4. Home & Events

- Fixed `EventServices.getEventOwned()` unconditionally throwing, which had permanently broken the "My Events" UI (2026-07-24).
- Wired the "Rate event" block in `EventDetailView` to the real ratings API, replacing 100% hardcoded dummy scores and reviews (2026-07-25).
- Fixed `EventModel.endTime`/`durationHours` always being wrong for every event due to a snake_case field-name mismatch (`starts_at`/`ends_at`) (2026-07-25).
- Fixed the event-recommendations decode contract, which was silently erroring and breaking Home's "matched" events section (2026-07-27).
- Implemented Home's search icon, which had been a completely empty button; built client-side substring filtering over already-loaded events since the backend has no free-text search endpoint (2026-07-28).
- Fixed iPhone Home's empty-state check comparing the wrong arrays, causing a fully blank screen even when the swipe deck had nothing to render (2026-07-29).
- Added an illustrated "No Events Yet" empty state (Lottie animation), replacing a state that could render fully blank (2026-07-29).
- Fixed Home getting stuck permanently on the loading animation by adding a 6-second location-resolution timeout fallback (2026-07-29).
- Fixed a wasteful event-list API call firing with hardcoded default coordinates even when location permission was already granted (2026-07-29).
- Fixed duplicate `hostId`/recommendations API calls firing twice per Home load whenever location resolved (2026-07-29).
- Fixed a race condition where a slower, stale default-coordinate response could overwrite the correct, real location-based event list (2026-07-29).
- Added the missing `NSLocationWhenInUseUsageDescription` Info.plist key, without which device location could never resolve, silently forcing the app onto default coordinates every time (2026-07-29).
- Removed a silent fallback to the unfiltered global event feed when a geo-filtered search came back empty, which had been masking Home's "No Event Found" empty state with unrelated distant events (2026-07-29).
- Added `CurrentLocationProvider`, sending the device's real coordinates plus a reverse-geocoded city to `GET /events` (2026-07-29).
- Removed an accidental auto-trigger of PayPal payment on a right-swipe join gesture; join and payment are now separate, deliberate actions again (2026-07-29).
- Per the user's own direct edits (documented, not agent-built): search radius reduced 100km→28km, several list `limit` params tightened to 10, the `city` query param dropped from the Home event-list call, and a new on-load prefetch added (profile cache, hobby categories, notifications, ad campaigns) (2026-08-04).

## 5. Create Event

- Fixed a raw system error ("kCLErrorDomain error 8") being shown verbatim to hosts when an address couldn't be geocoded; replaced with a clear, actionable message (2026-07-27).
- Fixed Create Event validation/error alerts never being visible on the main form — they only ever displayed deep inside the Preview screen (2026-07-27).
- Fixed a double-force-unwrap crash risk in `CreateEventView_iPhone` (2026-07-27).
- Fixed `CreateEventView_iPad` missing the `PreviewEventView` sheet entirely — event creation was completely unreachable end-to-end on iPad (2026-07-27).
- Fixed the iPad "Check User Availability" flow having no presentation wiring at all (2026-07-27).
- Fixed a crash ("No ObservableObject of type CreateEventViewModel found") on iPad caused by an orphaned duplicate presenter left over from the previous fix (2026-07-27).
- Fixed 100% fabricated Guest Prices pricing tiers (wrong prices, wrong currency symbol, a missing tier, wrong guest ceiling); wired to the real `GET /event-plans` (2026-07-28).
- Fixed the guest-count picker allowing values beyond every priced tier; added a live price quote shown as the host adjusts guest count (2026-07-28).
- Implemented PayPal event-payment end-to-end (approval URL flow), required after a successful join for paid events (2026-07-28).
- Fixed two dead "Buy" cart-icon buttons in Create Event — removed a fake duration-based pricing button entirely, and moved capacity-tier payment to fire automatically right after event creation instead of an incorrect `/cart/items` call (2026-08-01).
- Fixed `totalGuest` and `capacity` being disconnected — the guest-count picker had no effect on what was actually submitted to the backend (2026-08-01).
- Fixed a duplicate-event-creation bug where retrying payment after a Stripe cancel/failure would recreate the event a second time (2026-08-01).
- Fixed the "Pay now" button in the paid-event preview dialog doing nothing at all (wired to the same working flow as "Create event") (2026-08-03).
- Fixed the payment-required flag (`creationPlan`) being silently discarded — it arrives as a sibling of `data` in the response envelope, not nested inside it, so the generic decoder never saw it (2026-08-03).
- Fixed a second discard of the same `creationPlan` data by a follow-up `GET /events/{id}` refetch (for the banner image) that doesn't return it (2026-08-03).
- Added success/failure confirmation popups after event creation/payment, replacing a dead-end where the form just stayed on screen with no feedback (2026-08-03).
- Fixed default guest-count values (100→2) that silently forced payment on events a host expected to be free (2026-08-03).
- Implemented an automatic PayPal fallback for event-creation payment when the Stripe sheet fails or errors (2026-08-03).

## 6. Chat

- Audited the Chat section end-to-end (message REST contract, Socket.IO gateway path, join/status endpoints); confirmed everything already correctly wired, no code changes needed (2026-07-27).
- Visual fixes to the chat conversation and event-interaction screens are logged under "UI/visual polish fixes" below (dark-mode contrast in the conversation view, Ratings/Report/Guest-scan tab restyle).

## 7. Notifications

- Fixed `NotificationView_iPhone`'s empty-state message rendering 3 times (once per section) instead of once for the whole screen (2026-07-27).
- Implemented an unread notification count badge (numeric on the More-menu tile, dot on the tab bar), sourced from the backend's already-sent but previously-unused `unreadCount` field (2026-07-28).
- Fixed notification sections (Matched/Created/Other) staying permanently empty because filtering used the wrong field; decoded `category`/`read_status`/`target_reference`, all of which the model had silently been dropping (2026-07-29).
- Rebuilt the Notification Center: made the reward/medal modal data-driven from the real notification (previously hardcoded to "Bronze" for every notification), rebuilt the notification row with real event category/host/thumbnail data, wired real event Join/Pay flow from a notification tap, added a Blog Comments bottom sheet, and unwrapped the Cancelled popup's explanatory text from an accidental dismiss-button (2026-07-29).
- Fixed a Notifications-screen join action having zero error/success feedback on both free-join and payment-failure paths (2026-07-29).
- Fixed `NotificationItem_iPad` showing the same hardcoded fake "Bronze"/"Akesh kumar" data the iPhone version had already been fixed to avoid (2026-08-01).
- Fixed push-token registration silently dropping the required `deviceId` field when `identifierForVendor` was `nil` (e.g. right after install) — added a persisted UUID fallback (2026-07-30).
- Switched push-token registration to the canonical `/notifications/push-token` endpoint and field names (2026-08-01).
- Per the user's own direct edits: new per-event chat-status polling now drives a tab-bar unread-chat badge (2026-08-04).

## 8. Blog

- Audited the Blog section end-to-end; confirmed nested comment replies decode and render correctly, corrected a stale doc claim about `POST /blogs` (genuinely dead — no compose-a-post UI exists) (2026-07-27).
- Fixed "like works in Postman but not in the app" — the failure was real but silently swallowed with no UI feedback; added an alert (2026-07-27).
- Fixed newly-posted comments appearing instantly but blank until leaving and re-entering the screen — the response envelope wasn't being unwrapped; also fixed raw ISO8601 timestamps rendering unformatted (2026-07-27).
- Fixed blog feed images with a null cover image logging failed-load warnings; added a guard and placeholder icon (2026-07-27).
- Re-verified the like/unlike toggle contract against the real backend (single `POST` toggle, no separate `DELETE`) after a web-doc cross-check suggested otherwise; confirmed existing code was already correct, added regression tests (2026-07-28).

## 9. Shop, Commerce, NFTs & Subscriptions

- Wired the NFT screen's three tabs (Rewards/Claimed/Marketplace) to real `NFTService` calls, previously fully empty (2026-07-27).
- Fixed an `NFTModel` decode crash risk (price arriving as a string, not a number) and a missing `owned` field that would have shown "Claim" on already-owned rewards (2026-07-27).
- Wired the NFT Marketplace "Buy" button to `POST /nfts/{id}/purchase`, previously dead code with no payment-SDK blocker (2026-07-27).
- Pixel-audited the NFT card component against Figma on iPhone (corner radius, shadow, border, image height, ticket icon, button sizing, typography, chip colors) (2026-07-27).
- Built pixel-perfect Shop screen UI for Guest Tickets/NFTs/Subscriptions tabs (iPhone), including a Store Credit header and real per-tier icon selection (2026-07-29).
- Built a Tinder-style swipeable NFT card deck (`CardDeckSwipeView`), then fixed it not working at all — it was nested in an unbounded-height scroll view that collapsed the drag hit-area (2026-07-29).
- Built pixel-perfect iPad Shop/NFT UI (NFTs tab, section-list layout, detail sheet) (2026-07-29).
- Fixed subscription purchase hitting `/cart/items` with a non-UUID tier id; implemented a real Stripe PaymentIntent + native PaymentSheet checkout flow end-to-end for subscriptions (2026-07-29).
- Fixed a subscribed tier still showing "Buy now" instead of "Active" — a field-name mismatch (`tierId` vs `tier`) plus a decode-order bug in the shared envelope decoder that silently produced an all-nil object instead of throwing (2026-07-29).
- Migrated subscriptions from Stripe to Apple In-App Purchase / StoreKit 2 per explicit request; added `AppleSubscriptionStore`, `POST /subscriptions/apple/verify`, and `appleProductId`; removed the Stripe subscribe path entirely (2026-07-30).
- Hardened the StoreKit integration per external review: gated purchasability on Apple's actual product catalog (not just a backend flag), added Restore Purchases and silent post-reinstall entitlement reconciliation, added a native Manage Subscription sheet (2026-07-30).
- Removed the Manage Subscription/Restore Purchases UI buttons per user request, keeping the underlying logic intact (2026-07-30).
- Folded Restore Purchases into an automatic, once-per-session background reconciliation instead of a dedicated button (2026-07-30).
- Fixed every subscription tier showing "Unavailable" — added DEBUG diagnostics and a local StoreKit Configuration file for Simulator testing (2026-07-30).
- Fixed an unprompted "Sign in with Apple ID" system dialog appearing just from opening the Shop screen (2026-08-01).
- Fixed restored transactions never being finished (risking indefinite redelivery), added a double-tap purchase guard, and moved the renewal-transaction listener to an app-scoped observer active for the whole session instead of only while Shop was open (2026-08-01).
- Wired the local StoreKit config file into the Xcode scheme's Run action so Simulator testing uses the local catalog instead of the live App Store (2026-08-01).
- Fixed the NFT deck's Rewards/Claimed tab buttons becoming unresponsive after a purchase refreshed the list, due to the gesture recognizer being torn down mid-interaction (2026-08-01).

## 10. Payments, Tickets, Cart, Saved Cards & Refunds

- Implemented PayPal event-join payment end-to-end (approval URL opened via in-app Safari, no card data touches the app), wired into the swipe-card join action (2026-07-28).
- Wired the Stripe server-side half of event payments (`confirm`/`event`/`event-creation` endpoints); client-side confirmation remained blocked pending a payment-SDK/PCI decision until it was resolved later (2026-07-28).
- Wired the real `/tickets` endpoints for the Guest Tickets tab (previously showing unrelated event-pricing data); added automatic ticket issuance right after a successful PayPal event-join capture (2026-07-29).
- Removed an accidental auto-payment trigger on the Home right-swipe join gesture (2026-07-29).
- Fixed `GET /payments/cards`'s response envelope mismatch (`{"cards":[...]}` vs the assumed generic `{"data":[...]}`) (2026-07-29).
- Implemented the full `/payments/cards*` family (setup intent, list/add/delete/set-default) via Stripe's SDK-hosted card entry sheet, replacing a broken hand-rolled card form that would have collected raw card numbers into the app's own backend — a PCI-DSS violation, not just a style issue (2026-07-29).
- Fixed two dead "Buy" cart-icon buttons in Create Event; capacity-tier payment now fires automatically post-creation via Stripe (2026-08-01).
- Fixed a 3-layer bug preventing the Stripe payment sheet from ever opening for paid event creation (wiring, envelope-sibling decode bug, and a refetch that discarded the fix a second time) (2026-08-03).
- Added success/failure confirmation feedback after event-creation payment (2026-08-03).
- Fixed a guest-count default that silently forced payment on events meant to be free (2026-08-03).
- Implemented an automatic PayPal fallback for event-creation payment when Stripe fails (2026-08-03).
- Per the user's own direct edits: a new `GET /discounts/rewards` endpoint is now wired into the Cart and Saved Cards screens (not yet UI-consumed); tickets now embed their event summary directly, removing a per-ticket event lookup call (2026-08-04).
- Refunds and the PayPal-as-saved-payment-method endpoint remain confirmed dead code — no UI exists anywhere in the app to attach them to, left unwired per the project's no-speculative-UI convention.

## 11. History & Statistics / Rewards

- Wired the History & Statistics screen (iPhone and iPad) to real `GET /users/me/stats/monthly` data — bar-chart heights, tooltips, and "Money Earned" totals were previously 100% hardcoded fake data (2026-07-27).

## 12. Support, Legal & Content

- Wired the "Community Guidelines"/Terms tabs to the real `ContentService.legalDocument` endpoint, replacing literal Lorem Ipsum placeholder text (2026-07-27).
- Implemented a real customer-support ticket flow (`POST /support/tickets`) on the Contact screen, replacing a `MFMailComposeViewController` draft to a personal email address that had never actually reached the backend's support system (2026-07-27).
- Wired the "How To" and "Popular" Guidelines tabs to real legal-document content, and rebuilt the "Knowledge Base" chat tab as a real AI chatbot integration against a separate ML microservice (`/chatbot/ask`), replacing six hardcoded scripted messages with dead send buttons (2026-08-01).

## 13. Ads

- Fixed ad impression/click tracking silently failing on every single request app-wide due to a snake_case/camelCase field-name mismatch in the tracking payload (2026-07-27).
- Fixed a fake, hardcoded Spotify-branded fallback ad shown whenever a real ad had a nil title/body, on both iPhone and iPad ad-detail screens (2026-08-01).
- Per the user's own direct edits: the ad placement value was renamed `EVENT_DECISION`→`HOME` and a new `limit` param added to `GET /ads/fetch` (2026-08-04).

## 14. tvOS QR Pairing (phone-side)

- Built the phone-side QR scanner (`DeviceQRScannerView`, using `AVFoundation` — the app's first camera-permission usage) and a "Connect TV" row in the Profile Security screens, calling `POST /auth/device/claim` to approve a TV sign-in (2026-07-27).
- Added a standard viewfinder overlay (yellow corner brackets) to the scanner's camera preview to match typical iOS QR-scanner UI (2026-07-28).

## 15. UI/Visual Polish Fixes

- Fixed a "No image named ''" asset-catalog warning for events with no category icon; added an SF Symbol fallback (2026-07-27).
- Pixel-audited the NFT card component against Figma on iPhone (corner radius, shadow, border, image height, ticket icon, button pill shape, typography, chip colors) (2026-07-27).
- Restyled the Home search bar into a morphing circular-icon-to-pill design, then corrected it to properly flip with the system's light/dark appearance instead of staying a fixed color (2026-07-29).
- Centered the subscription and guest-ticket tier CTA buttons, which had been left/right-hugging their rows (2026-07-29).
- Rebuilt the NFT card deck's gesture/animation physics to match a supplied reference implementation (3-card conveyor stacking, real shadows, a working dot indicator) (2026-07-29).
- Extended the NFT Figma audit to the iPad detail popup: fixed a mislabeled toggle ("NFT Details"→"NFT Preview"), the action-bar color/shadow, button styling, and header font weights (2026-08-01).
- Refactored the NFT card deck from horizontal to vertical swipe physics using real Figma measurements (per-slot scale/offset fractions, dot-indicator sizes) (2026-08-01).
- Fixed the deck's peek cards rendering tinted real content instead of Figma's flat silhouette colors; capped the deck's width so the dot column doesn't get squeezed off on wider screens (2026-08-01).
- Fixed a math error in the peek-card offset calculation that produced a large gray blob below the front card and invisible dots (2026-08-01).
- Fixed wide/landscape NFT images overflowing their card frame; redesigned the dot indicator into a capped, tappable, sliding-window system (2026-08-01).
- Fixed NFT deck tap-to-advance not working at all — first a drag-gesture priority conflict, then a deeper issue where a background-filled view made its whole frame hit-testable, blocking taps on anything behind it (2026-08-01).
- Fixed an empty gap appearing above the NFT deck once a background color change exposed a pre-existing centering issue (2026-08-01).
- Reverted the NFT deck background from white back to Figma-accurate grey after a reference screenshot showed it looked "completely different"; switched badge-type NFT images from cropped-fill to aspect-fit (2026-08-01).
- Restyled the Ratings/Report/Guest-Scan tab bar to a pixel-perfect dark pill design with a yellow count badge and colored avatar rings (2026-08-03).
- Fixed dark-mode contrast bugs in the chat conversation screen: an invisible white-on-near-white sender-name label, and a low-contrast message composer placeholder (2026-08-03).

## 16. Testing Infrastructure

- Fixed the entire `KumeleTests` target failing to compile after a protocol method addition wasn't mirrored in a mock conformer — had gone unnoticed because only `xcodebuild build`, never `xcodebuild test`, had been run (2026-07-27).
- Identified (not yet root-caused) flaky full-suite parallel test failures traced to a shared mutable static (`URLProtocolMock.handler`) that isn't safe under Swift Testing's cross-suite parallelism (2026-07-27).
- Added `*Servicing` protocol seams (covering NFTs, legal content, support tickets, tickets, profile, payments, history stats, notifications, event plans, and more) across concrete Service classes throughout the project specifically to enable mock-based unit testing — an ongoing pattern applied consistently from 2026-07-25 through 2026-08-01.
- Standing project convention: every successful feature implementation throughout this history got dedicated test coverage in `KumeleTests/` at the time it was built — not itemized individually here; see `AI/09_ChangeLog.md` for the full per-entry test list.

---

*Kumele TV and Kumele Watch App targets have their own separate, extensive change history in `AI/09_ChangeLog.md` (target renames, per-target file-membership fixes, tvOS platform-compatibility guards, a full WatchConnectivity-based data relay, Watch notification scheduling, etc.) — not detailed in this iPhone/iPad-scoped report.*
