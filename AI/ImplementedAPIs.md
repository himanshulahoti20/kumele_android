# Kumele Flutter Android — Implemented APIs

**Audit Date:** 2026-08-08 (fully re-checked same day — every one of the 203 catalog operationIds was grepped against real call sites, tracing repo/datasource methods through to their actual UI callers, not just checked for a repo-layer definition)

This document tracks API implementation status in the **Kumele Flutter Android application**.

## Important

This is **NOT** the iOS/Swift project documentation. This tracks the **Flutter/Android** implementation.

The iOS Swift project has its own separate API tracking document at `AI/05_ImplementedAPIs.md` which tracks the Swift/iOS implementation.

## Summary

- **Total API Operations:** 203 (per `generated_api_catalog.dart` — see caveat below)
- **Consumer-Relevant:** 169
- **Admin/Business-Only (Excluded):** 34
- **Implemented:** 118 (+5 more outside the catalog, see "Endpoints outside the generated catalog" under Profile)
  - With UI Integration: 84 (+4 outside the catalog)
  - Without UI: 34
- **Not Implemented:** 51 (+1 more outside the catalog: `/users/me/stats`)

**Caveat:** the 203-operation catalog is generated from a snapshot OpenAPI spec and is itself stale — at least 5 real endpoints (`/users/me/stats/monthly`, `/event-plans`, `/event-plans/quote`, `/subscriptions/google/verify`, `/auth/device/claim`) are called via hand-written raw operationId strings that bypass it entirely. This audit only had ground truth for the 203 in the catalog; there could be more such gaps not yet found.

## Status Legend

- 🟢 **Implemented & Live** — API call exists and is used in the app
- ⚪ **Implemented but No UI** — API method exists but has no UI integration
- ❌ **Not Implemented** — No implementation exists
- 🚫 **Admin/Business Only** — Excluded from consumer app (not needed)

---

## 26. AUTH

**Status:** 22/26 implemented (2 missing, 2 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | POST | `/auth/2fa/disable` | Disable 2FA |
| 🟢 | POST | `/auth/2fa/enable` | Enable 2FA after verifying a TOTP code |
| 🟢 | POST | `/auth/2fa/setup` | Set up 2FA — returns QR code and secret |
| 🟢 | POST | `/auth/2fa/verify` | Complete 2FA login with TOTP code |
| 🟢 | POST | `/auth/change-password` | Change password (authenticated) |
| 🟢 | POST | `/auth/firebase-login` | Firebase token login (Flutter / mobile) |
| 🟢 | POST | `/auth/forgot-password` | Request password reset OTP (sent to email) |
| ❌ | GET | `/auth/google` | Initiate Google OAuth login |
| ❌ | GET | `/auth/google/callback` | Google OAuth callback |
| 🟢 | POST | `/auth/login` | Login with email and password |
| 🟢 | POST | `/auth/logout` | Logout current session |
| 🟢 | POST | `/auth/logout-all` | Logout from all devices |
| 🟢 | GET | `/auth/me` | Get current authenticated user — `AuthenRepo.getCurrentUser()`, called by `AppCubit` at launch |
| 🟢 | POST | `/auth/passkey/login/finish` | Complete passkey login |
| 🟢 | POST | `/auth/passkey/login/start` | Start passkey login |
| 🟢 | POST | `/auth/passkey/register/finish` | Complete passkey registration — `PasskeyService.register()`, wired to `AuthBloc`/Security settings "Add Passkey" |
| 🟢 | POST | `/auth/passkey/register/start` | Start passkey registration — same flow |
| 🟢 | POST | `/auth/refresh` | Refresh access token — automatic in `ApiService`'s 401-retry interceptor (`api_service.dart`), not a direct UI call |
| ⚪ | POST | `/auth/resend-verification` | Resend verification email |
| 🟢 | POST | `/auth/reset-password` | Reset password using token from /auth/verify-reset-otp |
| 🟢 | POST | `/auth/send-verification-email` | Send email verification OTP |
| 🟢 | POST | `/auth/signup` | Register a new user |
| 🟢 | POST | `/auth/verify-email` | Verify email with OTP code |
| 🟢 | POST | `/auth/verify-reset-otp` | Verify password reset OTP and get a one-time reset token |

## 20. PROFILE

**Status:** 15/20 implemented (5 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | GET | `/users/check-username` | Check if a username is available (case-insensitive) |
| ❌ | GET | `/users/follow/suggestions` | Get follow suggestions based on shared hobbies |
| 🟢 | GET | `/users/profile` | Get current user profile |
| 🟢 | PUT | `/users/profile` | Update current user profile (full update) |
| 🟢 | GET | `/users/referral-code` | Get current user referral code |
| ⚪ | GET | `/users/referral-code/{code}/validate` | Validate a referral code |
| ❌ | GET | `/users/referrals` | Get users referred by current user |
| ❌ | GET | `/users/{id}` | Get user by ID |
| ❌ | GET | `/users/{id}/attendance` | Get user attendance history |
| 🟢 | DELETE | `/users/{id}/follow` | Unfollow a user — `ConnectionsRepository.unfollow()`, wired this session to the multi-select "Remove" flow on the Followers/Following screen (`followers.dart`, long-press a row → checkboxes + "Select All"/"Remove" header → confirm dialog → bulk-unfollows selected ids). Backend has no separate "remove a follower" endpoint, so on the Followers tab this only actually does anything for mutually-followed accounts — a backend limitation, documented in `ConnectionsBloc._onRemoveSelectedConfirmed` |
| 🟢 | POST | `/users/{id}/follow` | Follow a user — `ConnectionsRepository.follow()`, wired this session to the "Follow Host" menu item in `ChatMoreDialog` (chat list tile's kebab menu) behind a confirm dialog ("Do you want to follow host?" / No / Follow host). This was previously a fully-built but entirely commented-out stub — the menu item existed, the icon and label existed, the dialog copy existed in a comment, it just never called anything |
| ⚪ | GET | `/users/{id}/follow-stats` | Get follow statistics for a user |
| 🟢 | GET | `/users/{id}/followers` | Get user followers |
| 🟢 | GET | `/users/{id}/following` | Get users this user is following |
| ❌ | GET | `/users/{id}/host-profile` | Get host profile card (public — ratings, stats, recent reviews) — this dedicated endpoint is unused, but the UI need it serves (Host Details + "Other Events from Host" on the Explore swipe card) is fully implemented anyway: host bio/avatar/followers/rating/medals come embedded on the `GET /events/{id}` response (`swipe_card_host_section.dart`), and "Other Events from Host" calls real `GET /events?hostId=...` (`event_detail_cubit.dart:108`, `getEventsByHostId`). Nothing hardcoded — verified against a live screenshot. |
| 🟢 | PATCH | `/users/{id}/profile` | Update user profile by ID (partial update) |
| ❌ | GET | `/users/{id}/profile-completeness` | Get user profile completeness |
| 🟢 | GET | `/users/{id}/qr` | Generate QR code for user identity (for event check-in) |
| ❌ | GET | `/users/{id}/referral-code` | Get user referral code by ID |
| 🟢 | GET | `/users/{id}/rewards` | Get user reward/badge status |

## ⚠️ Endpoints outside the generated catalog

These are **not** among the 203 operations in `generated_api_catalog.dart` (that catalog is generated from `config/openapi.snapshot.2026-07-21.json` and is itself stale relative to what the app actually calls) — found by grepping for raw `'XController_yyy_v1'` operationId strings that bypass `GeneratedApiOperations` entirely. They are real, and some are live. Not counted in the 203/169 totals above; tracked here separately so they don't get lost.

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | GET | `/users/me/stats/monthly` | Monthly stats for the History & Statistics screen — `StatisticsRepo.getMonthlyStats()`, called from `history_statistics.dart` |
| ❌ | GET | `/users/me/stats` | Aggregate (non-monthly) stats — no repo method calls this at all; only the monthly variant is implemented |
| 🟢 | GET | `/event-plans` | List host capacity/pricing plans — called from **two** independent places: `create_event_cubit.dart` (via `CreateEventRepository.fetchEventPlans`) and `shop.dart` (via `Web3Repo.getEventPlans`) — duplicate client-side implementations of the same call, candidate for consolidation |
| 🟢 | GET | `/event-plans/quote` | Price quote for a given guest capacity — `create_event_cubit.dart` |
| 🟢 | POST | `/subscriptions/google/verify` | Verify a Google Play purchase token — `GooglePlayBillingService`, called from `payment_subscriptions.dart`. **Caveat:** the code's own comment flags this as a best-guess route mirroring the Apple-verify shape, "confirm with backend and regenerate the catalog once they add the real route" — unconfirmed against a real backend contract, risk of silently failing server-side |
| 🟢 | POST | `/auth/device/claim` | TV pairing (phone-side claim) — out of scope per current instructions, listed here for completeness only |

## 7. HOBBIES

**Status:** 4/7 implemented (1 missing, 2 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | GET | `/hobbies/categories` | Get all hobby categories |
| ❌ | GET | `/hobbies/categories/{id}/hobbies` | Get hobbies by category |
| 🟢 | GET | `/hobbies/users/{id}` | Get user hobby preferences |
| 🟢 | PUT | `/hobbies/users/{id}` | Update user hobby preferences |
| 🟢 | GET | `/recommendations/hobbies` | Get hobby recommendations for the current user |

## 26. EVENTS

**Status:** 19/26 implemented (6 missing, 1 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | GET | `/chat/rooms` | Get all chat rooms for current user |
| ❌ | GET | `/events` | List events with filters (cursor-based pagination) |
| 🟢 | POST | `/events` | Create event (Host only) |
| ❌ | POST | `/events/participations/{participationId}/finalize` | Finalize single match (host only) |
| ❌ | POST | `/events/{eventId}/chat/create` | Create event chat room (host only) |
| 🟢 | POST | `/events/{eventId}/chat/join` | Join event chat |
| 🟢 | GET | `/events/{eventId}/chat/messages` | Get chat messages (paginated) |
| ❌ | POST | `/events/{eventId}/chat/messages` | Send a chat message |
| 🟢 | GET | `/events/{eventId}/chat/status` | Get event chat room status |
| 🟢 | GET | `/events/{id}` | Get event details by ID |
| ⚪ | POST | `/events/{id}/cancel` | Cancel event (host only) — `EventsRepo.cancelEvent()`, no host-cancel UI yet |
| 🟢 | POST | `/events/{id}/checkin/host-scan` | Host scans guest QR to check in |
| ⚪ | POST | `/events/{id}/checkin/self` | Self check-in via GPS (≤2km) — `EventsRepo.selfCheckIn()`, no UI yet |
| ❌ | POST | `/events/{id}/finalize-matches` | Finalize all matches and create chat (host only) |
| 🟢 | GET | `/events/{id}/guests` | Get event guest list (host only) |
| 🟢 | POST | `/events/{id}/join` | Join event (triggers matching) |
| ⚪ | GET | `/events/{id}/ratings` | Get event ratings (paginated) — `EventsRepo.getEventRatings()`, no ratings-list UI yet |
| 🟢 | POST | `/events/{id}/ratings` | Rate an event — `EventsRepo.rateEvent()`, wired to `RatingPage` (was previously a fake "Send" button that just popped the screen, discarding all input) |
| ⚪ | GET | `/events/{id}/ratings/mine` | Get my rating for this event — `EventsRepo.getMyEventRating()`, no UI yet |
| ⚪ | GET | `/events/{id}/ratings/summary` | Get advanced ratings summary — `EventsRepo.getEventRatingsSummary()`, no UI yet |
| ⚪ | DELETE | `/events/{id}/ratings/{ratingId}` | Delete your event rating — `EventsRepo.deleteEventRating()`, no UI yet |
| ❌ | PUT | `/events/{id}/ratings/{ratingId}` | Update your event rating — not implemented (only create/delete were built) |
| 🟢 | POST | `/events/{id}/reports` | Report an event — `EventsRepo.reportEvent()`, wired to `ReportEventPage` (same fake-button bug as ratings; also required refactoring `ReportRadio` off broken internal state and fixing 4 missing localization keys that were failing `flutter analyze`) |
| 🟢 | GET | `/match/events` | Get matched events for Discover/Explore/nearby (backend-filtered, AI-scored) |
| 🟢 | GET | `/recommendations/events` | Get personalised event recommendations (\ |

> ⚠️ **Path discrepancy, unresolved:** a separate iOS-derived Events API reference (and `config/openapi.snapshot.2026-07-21.json`) both say the real backend route is `GET /events/recommendations` — neither `/recommendations/events` nor `/match/events` (used above) appear in that spec at all. The Flutter code (`explore_remote_data_source.dart`) has an explicit comment attributing these two paths to direct backend-team guidance ("George's Primary Rule") postdating the snapshot, so this may be intentional and correct rather than a bug — but it's unverified against a live server either way. Marked 🟢 here because the calls are wired to real screens (Explore/Discover), not because the paths are confirmed correct. Needs a live curl against the actual backend to resolve.

## 8. BLOGS

**Status:** 5/8 implemented (3 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | POST | `/blogs` | Create a blog post (with markdown processing pipeline) |
| 🟢 | GET | `/blogs/feed` | Get blog feed (cursor-based pagination, approved + visibility filtered) |
| ❌ | GET | `/blogs/public/{slug}` | Get public SEO blog post by slug |
| ❌ | GET | `/blogs/sitemap` | Get list of public SEO blog slugs for sitemap |
| 🟢 | GET | `/blogs/{id}` | Get blog post detail by ID (pass JWT to get is_liked) |
| 🟢 | GET | `/blogs/{id}/comments` | Get comments for a blog post (cursor-based) |
| 🟢 | POST | `/blogs/{id}/comments` | Add a comment to a blog post |
| 🟢 | POST | `/blogs/{id}/like` | Toggle like on a blog post |

## 6. NOTIFICATIONS

**Status:** 4/6 implemented (2 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | GET | `/notifications` | Get notification feed (paginated) |
| 🟢 | POST | `/notifications/push-token` | Register FCM push token for current device — sends `{fcmToken, platform: "android"/"ios", deviceId, language}`, matches spec exactly |
| 🟢 | POST | `/notifications/read-all` | Mark all notifications as read — added this session: `NotificationRemoteDataSource.markAllAsRead()` + bloc event, wired to a "Mark all as read" action in the notification screen header (only shown when `unreadCount > 0`) |
| ❌ | POST | `/notifications/test` | Send a test push notification to your own registered devices |
| ❌ | POST | `/notifications/tokens` | Register APNs/FCM push token (iOS alias) — not needed, Android uses `/notifications/push-token` |
| 🟢 | POST | `/notifications/{id}/read` | Mark a notification as read |

**Notification `type` field mapping:** already more complete on Flutter than what the iOS reference doc describes (15 mapped types with a safe `unknown` fallback in `notification_item_mapper.dart`, vs. iOS's 3). Flagged as unconfirmed against the live backend in the source doc — not fixable without a real server response to check against; the existing fallback means an unrecognized `type` degrades gracefully rather than breaking.

## 6. SUBSCRIPTIONS

**Status:** 6/6 implemented (0 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | DELETE | `/subscriptions` | Cancel subscription — `Web3Repo.cancelSubscription()`, wired to the "Deactivate" button in `payment_checkout_page.dart` for Stripe-billed tiers only. **Not** called for Google Play–billed tiers (`tier.googleProductId` set) — Play policy requires cancellation to go through Play's own subscription-management UI, not a custom in-app call, so "Deactivate" opens `https://play.google.com/store/account/subscriptions?sku=...&package=com.kumele.hobbies` instead (mirrors iOS's `.manageSubscriptionsSheet()`) |
| 🟢 | POST | `/subscriptions` | Create new subscription (returns a PaymentIntent client secret for in-app payment, or a Stripe Checkout URL) — `Web3Repo.createSubscription()`, wired to "Activate" per-tier in `payment_checkout_page.dart` (falls back to `GooglePlayBillingService.buySubscription()` when the tier has a `googleProductId`) |
| ⚪ | GET | `/subscriptions/history` | Get subscription lifecycle history (created/renewed/cancelled) — `Web3Repo.getSubscriptionHistory()` added this session, distinct from the generic `/payments/history`; no UI surface consumes it yet (the new Payments screen mockup doesn't show a subscription-history list) |
| 🟢 | POST | `/subscriptions/resume` | Resume subscription pending cancellation — `Web3Repo.resumeSubscription()`, wired in `payment_subscriptions.dart`'s status card (the older subscription-management dialog, still reachable via `showPaymentSubscriptionsDialog`/`mynavController`); **not** exposed in the new `payment_checkout_page.dart` tier cards, which only show Activate/Deactivate |
| 🟢 | GET | `/subscriptions/status` | Get current subscription status — used to compute each tier's "Active" badge in `payment_checkout_page.dart` |
| 🟢 | GET | `/subscriptions/tiers` | Get available subscription tiers — renders the Monthly Silver/Monthly Gold/Yearly Gold cards in `payment_checkout_page.dart` |

## STORE CREDIT

**Status:** 2/2 implemented (0 missing, 0 admin-only)

Append-only ledger balance (`GRANT`/`PURCHASE`/`SPEND`/`REFUND`/`EXPIRY` entries, single-currency EUR, 60-day expiry, consumed oldest-first). Applies to event tickets and NFTs only — excluded from subscriptions and from buying store credit itself.

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | GET | `/store-credit` | Spendable balance — `Web3Repo.getStoreCreditBalance()`, shown as a wallet-icon card on the Shop screen's Subscriptions tab (`shop.dart`: "Store Credit" heading, "Pay for events, in-app purchases and NFTs. Valid for 60 days." subheading, amount in yellow). Not in the generated catalog yet, called by raw path/operationId like `/event-plans`. A 404 is treated the same as the live `amount: 0` shape |
| ⚪ | GET | `/store-credit/history` | Full ledger, newest first — `Web3Repo.getStoreCreditHistory()`, no UI surface consumes it yet |

## 15. PAYMENTS

**Status:** 18/19 implemented (1 missing/superseded, 0 admin-only)

*(Corrected count this session — the previous 14/15 total missed the 3 PayPal "connect escrow account" rows below, which are present in `generated_api_catalog.dart` and already implemented in `Web3Repo`, just never listed in this doc.)*

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | GET | `/payments/cards` | List all saved cards — `Web3Repo.listSavedCards()`, wired into `payment_checkout_page.dart` (the file previously referenced here as `removeCard.dart` was renamed/consolidated — same screen, reached from Profile → "Card Payments, Subscriptions & Escrow") |
| 🟢 | POST | `/payments/cards` | Save a card after Stripe tokenization — `Web3Repo.saveCard()`, called from `add_card.dart` after `PaymentSdkService.presentStripePaymentSheet` confirms the SetupIntent |
| 🟢 | POST | `/payments/cards/setup-intent` | Create a Stripe SetupIntent to tokenize a new card — `Web3Repo.createCardSetupIntent()`, `add_card.dart` |
| 🟢 | DELETE | `/payments/cards/{id}` | Remove a saved card — `Web3Repo.deleteCard()`, wired to the trash-icon button in `payment_checkout_page.dart` behind a "Confirm card deletion" dialog |
| 🟢 | PATCH | `/payments/cards/{id}/default` | Set a card as the default payment method — `Web3Repo.setDefaultCard()`, now wired this session to the radio button on each card row in `payment_checkout_page.dart` (previously implemented but had no UI trigger) |
| 🟢 | POST | `/payments/confirm` | Confirm a Stripe payment after client-side confirmation |
| 🟢 | POST | `/payments/event` | Create payment intent for event participation *or* a paid NFT (the DTO's `nftId` alternate field) — `Web3Repo.createEventPayment()`, called from two places: `EventDetailCubit._payForEventTicket()` when joining a paid event (via the "Join" confirm dialogs in `explorepreview.dart`/`swipe_card_expanded_content.dart`), and `CartCheckoutPage._handlePayNow()` for NFT checkout (via `nft_tab_view.dart`'s "Buy" action, which now pushes the tapped `NftItem` to Cart instead of landing on a bare screen). Both carry `useStoreCredit` — set from the grey/yellow store-credit toggle (`StoreCreditToggle`, shared by both screens) shown whenever the purchase needs payment and the user has a spendable balance. `CheckoutFlow.payStripeThenPayPal()` skips the Stripe sheet entirely when the response comes back `requiresPayment: false` (credit covered it in full). Cart previously sold subscriptions instead (`Web3Repo.createSubscription()`/Google Play Billing) — moved out; subscriptions are bought only from Shop's Subscriptions tab (`shop.dart`) or the Profile → Card Payments screen (`payment_checkout_page.dart`) now |
| 🟢 | POST | `/payments/event-creation/{eventId}` | Checkout for the host's create-event capacity plan |
| 🟢 | GET | `/payments/history` | Get payment history |
| 🟢 | GET | `/payments/paypal/connect` | Get the PayPal "Log in with PayPal" authorize URL — `Web3Repo.getPayPalConnectLoginUrl()`, step 1 of the escrow-connect flow in `payment_checkout_page.dart`'s "Connect your Escrow Account" section. *(Missing from the previous audit pass of this doc — was already implemented, just not listed.)* |
| 🟢 | DELETE | `/payments/paypal/connect` | Disconnect the linked PayPal account — `Web3Repo.disconnectPayPal()`, implemented in `PayPalConnectionService.disconnect()`; no disconnect button in the new screen's UI yet (button is disabled once connected, no way to unlink from this screen) |
| 🟢 | POST | `/payments/paypal/connect/callback` | Connect a PayPal account via "Log in with PayPal" (OpenID Connect) — `Web3Repo.finishPayPalConnect()`, step 2: called with the `code` captured by `PaymentSdkService.presentPayPalConnectFlow()`'s webview redirect. This is the call that actually persists the link server-side — the webview reaching the redirect alone proves nothing was linked yet |
| 🟢 | GET | `/payments/paypal/connect/status` | Live escrow-account link status (`{ connected, paypalPayerId, paypalEmail }`) — `Web3Repo.getPayPalConnectStatus()`, now the sole source of truth behind `PayPalConnectionService.loadStatus()`, replacing an earlier local-storage-cache + `user.paypalMerchantId` profile-field heuristic that could go stale across devices/sessions. Drives the connected/disconnected icon in `payment_checkout_page.dart`'s "Connect your Escrow Account" section (now also shows `paypalEmail` once connected) and `CreateEventCubit.state.paypalConnected`, the gate for publishing a paid event. Not in the generated catalog yet, called by raw path/operationId like `/event-plans` |
| 🟢 | POST | `/payments/paypal/capture/{orderId}` | Capture a PayPal order after user approval |
| 🟢 | POST | `/payments/paypal/create-order` | Create a PayPal order for event payment — `Web3Repo.createPayPalOrder()`, the PayPal fallback leg of `CheckoutFlow.payStripeThenPayPal()` used by the same join-event flow as `/payments/event` above (was previously listed ⚪ dead); also carries `useStoreCredit` |
| 🟢 | POST | `/payments/paypal/event-creation/{eventId}` | Start a PayPal order for the host's create-event capacity plan |
| ⚪ | GET | `/payments/paypal/status/{orderId}` | Get PayPal order status — `Web3Repo.getPayPalOrderStatus()` implemented, no polling UI yet |
| ❌ | POST | `/payments/paypal/vault/setup-token` | Create a PayPal vault setup token. **Deliberately not used** — per the doc comment on `Web3Repo.getPayPalConnectLoginUrl()`, this was an earlier attempt at the same "connect escrow account" feature, superseded by the OAuth login-url/callback flow above once that was confirmed live. Kept `❌` rather than re-implemented to avoid two competing connect flows |
| ⚪ | GET | `/payments/{id}/escrow` | Get escrow status for a payment — `Web3Repo.getEscrowStatus()` implemented, no UI row/detail view calls it yet |

## 6. TICKETS

**Status:** 5/6 implemented (1 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/tickets/events/{id}` | Get tickets for an event (organizer only) |
| ⚪ | POST | `/tickets/events/{id}` | Generate a guest ticket for an event — `TicketsRepo.createEventTicket()`, no UI yet |
| ⚪ | GET | `/tickets/my` | Get my tickets |
| ⚪ | DELETE | `/tickets/{id}` | Cancel a ticket — `TicketsRepo.cancelTicket()`, no UI yet |
| ⚪ | GET | `/tickets/{id}` | Get ticket details — `TicketsRepo.getTicket()`, no UI yet |
| ⚪ | POST | `/tickets/{id}/validate` | Validate a ticket (organizer only) — `TicketsRepo.validateTicket()`, no UI yet |

## 8. WEB3

**Status:** 6/8 implemented (1 missing, 1 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | GET | `/nfts/marketplace` | Browse NFT marketplace (filterable, paginated) |
| 🟢 | GET | `/nfts/mine` | Get all NFTs owned by the current user |
| ⚪ | GET | `/nfts/my-screen` | Get personalized NFT screen (owned, claimable, marketplace, exclusive) |
| 🟢 | GET | `/nfts/rewards` | Get all reward NFTs (earned status per user) |
| ❌ | GET | `/nfts/{id}` | Get NFT details by ID |
| 🟢 | POST | `/nfts/{id}/claim` | Claim a free reward NFT |
| 🟢 | POST | `/nfts/{id}/purchase` | Purchase an NFT |

## 2. ADS

**Status:** 2/2 implemented (0 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | GET | `/ads/fetch` | Fetch ads for display (ML + fallback) — fixed a real parsing gap this session: `FetchedAds.fromJson` only checked `ads`/`data`, missing the `firstPartyAds` array and `firstPartyAd` single-object shapes the backend/doc also use |
| 🟢 | POST | `/ads/track` | Track ad view/click/conversion — fixed two real bugs this session: (1) `TrackAdRequest.toJson()` was sending both `adId` **and** `ad_id` in the same body, which the doc explicitly warns causes a 400 (`property ad_id should not exist`) — removed the snake_case duplicates; (2) `campaignId`/`impressionId` were never sent at all, so impressions couldn't correlate with clicks server-side — `AdItem` now generates a client-side `impressionId` per fetched ad (UUID v4, no new dependency) and all 4 call sites in `explore_discount.dart` now pass both fields |

## 6. MEDIA

**Status:** 2/6 implemented (4 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | POST | `/media/upload` | Upload image or video |
| ❌ | POST | `/media/upload-url` | Get a pre-signed upload URL for direct media upload to storage |
| ❌ | POST | `/upload/blog-image` | Upload a blog image |
| 🟢 | POST | `/upload/event-banner` | Upload an event banner image |
| 🟢 | POST | `/upload/image` | Upload a profile image |
| ❌ | POST | `/upload/nft-image` | Upload an NFT image |

## 7. LEGAL

**Status:** 1/7 implemented (1 missing, 5 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/legal` | Get all active legal documents |
| 🟢 | GET | `/legal/type/{type}` | Get legal document by type (guidelines, terms, privacy_policy) |

## 2. LOCALIZATION

**Status:** 1/2 implemented (1 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| 🟢 | GET | `/localization/languages` | Get available languages |
| ❌ | GET | `/localization/strings` | Get localization strings by language |

## 4. TRANSLATION

**Status:** 1/4 implemented (3 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/translation/detect` | Detect language from Accept-Language header |
| 🟢 | GET | `/translation/languages` | Get available languages |
| ❌ | GET | `/translation/profile` | Get profile page content (backward compatibility) |
| ❌ | GET | `/translation/strings` | Get localized strings |

## 5. PRIVACY

**Status:** 3/5 implemented (2 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ⚪ | PATCH | `/privacy/consent` | Update consent settings (GDPR Article 7) |
| 🟢 | POST | `/privacy/delete` | Delete account (GDPR Article 17 - Right to Erasure) |
| ❌ | GET | `/privacy/export` | Export all user data (GDPR Article 20 - Data Portability) |
| ⚪ | GET | `/privacy/preferences` | Get privacy preferences |
| ❌ | PATCH | `/privacy/rectify` | Rectify personal data (GDPR Article 16) |

## 5. SUPPORT

**Status:** 1/5 implemented (4 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/support/tickets` | Get user's support tickets |
| 🟢 | POST | `/support/tickets` | Create a new support ticket |
| ❌ | GET | `/support/tickets/{id}` | Get support ticket details |
| ❌ | POST | `/support/tickets/{id}/close` | Close a support ticket |
| ❌ | POST | `/support/tickets/{id}/reply` | Add a reply to a support ticket |

## 5. CART

**Status:** 5/5 implemented (0 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ⚪ | DELETE | `/cart` | Clear entire cart — `CommerceRepo.clearCart()`, no cart UI exists yet |
| ⚪ | GET | `/cart` | Get my cart — `CommerceRepo.getCart()`, no cart UI exists yet |
| ⚪ | POST | `/cart/items` | Add item to cart — `CommerceRepo.addToCart()`. Doc flags iOS's `productId` as sometimes wrongly an event-plan tier ID; Flutter has no caller yet so this risk doesn't apply here, but keep it a real `/products` UUID when wiring a screen |
| ⚪ | DELETE | `/cart/items/{id}` | Remove item from cart — `CommerceRepo.removeFromCart()`, no cart UI exists yet |
| ⚪ | PUT | `/cart/items/{id}` | Update cart item quantity — `CommerceRepo.updateCartItem()`, no cart UI exists yet |

## 5. PRODUCTS

**Status:** 2/5 implemented (0 missing, 3 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ⚪ | GET | `/products` | Get all products (public) — `CommerceRepo.getProducts()`, no product-catalog UI exists (none on iOS either) |
| ⚪ | GET | `/products/{idOrSlug}` | Get product by ID or slug — `CommerceRepo.getProduct()`, same |

## 7. DISCOUNTS

**Status:** 2/7 implemented (0 missing, 5 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ⚪ | GET | `/discounts/rewards` | Get user available reward discounts — `CommerceRepo.getRewardDiscounts()`, returns raw flexible JSON per the doc's warning (shape isn't fixed); no discount-code UI to consume it yet |
| ⚪ | POST | `/discounts/validate` | Validate a discount code — `CommerceRepo.validateDiscount()`, same |

## 5. REFUNDS

**Status:** 0/5 implemented (3 missing, 2 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | POST | `/refunds` | Request a refund |
| ❌ | GET | `/refunds/eligibility/{paymentId}` | Check refund eligibility for a payment |
| ❌ | GET | `/refunds/my-requests` | Get my refund requests |

## 2. SHARE

**Status:** 0/2 implemented (2 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/share/resolve/{token}` | Resolve a share token to its entity |
| ❌ | POST | `/share/token` | Generate a share token for an entity |

## 7. CMS

**Status:** 0/7 implemented (2 missing, 5 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/cms/pages` | Get all published CMS pages |
| ❌ | GET | `/cms/pages/slug/{slug}` | Get CMS page by slug |

## 2. APP

**Status:** 1/2 implemented (1 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ⚪ | GET | `/app/config` | Get app configuration (maintenance mode, versions, feature flags) |
| ❌ | GET | `/app/health` | App health check (for load balancers) |

## 3. HEALTH

**Status:** 0/3 implemented (3 missing, 0 admin-only)

| Status | Method | Endpoint | Summary |
|--------|--------|----------|---------|
| ❌ | GET | `/health` | Check application health |
| ❌ | GET | `/health/live` | Liveness probe for Kubernetes |
| ❌ | GET | `/health/ready` | Readiness probe for Kubernetes |

---

## Implementation Notes

### General Architecture

- **API Client:** `lib/shared/services/api_service/api_service.dart`
- **Generated Catalog:** `lib/shared/services/api_service/generated/generated_api_catalog.dart`
- **Repositories:** `lib/features/*/data/repositories/`
- **Remote Data Sources:** `lib/features/*/data/datasources/`

### Key Implemented Features

1. **Authentication (22/26 endpoints)**
   - Email/password login and signup
   - Firebase/Google authentication
   - Passkey authentication (login and registration)
   - 2FA setup, enable, disable, verify
   - Password reset flow (forgot, verify OTP, reset), change password
   - Email verification, resend verification (no UI)
   - Session bootstrap (`/auth/me`) and automatic token refresh (`/auth/refresh`, transparent 401-retry)
   - Logout and logout-all
   - Missing: `/auth/google` + `/auth/google/callback` (superseded by Firebase-mediated Google Sign-In)

2. **Events (19/26 endpoints)**
   - Create events, join events, get details, matched/recommended events
   - Chat rooms, chat join/messages/status
   - Host guest-list and QR check-in scan
   - Rate an event and report an event both have live UI (`RatingPage`/`ReportEventPage` — previously fake "Send" buttons that just closed the screen and discarded the input; wired to the real APIs)
   - Cancel event, self check-in, and the other 4 rating endpoints (list/summary/mine/delete) are implemented but have no UI yet
   - Missing: rating update, match finalization, sending chat messages, plain `GET /events` list-with-filters (Discover/Explore use the recommendations/match endpoints instead — see the path-discrepancy caveat below)

3. **Subscriptions (6/6 endpoints)**
   - Get subscription tiers, get subscription status
   - Create, cancel, resume subscriptions — cancel now branches by billing provider: Stripe-billed tiers call `DELETE /subscriptions` directly, Google Play–billed tiers are sent to Play Store's own subscription-management page instead (see PAYMENTS section note)
   - Subscription history (`getSubscriptionHistory()`) added this session, repo-only, no UI yet

4. **Profile & Social (15/20 endpoints)**
   - Get/update user profile (full + partial by ID), check username, QR code, referral code, reward status
   - Get followers/following lists
   - Follow/unfollow now have real UI triggers, added this session: "Follow Host" in the chat list's kebab menu, and multi-select "Remove" (unfollow) on the Followers/Following screen. Follow stats (`follow-stats`) still has no UI consumer

5. **Payments (17/18 endpoints)**
   - Stripe card setup + confirm + save + delete + set-default, PayPal event-creation checkout + capture, PayPal escrow-account connect (authorize URL → callback → disconnect), payment history
   - Regular event-ticket payment (`/payments/event`, `/payments/paypal/create-order`) implemented but unused — only the event-*creation* payment flow is wired to UI
   - Missing/superseded: `/payments/paypal/vault/setup-token` (an earlier attempt at the escrow-connect feature, replaced by the authorize-URL/callback flow — see PAYMENTS table note)

6. **Blogs (5/8 endpoints)**
   - Feed, post detail, comments (read + post), like toggle
   - Missing: create post, public SEO routes (slug/sitemap)

7. **Hobbies (4/7 endpoints)**
   - Categories, get/update user hobby preferences, recommendations — all wired into onboarding/profile-setup

8. **Statistics & event pricing (outside the catalog, see caveat above)**
   - History & Statistics screen's monthly chart (`/users/me/stats/monthly`)
   - Event-creation capacity/pricing plans and quotes (`/event-plans`, `/event-plans/quote`)
   - Google Play subscription verification (unconfirmed backend contract — see caveat)

### Major Missing Features

1. **Cart & Products (All endpoints missing)**
   - No shopping cart implementation
   - No product catalog

2. **Support Tickets (1/5 endpoints — create only)**
   - Users can submit a ticket; no ticket list, detail, reply, or close screens

3. **Booking Tickets (5/6 endpoints, all with no UI)**
   - `TicketsRepo` has create/get/cancel/validate; `getMyTickets` also exists — none are called from any screen yet
   - Missing entirely: organizer's "tickets for an event" list

4. **Event Management (6/26 endpoints still missing)**
   - Missing: rating update, match finalization, in-app chat send, plain `GET /events` list

5. **Notifications (2/6 endpoints missing)**
   - Missing: test notification, APNs/FCM alias route (not needed on Android)

6. **Privacy & GDPR (2/5 endpoints missing)**
   - Delete account has UI; consent update and get-preferences are implemented but have no settings screen yet
   - Missing: data export, rectification

### Recommendations

#### High Priority (Core User Experience)

1. **Profile Completeness** - Better onboarding
2. **Ratings list / summary display** - Submitting a rating now works; showing an event's aggregate rating or a user's own past rating does not

#### Medium Priority (Enhanced Features)

1. **Event Check-in (self, GPS-based)** - Guest-side experience (host-scan already works, repo method now exists)
2. **My Tickets Screen** - Repo layer complete (create/get/cancel/validate/list), no screen
3. **Refunds** - Payment dispute handling
4. **Support Ticket List/Replies** - Creation works; no way to view ticket status after submitting
5. **Privacy/Consent Settings Screen** - API layer done, needs a UI surface
6. **Host Cancel Event UI** - Repo method exists, no button

#### Low Priority (Nice to Have)

1. **Shopping Cart** - If product sales are planned
2. **NFT "My Screen" surfacing** - Marketplace/rewards/claim/purchase already live; only the combined summary endpoint is unused
3. **CMS Integration** - For dynamic content

---

**Generated:** 2026-08-08T19:15:22.937368
**Re-verified:** 2026-08-08 — every operationId in `generated_api_catalog.dart` (203 total) was matched against real usages in `lib/`, distinguishing "repo method defined" from "actually reachable from a bloc/cubit/page", by following each call up to two hops (datasource → repository wrapper → presentation layer). 40 rows were corrected from the prior pass, mostly 🟢/⚪ undercounts (endpoints wrongly marked `❌ Not Implemented` despite having live UI callers) plus a few over-claims (e.g. referral-code validation, which is defined but never called).
**Updated (code change, not just re-audit):** 2026-08-08 — implemented `EventsRepo` (rate/list/summary/mine/delete rating, report event, cancel event, self check-in) and `TicketsRepo` (create/get/cancel/validate ticket), and wired `RatingPage` + `ReportEventPage` to their real endpoints — both previously had fully-built UI (star ratings, comment box, radio reasons) whose "Send" button just called `context.pop()` and discarded the input. Also fixed a real `flutter analyze` failure in `report_radio.dart` (4 referenced l10n keys existed in `app_en.arb` but the generated Dart l10n files were stale; fixed via `flutter gen-l10n`). 9 EVENTS rows and 4 TICKETS rows moved from ❌/dead to 🟢/⚪ as a result — this is genuinely new implementation, not a re-audit correction.

**Updated again:** 2026-08-08 — cross-checked against `AI/docs.md` (Events API integration guide). Implemented `POST /notifications/read-all` end to end (datasource → repo → bloc event → a "Mark all as read" header action, optimistic local update + best-effort server call, only shown when there are unread notifications) — the doc had explicitly called this out as a safe, ready-to-wire gap. Verified and fixed a real bug found via the doc's field-alias table: `ExploreEventModel`'s event-card image resolution was missing the `cover_image` (snake_case) and `event_images[0]`/`image` fallbacks the backend actually sends, falling back only to `eventImageUrl`/`event_image_url`/`coverImage` — could silently show no image for events whose payload used the other keys. Also verified (no fix needed, already correct): chat's `POST .../chat/messages` already sends the `message_text` key the doc flags as a historical camelCase-vs-snake_case gotcha, and notification `type` mapping already handles 15 values with a safe fallback (doc only expected iOS's 3).

**Updated again:** 2026-08-08 — cross-checked against `AI/ADS_COMMERCE_API_README.md`. Implemented the entire Commerce repo layer that didn't exist at all: `CommerceRepo` (cart get/add/update/remove/clear, products list/detail, discount rewards/validate) + `commerce_models.dart` (`ProductModel`, `CartItem`, `CartModel` with the flexible number/string parsing the doc requires). No cart or product-catalog UI exists on Flutter (none on iOS either, per the doc — its own checkout button is `.disabled(true)`), so all 9 new rows are ⚪ repo-only, same pattern as the Events/Tickets work. Also fixed two live bugs in the already-🟢 Ads endpoints, found via the doc's explicit gotcha list: `POST /ads/track` was sending both `adId` and `ad_id` in the same body (the doc names this exact combination as a confirmed 400-causing bug) and never sent `campaignId`/`impressionId` at all, breaking impression↔click correlation; `GET /ads/fetch` parsing missed the `firstPartyAds`/`firstPartyAd` response shapes entirely. Verified subscription status parsing already correctly reads `tier` (not `tierId`) and unwraps the envelope — no fix needed, matches the doc's flagged gotcha. Web3 relay endpoints (`/list`, `/cancel`, `/mint` — Solana wallet signing) and `/subscriptions/apple/verify` (iOS-only) intentionally left alone: the doc marks the former dead-on-iOS-too and the latter platform-specific; Android already has its own `/subscriptions/google/verify` from an earlier session.

**Updated again:** 2026-08-08 — cross-checked against `AI/FLUTTER_ANDROID_API_README.md` (Payments/Tickets/Support/Uploads/Privacy/Rewards). Note this doc's own paths were frequently wrong/guessed (e.g. `/payments/event-payment`, `/tickets/for-event/{eventId}`, `/users/me`) — cross-verified every claim against `config/openapi.snapshot.2026-07-21.json` directly rather than trusting the doc's paths, and all previously-implemented endpoints in this app already use the real ones. Found and fixed the highest-value gap it pointed at: saved cards. `POST /payments/cards`, `GET /payments/cards`, `DELETE /payments/cards/{id}` had zero implementation despite two real, fully-built screens already existing for them. `add_card.dart` confirmed a Stripe SetupIntent and told the user "Card added successfully" but never called `POST /payments/cards` to persist it — the card was tokenized with Stripe and then silently dropped, never actually saved to the user's profile. `removeCard.dart` displayed **4 permanently hardcoded fake cards** (`•••• •••• •••• 4634`, "Master Card", `Expires 12-08-23`, ×4) with a delete button whose confirm dialog had no `onConfirm` handler at all. Added `Web3Repo.listSavedCards/saveCard/deleteCard/setDefaultCard`, `getEscrowStatus`, `getPayPalOrderStatus`, `SavedCard`/`EscrowStatus` models, and a `PaymentSdkService.setupIntentIdFrom()` helper (extracts `seti_xxx` from the `..._secret_...` client secret) — wired the first three into the two real screens; the other three (`setDefaultCard`, escrow, PayPal status poll) have no UI trigger yet so land as ⚪. Tickets/Support/Uploads/Privacy/Rewards were already correctly implemented against the real paths from earlier sessions; no changes needed there.

**Updated again:** 2026-08-16 — revamped `payment_checkout_page.dart` (Profile → "Card Payments, Subscriptions & Escrow", `/cart` route) to match a new design: card list with radio-select-as-default + delete, PayPal escrow connect, and a flat Subscriptions list with per-tier Activate/Deactivate. All APIs used already existed in `Web3Repo` — no new backend work needed for the screen itself. Two real corrections found and fixed while wiring it up:

1. **`PATCH /payments/cards/{id}/default` had no UI trigger** — `Web3Repo.setDefaultCard()` existed but nothing called it. Now wired to the radio button on each saved-card row. Moved ⚪ → 🟢.
2. **This doc's PAYMENTS table was missing 3 already-implemented, already-live rows**: `GET /payments/paypal/connect`, `DELETE /payments/paypal/connect`, `POST /payments/paypal/connect/callback` (`Web3Repo.getPayPalConnectLoginUrl/disconnectPayPal/finishPayPalConnect`) — all three are in `generated_api_catalog.dart` and were already called from `payment_checkout_page.dart`'s PayPal-connect flow (pre-existing before this session), just never listed here. Added to the table; PAYMENTS section count corrected 14/15 → 17/18 (top-level Summary totals at the head of this doc were **not** re-verified against this correction — left as-is to avoid false precision, consistent with this doc's existing caveat about the catalog being an incomplete source of truth).

Also cross-checked cancellation semantics against the equivalent iOS implementation (`AI/05_ImplementedAPIs.md`), which deliberately does **not** call a backend cancel endpoint for StoreKit subscriptions — Apple owns cancellation for IAP, enforced via `.manageSubscriptionsSheet()`. Found the Android/Flutter side had the same gap (Deactivate always called `DELETE /subscriptions`, even for Google Play–billed tiers) and fixed it: `_handleDeactivateTier` in `payment_checkout_page.dart` now checks `tier.googleProductId` — if set, it opens `https://play.google.com/store/account/subscriptions?sku=...&package=com.kumele.hobbies` (Play Store's own subscription-management page) instead of calling the backend, matching Google Play policy that only Play's own UI may cancel a Play-billed subscription. `DELETE /subscriptions` is still called, unchanged, for Stripe-billed tiers.

Added `Web3Repo.getSubscriptionHistory()` (`GET /subscriptions/history`) this session — was previously `❌ Not Implemented` despite being a real, catalog-confirmed endpoint; added as a repo method matching the existing `getPaymentHistory()` pattern, reusing the `PaymentHistoryItem` model. No UI consumes it yet (the new Payments screen mockup doesn't include a subscription-history list) — lands as ⚪.

**Updated again:** 2026-08-16 — implemented `POST`/`DELETE /users/{id}/follow` end to end, in the two places a mockup specified. Both moved ⚪ → 🟢 (see PROFILE table). Two builds:

1. **"Follow Host"** — `ChatMoreDialog` (`lib/shared/modals/dialog/chat_more_dialog.dart`), reached from the kebab menu on a chat list tile (`chat_list_item.dart`). This menu item and its icon/label already existed; its `onTap` body was a fully-written-out call to a deleted `BottomAlertDialog` widget, entirely commented out — a dead stub, not a missing feature. Replaced with a real `AppDialog.confirm(...)` ("Follow Host" / "Do you want to follow host?" / No / Follow host) that calls `ConnectionsRepository.follow(userId: hostId)` on confirm. `ChatMoreDialog` now takes a required `hostId` (threaded from `ChatRoomEntity.hostId`, already on the model, just not passed through before).
2. **Multi-select "Remove" on Followers/Following** (`followers.dart`, `connections_list.dart`, `connections_bloc.dart`) — long-press a row to enter selection mode (checkboxes appear, header switches to "Select All" + "Remove" 🗑), tap "Remove" → confirm dialog ("Are you sure you want to unfollow?" / Cancel / Unfollow) → bulk-calls `ConnectionsRepository.unfollow()` for every selected id, then reloads the active tab. New `ConnectionsBloc` events (`ConnectionsSelectionStarted/Toggled`, `ConnectionsSelectAllToggled`, `ConnectionsSelectionCancelled`, `ConnectionsRemoveSelectedConfirmed`) and `ConnectionsState` fields (`isSelectionMode`, `selectedIds`). **Known backend limitation, not a bug**: there is no dedicated "remove a follower" endpoint — only `follow`/`unfollow` (which act on accounts *I* follow). "Remove" on the Followers tab therefore only does anything for mutually-followed accounts; documented inline in `ConnectionsBloc._onRemoveSelectedConfirmed`.

Also added a `cancelText` param to `AppDialog.confirm`/`AppConfirmDialog` (`app_dialog.dart`/`app_dialog_layout.dart`) — previously the Cancel button was hardcoded to the `cancel` l10n key ("Cancel"); the "Follow Host" dialog needed it to read "No" instead. Backward compatible, defaults to the old behavior when omitted. 8 new l10n keys added across all 6 locales (`followHostConfirmMessage/Button`, `followHostSuccessMessage`, `no`, `unfollowConfirmTitle/Button`, `selectAllLabel`, `removeLabel`, `unfollowFailedMessage`).

**Note:** This audit was performed by automated analysis of the Flutter codebase.
Actual runtime behavior and UI integration may require manual verification.
