# Kumele — Android/Flutter API Integration Guide

Companion doc for the team building the Android/Flutter module of Kumele. This file lists,
**screen by screen**, exactly which backend endpoints the existing iOS app calls, why, and with
what data — so the Flutter build can replicate the same API integrations without re-deriving them
from the backend spec alone. It was generated 2026-08-04 by reading every relevant View →
ViewModel → Service → `APIConstants` call chain in the iOS source, not by guessing from the API
spec.

**Companion prompt:** [`13_FlutterReplicationMasterPrompt.md`](13_FlutterReplicationMasterPrompt.md) —
a ready-to-paste prompt for kicking off the Flutter implementation work using this file as ground truth.

---

## 1. How to use this document

- Each screen section names its **iOS source file(s)** (for cross-reference only — not portable
  code, just so you can go look at the real behavior if a description is ambiguous) and lists the
  **APIs it calls**, in what order, and what triggers each call.
- "Not called from any screen" sections at the end of each part list endpoints that exist on the
  backend and have a Service method on iOS, but **no UI anywhere calls them today**. Don't spend
  time porting those unless you're building new functionality the iOS app doesn't have yet.
- For full request/response JSON shapes and curl examples for every endpoint, see
  [`08_APICompleteReference.md`](08_APICompleteReference.md) — this file tells you *which*
  endpoint a screen uses and *when*; that file tells you the exact wire format.
- For the raw OpenAPI specs (importable into Postman/Insomnia or for codegen), see
  [`api-reference/openapi.json`](api-reference/openapi.json) (main backend),
  [`api-reference/openapi_ml.json`](api-reference/openapi_ml.json) (AI/ML host),
  [`api-reference/openapi_web3.json`](api-reference/openapi_web3.json) (NFT/Web3 host), and the
  Postman collection in the same folder.

---

## 2. Backend hosts & global conventions

The app talks to **four separate hosts** — get the base URL right per endpoint or nothing will
resolve:

| Host | Base URL | Used for |
|---|---|---|
| Main API | `http://84.247.131.180:3000/api/v1/` | Everything except the three rows below. (Debug and current release build both point at this same HTTP host — there is no HTTPS backend live yet.) |
| AI/ML microservice | `http://84.247.131.180:8080` | `POST /chatbot/ask`, `GET /content-translations/{contentType}/{contentId}` |
| Web3 microservice | `https://kumele-backend.ansht.workers.dev` | NFT `list`/`cancel-listing`/`mint` only (not currently called by any live screen, but exists if you build that UI) |
| Chat WebSocket | `ws://84.247.131.180` (Socket.IO, default `/socket.io/` path) | Real-time chat — see Part B, Chat Conversation |

### Auth model
- Email/password and Google/Firebase login return `{access_token, refresh_token, user_id, ...}`.
  Store both tokens in secure storage (iOS uses Keychain; Android equivalent is
  `flutter_secure_storage` / `EncryptedSharedPreferences`).
- Every authenticated request sends `Authorization: Bearer <access_token>`.
- On a `401` from an authenticated endpoint, call `POST /auth/refresh` with `{refreshToken}`,
  replace the stored tokens with the response, and retry the original request **once**. If refresh
  itself fails, clear the session and route to Login. iOS single-flights concurrent refreshes (if
  five requests 401 at once, only one refresh call fires and the rest wait on it) — worth
  replicating so you don't hammer `/auth/refresh` on a bad-token burst.
- A login/2FA-protected flow can return a `tempToken` field instead of tokens — this means the
  account has 2FA enabled; open the OTP challenge UI and call `POST /auth/2fa/verify` with
  `{code, tempToken}` to actually complete sign-in.

### Response envelope
Endpoints return the payload either as a bare JSON object/array, **or** wrapped as
`{"data": <payload>}`. Try decoding the bare shape first, fall back to unwrapping `data` if that
fails. (iOS does this generically in `APIClient.decode` — one decoder, not per-endpoint special
casing.)

### Error format
On a non-2xx response, the body is typically `{"message": "..."}` or `{"errors": [...]}`
(sometimes nested under `data`). For `400`/`409`/`422`, treat the extracted message(s) as
field/business-rule validation errors to show inline; other codes are generic failures. A `500`
from any `tickets/events/...` path has historically meant "ticket service is down", not a real
client error — surface that distinctly if you see it.

### File uploads
Multipart form POST with a single `file` field: `POST /upload/image` (avatars/general),
`POST /upload/event-banner`, `POST /upload/blog-image`, `POST /upload/nft-image`. Response
contains a `secureUrl`/`url` you then attach to the owning resource in a follow-up call (uploads
don't auto-attach themselves).

### Push notifications
Once notification permission is granted, upload the FCM token via `POST /notifications/push-token`.
This is fire-and-forget, triggered by the OS permission callback, not by any specific screen.

### Passkeys (WebAuthn) — flag for Android
iOS uses native WebAuthn passkeys tied to the `kumele.com` associated domain (relying party ID).
Android has an equivalent (Credential Manager API / Passkeys), but it's a genuinely different
platform integration, not a drop-in port — treat `/auth/passkey/*` endpoints as lower priority
unless Android passkey support is explicitly in scope.

---

## Part A — Auth, Onboarding, Profile & Settings

Scope: sign up/in, password reset, 2FA, passkeys, hobby onboarding, profile view/edit,
follow/followers, security settings, support/legal/guidelines, notification settings & list,
rewards, sign out, delete account.

### Splash / Session Bootstrap

**iOS source:** `SplashScreenView_iPhone.swift` (logic: `SplashSessionBootstrap.swift`, via `AuthViewModel`)
**Purpose:** App-launch screen. Silently checks whether a stored session is still valid and routes straight to the main app or to Login — no user interaction.

| API | Method | Path | Description |
|---|---|---|---|
| Validate session | GET | `/auth/me` | Called only if a stored access token is present. A 401 here is transparently retried once via the refresh-token flow; if that also fails the user is routed to Login. No request body; response is discarded (only success/failure matters). |

---

### Login / Sign In Screen

**Purpose:** Email/password sign-in, "Remember me", Google sign-in, and the entry points into Forgot Password and Passkey sign-in. Also renders a language picker.

| API | Method | Path | Description |
|---|---|---|---|
| Login | POST | `/auth/login` | `{email, password}`. Called when the user taps **Sign in**. On success stores tokens and fetches the profile; if the account's email isn't verified yet it instead triggers `POST /auth/send-verification-email` and opens the OTP sheet. If the account has 2FA enabled, the backend responds with a `tempToken` and the app opens the Two-Factor sheet instead of completing sign-in. |
| Send verification email | POST | `/auth/send-verification-email` | No body (Bearer token from the just-completed login). Fired automatically when `login` reports `emailVerified == false`. |
| Firebase/Google login | POST | `/auth/firebase-login` | `{firebaseToken}`. Called after the native Google Sign-In SDK returns a Firebase ID token. Returns the same token/profile pair as `/auth/login`. |
| Get languages | GET | `/localization/languages` | Public. Populates the horizontal language-choice chips; called on screen load. |
| Get localization strings | GET | `/localization/strings?lang=&namespace=auth` | Public. Fetches translated auth-screen copy for the selected language; re-fetched whenever the user taps a different language chip. |

---

### Sign Up Screen

**Purpose:** Account creation — name, email, gender, DOB, password, referral code, legal/newsletter checkboxes.

| API | Method | Path | Description |
|---|---|---|---|
| Register | POST | `/auth/signup` | `{email, password, firstName, lastName, referralCode}`. Called on **Sign up** tap. On success, tokens are stored and the app immediately calls `PUT /users/profile` if any of gender/DOB were captured, then triggers email verification. |
| Update profile (post-signup) | PUT | `/users/profile` | Sent right after signup, only if gender/DOB/name data exists, to persist `{firstName, lastName, dateOfBirth, gender}`. Response is discarded — the app re-fetches via `GET /users/profile`. |
| Get profile | GET | `/users/profile` | Fetched immediately after signup to populate the local user model. |
| Send verification email | POST | `/auth/send-verification-email` | Fired automatically after signup completes, opening the OTP verification sheet. |

---

### OTP / Email Verification Screen

**Purpose:** User enters the 6-digit code emailed after signup or after a login attempt with an unverified email.

| API | Method | Path | Description |
|---|---|---|---|
| Verify email | POST | `/auth/verify-email` | `{otp}`. Called when the user taps **Ok**. On success the app re-fetches the profile and completes the authenticated session (routes to onboarding or the main app). |

---

### Forgot Password Screen

**Purpose:** Three-step password-reset flow: enter email → enter OTP + new password → confirmation.

| API | Method | Path | Description |
|---|---|---|---|
| Forgot password | POST | `/auth/forgot-password` | `{email}`. Called when the user taps **Ok** on the email step; triggers an OTP email and advances to the code-entry step. |
| Verify reset OTP | POST | `/auth/verify-reset-otp` | `{email, otp}` → returns a one-time `resetToken`. Called on the code step's **Ok**, before the password is actually changed. |
| Reset password | POST | `/auth/reset-password` | `{token, newPassword}`, using the token from the previous call. Completes the flow. |

---

### Two-Factor Authentication — Sign-in Challenge

**Purpose:** Prompts for the 6-digit authenticator code after a password (or passkey-registration) login that requires 2FA.

| API | Method | Path | Description |
|---|---|---|---|
| Verify 2FA | POST | `/auth/2fa/verify` | `{code, tempToken}` — `tempToken` comes from the login response. Called on **Verify** tap. Returns full auth tokens; the app then fetches the profile and completes the session. |

---

### Passkey Sign-in / Setup (Auth flow)

**Purpose:** Sign in with an existing device passkey, or create a new passkey (verifying email+password first if the account isn't yet signed in). See "Passkeys" note in Part 2 above re: Android portability.

| API | Method | Path | Description |
|---|---|---|---|
| Passkey login start | POST | `/auth/passkey/login/start` | `{email}`, public. Returns a WebAuthn challenge + relying-party ID, validated against `kumele.com` before invoking biometric auth. |
| Passkey login finish | POST | `/auth/passkey/login/finish` | `{email, response}` (signed WebAuthn assertion), public. Returns auth tokens on success. |
| Login (pre-passkey-creation) | POST | `/auth/login` | Verifies email/password before offering to create a passkey. If 2FA is enabled, surfaces the 2FA sheet before continuing. |
| Passkey register start | POST | `/auth/passkey/register/start` | `{deviceName}`, authenticated. Returns a WebAuthn registration challenge. |
| Passkey register finish | POST | `/auth/passkey/register/finish` | `{response}` (signed WebAuthn attestation). Completes passkey creation. |

---

### Connect TV (phone-side QR pairing)

**Purpose:** Scans the QR code shown by the Kumele tvOS app and approves that TV's sign-in using the phone's own session. (tvOS-specific — low priority for an Android/Flutter phone app unless a TV companion is planned.)

| API | Method | Path | Description |
|---|---|---|---|
| Claim device | POST | `/auth/device/claim` | `{userCode}` — the code scanned from the TV's QR code, sent with the phone's own Bearer token. Called automatically the instant a QR code is scanned. |

---

### Interest / Hobby Selection (Onboarding)

**Purpose:** First-run onboarding step — pick 3–5 hobbies before entering the app.

| API | Method | Path | Description |
|---|---|---|---|
| Get hobbies | GET | `/hobbies/categories` | Public. Populates the interest grid. |
| Set hobbies | PUT | `/hobbies/users/{userId}` | `{hobbies: [{hobbyId, skillLevel, isPrimary}]}`. Called on **Continue**. On success the app advances to the Earn Medals screen. |

---

### Earn Medals (Onboarding)

**Purpose:** Static informational screen explaining the Bronze/Silver/Gold reward tiers. No API calls — purely local UI.

---

### Profile Setup (Onboarding)

**Purpose:** Collects avatar, username, phone, and a required 200–500 character bio to finish onboarding.

| API | Method | Path | Description |
|---|---|---|---|
| Check username | GET | `/users/check-username?username=` | Debounced (500ms) as the user types; shows available/taken/error under the username field. |
| Upload avatar | POST | `/upload/image` | Multipart form upload (`file` field), only if the user picked a photo. Called as part of **Continue**, before the profile update. |
| Update profile | PUT | `/users/profile` | `{username, avatar, bio, phone}`. Called on **Continue** once any avatar upload finishes. Response is cached locally; the app then routes into the main content screen. |

---

### Filter Hobbies (event search filter)

**Purpose:** A local filter sheet (distance range, age range, paid-only toggle, address/location picker) for the event discovery feed. Makes **no backend API calls** — it only builds a filter value passed back to the caller, which the Home screen then uses to call `GET /events`.

---

### My Profile

**Purpose:** The main Profile tab — avatar, name, bio, personal QR code, follower/following counts, and the Settings menu (Notifications, Payments, Security, Contact, Guidelines, Refer a Friend, Terms, Night Mode, Delete Account, Sign out).

| API | Method | Path | Description |
|---|---|---|---|
| Get profile | GET | `/users/profile` | Loaded on demand by the Profile view model. **As of 2026-08-05** the response also includes `latitude`/`longitude` fields — the Home Feed's on-load prefetch caches this response locally specifically to read those two fields back out as a location fallback tier (see **Home Feed** in Part B); this screen itself doesn't display them. |
| Get QR code | GET | `/users/{userId}/qr` | Called once per screen appearance to render the user's personal check-in QR code as a data-URL image. |
| Follow stats | GET | `/users/{userId}/follow-stats` | Populates the Following/Followers counts shown under the avatar. |
| Followers (page 1) | GET | `/users/{userId}/followers?page=1&limit=50` | Fetched alongside follow stats to seed the counts. |
| Following (page 1) | GET | `/users/{userId}/following?page=1&limit=50` | Same, for the Following count. |

---

### Edit Profile

**Purpose:** Edit the "About" bio and avatar. (Current/New Email and Password fields are rendered but only `about`/avatar are actually wired to Save — email change and inline password change aren't submitted from this screen.)

| API | Method | Path | Description |
|---|---|---|---|
| Get profile | GET | `/users/profile` | Loaded if not already cached, to prefill the current email and bio. |
| Upload avatar | POST | `/upload/image` | Multipart upload, fired immediately when a new photo is picked, followed by a profile update with the returned URL. |
| Update profile (bio) | PUT | `/users/profile` | `{bio}` on **Update Profile** tap; `{avatar}` on photo selection. |

---

### Change Interests (Profile → Hobbies)

**Purpose:** Same hobby-selection grid as onboarding, reused post-signup, plus a language-preference picker.

| API | Method | Path | Description |
|---|---|---|---|
| Get languages | GET | `/localization/languages` | For the language-choice chips. |
| Get hobbies | GET | `/hobbies/categories` | Populates the interest grid, pre-selecting the user's existing hobbies. |
| Set hobbies | PUT | `/hobbies/users/{userId}` | `{hobbies: [...]}`. Part of **Save**. |
| Update profile (language) | PUT | `/users/profile` | `{preferredLanguage}`. Also part of **Save**, sent right after the hobbies update. |

---

### Follow / Followers List

**Purpose:** Toggle between Followers/Following lists, remove individual followers or bulk-remove via multi-select edit mode.

| API | Method | Path | Description |
|---|---|---|---|
| Get profile | GET | `/users/profile` | Called once on first load to resolve the current user's ID. |
| Follow stats | GET | `/users/{userId}/follow-stats` | Loaded alongside the two lists on initial load and retry. |
| Followers | GET | `/users/{userId}/followers?page=1&limit=50` | Loaded on initial load, retry, and Followers tab switch. |
| Following | GET | `/users/{userId}/following?page=1&limit=50` | Same, for the Following tab. |
| Unfollow | DELETE | `/users/{userId}/follow` | Called once per selected user on removal confirm (looped for multi-select). `{userId}` here is the *target* being unfollowed. |

---

### Security Settings

**Purpose:** Landing page (navigation menu, no API calls itself) for Change Password, Passkeys, Two-Factor Authentication, and Connect TV.

#### Change Password
| API | Method | Path | Description |
|---|---|---|---|
| Change password | POST | `/auth/change-password` | `{currentPassword, newPassword}`. Called on **Update Password** (client validates the new-password fields match and are ≥8 characters first). |

#### Passkeys row
| API | Method | Path | Description |
|---|---|---|---|
| Passkey register start | POST | `/auth/passkey/register/start` | `{deviceName}`. Called on **Create** tap. |
| Passkey register finish | POST | `/auth/passkey/register/finish` | `{response}`. Completes passkey creation for the already-authenticated account. |

#### Two-Factor Authentication row
| API | Method | Path | Description |
|---|---|---|---|
| Get profile | GET | `/users/profile` | Loaded on appear to read `twoFactorEnabled` and drive the toggle's initial state. |
| Setup 2FA | POST | `/auth/2fa/setup` | No body. Called when the toggle is switched **on**; returns a QR code/secret to scan into an authenticator app. |
| Enable 2FA | POST | `/auth/2fa/enable` | `{code}` — the 6-digit authenticator code. Called on the setup sheet's **Enable** tap. |
| Disable 2FA | POST | `/auth/2fa/disable` | `{code}`. Called when the toggle is switched **off** and confirmed with a current code. |

#### Connect TV row
See **Connect TV (phone-side QR pairing)** above.

---

### Contact / Support

**Purpose:** Submit a support message under a reason category (Business/Complaint/Improvement) with a free-text comment (min. 20 characters).

| API | Method | Path | Description |
|---|---|---|---|
| Create support ticket | POST | `/support/tickets` | `{subject, description, category}` — `category` is mapped client-side (`"Improvement"` → `feature_request`, everything else → `other`). Called on **Send**. |

---

### Guidelines (Community / How To / Popular / Knowledge Base)

**Purpose:** A 4-tab screen — three static CMS-backed content tabs, plus an AI chat tab ("Knowledge Base").

| API | Method | Path | Description |
|---|---|---|---|
| Get legal document (guidelines) | GET | `/legal/type/guidelines` | Public. Loaded when the **Community Guidelines** tab is first shown. |
| Get legal document (how-to) | GET | `/legal/type/how_to` | Public. Loaded when the **How to** tab is first shown. |
| Get legal document (popular) | GET | `/legal/type/popular` | Public. Loaded when the **Popular** tab is first shown. |
| Chatbot ask | POST | `/chatbot/ask` | **Runs on the AI/ML host** (`http://84.247.131.180:8080`), not the main backend. `{userId, query}` → `{answer}`. Called every time the user sends a message in the **Knowledge Base** tab; the transcript is not persisted server-side. |

---

### Terms & Conditions / Legal

| API | Method | Path | Description |
|---|---|---|---|
| Get legal document (terms) | GET | `/legal/type/terms` | Public. Loaded once on screen appear (and via retry on failure). |

---

### Refer a Friend

**Purpose:** Shows the user's referral code with copy/share actions.

| API | Method | Path | Description |
|---|---|---|---|
| Get profile | GET | `/users/profile` | Called on screen appear; the referral code shown is `profile.referralCode` from this response (the dedicated `GET /users/referral-code` endpoint is **not** used for this screen). |

---

### Notification Settings

**Purpose:** Toggle push notifications (deep-links to OS Settings) and an E-Mail notifications toggle. **No backend API calls** on this screen — push authorization is read/requested locally, and the E-Mail toggle is local-only UI state (not persisted to the backend).

Note: once push permission is granted (anywhere in the app), the FCM token is uploaded via `POST /notifications/push-token` — triggered by the OS permission callback, not by a control on this screen.

---

### Notifications List

**Purpose:** Paginated, sectioned (Created Events / Matched Events / Other) notification feed, interleaved with in-feed ads; tapping a row routes to the relevant detail (event join, blog comments, birthday, cancellation, reward).

| API | Method | Path | Description |
|---|---|---|---|
| Get notifications | GET | `/notifications?page=&limit=100` | Called on load (page 1) and again via infinite scroll while more pages remain. |
| Mark notification read | POST | `/notifications/{id}/read` | Called when a row is tapped, before routing to that notification's detail. Skipped if already read. |
| Fetch ads | GET | `/ads/fetch?placement=notifications` | Called once per load, interleaved into the section lists (roughly every 3rd item). |
| Track ad impression | POST | `/ads/track` | `{adId, campaignId, impressionId, eventType: "view", placement: "notifications"}`. Fired once per ad the first time it becomes visible. |
| Track ad click | POST | `/ads/track` | Same shape with `eventType: "click"`. Fired when an inline ad card is tapped. |
| Unread count refresh | GET | `/notifications?page=1&limit=1` | Called on screen dismiss purely to refresh the tab-bar unread badge count, not the feed itself. |

Note: there is no backend endpoint to delete a single notification — the trash icon on a resolved row only removes it from the current in-memory list, not the server.

---

### Ad Detail

**Purpose:** Full-screen expansion of a tapped in-feed ad. Makes **no API calls directly** — tracking happens on the inline card before this screen is presented.

---

### Birthday / Event-Cancelled / Reward Notification Popups

**Purpose:** Static celebratory/informational popups shown from a notification row tap. No API calls — content is parsed client-side from the already-fetched notification's title/message.

---

### Rewards (Reward Rings)

**Purpose:** Renders the Bronze/Silver/Gold medal-count rings (shown on the History & Statistics screen — see Part B).

| API | Method | Path | Description |
|---|---|---|---|
| Get user rewards | GET | `/users/{userId}/rewards` | Called once when the rings first appear; returns `{gold, silver, bronze}` counts. |

---

### Sign Out

| API | Method | Path | Description |
|---|---|---|---|
| Logout | POST | `/auth/logout` | No body. Called on **Signout** confirm. Clears local tokens/cache regardless of response (best-effort), then routes to Login. |

---

### Delete Account

| API | Method | Path | Description |
|---|---|---|---|
| Delete account | POST | `/privacy/delete` | `{password, reason: "User requested account deletion", confirmation: true}`. Called on **Delete** confirm. On success clears the local session and routes to onboarding/login. |

---

### Part A — endpoints referenced but not called from any screen

Exist in the auth/profile/notification services and are wired into `APIConstants`, but nothing in
this domain currently triggers them:

- `POST /auth/resend-verification` — OTP screen only resends via `POST /auth/send-verification-email`.
- `POST /auth/logout-all` — every call site passes "single device" only.
- `GET /users/referral-code`, `GET /users/referrals`, `GET /users/follow/suggestions` — implemented, unused.
- `POST /notifications/read-all` — no "mark all read" control exists anywhere in the UI.

---

## Part B — Home, Events, Chat, History & Tab Bar

All authenticated calls send `Authorization: Bearer <accessToken>`; a 401 triggers an automatic
`POST /auth/refresh` + retry once (see Part 2).

### Home Feed (event swipe deck)

**Purpose:** The main landing tab. Shows nearby events as a swipeable card deck (interleaved with ads); a search bar filters already-loaded events client-side; swiping right joins an event, swiping left dismisses it from the deck.

**On-load prefetch (as of 2026-08-05):** the moment Home appears, it fires four best-effort,
fire-and-forget calls in parallel (`EventViewModel.prefetchHomeDependencies()`) — failures are
silently swallowed, nothing blocks the main feed load on these:
- `GET /users/profile` — result is cached to local storage (the `"user"` key) purely so its
  `latitude`/`longitude` can serve as a location fallback (see below); not otherwise consumed here.
- `GET /hobbies/categories` — warms the cache other screens read from.
- `GET /notifications?page=1&limit=100` — warms the notifications cache.
- `GET /ads/campaigns?page=1&limit=20` (`AdCampaignService.listCampaigns`) — response is currently
  discarded entirely; this is a warm-up call with no visible effect yet. (This is the **one** live
  caller of `AdCampaignService` in the whole app — see the Part C note below, which corrects an
  earlier "fully dead code" read on this service.)

**Location resolution** now has three tiers, checked in order: a live GPS fix →
`GET /users/profile`'s cached `latitude`/`longitude` (from the prefetch above, read out of local
storage, not a fresh network call) → a hardcoded fallback coordinate. The `city` query param that
used to accompany the event-list call has been dropped — only lat/lng/radius are sent now.

| API | Method | Path | Description |
|---|---|---|---|
| Event list (geo) | GET | `/events?centerLat=&centerLon=&radiusKm=&limit=10` | Fetches nearby events by lat/lng within a 28km radius (previously 100km — tightened). Called on first load with the resolved location (GPS → cached profile → fallback, see above), and again once a real GPS fix lands. |
| Event recommendations | GET | `/events/recommendations?limit=10` | "Matched" events for the user (limit lowered from 20), fetched in parallel with the list above. |
| Host's own events | GET | `/events?limit=10` (filtered by `hostId`) | Events the current user is hosting, fetched alongside the two calls above. |
| Ads fetch | GET | `/ads/fetch?placement=HOME&limit=1` | Fetches ad creatives merged into the feed. Placement value changed from `EVENT_DECISION` to `HOME`; now caps to 1 ad per fetch via the new `limit` param. |
| Ad impression track | POST | `/ads/track` | `{placement: "HOME", eventType: "view", ...}` — fired once per ad the first time it becomes visible in the deck. |
| Ad click track | POST | `/ads/track` | Same shape, `eventType: "click"` — fired when an ad card is tapped. |
| Join event | POST | `/events/{id}/join` | Triggered by swiping a card right. No payment step is wired into this swipe path even for paid events (see **Event Join / RSVP** below for the flow that handles payment). |
| Unread chat status (per event) | GET | `/events/{eventId}/chat/status` | **New**: whenever the loaded event lists (feed/matched/owned) change, the app loops over every event id and checks `messageCount > 0` on each, to drive the tab-bar unread-chat badge (see **Bottom Tab Bar** below). Sequential, one call per event id — no batching. |

---

### Event Detail (expanded card)

**Purpose:** Full event details: description, host profile, price/date/location, past ratings and reviews, and other events by the same host. Ends with a "Join" action.

| API | Method | Path | Description |
|---|---|---|---|
| Event detail | GET | `/events/{id}` | Fetches full event fields once the card is opened. |
| Content translation | GET | `/content-translations/{contentType}/{contentId}` (AI/ML host) | If the signed-in user has a `preferredLanguage` set, translates the event's `name`/`description` into it (`contentType=event`). |
| Rating summary | GET | `/events/{id}/ratings/summary` | Average overall rating + per-category sub-averages (communication, respect, professionalism, atmosphere, value-for-money) and verified-attendee percentage. |
| Ratings list | GET | `/events/{id}/ratings` | Individual reviews with comments. |
| Host profile | GET | `/users/{id}/host-profile` | Host's display info shown on the detail card. |
| Other events by host | GET | `/events` (filtered by `hostId`, limit 10) | "More from this host" row, excludes the currently-viewed event. |
| Join event | POST | `/events/{id}/join` | Same as Home Feed. |

---

### Event Join / RSVP

**Purpose:** A confirmation modal showing event summary with a "Join now" button (reached from a matched-event notification tap). For a free event, joining is a single API call; for a paid event, a successful join is immediately followed by a PayPal checkout.

| API | Method | Path | Description |
|---|---|---|---|
| Join event | POST | `/events/{id}/join` | Called first, regardless of payment type. |
| PayPal create order | POST | `/payments/paypal/create-order` | `{eventId, discountCode?}` — only called if the event requires payment and the join succeeded. Returns an `approvalUrl` that opens PayPal's hosted checkout. |
| PayPal capture | POST | `/payments/paypal/capture/{orderId}` | Called once the PayPal approval sheet is dismissed (PayPal has no in-app callback); the response status decides whether the charge actually succeeded. |

Note: this PayPal-on-join flow is only wired from the Notifications screen's "Join now" — the Home
Feed's swipe-right join does **not** currently trigger payment for paid events, even though this
confirmation UI is shared.

---

### Create Event (multi-step)

**Purpose:** Host fills in event category, name/description, date/time, address, cover photo, capacity (guest count), age range, and free/paid pricing, then previews and submits.

| API | Method | Path | Description |
|---|---|---|---|
| Hobby categories | GET | `/hobbies/categories` | Populates the "Event Category" chip selector. |
| Event plans (capacity tiers) | GET | `/event-plans` | Fetches the capacity→price tier table; drives both the "Guest Prices" info popup and the max guest count the picker allows. |
| Event plan quote | GET | `/event-plans/quote?capacity=` | Debounced (350ms) live price preview as the host drags the guest-count wheel. Preview only; the real charge happens after the event is created. |
| Create event | POST | `/events` | Submits title, description, hobby category, start/end time (ISO 8601), capacity, paid flag + price, and geocoded lat/lng/address (geocoding is done on-device, not an API call). Called from the final Preview step, not the form itself. |
| Upload event banner | POST | `/upload/event-banner` | Multipart image upload, called right after `POST /events` succeeds if a cover photo was picked; the event is then re-fetched since creation doesn't return the uploaded banner URL. |
| Event-creation payment (Stripe) | POST | `/payments/event-creation/{eventId}` | If the chosen capacity tier requires payment, tried first for the host's capacity-plan fee. Falls back to PayPal automatically if Stripe can't start. |
| Payment confirm (Stripe) | POST | `/payments/confirm` | Confirms the capacity-tier charge server-side after Stripe's payment sheet reports success — this is what actually publishes the event (DRAFT → ACTIVE). |
| PayPal create order (event creation) | POST | `/payments/paypal/event-creation/{eventId}` | Fallback if Stripe fails to start or its charge fails. |
| PayPal capture (event creation) | POST | `/payments/paypal/capture/{orderId}` | Captures the plan-fee PayPal order once its approval sheet closes; also what publishes the event on this rail. |

---

### Event Check-in (host QR scan) — "Guest scan"

**Purpose:** Host-facing screen listing all guests for the event with a per-guest "Check in" button, reached from the Chat room's overflow menu.

| API | Method | Path | Description |
|---|---|---|---|
| Guest list | GET | `/events/{id}/guests` | Full guest list for the event, loaded once when the tab appears. |
| Host check-in | POST | `/events/{id}/checkin/host-scan` | `{guestUserId, note?}`. Marks a specific guest checked in when the host taps "Check in" next to their name. |

Note: `POST /events/{id}/checkin/self` (self-check-in) exists on the backend but has **no UI
anywhere in the iOS app** — no screen calls it today.

---

### Event Rating

**Purpose:** Star-rating form across 5 categories (communication, respect, professionalism, atmosphere, value-for-money) plus a free-text comment, submitted after the event's rating window opens.

| API | Method | Path | Description |
|---|---|---|---|
| Submit rating | POST | `/events/{id}/ratings` | `{eventRating, comment, communication, respect, professionalism, atmosphere, valueForMoney}` — `eventRating` is the rounded average of the 5 category scores (each clamped 1–5). Blocked client-side until the event's `ratingAvailableAt` time has passed. |

---

### Event Report

**Purpose:** Lets a guest report an event/host for a selected reason (Racist / Scam / Physical assault / Other) with optional details.

| API | Method | Path | Description |
|---|---|---|---|
| Submit report | POST | `/events/{id}/reports` | `{reason, details}`. |

---

### Chat Room List

**Purpose:** Lists every event-chat room the user belongs to (one per joined/hosted event); tapping a row opens that room's conversation. Pull-to-refresh reloads.

| API | Method | Path | Description |
|---|---|---|---|
| List chat rooms | GET | `/chat/rooms` | Returns each room's title, host, open/closed status, rating-availability time, etc. Called on load (cached after first load unless force-refreshed, e.g. pull-to-refresh). |

---

### Chat Conversation

**Purpose:** Real-time message thread for one event's chat room — message history, live incoming messages, typing indicators, and join/leave presence notices.

**WebSocket connection.** Connects to `ws://84.247.131.180`, using Socket.IO's default
`/socket.io/` engine path. Auth is a `Bearer <accessToken>` header set at connect time;
auto-reconnect with unlimited attempts and 1–10s backoff is recommended.

| Event / API | Direction | Description |
|---|---|---|
| `joinRoom` (emit `{eventId}`) | Send | Emitted once connected (or immediately re-emitted after any reconnect) for the currently-open event's chat room. |
| `leaveRoom` (emit `{eventId}`) | Send | Emitted when leaving the conversation screen or switching rooms. |
| `typing` (emit `{roomId}`) | Send | Emitted (rate-limited to once/second) while the user is typing. |
| `newMessage` | Receive | A new chat message from another user (or an echo of your own) — append, deduplicated by message id. |
| `userTyping` | Receive | Another user is typing — show as "X is typing…" for ~2.5s. |
| `userJoined` / `userLeft` | Receive | Presence notices. |
| Fetch message history | GET `/events/{eventId}/chat/messages` | Loads existing history when the room is opened, and again (silently) right after sending a message. |
| Send message | POST `/events/{eventId}/chat/messages` | `{content}`. Posts the composed text; the REST response is appended immediately, then history is silently re-fetched as a consistency check. |

Note: actual room join/membership happens via the `joinRoom` socket event — the REST
`POST /events/{eventId}/chat/join` endpoint exists but has no call site in the iOS app; rooms
appear to auto-create/auto-join via the socket flow in practice.

---

### Chat QR Code (host identity QR)

| API | Method | Path | Description |
|---|---|---|---|
| User QR code | GET | `/users/{id}/qr` | Fetches the current (host) user's own QR as a base64 data-URL, for guest identity verification/check-in. |

---

### Guest Scan Confirmation

**Purpose:** A static confirmation popup shown after a guest QR "scan" — no API calls, pure local UI.

---

### Follow Host (popup)

**Purpose:** Small confirmation popup letting the user follow the event's host directly from the chat room menu.

| API | Method | Path | Description |
|---|---|---|---|
| Follow user | POST | `/users/{id}/follow` | Follows the host whose id is embedded on the current chat room object. |

---

### History / Stats Dashboard

**Purpose:** Shows the user's reward-medal breakdown (gold/silver/bronze pie chart) and a monthly bar chart of event activity/money earned for a selectable year; tapping a bar shows that month's real events.

| API | Method | Path | Description |
|---|---|---|---|
| Monthly stats | GET | `/users/me/stats/monthly?year={year}` | Returns `{year, months: [{label, month, value, eventCount, attendedCount, totalSpendEur, events: [...]}]}`. Drives the bar heights, the "Money Earned" total, and the per-month tooltip. Re-fetched whenever the year dropdown changes. |
| Reward rings | GET | `/users/{id}/rewards` | Feeds the gold/silver/bronze medal pie chart at the top of the screen. |

Note: `GET /users/me/stats` (the non-monthly summary endpoint) is implemented but not consumed by
this screen.

---

### Bottom Tab Bar (badge counts)

**Purpose:** Persistent bottom navigation (Home / Blog / More / Shop / Profile) with an unread-count badge on the "More" tab (which houses Notifications and, as of 2026-08-05, a chat-unread signal too).

| API | Method | Path | Description |
|---|---|---|---|
| Unread notification count | GET | `/notifications?page=1&limit=1` | Reads only `unreadCount` off the paginated envelope (fetches 1 item just to get the count cheaply). Called on leaving the Notifications screen, not on every tab-bar render; failures are silent and the badge keeps its last known value. |
| Unread chat status (per event) | GET | `/events/{eventId}/chat/status` | **New.** Called once per event id the user belongs to (from Home's currently-loaded feed/matched/owned lists) whenever those lists change — not paginated/batched, one request per event. The badge is a boolean, not a real count: the first event whose `messageCount > 0` flips it on. Combined with the notification count to decide whether the "More" tab shows a dot (iPhone tab bar) or a numeric badge (the in-menu "Notifications" row specifically). |

Note: the unread-chat check reuses the same `APIChatStatus` model/endpoint documented under **Chat
Conversation** below (`GET /events/{eventId}/chat/status` was previously implemented but had no
caller — it now does, for this badge specifically, not for anything inside the chat screen itself).

---

### Part B — endpoints referenced but not called from any screen

- `POST /events/{id}/checkin/self` — implemented, no UI.
- `POST /events/{eventId}/chat/join` — room join happens via the socket event instead.

---

## Part C — Shop, Payments, Cart, NFTs, Blog & Ads

> **Subscriptions status (read this first):** On 2026-07-30 the app migrated subscription
> *purchases* off Stripe onto Apple StoreKit 2 (native IAP). This is **iOS-specific** — Android's
> equivalent is Google Play Billing, a different SDK entirely. The old Stripe subscription-create
> REST call (`POST /subscriptions`) is dead/orphaned on iOS. The one backend call that *is*
> platform-agnostic is the receipt-verify step (`POST /subscriptions/apple/verify` on iOS) — Android
> will need its own equivalent verify endpoint for Play Billing purchase tokens; check with backend
> whether that already exists or needs to be added, don't assume `apple/verify` is reusable as-is.

### Subscription Plans

**Purpose:** User browses subscription tiers and purchases one via the platform's native in-app-purchase flow (StoreKit on iOS; Play Billing on Android).

| API | Method | Path | Description |
|---|---|---|---|
| Subscription tiers | GET | `/subscriptions/tiers` | Public. Returns the list of subscription tiers with name, description, features, price, and a platform product id (`appleProductId` on iOS — Android will need the equivalent Play product id field). Called on screen load. |
| Subscription status | GET | `/subscriptions/status` | Returns the caller's current subscription (active tier, store credit balance/currency). Called on screen load and again after a purchase or restore completes. |
| Verify purchase | POST | `/subscriptions/apple/verify` (iOS) | Body: `{"signedTransactionInfo": "<JWS>"}` — the signed transaction the platform IAP SDK hands back after purchase. Backend verifies against the platform's servers and derives tier/expiry itself. Called immediately after a successful purchase, and again silently on load to reconcile restored purchases. **Confirm with backend whether an Android/Play-Billing equivalent of this route exists before building the Android purchase flow** — do not assume the same path works for a Play purchase token. |

Not called by iOS (implemented, no UI): `DELETE /subscriptions` (cancel), `POST /subscriptions/resume`,
`GET /subscriptions/history` — cancellation for IAP goes through the platform's own subscription
management UI, not a REST call. `POST /subscriptions` (Stripe-era create) is dead code.

---

### Guest Tickets List

**Purpose:** User views tickets they hold as a guest for paid events they've joined, and can cancel one.

| API | Method | Path | Description |
|---|---|---|---|
| My tickets | GET | `/tickets/my?page=1&limit=50` | Paginated list of the current user's tickets. **As of 2026-08-05** each ticket in the response embeds its own event summary directly (`event: {id, title, startsAt, address}`) — the app no longer does a separate `GET /events/{id}` per ticket to backfill the title/date the way it briefly did before; the response decoder tolerates either a bare array or a paginated `{tickets/items/results/data, page, limit, total, hasMore}` envelope, so don't assume one fixed shape. Called when this tab is first selected, in parallel with the event-plans call below. |
| Event plans | GET | `/event-plans` | **New (2026-08-05).** Fetched alongside the ticket list but **not yet displayed anywhere on this screen** — likely groundwork for showing ticket price-tier info later. Don't treat its absence from the visible UI as a bug to fix; it's a genuine fetch-ahead-of-need. |
| Cancel ticket | DELETE | `/tickets/{id}` | Cancels a single ticket by id; removed from the local list on success. |

---

### NFT Marketplace / Rewards / Claimed

**Purpose:** Three sub-tabs — Rewards (unclaimed NFT rewards earned), Claimed (NFTs owned), and Market Place (NFTs available to buy). Supports claiming a reward NFT and buying a marketplace NFT; a pending on-chain transaction opens a wallet app (Phantom on iOS) for signing.

**Note on hosts:** most NFT endpoints below hit the main API host, but `list`/`cancel-listing`/`mint`
live on the **separate Web3 microservice** (`https://kumele-backend.ansht.workers.dev`) and aren't
currently called from any screen — flag only if a "list my NFT for sale" screen is planned.

| API | Method | Path | Description |
|---|---|---|---|
| Reward NFTs | GET | `/nfts/rewards` | NFTs the user has earned but not yet claimed. Loaded when the Rewards sub-tab appears. |
| Claimed NFTs | GET | `/nfts/mine` | Paginated list of NFTs the user owns. Loaded when the Claimed sub-tab appears, and refreshed after a claim or purchase. |
| Marketplace NFTs | GET | `/nfts/marketplace` | Public, paginated (page/limit, default page 1 / limit 20) list of NFTs for sale. |
| Claim NFT | POST | `/nfts/{id}/claim` | Claims a reward NFT into the user's collection; reloads rewards + claimed lists on success. |
| Purchase NFT | POST | `/nfts/{id}/purchase` | Body: `{transactionRef, walletAddress}` (both currently sent as `null` on iOS — no wallet SDK fully wired yet). If the response includes a base64 blockchain transaction, the UI surfaces a "sign in wallet app" step; otherwise reloads marketplace + claimed lists. |

---

### Cart / Checkout

**Purpose:** User reviews items (products/subscription tiers) added to their cart, adjusts quantities, removes items, or clears the cart. **Note:** on iOS the discount-code "Apply" and "Pay now" buttons are currently disabled — checkout isn't wired up yet, only cart CRUD is live. Decide whether to build checkout for real on Android or match the same "not yet" state.

| API | Method | Path | Description |
|---|---|---|---|
| Get cart | GET | `/cart` | Returns the full cart with items, totals, and currency. Called on screen appear and pull-to-refresh, in parallel with the reward-discounts call below. |
| Reward discounts | GET | `/discounts/rewards` | **New (2026-08-05).** Fetched alongside the cart on every load. Response is decoded loosely (untyped JSON) rather than into a fixed model — the shape isn't fixed/consumed by UI yet, so treat this as "fetch and hold," not a finalized contract. Best-effort: a failure here doesn't block the cart from showing. |
| Add cart item | POST | `/cart/items` | `{productId, quantity}`. (No "Add to Cart" entry point exists in the iOS app today — cart items originate elsewhere or this is currently review/edit-only.) |
| Update cart item quantity | PUT | `/cart/items/{id}` | `{quantity}`. Triggered by a +/− stepper; quantity 0 triggers a remove instead. |
| Remove cart item | DELETE | `/cart/items/{id}` | Triggered by a row's trash-icon button. |
| Clear cart | DELETE | `/cart` | Triggered by "Clear All" with a confirmation dialog. |

---

### Saved Cards

**Purpose:** User views payment history and saved cards, sets a default card, deletes a card, and can view escrow status for a selected payment. This flow stayed on Stripe — it was explicitly untouched by the subscriptions→StoreKit migration.

| API | Method | Path | Description |
|---|---|---|---|
| List saved cards | GET | `/payments/cards` | Returns the user's saved cards (brand, last 4, expiry, default flag). |
| Set default card | PATCH | `/payments/cards/{id}/default` | Marks a card as default; triggered by tapping a card's radio circle. |
| Delete card | DELETE | `/payments/cards/{id}` | Removes a saved card. |
| Payment history | GET | `/payments/history` | Paginated (page/limit, default limit 50) list of past payments (amount, provider, status, date). Called in parallel with the reward-discounts call below. |
| Reward discounts | GET | `/discounts/rewards` | **New (2026-08-05).** Same call/response shape as the Cart screen's version above (loosely-typed JSON, not yet consumed by any specific UI element on this screen either) — fetched alongside payment history on load. |
| Escrow status | GET | `/payments/{id}/escrow` | Returns escrow status for a selected payment. |

---

### Add Card

**Purpose:** User adds a new payment card via Stripe's native card-entry sheet (card number never touches app/servers directly). Android would use Stripe's Android SDK equivalent (PaymentSheet).

| API | Method | Path | Description |
|---|---|---|---|
| Create card SetupIntent | POST | `/payments/cards/setup-intent` | Requests a Stripe SetupIntent client secret, used to drive Stripe's native card-entry sheet (not itself a card-data-carrying call). |
| Save card | POST | `/payments/cards` | Body: `{setupIntentId}`. Called once Stripe's SDK confirms the SetupIntent client-side — persists the resulting card, then the Saved Cards list is reloaded. |

---

### Event Ticket Purchase (PayPal Checkout)

**Purpose:** After a user joins a paid event, this drives paying for the guest ticket via PayPal — the only payment provider that completes end-to-end for event tickets today (PayPal hosts its own approval page in an in-app browser, so no card data or payment SDK is needed client-side).

| API | Method | Path | Description |
|---|---|---|---|
| Create PayPal order | POST | `/payments/paypal/create-order` | Body: `{eventId, discountCode?}`. Creates a PayPal order for the event and returns an approval URL. Triggered right after a successful paid-event join. |
| Capture PayPal order | POST | `/payments/paypal/capture/{orderId}` | Called once the user dismisses PayPal's approval page (no in-app callback exists, so capture is unconditional and the resulting status decides success/failure). |

**Implemented but not currently reachable from any wired UI** — port only if you're building the flow fresh:
- `POST /payments/event` + `POST /payments/confirm` — Stripe PaymentIntent path for event tickets (PayPal already covers this end-to-end, so it was never wired).
- `GET /payments/paypal/status/{orderId}` — no caller.
- `POST /payments/event-creation/{eventId}` / `POST /payments/paypal/event-creation/{eventId}` — these are the **host-side** "pay to publish an event with more capacity" checkout (see Create Event in Part B), a different flow from guest-ticket purchase.
- `GET /refunds/eligibility/{paymentId}`, `POST /refunds`, `GET /refunds/my-requests` — fully implemented backend-side, **no refund UI exists anywhere in the app**. Flag as backend-ready-but-unbuilt if a refund screen is planned for Android.

---

### Blog List

**Purpose:** User browses blog posts, filters by hobby category (chips derived from the user's own hobbies) or a local text search, and taps a post to open its detail.

| API | Method | Path | Description |
|---|---|---|---|
| Blog feed | GET | `/blogs/feed?limit=50` | Public. Add `hobbyCategoryId` when a category chip other than "All" is selected. Returns post list (title, excerpt, author, thumbnail). Called on load and whenever the category filter changes. Text search is filtered client-side against the already-fetched list, not a separate call. |

---

### Blog Detail

**Purpose:** User reads a full blog post (banner image, HTML content, social links), likes/unlikes it, and posts or replies to comments.

| API | Method | Path | Description |
|---|---|---|---|
| Blog detail | GET | `/blogs/{id}` | Public. Fetched in parallel with comments when the screen opens. |
| Blog comments | GET | `/blogs/{id}/comments?limit=50` | Public. Fetched in parallel with the detail call above. |
| Post comment | POST | `/blogs/{id}/comments` | Body: `{content, parentId?}` — `parentId` set when replying to an existing comment (threaded). |
| Like/unlike blog | POST | `/blogs/{id}/like` | Toggles like state. UI updates optimistically; reverted if the call fails. |

---

### Ad Banner Display (swipe card & inline card)

**Purpose:** Renders a sponsored ad (as a swipeable full card or a small inline card) inline in other feeds (Home swipe deck, Notifications list), with "Sponsored" labeling and a call-to-action.

| API | Method | Path | Description |
|---|---|---|---|
| Fetch ads | GET | `/ads/fetch` | Query: optional `placement`, optional `limit` (added 2026-08-05 — Home now requests `limit=1`). Returns ads for a given placement/context. Called by the hosting screen before rendering these components. |
| Track ad event | POST | `/ads/track` | Body: `{adId, campaignId, impressionId, eventType, placement, hobbyContext?}`. Fired automatically on card appear (`eventType: "impression"`) and on CTA/card tap (`eventType: "click"`). Best-effort/fire-and-forget — failures should be logged, never surfaced to the user. Note the Home feed's placement value changed from `EVENT_DECISION` to `HOME` on 2026-08-05 — check which screen is embedding the card before assuming a placement string. |

**Correction (2026-08-05) — `AdCampaignService` is no longer fully dead code.** The Home Feed's
on-load prefetch (see **Home Feed** in Part B) now calls `GET /ads/campaigns?page=1&limit=20`
(`AdCampaignService.listCampaigns`) as one of four background warm-up calls — but the response is
discarded entirely, nothing reads it yet. So: the *service call* is live, but there is still
**no screen anywhere that displays or acts on campaign data**, and `AdCampaignViewModel` (the
would-be advertiser dashboard) remains entirely unused. The rest of the campaign-management API
(`POST/GET/PUT /ads/campaigns`, `GET /ads/campaigns/{id}`, `GET /ads/dashboard/stats`,
`POST/PUT/DELETE /ads`, `GET /ads/{id}`) is still unreferenced. Bottom line for porting: don't
build an advertiser dashboard off this, but do replicate the harmless prefetch call if you're
mirroring iOS's warm-up behavior exactly.

---

### Part C — endpoints referenced but not called from any screen

- `POST /subscriptions` (Stripe-era create), `DELETE /subscriptions`, `POST /subscriptions/resume`, `GET /subscriptions/history`.
- `POST /payments/event`, `POST /payments/confirm`, `GET /payments/paypal/status/{orderId}`.
- `GET /refunds/eligibility/{paymentId}`, `POST /refunds`, `GET /refunds/my-requests`.
- NFT `list`/`cancel-listing`/`mint` (Web3 host).
- The full `AdCampaign*` endpoint group **except** `GET /ads/campaigns` (list), which Home now
  calls as a discarded-response prefetch as of 2026-08-05 — see the correction note under **Ad
  Banner Display** above. Still no screen displays campaign data.
- `POST /cart/items` (no "Add to Cart" entry point in the current UI).

---

## 3. Summary — what to build first

If you're sequencing the Flutter build, the highest-value order (most-used, least platform-specific first) is roughly:

1. **Networking foundation** — base client, token storage/refresh, envelope/error handling (Part 2).
2. **Auth** — login/signup/OTP/forgot-password (skip passkeys initially — platform-specific, low priority).
3. **Onboarding** — hobbies, profile setup.
4. **Home feed + Event detail + Join** (no payment first, add PayPal after).
5. **Profile + Follow + Settings** (skip 2FA/passkey rows initially if time-constrained).
6. **Chat** (REST history/send first; Socket.IO real-time layer can follow).
7. **Create Event.**
8. **Notifications + Tab bar badge.**
9. **Shop/NFTs/Blog/Ads** — lowest urgency; several sub-flows here are unwired even on iOS (checkout, refunds, ad campaigns) so there's no working reference behavior to match for those specifically.
