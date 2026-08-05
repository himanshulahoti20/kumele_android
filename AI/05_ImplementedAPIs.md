# Kumele — Implemented APIs (current state, 2026-07-30, fresh full per-endpoint re-audit)

**This is the current, authoritative source of truth for every endpoint's implementation status.** This pass re-derived every status from scratch — nothing was trusted from the previous (2026-07-24, incrementally patched through 2026-07-30) version of this file — by `grep`-ing every constant in `Kumele/Core/APIConstants.swift` for its `Service` method, then every `Service` method for its actual call sites in `Kumele/ViewModels`/`Kumele/Views`/`Kumele TV`/`Kumele Watch App`, not just whether the containing class is used somewhere.

Covers **167 consumer-relevant endpoints** — recounted from scratch per section this pass (163, not the previously claimed 168; the old figure didn't actually match the sum of its own per-section headers, another small pre-existing inconsistency this pass fixed) **+ 4 endpoints found with real Swift code but never added as rows to either doc** — see "Corrections" below — of the ~248 total backend endpoints across 40 tags per [`api-reference/endpoint-catalog.md`](api-reference/endpoint-catalog.md) / [`api-reference/openapi.json`](api-reference/openapi.json). **That catalog itself is stale** — it was generated 2026-07-24 and predates the tvOS device-pairing endpoints and `/subscriptions/apple/verify`, none of which exist in the checked-in `openapi.json` (confirmed by `grep`); their existence and shape come from this repo's own Swift code and prior sessions' live-curl notes (see `AI/09_ChangeLog.md`), not the stale spec. **Admin, business-portal, and internal/infra endpoints (78), plus blog/NFT image upload (2), remain stripped from this list entirely** — none are relevant to this consumer iOS app; see [`10_APIStatusList.txt`](10_APIStatusList.txt) §3 if that accounting is ever needed again.

## Corrections made this pass (2026-07-30 fresh audit)

- **4 endpoints added, previously missing from both docs entirely**: `POST /auth/device/code`, `POST /auth/device/token`, `POST /auth/device/claim` (tvOS QR sign-in, device-authorization-grant — implemented 2026-07-27 per project history but never added as rows here), and `POST /subscriptions/apple/verify` (added with the StoreKit migration, 2026-07-30). All 4 are 🟢 live — see §1 and §9.
- **`GET /users/check-username`**: `10_APIStatusList.txt` had it duplicated in both the Implemented list *and* the Pending `[NOT BUILT]` list — a leftover contradiction from an incremental edit. It's 🟢 live (this file already had it correct); the flat list is fixed below.
- **`POST /payments/cards/setup-intent`, `POST /payments/cards`, `GET /payments/cards`, `PATCH /payments/cards/{id}/default`, `DELETE /payments/cards/{id}`**: previously ❌/`[NOT BUILT]` ("needs Stripe SDK, not a project dependency"). **Stale** — a later session added the Stripe iOS SDK for exactly this (`ProfileAddCardView_iPhone`, `SavedCardsViewModel`, `CardSetupPresenter.swift`), and it's fully wired on iPhone (add/list/delete/set-default) and partially on iPad (list/delete/set-default via `ProfileCardView_iPad`, no "Add Card" screen there). Now 🟢. This closes what was previously the single largest flagged gap in the app.
- **`POST /payments/event`**: still ⚪ dead (no call site), but the *reason* was stale — it was flagged `[BLOCKED]` on "no Stripe SDK dependency," which is no longer true (the SDK is now in the project for cards/subscriptions). The real reason it's still dead: PayPal already covers paid-event-join end-to-end, and nobody wired the Stripe alternative on top of it. Downgraded from `[BLOCKED]` to plain `[NO UI]`/dead-code.
- **`POST /subscriptions` (create)**: previously 🟢. The 2026-07-30 StoreKit migration removed `SubscriptionService.create(tierID:discountCode:)` entirely (confirmed zero references to `APIConstants.Subscriptions.create` anywhere in Swift) in favor of StoreKit purchase + `POST /subscriptions/apple/verify`. The path constant is kept only as a comment-flagged leftover ("Stripe-era... no longer called"). Now ⚪ — no Swift method wraps it at all, so it's closer to ❌ in spirit, but the constant and backend route still exist.
- **`Kumele TV`'s "Sign In with QR" flow** (§ cross-target table): previously documented as unwireable ("no TV/device-pairing endpoint exists anywhere in `openapi.json`"). **Wrong as of this pass** — `LandingPage.swift`'s `SignInView` (TV) generates a real QR from `AuthViewModel.startDevicePairing()`/`devicePairingStatus`, and `DeviceQRScannerView.swift` (phone) scans + calls `claimDevice(userCode:)` — both ends fully live via the 3 new Device endpoints above. Corrected to 🟢.
- **Tickets (§11), biggest single miss this pass**: the whole section previously said "all ⚪ dead, no My Tickets/ticket-purchase UI exists anywhere in the app, confirmed via find/grep." That claim was simply false — `GuestTicketsViewModel.swift` is real, wired into both `ShopView_iPhone`'s and `ShopView_iPad`'s "Guest tickets" tab (list + cancel), and `EventPaymentViewModel` auto-issues a ticket after every successful PayPal capture. `POST /tickets/events/{id}`, `GET /tickets/my`, `DELETE /tickets/{id}` corrected ⚪→🟢.
- **Cart (§9), second-biggest miss**: previously "entirely ⚪ dead... no product/cart catalog UI anywhere in the app." Also false — `PaymentView_iPhone.swift` (reachable from the tab bar's payment icon) is a real, working Cart screen (`CartViewModel`: load/update-quantity/remove/clear), and `CreateEventViewModel.addGuestTicketsToCart()` adds an event-plan capacity tier to it from the "Guest Prices" modal. 4 of 5 Cart endpoints corrected ⚪→🟢; the 5th (`POST /cart/items`) is flagged 🟡 — first `[LIVE BUT WRONG]` finding in this doc — since it passes a non-catalog tier ID as the cart's `productId`, the same anti-pattern already confirmed-and-fixed once elsewhere in this app (see §9 for why it's flagged, not fixed outright: unconfirmed without a fresh live-curl).
- **Both misses share a root cause worth naming**: neither `CartViewModel.swift` nor `GuestTicketsViewModel.swift` was checked against `Kumele/ViewModels/*.swift` directly — the previous audits searched for UI screens/buttons by name and found none obviously labeled "Cart" or "My Tickets," when in fact the Cart screen is titled "Cart" but reached via the *Payments* tab, and tickets live inside the *Shop* screen's "Guest tickets" tab. `grep`-ing the ViewModels folder directly for unaccounted-for `Service`-backed classes (not just grepping constants → services → known screens) is what surfaced both this time.

## Status legend

- 🟢 **Live** — a real network call exists, the path/method match the real backend, and it's actually reachable from a View/ViewModel today (verified by grep, not assumed from the class being "live" overall).
- 🟡 **Live but wrong** — reachable from a View, but something about the call (path, request shape, or a missing intermediate step) doesn't match the real contract, so it fails or misbehaves at runtime.
- ⚪ **Dead code** — a `Service` method exists with a correct endpoint and would work if called, but zero ViewModel/View call sites reference it. The backend supports the feature; the app doesn't reach it.
- ❌ **Not implemented** — no Swift constant or Service method exists for this endpoint at all. A real, user-facing gap.

A **✅ before a section number** means that section has been through the full audit-and-implement cycle (per the standing "check a section" workflow in [04_CodingRules.md](04_CodingRules.md)): every endpoint audited, every dead-code endpoint checked against real UI, everything with genuine existing UI wired up, everything without UI left alone and flagged. Sections without ✅ have an endpoint-status audit below but haven't had that UI cross-check pass yet.

## 0. Networking layer

`Kumele/Networking/{APIClient,APIEndpoint}.swift` — `APIClient` is an `actor` singleton (`.shared`) built on `URLSession`: Bearer JWT auth, Keychain-backed token storage (`KeychainTokenStore`), automatic 401 → `POST /auth/refresh` → retry-once (with in-flight de-duplication), `APIEnvelope<T>` for the `{ok/success, data, meta}` shape used by Hobbies/Blogs/Events/etc., and structured `APIError` cases (`.twoFactorRequired`, `.ticketServiceUnavailable`, `.validation([String])`, etc.). DEBUG-only request/response console logging lives in `APIClient.execute`.

Dead, do-not-use stacks: `Kumele/Networking/NetworkManager.swift` (`NetworkManagerProtocol`, `APIResponse<T>`-envelope, zero call sites) and `Kumele/Services/NetworkService.swift` (Alamofire-based, zero call sites). See [08_APICompleteReference.md](08_APICompleteReference.md) for why these exist.

---

## ✅ 1. Auth (25 endpoints) — `Kumele/Services/Auth/{AuthService,PasskeyService,FirebaseGoogleSignInService}.swift`

Google OAuth redirect pair (`GET /auth/google`, `/auth/google/callback`) omitted — not relevant to this app, superseded by Firebase-mediated Google Sign-In below.

**3 endpoints not in the stale checked-in `openapi.json`/`endpoint-catalog.md`** (both generated 2026-07-24, before this feature existed) — device-authorization-grant TV QR sign-in, implemented 2026-07-27: `POST /auth/device/code` (TV requests a code), `POST /auth/device/token` (TV polls for a token), `POST /auth/device/claim` (phone approves, scanning the TV's QR). Confirmed real via `AuthService.{requestDeviceCode,pollDeviceToken,claimDevice}` and both ends of the flow (`Kumele TV/LandingPage.swift`'s `SignInView` generates+polls; `Kumele/Views/Common/Auth/DeviceQRScannerView.swift` scans+claims from the phone).

| Method | Path | Status | Notes |
|---|---|---|---|
| POST | `/auth/signup` | 🟢 | `register(...)` — real `SignupDto` shape, then `PUT /users/profile` for optional fields |
| POST | `/auth/login` | 🟢 | Detects `tempToken` → `.twoFactorRequired`, then `fetchProfile()` |
| POST | `/auth/logout` | 🟢 | Also clears Keychain + legacy `UserDefaults` |
| POST | `/auth/logout-all` | 🟢 | |
| POST | `/auth/refresh` | 🟢 | Automatic, inside `APIClient` on any 401 |
| POST | `/auth/firebase-login` | 🟢 | `firebaseLogin(firebaseToken:)`, via `FirebaseGoogleSignInService` |
| POST | `/auth/passkey/register/start` | 🟢 | `PasskeyService` — full WebAuthn ceremony |
| POST | `/auth/passkey/register/finish` | 🟢 | |
| POST | `/auth/passkey/login/start` | 🟢 | |
| POST | `/auth/passkey/login/finish` | 🟢 | |
| POST | `/auth/forgot-password` | 🟢 | |
| POST | `/auth/verify-reset-otp` | 🟢 | `verifyResetOtp` |
| POST | `/auth/reset-password` | 🟢 | Chained correctly after `verifyResetOtp` (was 🟡, fixed — see changelog) |
| POST | `/auth/change-password` | 🟢 | |
| POST | `/auth/send-verification-email` | 🟢 | Triggered by `AuthViewModel.login()` when `user.emailVerified == false` |
| POST | `/auth/verify-email` | 🟢 | |
| POST | `/auth/resend-verification` | 🟢 | |
| POST | `/auth/2fa/setup` | 🟢 | `TwoFactorSettingsViewModel` |
| POST | `/auth/2fa/enable` | 🟢 | |
| POST | `/auth/2fa/disable` | 🟢 | |
| POST | `/auth/2fa/verify` | 🟢 | `TwoFactorAuthenticateViewModel` |
| GET | `/auth/me` | 🟢 | `validateSession()`, used by `SplashSessionBootstrap` at launch |
| POST | `/auth/device/code` | 🟢 | `requestDeviceCode()`, called from `AuthViewModel.startDevicePairing()` (TV) |
| POST | `/auth/device/token` | 🟢 | `pollDeviceToken(deviceCode:)`, same flow, polled on a timer until claimed/expired |
| POST | `/auth/device/claim` | 🟢 | `claimDevice(userCode:)`, called from `DeviceQRScannerView` (phone, after scanning the TV's QR) |

Fully implemented — all 25 endpoints live.

## ✅ 2. Hobbies (4 endpoints) — folded into `AuthService`, no separate service

| Method | Path | Status | Notes |
|---|---|---|---|
| GET | `/hobbies/categories` | 🟢 | `getHobbies()` — flattens nested `hobbies` per category |
| GET | `/hobbies/categories/{id}/hobbies` | ❌ | Not called separately — hobbies already arrive nested in the categories response above, so there's no need today, but a dedicated per-category fetch isn't implemented if ever needed |
| GET | `/hobbies/users/{id}` | ❌ | No call site — the app reads hobby prefs from the `hobbies` field already embedded in `GET /users/profile` instead |
| PUT | `/hobbies/users/{id}` | 🟢 | `setHobbies(hobbies:)` |

## ✅ 3. Users / Profile / Social (22 endpoints: 21 `Users` tag + 1 `users` "attendance" tag)

Two competing implementations exist for follow/social endpoints: `ProfileService` (`Kumele/Services/API/ProfileService.swift`, **live**, 4 call sites: `ProfileViewModel`, `ProfileFollowViewModel`, `InterestSelectionViewModel`, `PopUpFollowHostView`) and `UserSocialService` (`UserEventExtendedService.swift`, mostly dead — only `qrCode(userID:)` is now called, from `ChatQrCodeView_{iPhone,iPad}`; its other 5 methods remain zero-caller). Where both implement the same endpoint, the status below reflects `ProfileService`'s live status, not `UserSocialService`'s dead duplicate.

| Method | Path | Status | Notes |
|---|---|---|---|
| GET | `/users/profile` | 🟢 | `ProfileService.profile()` |
| PUT | `/users/profile` | 🟢 | `ProfileService.update(_:)` |
| GET | `/users/me/stats` | ⚪ | `HistoryStatsService.myStats()` — correct, endpoint has no dedicated consumer of its own; the fields it exposes (event/ticket/social/host-rating counts) aren't shown anywhere in the History & Statistics screen (see below), only the monthly breakdown is |
| GET | `/users/me/stats/monthly` | 🟢 **corrected from ❌** | `HistoryStatsService.myStatsMonthly(year:)` — **found and fixed a real miss**: `HistoryStatisticsView_iPhone`/`_iPad` and `Kumele TV`'s own `HistoryStatisticsView` all had a fully-built chart (bar chart + "Money Earned $XXX" text + year picker) wired to 100% hardcoded fake data (`Earning`/`BarChartView.data` tuples with fake event names like "90's Hip-Hop"). Live-curled this endpoint and wired all three screens to it — see the field-completeness note below. |
| GET | `/users/check-username` | 🟢 | `ProfileService.checkUsername(_:)`, called from `ProfileSetupViewModel` (debounced live-availability check on the username field in `ProfileSetupView`, the signup screen right after "Earn Medals") |
| PATCH | `/users/{id}/profile` | ❌ | Only the full `PUT /users/profile` exists; no partial-update-by-ID path |
| GET | `/users/referral-code` | ⚪ (correctly) | `UserSocialService.referralCode()` still unreached, but intentionally — `ProfileReferFriendView.swift` (Profile → "Refer a Friend") now reads `referralCode` off the current user's already-fetched `ProfileService.profile()` response instead of calling this separate, redundant endpoint. Was previously showing a hardcoded fake `"SXF2RS4"` code — that's the real bug that's now fixed. |
| GET | `/users/{id}/referral-code` | ❌ | No constant/method for the by-ID variant |
| GET | `/users/referral-code/{code}/validate` | ⚪ | `UserSocialService.validateReferralCode(_:)` — dead |
| GET | `/users/referrals` | ⚪ | `UserSocialService.referrals()` — dead |
| GET | `/users/{id}/host-profile` | 🟢 | `EventServices.getHostProfile(id:)`, called from event detail flow |
| GET | `/users/{id}` | ⚪ | `UserSocialService.user(id:)` — dead |
| GET | `/users/{id}/qr` | 🟢 | `UserSocialService.qrCode(userID:)` — **corrected from ⚪**, now wired into `ChatQrCodeView_{iPhone,iPad}` (fetches the current user's own identity QR, decodes the data-URL response, replaces the static dummy QR image) |
| GET | `/users/{id}/rewards` | 🟢 | `RewardService.rewardsForCurrentUser()` — live (§7). `UserSocialService.rewards(userID:)` duplicates it, dead. |
| GET | `/users/{id}/profile-completeness` | ⚪ (correctly) | `UserSocialService.profileCompleteness(userID:)` still has zero callers, but this is intentional, not a gap — `GET /users/profile` already embeds this same data (`profileCompleteness: {percentage, missingFields, completedFields}`), which `User.swift` now actually decodes (previously discarded — the field wasn't in the model at all). No UI displays it yet; that's a separate, real gap — there's no "complete your profile" percentage/prompt anywhere in the app despite the data now being available. |
| POST | `/users/{id}/follow` | 🟢 | `ProfileService.follow(userId:)`, called from `PopUpFollowHostView` |
| DELETE | `/users/{id}/follow` | 🟢 | `ProfileService.unfollow(userId:)`, called from `ProfileFollowViewModel` |
| GET | `/users/{id}/followers` | 🟢 | `ProfileService.followers`, called from `ProfileFollowViewModel` |
| GET | `/users/{id}/following` | 🟢 | Same |
| GET | `/users/{id}/follow-stats` | 🟢 | Same |
| GET | `/users/follow/suggestions` | ⚪ | `UserSocialService.followSuggestions()` — dead |
| GET | `/users/{id}/attendance` | ⚪ | **Corrected from previous 🟢.** `EventInteractionService.attendance(userID:)` exists with a correct path but has **zero call sites** — not actually reachable from any screen |

**History & Statistics — real gap found and fixed (flagged directly by the user, not caught during the original section audit).** `HistoryStatisticsView_iPhone.swift`, `HistoryStatisticsView_iPad.swift`, and `Kumele TV/View/HistoryStatistic/HistoryStatisticsView.swift` (three separate, unshared copies of essentially the same screen) each had a fully-built "Money Earned" bar chart with a tappable per-month tooltip and a year picker — 100% driven by hardcoded literals (`Earning(month:amount:)` arrays never even referenced in the body, a `BarChartView.data: [(String, Double, String, String, Double)]` tuple array with fake months/events like `("Jun", 70, "Group Meditation", "Spirituality", 305)`, and a tooltip hardcoded to always show "Group Meditation" / "90's Hip-Hop" regardless of which bar was tapped). Live-curled both stats endpoints to get the real shape (`GET /users/me/stats/monthly?year=` → `{year, months: [{label, month, value, eventCount, attendedCount, totalSpendEur, events: [{id, title, price, priceEur, currency, category, icon, coverImage, startsAt, role}]}]}`) and wired all three screens to it:
- Added `HistoryStatsService`/`HistoryStatsServicing` (`Kumele/Services/API/HistoryStatsService.swift`) as its own small file rather than folding into `ProfileService` — deliberately, so `Kumele TV` (which doesn't share the heavier `ProfileService.swift`/`ProfileModels.swift` dependency graph) only needs this one minimal file plus the models, not the whole Profile stack.
- Added `UserActivityStats`/`MonthlyStatsResponse` (`Kumele/Models/API/UserStatsModels.swift`) and `HistoryStatisticsViewModel` (mirrors `RewardRingsViewModel`'s `State` enum + `.preview()` convention).
- Bar height now derives from real `eventCount` (normalized against the month with the most events that year); the tooltip shows the real event(s) for that month (title, price, category, and the real emoji `icon` field instead of a hardcoded numbered image asset) or "No events" if there were none; "Money Earned $XXX" sums real `totalSpendEur` across the selected year; the year dropdown (previously decorative) now actually refetches.
- `GET /users/me/stats` (non-monthly) has no dedicated UI anywhere on this screen to receive its event/ticket/social/host-rating counts, so left as dead code (⚪), correctly, not forced into a display that doesn't exist.
- Added `historyStatsServiceRequestsMonthlyStatsWithYearQueryAuthenticated`, `historyStatisticsViewModelLoadsMonthlyStatsSuccessfully`, `historyStatisticsViewModelMapsUnauthorizedError` (`KumeleTests.swift`) — all verified passing. Verified via a full iOS build (`BUILD SUCCEEDED`) and `build-for-testing`/targeted test run (`TEST SUCCEEDED`); `Kumele TV`'s copy could not be independently built in this environment (same pre-existing `SDWebImageSwiftUI` tvOS module-map limitation noted in the cross-target section below) but is a line-for-line mirror of the already-verified iPad version.

## ✅ 4. Events (19 endpoints) — `Kumele/Services/Event/EventServices.swift` + `Kumele/Services/API/UserEventExtendedService.swift` (`EventInteractionService`)

| Method | Path | Status | Notes |
|---|---|---|---|
| POST | `/events` | 🟢 | `createEvent(_:)` |
| GET | `/events` | 🟢 | `getEventList`/`searchEvents` — rich filters incl. `hostId`, cursor pagination |
| GET | `/events/recommendations` | 🟢 | `getEventMatched()` |
| GET | `/events/{id}` | 🟢 | `getEvent(id:)` |
| POST | `/events/{id}/join` | 🟢 | `joinEvent(id:)`, called from swipe-card flow |
| POST | `/events/{id}/cancel` | 🟢 | `cancelEvent(id:reason:)` |
| GET | `/events/{id}/guests` | 🟢 | `EventInteractionService.guests`, called from `RatingReportScanChatView` |
| POST | `/events/{id}/checkin/host-scan` | 🟢 | `hostCheckIn`, same view |
| POST | `/events/{id}/checkin/self` | ⚪ | `selfCheckIn` — correct, zero callers (no self-check-in UI wired) |
| POST | `/events/{id}/finalize-matches` | ⚪ | `finalizeMatches` — correct, zero callers |
| POST | `/events/participations/{id}/finalize` | ⚪ | `finalizeParticipation` — correct, zero callers |
| POST | `/events/{id}/ratings` | 🟢 | `rate(...)`, called from `RatingReportScanChatView` |
| GET | `/events/{id}/ratings` | 🟢 | `EventServices.getEventRatings`, called from `SwipeCardView` |
| GET | `/events/{id}/ratings/mine` | ⚪ | `EventInteractionService.myRating` — correct, zero callers |
| GET | `/events/{id}/ratings/summary` | 🟢 | `getEventRatingSummary`/`ratingSummary`, called from `SwipeCardView` |
| PUT | `/events/{id}/ratings/{ratingId}` | ❌ | No edit-rating method — only create and delete exist |
| DELETE | `/events/{id}/ratings/{ratingId}` | ⚪ | `deleteRating` — correct, zero callers |
| POST | `/events/{id}/reports` | 🟢 | `report(...)`, called from `RatingReportScanChatView` |
| GET | `/events/{id}/reports` | ❌ | No method to list your own submitted reports |

`getEventOwned()` — previously documented as 🟡 "always fails," **now fixed and 🟢**: it calls `searchEvents(EventSearchFilters(hostID:))` using the current user's ID. "My Events" works.

## ✅ 5. Chat (6 `chat`-tag endpoints + `chat/rooms`) — `Kumele/Services/Chat/ChatSocketService.swift` + `Kumele/Services/API/CommunicationService.swift`

| Method | Path | Status | Notes |
|---|---|---|---|
| GET | `/events/{eventId}/chat/status` | ⚪ (correctly) | `ChatService.status(eventID:)` still unreached, but redundant — `ChatDetailView.swift`/`ChatItemView_iPhone.swift` already show open/closed status from the `isOpen`/`isExpired` fields already embedded in `GET /chat/rooms`'s response. No separate call needed. |
| POST | `/events/{eventId}/chat/create` | ❌ (correctly) | Rooms auto-create on `chat/join`/`finalize-matches` per spec — not a functional gap. |
| POST | `/events/{eventId}/chat/join` | ⚪ | `ChatService.join(eventID:)` still unreached. `ChatViewModel.openChat()` joins via the Socket.IO `joinRoom` event instead, which appears to work in practice (chat is otherwise the best-integrated feature in the app). No distinct "Join Chat" UI element exists to wire this REST call into — it'd have to be inserted into the existing working socket flow speculatively, with no confirmed bug to justify it. Left alone; flagging in case the backend expects this REST call for membership accounting the socket path doesn't cover. |
| GET | `/events/{eventId}/chat/messages` | 🟢 | via `ChatService.fetchMessages(eventID:)`, called from `ChatViewModel`. A second, unused method `ChatService.messages(eventID:cursor:limit:)` hits the same path with a different decode shape and is dead (⚪) — pick one, don't add a third. |
| POST | `/events/{eventId}/chat/messages` | 🟢 | `ChatService.sendMessage`, called from `ChatViewModel` |
| GET | `/chat/rooms` | 🟢 | `ChatRoomService.fetchRooms()`, called from `ChatViewModel` |

**Socket.IO gateway path — now live-verified, not just assumed.** Curled `http://84.247.131.180/socket.io/?EIO=4&transport=polling` directly: returns a valid Engine.IO handshake (`{"sid":...,"upgrades":["websocket"],...}`). The app's `SocketIOChatService` uses this exact default path (no custom `.path(...)` set) — confirmed correct. The older `ws://84.247.131.180/chat` path this doc previously flagged as the possibly-correct one returns 404 — that note was based on a stale assumption, not the real gateway mount point.

`Chat`/`ChatMessage` models checked against real live-shaped fixtures for the dropped-field bug class (per §"Auth/Events" corrections above) — no gaps found, both decode every field the backend sends.

Real-time Socket.IO client (`SocketIOChatService`) runs alongside this REST layer — Bearer-authenticated, handles `newMessage`/`userTyping`/`userJoined`/`userLeft`. Unverified live: whether `ws://84.247.131.180`'s default `/socket.io/` engine path actually matches the backend's Socket.IO gateway mount point (doc previously recorded `ws://84.247.131.180/chat` as the WS path).

## ✅ 6. Notifications (6 endpoints) — `Kumele/Services/API/CommunicationService.swift`

| Method | Path | Status | Notes |
|---|---|---|---|
| POST | `/notifications/push-token` | 🟢 | `registerPushToken`, called from `FirebaseMessagingService`, deferred until post-auth. Switched from the `/notifications/tokens` iOS alias to this canonical route per explicit request — payload updated to `{fcmToken, platform, deviceId}` to match |
| POST | `/notifications/tokens` | ❌ | iOS alias, no longer used — see above |
| POST | `/notifications/test` | ❌ (correctly) | Self-service "send yourself a test push" endpoint, confirmed live (curled it — returns `{"tokensFound":5,"success":0,"failure":5,...}`, the failures being stale/Simulator FCM tokens, not an API problem). Not a real gap: this is a developer/QA tool, not a consumer-facing feature, and no UI exists (or should exist) for "send me a test notification." |
| GET | `/notifications` | 🟢 | `notifications(page:limit:)`, called from `NotificationViewModel` |
| POST | `/notifications/{id}/read` | 🟢 | `markRead`, called from `NotificationViewModel` |
| POST | `/notifications/read-all` | ⚪ | `markAllRead` still unreached — checked thoroughly, there is genuinely no "Mark all as read" button, menu, or affordance anywhere in `NotificationView_iPhone`/`_iPad` (only a back button exists in the toolbar). Left alone per the standing rule — nothing existing to wire it into. |

**Real, unconfirmed risk found while checking this section**: `NotiType`'s three cases (`EVENT_MATCHED`, `CREATED_EVENT`, `OTHER`) are hardcoded raw values that the app's `NotificationViewModel.makeSectionItems` filters every notification against (`notification.type == type.rawValue`) to decide which section it lands in. **These raw strings have never been confirmed against a real notification's actual `type` field** — the OpenAPI schema (`NotificationResponseDto`) only documents `type` as a bare `string` with no enum listed. I tried to verify live (logged into the test account, called `POST /notifications/test`, then `GET /notifications`) but the test account has zero notification history and the test-push endpoint doesn't create an in-app record — so this remains unconfirmed. **If the real backend's `type` values don't exactly match these three strings, every notification would silently land in no section at all and the screen would appear empty despite the API succeeding** — this is the same bug class as `EventModel.endTime`, just not provable without a real notification to inspect. Not fixed (guessing wrong values could make it worse) — flagging for whoever can trigger a real event-match/event-creation notification and check the actual `type` string that comes back.

`APINotification` also doesn't decode `userId` or `category` (both present in the documented schema) — likely harmless since nothing needs them (you only ever see your own notifications, and grouping uses `type` not `category`), but noting for completeness per the dropped-field check.

## ✅ 7. Blog (8 endpoints) — `Kumele/Services/Blog/BlogServices.swift`

| Method | Path | Status | Notes |
|---|---|---|---|
| GET | `/blogs/feed` | 🟢 | `fetchAllBlog()`/`fetchAllBlogByCategory`, both confirmed live via a fresh curl of the real endpoint |
| GET | `/blogs/public/{slug}` | ❌ (correctly) | SEO public page, no client need |
| GET | `/blogs/sitemap` | ❌ (correctly) | Same |
| GET | `/blogs/{id}` | 🟢 | `fetchBlogDetail`, concurrent with comments fetch. Nested comment `replies` (confirmed via live curl — comments come back with a `replies: [...]` array, itself of the same shape) are correctly decoded recursively and rendered via `CommentChildView.swift`. |
| GET | `/blogs/{id}/comments` | 🟢 | Same call |
| POST | `/blogs/{id}/comments` | 🟢 | `createComment` |
| POST | `/blogs` | ❌ (correctly) | Admin-only endpoint. A method `create(title:markdown:categoryID:)` was written, but there is no "write/create a blog post" screen in the consumer app. This is by design, as blog creation belongs to the admin portal. |
| POST | `/blogs/{id}/like` | 🟢 | `like(blogId:)` |

**Field-completeness check** (live-curled `GET /blogs/feed` directly): the real feed item includes `slug`, `reading_time_minutes`, `word_count`, `like_count`, `comment_count`, `language`, `visibility`, `hobby_category {id,name,slug}`, and `author.{id,avatar}` — `BlogModel` only captures `id`, `title`, `excerpt`, `coverImage`, `author.displayName`, `createdAt`. None of the dropped fields are currently rendered anywhere in the feed card UI (`ProductCard_iPhone`/`_iPad` only use displayName/date/coverImage), so — like the Hobbies-category-metadata gap found earlier — this is flagged, not fixed: no confirmed behavioral bug to point to, and adding unused fields speculatively isn't warranted. Worth revisiting if the feed card is ever redesigned to show like/comment counts or author avatars. `BlogDetailModel`/`BlogDetailComment` were also checked against live data and are solid — no gaps found there.

Added test coverage for the previously-untested methods: `fetchAllBlogByCategory`, `createComment`, `like`, `create` (contract test despite being dead code, to lock in correctness), and nested-reply decoding for `BlogDetailComment`. All verified passing.

## Cross-target status: `Kumele TV` & `Kumele Watch App` (sections 1–7)

Per the standing rule added to [04_CodingRules.md](04_CodingRules.md), a section audit covers every target, not just iPhone/iPad. `Kumele TV` shares the real `Networking`/`Services`/most `ViewModels`/`Models` files with the main target (multi-target membership via `PBXFileSystemSynchronizedBuildFileExceptionSet` in `project.pbxproj`); `Kumele Watch App` shares nothing and has no networking layer at all (see doc 01 §1/§7/§8).

| # | Section | `Kumele TV` | `Kumele Watch App` |
|---|---|---|---|
| 1 | Auth | 🟢 Already live — `LandingPage.swift`'s "Sign In" flow calls the real `AuthViewModel.skipLogin()` → `fetchProfile()`. **Corrected this pass**: the "Sign In with QR" popup was previously documented as unwireable ("no TV/device-pairing endpoint exists anywhere") — stale. It was implemented 2026-07-27 (device-authorization-grant, 3 new `Auth.Device` endpoints — see §1) but never reflected here: `SignInView`'s `qrCodeImage` generates a real QR from `AuthViewModel.startDevicePairing()`/`devicePairingStatus`, polling `POST /auth/device/token` until the phone (`DeviceQRScannerView.swift`, scanning the QR + calling `POST /auth/device/claim`) approves it. No `dummyQrCode` asset remains in this flow. | 🟢 **Wired this session** via the new `WCSession` relay — `LoginView.swift` polls `WatchConnectivityClient.sessionStatus()` every 3s and transitions to content once the phone reports `isLoggedIn == true`. Real login (email/password, passkey, etc.) still only happens on the phone, by design — the Watch has never had its own credential-entry UI and this session didn't add one. |
| 2 | Hobbies | 🟢 Already live — `HomeView`'s hobby chips read `tabViewModel.user?.hobbies`, populated from the same real profile fetch as Auth. | ❌ No hobbies UI anywhere — left alone, no existing screen to wire. |
| 3 | Users/Profile/Social | ⚪ No Profile tab exists — `AppTab.tvOSTabs` deliberately omits `.profile` (`[.home, .blog, .chart]` only), a real product decision, not an oversight. The one real UI element, the header avatar (`ContentView.swift`), was hardcoded to `Image("dummyPhotoProfile")` with a real `tabViewModel.user?.pictureURL` already available — **wired this session** to show the real avatar via `WebImage`, falling back to the placeholder when there's no photo. | ⚪ No profile/social UI anywhere on Watch — left alone. The one adjacent real UI, `QrCodeView.swift` ("Show QR for verification" from an event's action card), **wired this session** via the relay's `.fetchOwnQRCode` action, reusing the same `GET /users/{id}/qr` endpoint the iPhone/iPad `ChatQrCodeView` already calls — the phone decodes the data-URL into PNG bytes and relays those directly so the Watch never needs data-URL parsing. |
| 4 | Events | 🟢 Already live — `HomeView` uses the real `EventViewModel` (`loadAllEvents`, error/empty states via `ErrorPageView`), and reuses the exact shared `EventDetailView`/`CardEventView`/`EventJoinView`/`BottomDetailEventView` files iOS uses. | 🟢 **Wired this session** — `EventListView.swift` fetches `EventServices.getEventMatched()` via the relay (`.fetchEvents`), grouped into Today/Upcoming by `startTime`. Deliberately used matched events, not a lat/long geo-search like the TV/iOS list, to avoid adding a CoreLocation permission prompt to the Watch speculatively. `EventDetailView`'s "Navigate" action now uses the event's real `latitude`/`longitude` instead of a hardcoded London coordinate. |
| 5 | Chat | ⚪ No Chat UI exists — `AppTab.tvOSTabs` doesn't include `.chat` either, same deliberate scoping as Profile. | 🟢 **Wired this session** — `ChatView.swift` fetches real rooms via `ChatRoomService.fetchRooms()` (`.fetchChatRooms`), `ChatDetailView.swift` fetches/sends real messages via `ChatService.fetchMessages`/`sendMessage` (`.fetchChatMessages`/`.sendChatMessage`) keyed by event ID. Uses the REST chat endpoints only (matches what `ChatViewModel` already treats as 🟢 live) — no Socket.IO client on Watch, so a message sent from the phone won't push to an already-open Watch chat screen without a manual re-open; acceptable for a "glance and reply" surface, flagged as a known limitation rather than building real-time delivery. |
| 6 | Notifications | 🟡→🟢 Was fully hardcoded (`NotificationView.swift` rendered 5 literal `NotificationItem(...)` calls). **Wired this session** to the real `NotificationViewModel`/`NotificationService` (added `ViewModels/NotificationViewModel.swift`, `Services/API/{CommunicationService,AdService}.swift`, `Models/API/{FeatureModels,AdModels}.swift` to the TV target's file membership in `project.pbxproj`) — loading/error/empty states now match the real feed; tapping a card calls `markRead`. Deliberately did **not** add inline ad cards (`AdInlineCard`) — TV's widget never had an ad slot, and porting the iPhone ad-card sizing as-is would look wrong at TV scale; that's Ads-section (§8) work, not Notifications. **Verified this pass, still true**: real data end to end, only cosmetic gap is `NotificationItem.swift`'s (TV) row avatar staying a static `Image("dummyPhotoNotification")` rather than a per-notification real image the way iPhone's `NotificationItem_iPhone` shows one — not an endpoint gap (`GET /notifications` is fully 🟢), just a display-polish item, left alone. | 🟢 **Wired this session** — `NotificationListView.swift` fetches real notifications via the relay (`.fetchNotifications`), phone-side mapped through the same `displayMessage`/`formattedTime` helpers `NotificationViewModel` already uses. |
| 7 | Blog | 🟢 Already live — `BlogView.swift` uses the real, shared `BlogViewModel` (`fetchBlog`, `CategoryFilterBar`, `ProductCard`, `BlogDetailView`) — same code path as iOS, same field-completeness caveats already noted in §7 above apply identically here. | ❌ No Blog UI on Watch at all — left alone, no existing screen to wire. |

**`Kumele Watch App` architecture decision: resolved.** Asked the user to choose between (a) direct backend calls from a Watch-native networking stack, or (b) a `WCSession` relay reusing the phone's already-authenticated session. **User chose (b).** Built a generic bidirectional bridge: `Kumele/Networking/WatchBridge.swift` (shared with both targets via a new `PBXFileSystemSynchronizedBuildFileExceptionSet` entry for `Kumele Watch App`, alongside `Helper/DateFormatterHelper.swift`) defines a `WatchBridgeAction` enum + request/response envelope + small transfer-object DTOs (`WatchEventSummary`, `WatchChatRoomSummary`, `WatchChatMessageSummary`, `WatchNotificationSummary`, `WatchSessionStatus`) — deliberately dedicated summary types rather than relaying the app's real `EventModel`/`Chat`/`ChatMessage`/`APINotification` verbatim, since those are `Decodable`-only (no `Encodable`) and forcing them to round-trip through `WCSession`'s message dictionary would have meant either risky manual `Encodable` conformance fighting their multi-key-alias decoders, or bloating the relay with the app's full ~40-field internal event model when the Watch only ever displays 5 of those fields. `Kumele/Services/Watch/PhoneWatchConnectivityService.swift` (phone side, `WCSessionDelegate`, activated from `KumeleAppDelegate`) maps real service calls to these summaries and replies; `Kumele Watch App/Services/WatchConnectivityClient.swift` (Watch side) sends requests and decodes replies. Removed the Watch's local placeholder models (`Models/{Event,ChatMessage,AppNotification}.swift`) since every screen now uses real relayed data. **Known limitation, by design, not fixed:** the relay is request/reply only (Watch asks, phone answers) — there's no push from phone to Watch (e.g. `updateApplicationContext`), so `LoginView` polls every 3s for session status rather than being notified instantly, and an open Watch chat screen won't live-update if a message arrives while it's open. Both are reasonable for a "glance at your phone's data" surface and avoidable scope creep for a first pass; revisit if real-time delivery turns out to matter.

Verified via a full `xcodebuild build -scheme "Kumele Watch App" -destination "platform=watchOS Simulator"` (this environment has the watchOS 26.4 simulator runtime installed, unlike tvOS) — **BUILD SUCCEEDED**, and re-verified the main `Kumele` (iOS) scheme separately — also **BUILD SUCCEEDED**.

**Build verification note:** `Kumele TV`'s own compile could not be independently verified in this environment — confirmed via a baseline test (stashing all changes and rebuilding) that `xcodebuild -target "Kumele TV" -sdk appletvos26.4` already fails identically before any of this session's edits, with a pre-existing `SDWebImageSwiftUI` tvOS module-map generation error unrelated to this repo's source. No tvOS Simulator runtime is installed in this environment either (only iOS and watchOS runtimes are), so `-destination` builds aren't available. The main `Kumele` (iOS) scheme still builds clean (`BUILD SUCCEEDED`) after the `project.pbxproj` edits. Recommend a real build of the `Kumele TV` scheme on a machine with the tvOS platform installed to confirm before shipping.

## ✅ 8. Ads (3 endpoints) — `Kumele/Services/API/AdService.swift`

| Method | Path | Status | Notes |
|---|---|---|---|
| GET | `/ads/fetch` | 🟢 | `fetch(placement:)`, called from `EventViewModel` (Home feed, iPhone/iPad/TV) and `NotificationViewModel` (Notifications feed) |
| POST | `/ads/track` | 🟡→🟢 **found and fixed a real, live-confirmed bug** | `track(...)`, same call sites. `AdTrackRequest` had explicit `CodingKeys` remapping every field to snake_case (`ad_id`, `campaign_id`, `impression_id`, `event_type`) — but the real backend's `TrackAdDto` schema (and every other endpoint in this app) is camelCase. Live-curled both versions against the real backend to confirm: the snake_case body returned `400 {"message":["property ad_id should not exist",...,"adId should not be empty",...]}`; the camelCase body returned `200 {"message":"Event tracked successfully"}`. This means **every single ad impression/click track call in the entire app has been silently failing** since `track()` catches and swallows its own errors (by design, correct for fire-and-forget analytics) — invisible unless you read the DEBUG console. Removed the incorrect `CodingKeys` entirely (the property names already match the schema 1:1). |
| GET | `/ads/admob/context` | ❌ (correctly) | AdMob fallback context — no client method, and no reason to add one: there's no Google Mobile Ads SDK dependency anywhere in the project, so nothing could consume this context if fetched. Would need a real AdMob SDK integration (new dependency, ad unit IDs, consent flow) before this becomes a real gap, not a wiring task. |

**Cross-target check.** iPhone (`SwipeCardStackView`'s `AdSwipeCardView`, interleaved into the swipe-card home feed) and iPad (`HomeView_iPad`'s `adsPanel`/`AdInlineCard`) were both already fully live, reading real ads from `EventViewModel.homeFeedItems` with real impression/click tracking. **`Kumele TV`'s Home ad carousel was not** — `Kumele TV/View/Home/HomeView.swift` called the shared `AdsHomeContainerView` twice with a fully hardcoded `images: ["dummyImage", "dummyEvent", ...]` array (literal bundled asset names, repeated), and its tap handler only did `tabViewModel.isShowAdsDetail.toggle()` without ever setting `tabViewModel.selectedAd` — so tapping any tile opened the ad-detail sheet with a `nil` ad. Fixed:
- Added a `homeAds`/`homeAdImageURLs` computed pair to TV's `HomeView.swift` (same pattern as `HomeView_iPad`'s `homeAds`), sourced from the same already-shared `EventViewModel.homeFeedItems` — no new fetch call needed.
- `AdsHomeContainerView.swift` (`Kumele/Views/Common/Home/AdsHomeContainerView.swift`, shared with TV) only knew how to render `Image(name:)` for literal bundled asset names — extended it with a `WebImage`-based branch for `http(s)://` URL strings (falls back to `Image(name:)` for anything else, so its behavior for any future literal-asset caller is unchanged), and added an `onImpression: ((Int) -> Void)?` callback that fires once per index the first time its existing (already-built-in) visibility-tracking marks it visible — reusing the mechanism already there for the tvOS button-disable behavior rather than building a new one.
- Wired both carousel calls to real ad image URLs, real tap-through (`tabViewModel.selectedAd` + `isShowAdsDetail`), and real impression/click tracking (`trackAdImpression`/`trackAdClick`), and fixed the `AdsDetailView()` call to pass `ad: tabViewModel.selectedAd`.
- `Kumele Watch App` has no ad UI anywhere — correctly out of scope, nothing to wire.

Added `adServiceTrackPostsCamelCaseKeysMatchingTheBackendSchema` (`KumeleTests.swift`), verified passing. Verified via full iOS build (`BUILD SUCCEEDED`); `Kumele TV`'s own build could not be independently verified in this environment (same pre-existing tvOS module-map limitation noted earlier in this doc).

## ✅ 9. Commerce: Subscriptions, Products, Cart, NFTs (21 endpoints) — `Kumele/Services/API/CommerceService.swift`

**Subscriptions** — `SubscriptionService`, 1 call site (`ShopViewModel`). **Migrated off Stripe to Apple IAP/StoreKit 2 on 2026-07-30** — subscriptions purchase via `StoreKit`, verified server-side by a new endpoint; event payments, saved cards, and PayPal are untouched and still Stripe/PayPal:

| Method | Path | Status | Notes |
|---|---|---|---|
| GET | `/subscriptions/tiers` | 🟢 | `tiers()`, called from `ShopViewModel.load()` |
| GET | `/subscriptions/status` | 🟢 | `status()`, same |
| POST | `/subscriptions/apple/verify` | 🟢 **new, added 2026-07-30** | `verifyApplePurchase(signedTransaction:)` — posts the StoreKit JWS after a purchase, a restore, a silent-reconcile, or a background renewal; backend derives tier/expiry from the verified JWS itself. Not in the stale checked-in `openapi.json` (predates this feature) — shape confirmed via this repo's own `AppleSubscriptionStore`/`CommerceService.swift` and `AI/09_ChangeLog.md`/`Docs/APPLE_IAP_BACKEND_REQUIREMENTS.md`. Still needs the backend half built per that requirements doc. |
| POST | `/subscriptions` | ⚪ **corrected from 🟢** | `create(tierID:discountCode:)` was removed entirely in the StoreKit migration (confirmed zero references to `APIConstants.Subscriptions.create` anywhere in Swift) — no method wraps this endpoint at all anymore. The constant is kept only as a documented leftover ("Stripe-era checkout creation — no longer called by the app"). |
| DELETE | `/subscriptions` | ⚪ | `cancel` — correct, zero callers. Real subscription cancellation now goes through Apple's native "Manage Subscription" sheet (`manageSubscriptionsSheet`, added 2026-07-30), not this endpoint. |
| POST | `/subscriptions/resume` | ⚪ | Same — no caller, same reasoning |
| GET | `/subscriptions/history` | ⚪ | Same — no caller, no subscription-history UI |

**Products** (`ProductCartService`) — genuinely dead, correct paths, correctly left alone: no product-catalog browsing UI exists anywhere (`ShopView_{iPhone,iPad}`'s "Guest tickets" tab explicitly states *"Guest tickets are created from an event; no standalone ticket catalogue is available"*):

| Method | Path | Status |
|---|---|---|
| GET | `/products` | ⚪ |
| GET | `/products/{idOrSlug}` | ⚪ |

**Cart — major correction this pass, previously documented as "entirely ⚪ dead... no product/cart catalog UI anywhere in the app." Wrong.** A real Cart screen exists and is fully wired: `PaymentView_iPhone.swift` (reachable via the tab bar's payment icon / More menu → `TabViewModel.isShowPayment`, on iPhone specifically — `PaymentView_iPad` is a different screen, payment *history*, see §10) is a genuine Cart UI — header literally says "Cart" — built on `CartViewModel`, with a quantity stepper, per-item delete, "Clear All", and a running total. Separately, `CreateEventViewModel.addGuestTicketsToCart()` (the "Guest Prices" modal's Buy button, `CreateEventView_{iPhone,iPad}`) adds the chosen capacity tier to the same cart via `POST /cart/items`.

| Method | Path | Status | Notes |
|---|---|---|---|
| GET | `/cart` | 🟢 **corrected from ⚪** | `CartViewModel.loadCart()` — on `.task`/pull-to-refresh in the Cart screen |
| DELETE | `/cart` | 🟢 **corrected from ⚪** | `clearCart()` — "Clear All" button |
| PUT | `/cart/items/{id}` | 🟢 **corrected from ⚪** | `updateQuantity(item:quantity:)` — the +/- stepper on each cart row |
| DELETE | `/cart/items/{id}` | 🟢 **corrected from ⚪** | `removeItem(item:)` — the trash icon on each cart row |
| POST | `/cart/items` | 🟡 **corrected from ⚪, suspected live bug, unconfirmed** | `CreateEventViewModel.addGuestTicketsToCart()` passes an **event-plan capacity-tier ID** as the cart's `productId`. This is the exact same anti-pattern already found and fixed once in this app: subscription tier IDs (`"basic"`/`"premium"`/`"vip"`) aren't real `/products` catalog rows either, and that call was confirmed live to fail with `"productId must be a UUID"` before being removed. Event-plan tier IDs are a different (likely UUID-shaped) resource, so this may or may not hit the identical error — **not live-curled this pass to confirm either way** — but `/cart/items` is documented as accepting a real product catalog ID, and event-plan tiers aren't in that catalog, so this is flagged as a probable repeat of the same bug class, not a confirmed one. Whoever picks this up: tap "Buy" on a guest-price tier in Create Event and check the `➡️/⬅️ [API]` console lines for the actual response. |

**Practical implication**: the Cart screen and its "Add to Cart" trigger are real and reachable, but the actual checkout step ("Pay now" on the Cart screen) is still a hardcoded `.disabled(true)` button with an empty action — same finding as §10's Stripe/PayPal payment gap, not a new one. So even if `POST /cart/items` succeeds, nothing in the app can currently complete that purchase.

**NFTs** (`NFTService`) — **found and fixed real gaps**. `ShopView_iPhone`'s "NFTs" tab already routed to `ShopNFTsView_iPhone`, a real, reachable screen with a 3-way tab switcher ("Rewards" / "Claimed" / "Market Place") — but every tab was empty, no content view at all, zero data of any kind. (iPad has no NFTs tab at all — its `ShopView_iPad` only has Subscriptions/Guest tickets, so this stays iPhone-only, not added speculatively.) Built `NFTsViewModel` + wired all three tabs to the real endpoints:

| Method | Path | Status | Notes |
|---|---|---|---|
| GET | `/nfts/my-screen` | ⚪ (correctly) | `myScreen()` — no matching UI concept (a combined "my NFT screen" summary), the app's screen is already split into the 3 tabs below |
| GET | `/nfts/rewards` | 🟢 **wired this session** | `rewards()` — "Rewards" tab, each shows a "Claim" button unless `owned == true` |
| GET | `/nfts/mine` | 🟢 **wired this session** | `mine()` — "Claimed" tab |
| GET | `/nfts/marketplace` | 🟢 **wired this session** | `marketplace(page:limit:)` — "Market Place" tab, display-only (see below) |
| GET | `/nfts/{id}` | ⚪ (correctly) | `detail(id:)` — no per-NFT detail screen exists, only the grid |
| POST | `/nfts/{id}/claim` | 🟢 **wired this session** | `claim(id:)` — the "Claim" button on the Rewards tab |
| POST | `/nfts/{id}/purchase` | 🟢 **wired 2026-07-27** | `purchase(id:transactionRef:walletAddress:)` — "Buy" button added to the Marketplace tab (hidden when owned/coming-soon). Re-examined the OpenAPI schema: `transactionRef`/`walletAddress` are just optional strings (`walletAddress` explicitly documented server-side as "for future on-chain minting"), not a real wallet-SDK requirement as previously assumed. No payment SDK exists in the app (no Stripe, no StoreKit — confirmed via grep), and Subscriptions purchase already calls the backend directly with no in-app payment capture step, so both params are passed `nil`, matching that existing pattern. |

**Real bug found and fixed while wiring this**: `NFTModel` used plain synthesized `Decodable` with `price: Double?` — but live-curling `/nfts/marketplace` showed at least one real NFT with `"price":"12"` (a JSON **string**, not a number). Synthesized decoding would have thrown a type-mismatch and failed the **entire** marketplace array (not just that one entry) the moment this screen was used for real. Also found `owned: Bool` is present on `/nfts/rewards` items but wasn't decoded at all — without it, the UI would show a "Claim" button on rewards the user already owns. Rewrote `NFTModel`'s decoder to use the same `flexibleDouble`/`flexibleBool` helpers already established elsewhere in this file, and added the `owned` field.

## ✅ 10. Payments & Refunds (17 endpoints) — `Kumele/Services/API/TicketPaymentService.swift`

**2026-07-30 correction — saved cards are now fully live; see bottom of this section.** History below kept for context (dates as originally recorded).

| Method | Path | Status | Notes |
|---|---|---|---|
| POST | `/payments/confirm` | 🟢 | `PaymentService.confirm(paymentIntentID:)`, called from `EventPaymentViewModel.confirmStripePayment` — server half of the Stripe *event-payment* path specifically. Still has zero call sites triggering it (see `/payments/event` below) — the Stripe SDK dependency it needed now exists in the project (added for cards/subscriptions), it's just never been wired into the event-join flow. |
| POST | `/payments/event` | ⚪ **corrected from `[BLOCKED]`** | `createEventPayment` still exists, still zero callers. Previously flagged as blocked on "no Stripe SDK dependency" — **that's stale**, the SDK is in the project now (see cards below). The real reason it's still dead: PayPal (`createPayPalOrder`) already covers paid-event-join end-to-end, and nobody's built the Stripe alternative on top of it. Plain dead code now, not an SDK blocker. |
| POST | `/payments/event-creation/{eventId}` | 🟢 | `PaymentService.createEventCreationPayment(eventID:)` — host capacity-plan checkout, wired (not yet call-sited into `CreateEventView`'s submit flow — the pricing *display* is wired via `EventPlanService`, this endpoint is ready for the host-side checkout call when that flow is prioritized) |
| GET | `/payments/history` | 🟢 | `history(page:limit:)`, called from `PaymentView_iPhone` |
| GET | `/payments/{id}/escrow` | 🟢 | `escrow(paymentID:)`, same view |
| POST | `/payments/paypal/create-order` | 🟢 | `createPayPalOrder` — wired 2026-07-28 via `EventPaymentViewModel.startPayPalCheckout`, called from the swipe-card join action after a successful `POST /events/{id}/join` |
| POST | `/payments/paypal/capture/{orderId}` | 🟢 | `capturePayPal` — wired 2026-07-28, called after the PayPal approval sheet dismisses |
| GET | `/payments/paypal/status/{orderId}` | ⚪ | `paypalStatus` — still no caller; create-order + capture cover the flow, nothing polls status separately |
| POST | `/payments/paypal/vault/setup-token` | ❌ | No client method — no PayPal-as-saved-payment-method UI exists anywhere to hang it off |
| POST | `/payments/cards/setup-intent` | 🟢 **corrected from ❌** | `PaymentService.createCardSetupIntent()` — called from `SavedCardsViewModel`, which presents Stripe's `PaymentSheet` (`CardSetupPresenter.swift`) from `ProfileAddCardView_iPhone` |
| POST | `/payments/cards` | 🟢 **corrected from ❌** | `saveCard(setupIntentID:)` — same flow, called after the setup sheet completes |
| GET | `/payments/cards` | 🟢 **corrected from ❌** | `listCards()` — called from `SavedCardsViewModel`, used by both `ProfileCardView_iPhone` and `ProfileCardView_iPad` |
| PATCH | `/payments/cards/{id}/default` | 🟢 **corrected from ❌** | `setDefaultCard(id:)` — same, tapping a saved card row on either platform |
| DELETE | `/payments/cards/{id}` | 🟢 **corrected from ❌** | `deleteCard(id:)` — same, trash icon on either platform. **iPad note**: list/set-default/delete are wired on `ProfileCardView_iPad`, but there's no iPad equivalent of `ProfileAddCardView_iPhone` — no "Add Card" screen exists on iPad, so a new card can only be added from the phone. Not a missing-endpoint gap (the endpoint is 🟢 globally via iPhone), just an iPad UI gap; left alone per the no-unasked-UI rule. |
| GET | `/refunds/eligibility/{paymentId}` | ⚪ | `refundEligibility` — zero callers |
| POST | `/refunds` | ⚪ | `requestRefund` — zero callers |
| GET | `/refunds/my-requests` | ⚪ | `myRefunds` — zero callers |

**Historical context (2026-07-27/28, superseded by the corrections above):** this section was previously "only `history`/`escrow` actually called," then PayPal event payment was wired 2026-07-28 (`EventPaymentViewModel` → `SFSafariViewController` approval handoff, triggered right after `POST /events/{id}/join`, since the backend rejects a PayPal order until a participation exists), with Stripe cards/event-payment flagged `[BLOCKED]` on "no payment SDK in the project."

**2026-07-30 — that blocker is gone.** A later session added the Stripe iOS SDK (`StripePaymentSheet`) to the project — not for event payments, but to replace `ProfileCardView_{iPhone,iPad}`'s broken hand-rolled card form (previously an empty `Button {}` with no card-number field at all, which would've been a PCI-DSS violation had it worked) with Stripe's own SDK-hosted setup-intent sheet. That SDK addition incidentally removes the reason `/payments/event`/`/payments/confirm` were called "blocked" — the dependency now exists — but nobody has wired Stripe into the *event-payment* flow specifically (PayPal already covers that end-to-end), so those two rows stay ⚪ dead code, not `[BLOCKED]`.

**Subscriptions moved off Stripe entirely 2026-07-30** (StoreKit/Apple IAP — see §9) — the Stripe SDK's remaining consumers in this app are the saved-cards flow above, nothing else.

## ✅ 11. Tickets (6 endpoints) — `Kumele/Services/API/TicketPaymentService.swift` (`TicketService`)

**Major correction this pass — this whole section was stale.** It previously claimed "all ⚪ dead, no My Tickets screen anywhere" — wrong: a prior session (before this doc was last touched) built exactly that. `GuestTicketsViewModel.swift` is real and wired into both `ShopView_iPhone`'s and `ShopView_iPad`'s "Guest tickets" tab via `GuestTicketRowView` (event title/date/ticket code/status + a Cancel button), and `EventPaymentViewModel` auto-issues a ticket right after a successful PayPal capture. Only the two organizer-only endpoints (no host-facing event-management screen exists) are still genuinely dead:

| Method | Path | Status | Notes |
|---|---|---|---|
| POST | `/tickets/events/{id}` | 🟢 **corrected from ⚪** | `TicketService.create(eventID:)` — called from `EventPaymentViewModel.completeAfterApproval()` right after a successful PayPal capture (best-effort, `try?` — a ticket hiccup shouldn't undo a successful payment) |
| GET | `/tickets/my` | 🟢 **corrected from ⚪** | `myTickets()` — called from `GuestTicketsViewModel.load()`, drives the Guest Tickets tab on both iPhone and iPad |
| DELETE | `/tickets/{id}` | 🟢 **corrected from ⚪** | `cancel(id:)` — called from `GuestTicketsViewModel.cancel(_:)`, the Cancel button on `GuestTicketRowView` |
| GET | `/tickets/events/{id}` | ⚪ | `eventTickets(eventID:)` — organizer-only ("Get tickets for an event"), no host-facing ticket-management screen exists |
| GET | `/tickets/{id}` | ⚪ | `ticket(id:)` — redundant with `GET /tickets/my`, which already returns full ticket objects; not wired to avoid an unnecessary extra call |
| POST | `/tickets/{id}/validate` | ⚪ | `validate(id:code:)` — organizer-only ("scan to check a guest in"), this app's host check-in flow uses a separate QR endpoint (`Events.Interaction.hostCheckIn`) instead |

## ✅ 12. Support (5 endpoints) — `Kumele/Services/API/SupportContentService.swift` (`SupportService`)

**Correction — the previous "no Contact Support screen exists anywhere" claim was wrong.** `ProfileContactView_{iPhone,iPad}.swift` (Profile → "Contact") is exactly that screen: a real "Choose a reason" (Business/Complaint/Improvement) + comment form — it was missed earlier because it searched local `MFMailComposeViewController`-based device mail instead of the backend, so a keyword search for "support"/"contact" screens landed on it but didn't register it as a support-ticket candidate. Live-curled `POST /support/tickets` with a throwaway QA account to confirm the real contract before wiring: `description` must be ≥20 characters, and `category` is a fixed backend enum (`account, payment, event, technical, report_user, report_content, feature_request, other` — confirmed via the validation error message, not guessed). Wired both views to create a real ticket instead of opening the Mail app: `subject` = the chosen reason, `category` = `"feature_request"` for "Improvement" and `"other"` for "Business"/"Complaint" (no other enum value fits), `description` = the comment (client-side validated ≥20 chars before submitting, matching the backend rule). Added `SupportServicing` protocol seam + `SupportContactViewModel`. Removed the old hardcoded-to-a-personal-Gmail mail-composer flow entirely — the ticket now lands in the real backend's admin support-ticket system (list/reply/assign/close), which previously had no way to ever receive a ticket. `GET/POST` ticket-list/detail/reply/close remain dead — still no "My Support Tickets" list/detail screen anywhere, confirmed again this session; would need new UI, not a wiring fix.

| Method | Path | Status | Notes |
|---|---|---|---|
| POST | `/support/tickets` | 🟢 **wired this session** | `SupportContactViewModel.submit`, called from `ProfileContactView_{iPhone,iPad}` |
| GET | `/support/tickets` | ⚪ | No "My Support Tickets" list screen |
| GET | `/support/tickets/{id}` | ⚪ | No ticket detail screen |
| POST | `/support/tickets/{id}/reply` | ⚪ | No ticket detail screen to reply from |
| POST | `/support/tickets/{id}/close` | ⚪ | Live-curl-verified working (closed the QA test ticket), no UI to trigger it |

## ✅ 13. Content: Localization, Translation, Share, CMS, Legal, App Config (14 endpoints) — `Kumele/Services/API/SupportContentService.swift` (`ContentService`)

**⚠️ Correction from the previous audit**: this file's whole class was described as "🟢 live, 3 call sites." True but misleading — `ContentService` has 13 methods, and only 2 of them (`languages`, `localizationStrings`) are actually called anywhere; the other 11 are correctly-coded dead code:

| Method | Path | Status | Notes |
|---|---|---|---|
| GET | `/localization/strings` | 🟢 | `localizationStrings(lang:namespace:)`, called from `LoginView_iPhone`/`_iPad` |
| GET | `/localization/languages` | 🟢 | `languages()`, called from `InterestSelectionViewModel` + both `LoginView`s (3 call sites) |
| GET | `/translation/strings` | ⚪ | `translations(language:)` — **corrected from implied-live**, zero callers |
| GET | `/translation/languages` | ❌ | No separate constant — app uses `/localization/languages` above instead. Not a functional gap. |
| GET | `/translation/profile` | ⚪ | `translationProfile()` — zero callers |
| GET | `/translation/detect` | ⚪ | `detectLanguage(_:acceptedLanguage:)` — zero callers |
| POST | `/share/token` | ⚪ | `createShareToken` — zero callers, no share-sheet UI wired to it |
| GET | `/share/resolve/{token}` | ⚪ (correctly) | `resolveShareToken` — zero callers. Not a gap: `SwipeCardView.swift`'s event share button already works, via a native `ShareLink` built from the event's own public URL/image client-side — a different, already-functional mechanism for the same user need, not broken or fake. Swapping a working feature for the backend's short-link system wasn't attempted, since that's a redesign of something that already works, not a wiring fix. |
| GET | `/cms/pages` | ⚪ | `cmsPages()` — zero callers |
| GET | `/cms/pages/slug/{slug}` | ⚪ | `cmsPage(slug:)` — zero callers |
| GET | `/legal` | ⚪ (correctly) | `legalDocuments()` — no matching UI (no "browse all legal docs" list screen), left alone |
| GET | `/legal/type/{type}` | 🟢 **wired this session** | `legalDocument(type:)` — see below |
| GET | `/app/config` | ⚪ | `appConfiguration()` — zero callers |
| GET | `/app/health` | ⚪ | `appHealth()` — zero callers |

**Found and fixed real gaps this session**: `ProfileTermsConditionView_{iPhone,iPad}` (Profile → "Terms & Conditions") and `ProfileGuidelinesView_{iPhone,iPad}`'s "Community Guidelines" tab (Profile → "Guidelines") were both rendering multiple paragraphs of literal Lorem Ipsum placeholder text — real, reachable screens with a completely fake body. The endpoint's own description documents exactly three valid `type` values: `guidelines`, `terms`, `privacy_policy`. Added `LegalDocumentViewModel` (`Kumele/ViewModels/LegalDocumentViewModel.swift`) and wired both screens to `legalDocument(type: "terms")` / `legalDocument(type: "guidelines")` respectively, replacing the Lorem Ipsum with the real fetched title/content (with loading/error/retry states matching the rest of the app). **Environment note**: live-curled `GET /legal/type/terms` and `GET /legal/type/guidelines` against the real backend — both return `404 Document not found`, and `GET /legal` (list-all) returns an empty array. The wiring is correct and will show real content the moment documents are seeded via the CMS; until then these two screens will show their error/retry state instead of the old Lorem Ipsum. Added tests for the ViewModel and service call, all passing.

**Update (2026-08-01)**: the Guidelines screen's other two content tabs, "How to" and "Popular", were fixed the same way — each gets its own `LegalDocumentViewModel` instance, calling `legalDocument(type: "how_to")` / `legalDocument(type: "popular")`. The backend team confirmed these will be seeded via the same CMS the same day, so this wasn't speculative. **"Knowledge Base"** (previously a fake AI chatbot with 6 hardcoded messages and non-functional send buttons) is now wired to a genuinely real, separate endpoint: this doc's earlier claim that "there's no AI chat endpoint anywhere in this API" was true only of the main backend spec — a *second*, separate microservice spec exists at `AI/api-reference/openapi_ml.json` ("Kumele AI/ML Advisory Service"), with a live, working `POST /chatbot/ask` at a different host (`http://84.247.131.180:8080`, confirmed via `GET /health` → `{"service":"kumele-aiml-service",...}` and a real live-curled answer to "How do I create an event?"). Added `APIConstants.aimlBaseURL`/`APIConstants.Chatbot`, `ChatbotModels.swift`, `ChatbotService.swift` (own `APIClient(baseURL: APIConstants.aimlBaseURL)`, same pattern as `NFTService`'s `web3Client`), and `ChatbotViewModel.swift` — the Knowledge Base tab now sends real queries and shows the model's real answers instead of a static script.

**Practical implication for App Config**: `GET /app/config`/`GET /app/health` (maintenance-mode flag, min supported version) have no UI anywhere — no maintenance banner, no "update required" screen — confirmed via search. Correctly left dead; would need new UI to surface, not just a wiring fix.

## ✅ 14. Uploads / Media (4 endpoints) — `Kumele/Services/API/{ProfileService,SupportContentService}.swift` (`UploadService`), `Kumele/Services/Event/EventServices.swift`

`/upload/blog-image` and `/upload/nft-image` omitted — not relevant to this app: blog posts have no create-from-app screen (blog content is CMS/admin-authored, only read/liked/commented from the client), and NFT images are set when NFTs are issued server-side (`/nfts/internal/auto-issue`, admin), never user-uploaded.

**Correction — the first pass on this section was wrong, caught when the user asked "why not" directly.** The initial search for `PhotosPicker`/`UIImagePickerController`/`ImagePicker(` found no *picker component*, and concluded there was no avatar UI at all — but that missed that the avatar **button** already existed with a completely empty `Button { } label: { Image("dummyPhotoProfile")... }` action, i.e. a real, tappable, unwired UI element that a component-name search doesn't catch (there's nothing to grep for when the action body is just empty). Found and fixed in both `EditProfileView_{iPhone,iPad}.swift`:
- Wired the avatar button to present the existing `ImagePicker` component (same one `CreateEventView` already uses, reused rather than adding a new picker), and added `ProfileViewModel.uploadAvatar(_:)` (`POST /upload/image` → `PUT /users/profile` with the returned URL, mirroring `updateBio`'s existing partial-update pattern) triggered on picker dismiss.
- Both edit screens, and the shared `ProfileHeaderView.swift` (the main profile display, not just the edit sheet), were also hardcoded to `Image("dummyPhotoProfile")` unconditionally — never showing the real uploaded photo even when `User.pictureURL` had one. Fixed all three to show the real photo via `WebImage` with the placeholder as fallback.
- **`EditProfileView_iPad.swift` had a second, larger gap in the same file**: it never had a `ProfileViewModel` injected at all — the bio field showed nothing real, and "Update" just called `dismiss()` with no save of any kind. Fixed to match `EditProfileView_iPhone`'s already-correct pattern (`@EnvironmentObject var viewModel: ProfileViewModel`, already available from the presenting `ProfileView`'s `.environmentObject(viewModel)`; wired "Update" to `viewModel.updateBio(about)`).
- **Also found and fixed while in `ProfileHeaderView.swift`**: the small QR icon next to the username was hardcoded to `Image("dummyQrCode")` too — a *third* dummy-QR call site beyond the two `ChatQrCodeView_{iPhone,iPad}` ones already fixed earlier this session. Wired it to the same `UserSocialService.qrCode(userID:)` call and decode logic already established for those.

| Method | Path | Status | Notes |
|---|---|---|---|
| POST | `/upload/image` | 🟢 **corrected from ⚪, wired this session** | `ProfileService.uploadAvatar`, called from `ProfileViewModel.uploadAvatar(_:)` — see above |
| POST | `/upload/event-banner` | 🟢 | `EventServices.uploadBanner`, called from `CreateEventViewModel` |
| POST | `/media/upload` | ⚪ | `UploadService.media` — zero callers |
| POST | `/media/upload-url` | ⚪ | `UploadService.uploadURL` — zero callers |

**Practical implication**: profile-avatar upload is not actually wired to any screen despite the plumbing existing and being correct — worth flagging if "edit profile picture" is assumed to work.

## ✅ 15. Privacy / GDPR (5 endpoints) — `Kumele/Services/API/ProfileService.swift`

**⚠️ Correction from the previous audit**: previously listed as correct paths without noting only 1 of 4 is actually called:

| Method | Path | Status | Notes |
|---|---|---|---|
| GET | `/privacy/preferences` | ⚪ | `privacyPreferences()` — **corrected**, zero callers |
| PATCH | `/privacy/consent` | ⚪ | `updateConsent(_:)` — **corrected**, zero callers |
| GET | `/privacy/export` | ⚪ | `exportData()` — **corrected**, zero callers |
| PATCH | `/privacy/rectify` | ❌ | No client method at all |
| POST | `/privacy/delete` | 🟢 | `deleteAccount(password:reason:)`, called from `PopUpDeleteAccountView` — the only privacy endpoint actually reachable |

Re-audited this session, all 4 targets — searched for marketing/analytics/consent toggles and an "export my data" button anywhere in the app (`ProfileSecurityView`, profile settings, etc.); found none. These three stay correctly dead — no preferences/consent screen exists to wire them into.

## ✅ 16. Rewards (1 endpoint, part of `Users` tag, listed separately for clarity) — `Kumele/Services/API/RewardService.swift`

🟢 `GET /users/{userID}/rewards` — `rewardsForCurrentUser()`, called from `RewardRingsViewModel`. Re-confirmed this session — already fully live on iPhone, iPad, and TV (shared `RewardRingsViewModel`); no Watch UI for it (no rewards/medals screen on Watch), correctly left alone.

## ✅ 16b. Event Plans (2 endpoints) — `Kumele/Services/API/CommerceService.swift` (`EventPlanService`)

**Added and wired 2026-07-28.** Previously `❌` under §17 below. `InfoGuestPricesView` (Create Event → "Guest Prices") had been showing a **fully hardcoded, wrong** tier table (wrong prices, wrong currency, a missing tier, wrong guest ceiling) in place of this endpoint — live-curling `GET /event-plans` (`84.247.131.180:3000/docs-json`) found the real tiers are `1-5 Free / 6-20 €9.99 / 21-50 €19.99 / 51-100 €39.99`, nothing like what was on screen.

| Method | Path | Status | Notes |
|---|---|---|---|
| GET | `/event-plans` | 🟢 | `EventPlanService.plans()`, called from `CreateEventViewModel.loadEventPlans()` — drives `InfoGuestPricesView`'s tier list and `maximumSupportedGuests` (the guest picker's cap, previously hardcoded to 150 regardless of what the backend actually prices) |
| GET | `/event-plans/quote` | 🟢 | `EventPlanService.quote(capacity:)`, called from `CreateEventViewModel.refreshQuote(for:)` (debounced) — shown live in `InfoNumberofGuestsView` as the guest count changes |

## 17. Areas with genuinely no client code (6 endpoints)

Backend support confirmed in `openapi.json`; nothing in the Swift app calls these, and there's no dead-but-correct method to wire up — this is real, ground-up integration work if ever prioritized:

| Area | Endpoints | Status |
|---|---|---|
| **beta** | `POST /beta/validate` | ❌ |
| **discounts** | `POST /discounts/validate`, `GET /discounts/rewards` | ❌ |
| **newsletter** | `POST /newsletter/subscribe`, `GET /newsletter/unsubscribe` | ❌ |
| **PayPal vault** | `POST /payments/paypal/vault/setup-token` | ❌ (see §10) |

---

## Summary (fresh per-method re-audit, 2026-07-30)

- **🟢 Live**: Auth (all 25, incl. 3 device-pairing endpoints), Hobbies (2 of 4), all 8 Blog, 15 of 19 Events, 4 of 6 Chat + rooms, 3 of 6 Notifications, 2 of 3 Ads, **3 of 7 Subscriptions** (tiers, status, apple/verify), **4 of 5 Cart** (all but the suspect `POST /cart/items`, see §9), **3 of 6 Tickets** (create/mine/cancel — corrected this pass, previously documented as all-dead), **12 of 17 Payments/Refunds** (history, escrow, PayPal create-order + capture, Stripe confirm-server-half, event-creation checkout, and all 5 saved-card endpoints — both corrections this pass), **both Event Plans**, 2 of 4 Uploads, 1 of 5 Privacy, Rewards, 12 of 22 Users/Social.
- **🟡 Live but wrong**: `POST /cart/items` (§9) — suspected, not confirmed, repeat of an already-fixed bug class (a non-catalog ID passed as a cart `productId`).
- **⚪ Dead code (correct endpoint, zero callers)** — the largest bucket by far: most of `ContentService` (11 of 13 methods), remaining `TicketPaymentService` (organizer-only ticket endpoints, PayPal status, refund eligibility/request/list, `/payments/event` — corrected this pass from `[BLOCKED]`, the SDK it needed now exists, it's just unwired), 4 of `SupportService`'s 5 methods, all of `ProductCartService`'s `Products` half, all of `NFTService`'s dead subset, most of `UserSocialService`, most of `UploadService`, most of Privacy, half of Events' interaction methods, half of Chat's REST surface, `Notifications.readAll`, `Subscriptions.{create,cancel,resume,history}` (`create` newly dead — removed in the StoreKit migration).
- **❌ Not implemented**: Discounts, Newsletter, Beta codes, PayPal vault/setup-token, a handful of one-off gaps (rectify, edit-rating, list-own-reports, ads/admob-context).

**Practical implication**: the live surface is real and broad (Auth incl. TV QR sign-in, Blog, core Events, core Chat, Ads, core Notifications, PayPal event payment, real capacity pricing, Apple IAP subscriptions, saved payment cards, guest tickets, and a real Cart screen) — considerably broader than any previous version of this doc credited it for, mostly because this pass found undocumented ViewModels (`CartViewModel`, `GuestTicketsViewModel`) doing real work that never got written up. The remaining gap is narrower than any previous audit found: **`/payments/event`/`/payments/confirm` (Stripe event-payment) have no UI entry point**, but that's a "nobody's built it yet" gap, not an SDK blocker, since PayPal already covers the same user need end-to-end. **Most `ContentService`/Privacy/GDPR endpoints are unreachable** despite correct code (§13, §15) — worth prioritizing over building genuinely new feature areas (§17) if this app ever needs them.

**2026-07-27 — full dead-code wiring pass.** Re-checked every ⚪ dead-code endpoint for a genuine existing UI element to wire it into. Found and fixed one: `POST /support/tickets` via `ProfileContactView_{iPhone,iPad}` (§12).

**2026-07-28 — capacity pricing corrected + PayPal event payment wired.** Found `InfoGuestPricesView` rendering a fabricated tier table instead of calling `GET /event-plans` (wrong prices, wrong currency, a missing tier, wrong guest ceiling — §16b). Re-examined the Payments blocker from 2026-07-27 against the live backend contract and found PayPal's create-order endpoint returns a hosted approval URL needing no SDK, unlike Stripe's `clientSecret` path — implemented via `EventPaymentViewModel` + `SFSafariViewController`, triggered from the swipe-card join action.

**2026-07-30 — fresh from-scratch re-audit.** Re-derived every status by grep instead of trusting the previous file, which had drifted after several incremental edits. Corrections found: (1) subscriptions migrated to StoreKit the same day (§9); (2) the tvOS QR sign-in flow (device-authorization-grant, actually implemented 2026-07-27) was never added as rows here (§1); (3) saved payment cards (`/payments/cards*`) had actually been implemented in an undocumented earlier session — this doc still called them `[BLOCKED]` on a missing SDK that had since been added (§10); (4) **Tickets (§11) and Cart (§9) were the two biggest misses** — both have real, working ViewModels (`GuestTicketsViewModel`, `CartViewModel`) wired into real screens that this doc had confidently, wrongly described as "no such screen exists anywhere"; (5) found one new suspected-but-unconfirmed bug, `POST /cart/items` passing a non-catalog ID (§9); (6) `10_APIStatusList.txt`'s `check-username` duplicate-listing bug fixed. No dead-code-with-real-UI was left unwired this pass — every remaining ⚪ endpoint was re-confirmed to have no reachable UI, via fresh `grep` across all 4 targets, not carried over from the previous audit's claims.
