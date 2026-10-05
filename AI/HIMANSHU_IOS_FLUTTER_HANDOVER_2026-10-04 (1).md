# Kumele iOS and Flutter Handover - Himanshu

Date: 2026-10-04  
Owner: Himanshu  
Scope: native iOS and Flutter client integration only

## Current Server Contract

- Production API: `https://api.kumele.com/api/v1`
- Swagger: `https://api.kumele.com/docs`
- OpenAPI: `https://api.kumele.com/docs-json`
- The deployed API is healthy. Fresh probes returned HTTP 200 for health, readiness, events, categories, blogs, NFT marketplace, subscription tiers, event plans, and Solana fee quotes. The readiness route is `GET /api/v1/health/ready`; `/api/v1/ready` is not a valid route.
- Protected routes return HTTP 401 without a bearer token; this is correct behavior.
- Flutter Android application ID is `com.kumele.hobbies`. Do not change it to `com.kumele.app`; the Kotlin namespace/activity may remain `com.kumele.app`.

## Client Rules

1. Use the backend response as the authority for matching order, ad selection, payment state, rating aggregates, NFT state, eligibility, and moderation.
2. Never rerank matched events or locally reproduce the matching algorithm.
3. Never call Stripe or PayPal secret/server APIs, Solana RPC, Helius, or the mint worker directly from a mobile client. The approved mobile payment path is the Stripe client SDK/Payment Sheet initialized only with client-safe data returned by Kumele's backend, or the backend-created PayPal approval URL.
4. Attach `Authorization: Bearer <access-token>` to every protected route. On 401, refresh once or return to sign-in; do not silently show fixtures as live data.
5. Preserve backend ISO-8601 timestamps and EUR minor-unit prices.

## Required API Integration

| Feature | Method and route | Auth | Mobile behavior |
|---|---|---:|---|
| Health | `GET /health` | No | Diagnostics only; do not poll from every screen |
| Firebase sign-in | `POST /auth/firebase-login` | Firebase ID token | Exchange Firebase identity for Kumele access/refresh tokens |
| Current user | `GET /auth/me` | Yes | Restore authenticated session |
| Categories | `GET /hobbies/categories` | No | Render backend `name`, `icon`, and `iconDark` |
| Events | `GET /events?limit=<n>` | No | Public approved, unexpired event feed |
| Event detail | `GET /events/{id}` | No | Render description, time, venue, host, category and rating data |
| Matching | `GET /match/events?user_id=<id>&lat=<lat>&lon=<lon>&radius_km=<km>&limit=<n>` | Yes | Preserve response order exactly |
| Blogs | `GET /blogs/feed?limit=<n>` | No | Render supplied image/video URLs and backend fields |
| Blog comments | `GET /blogs/{id}/comments` | No | Render real authors and comments |
| Local ad decision | `GET /ads/fetch` | Yes | Render only the returned current decision |
| Ad tracking | `POST /ads/track` | Yes | Send one `view` or `click` using returned impression ID |
| NFT screen | `GET /nfts/my-screen` | Yes | Rewards, owned/claimed items and marketplace sections |
| NFT marketplace | `GET /nfts/marketplace` | No | Public marketplace cards |
| NFT detail | `GET /nfts/{id}` | No | Solana details, token number, media, download and QR URL |
| NFT rewards | `GET /nfts/rewards` | Yes | Claimable state; ownership begins only after mint success |
| NFT collection | `GET /nfts/mine` | Yes | User-owned minted NFTs |
| NFT claim | `POST /nfts/{id}/claim` | Yes | Reward price is zero; Stripe still collects quoted mint fee |
| NFT purchase | `POST /nfts/{id}/purchase` | Yes | Use returned Stripe payment data |
| NFT status | `GET /nfts/{id}/purchase/status` | Yes | Poll boundedly until payment/mint terminal state |
| Solana fee quote | `GET /web3/fees/quote?operation=nft_mint&chain=solana&quantity=1` | No | Show backend label and EUR amount |
| Shop plans | `GET /event-plans` | No | Subscriptions and guest tickets from backend catalog |
| Subscription tiers | `GET /subscriptions/tiers` | No | Render backend catalog; do not hard-code prices |
| Subscription state | `GET /subscriptions/status` | Yes | Current entitlement |
| Payment history | `GET /payments/history?limit=<n>` | Yes | Backend provider/status display |

## Matching Algorithm

- Backend eligibility and deterministic fallback are complete. The mobile client only supplies the authenticated user's ID, coordinates, radius and limit.
- `user_id` must equal the JWT user. Expect 403 on mismatch and 422 for invalid coordinates.
- Preserve returned order and event identifiers. Do not combine this list with a locally sorted fallback.
- Show a proper empty state when the response contains no eligible events.

## Kumele Local Ads

These are Kumele's Facebook-style ads created by users, not Google Ads or AdMob.

- Send placement, platform (`android` or `ios`), language, location context and optional current `hobbyContext` to `/ads/fetch`.
- Render a backend creative only when `ad_source` is `BACKEND` and retain `impressionId`, `adId`, `campaignId`, `placement` and current hobby context.
- Track one view after a creative is visibly mounted and one click for a user action. Deduplicate rerenders.
- Clear stale creative after an active request fails, and do not let an older request overwrite a newer decision.
- Consent-off users must not be locally profiled or targeted by the client.

## Web3 and NFT UI

- Blockchain: `Solana`; token standard: `Metaplex Core` for Kumele-minted NFTs. A token ID/number remains unique data and must not be replaced by the token-standard label.
- Kumele's wallet pays SOL on-chain. The user pays the quoted economic mint cost through Stripe. Display `Blockchain processing fee` or the exact backend label, not a claim that Stripe directly pays gas.
- Show QR under NFT Details using `qr_code_url`; it encodes `share_url`.
- Render `animationUrl` when supplied, otherwise `imageUrl`. Owned music NFTs may expose MP3 or FLAC downloads through backend-provided URLs.
- Never mark an NFT owned merely because checkout opened or payment succeeded; use mint/ownership state from the backend.

## Source Updates Expected

### Flutter

- Keep `com.kumele.hobbies` aligned across Gradle, Firebase Android client and signing SHA configuration.
- In Create Event, fetch `/hobbies/categories`; render the horizontal category selector with backend light/dark icons. Never use event status such as `ACTIVE` as a category.
- Complete the Shop NFT tab and states in `lib/features/shop/presentation/shop.dart` using `/nfts/my-screen`; preserve Subscription and Guest Ticket sections.
- Ensure event/blog/NFT models map backend media URLs and render a deliberate placeholder only after an actual load error.
- Replace deprecated `WillPopScope` during normal frontend maintenance; it is not a backend blocker.

### Native iOS

- Keep `CreateEventViewModel.getHobbies()` mapped to `name`, `icon`, and `iconDark` for both iPhone and iPad.
- Apply the same matching, local-ad, NFT and shop contracts as Flutter without reproducing server logic.
- Verify dark/light remote icon loading, media failure states, Stripe handoff and authenticated token refresh on a signed build.

## Acceptance Checklist

- Google/Firebase sign-in reaches Kumele session restoration on the signed mobile builds.
- Create Event shows backend categories and both icon themes.
- Matching order is unchanged from `/match/events`.
- One first-party local ad records exactly one view and one click.
- NFT marketplace, reward, owned, QR, media and Stripe-to-mint states render correctly.
- iOS build and Flutter analyze/tests pass; capture one device/simulator screen for each flow.

Do not place secrets, provider keys, private certificates or test-user tokens in either mobile repository.

## Flutter APK Runtime Verification - 2026-10-05

- Tested artifact: `app-release.apk`, SHA-256 `92e587f809a9577b21c0ef06ba89e0898dc6254844e62319d3e5255585daadd8`.
- Verified identity: package `com.kumele.hobbies`, versionCode `10`, versionName `1.0.0`, min SDK 24, target SDK 36.
- Verified release signer: `CN=Himanshu Lahoti, OU=Kumele, O=Kumele`; certificate SHA-256 `23f01d8f541415bf7eaec1ddb68396e5db22f022f235f9e0a69197ce0517aa5c`.
- The APK is universal for the tested Android form factors; it includes ARM64 and x86_64 native libraries, declares large/xlarge screen support, and does not lock orientation. There is no separate tablet APK.
- The v10 package was observed installed and active as `com.kumele.hobbies/.MainActivity`; portrait and landscape screenshots were captured at Pixel 8 and Pixel Tablet dimensions. This does **not** mean the tablet layouts passed.
- After release testing, `Kumele_API_35_Play` still contained versionCode 1 signed by the Android Debug certificate. Android cannot safely upgrade that package with Himanshu's release-signed APK. Existing application-data preservation was not independently inspected.
- Phone portrait and landscape render, but first-run permission sheets dominate the viewport and should be reviewed against the approved mobile design.
- **Tablet portrait and landscape acceptance: FAIL / pending frontend repair.** Do not describe v10 as tablet-ready.
- Tablet landscape defect: the first onboarding slide scales beyond the viewport and clips the large yellow headline. The first-run permission sheets span almost the full 2560-pixel width and use oversized controls instead of a constrained tablet dialog.
- Tablet portrait defect: first-run permission sheets occupy an excessive portion of the 1600 x 2560 screen, and the sign-in composition leaves disproportionate unused vertical space instead of a balanced tablet layout.
- Required frontend follow-up: apply width-aware constraints to every onboarding slide, permission sheet, sign-in/sign-up surface, and authenticated screen. Test all four combinations: phone portrait, phone landscape, tablet portrait, and tablet landscape. Preserve the useful two-column tablet sign-in structure, but do not mark tablet support complete until screenshots and interaction checks pass in both tablet orientations. Do not change the Android application ID.
- Runtime evidence is stored in the task workspace `evidence/` directory as `phone-portrait-v10.png`, `phone-landscape-v10.png`, `tablet-portrait-v10.png`, and `tablet-landscape-v10.png`.

### Google Sign-In Status on v10 Release APK

- **Acceptance: pending / not verified.** Do not mark Google sign-in complete for this APK yet.
- The APK embeds the expected Firebase Android app identity: project `kumele-2026`, app ID `1:540234199221:android:d5569dfc6867c5a5950efc`, package `com.kumele.hobbies`, and web client ID `540234199221-ve5ppuvkr6328a8cl1hv6d08m6go8km2.apps.googleusercontent.com`.
- Himanshu release signer SHA-1 is `3B:70:17:25:6B:9C:C3:87:57:1D:1B:07:C9:5C:F9:23:9B:73:2C:61`. Confirm this exact SHA-1 is registered on Firebase app `Kumele Android`, then download the refreshed `google-services.json` and rebuild if Firebase changed it.
- On the fresh release-test Pixel 8 AVD, the Google button correctly opened Credential Manager and Google Play Services. The AVD has zero Google accounts, so Google entered its add-account flow. That Google-owned `MinuteMaidActivity` rendered as a blank black screen even though Android reported a validated network. No Kumele backend request or Firebase result was reached.
- The blank add-account screen occurred only on the newly isolated release-test AVD, which had no Google account. It does **not** explain or supersede the fact that Google Sign-In worked on the preserved original AVD on the prior two days. Treat the release-SHA registration and v10 credential result as separate acceptance items. Retest v10 with an already provisioned Google account and capture the final Firebase credential result plus `POST /auth/firebase-login` response before closing Google sign-in.

## Flutter v10 API Integration Audit - 2026-10-05

Scope: static inspection of Himanshu's exact v10 release APK plus bounded read-only production probes. Route presence in a compiled binary proves intended integration, not an authenticated successful workflow.

### Decision

- **Backend health: PASS.** `GET /api/v1/health` returned HTTP 200. Public categories, events, blogs, NFT marketplace, subscription tiers, event plans, and Solana fee quote also returned HTTP 200. Protected current-user, matching, and local-ad routes returned HTTP 401 without a bearer token, which is the correct boundary. Production OpenAPI currently contains 303 paths, 357 operations, and 107 schemas.
- **Google Sign-In is not a reproduced backend defect.** v10 contains `/auth/firebase-login`; the deployed endpoint is registered and returned HTTP 401 with `Invalid or expired Firebase token` for the deliberately invalid audit token recorded in `evidence/firebase-invalid-token.json`. The captured Google Play Services logs show failed/incomplete credential activity, but no successful Firebase-to-Kumele exchange is evidenced. The previously working `Kumele_API_35_Play` baseline and the new isolated release AVD must not be conflated. Register Himanshu's release SHA-1 in Firebase and retest on a device/AVD with an already provisioned Google account.

### Integration Matrix

| Area | v10 evidence | Status | Required action |
|---|---|---|---|
| Firebase session exchange | `/auth/firebase-login`, `/auth/me` | Correct route; authenticated result pending | Confirm release SHA-1, then capture one successful Firebase token exchange and session restore. |
| Categories and event feed | `/hobbies/categories`, `/events`, event detail/rating routes | Correct route set | Keep backend names and `icon`/`iconDark`; never display event status as category. |
| Deterministic matching | Static v10 strings contain `/events/recommendations` but no `/match/events` literal | **Static integration concern; runtime pending** | Verify the current call site. Integrate authenticated `GET /match/events` with user ID, coordinates, radius, and limit if it is not already generated dynamically. Preserve backend order and do not substitute AI recommendations. |
| Blogs and comments | `/blogs/feed`, `/blogs/{id}/comments` | Correct route set; rendering acceptance pending | Verify real media, YouTube/video, author, pagination, and comments on a signed-in build. |
| Kumele local ads | `/ads/fetch`, `/ads/track` | Correct route set; authenticated tracking pending | Preserve backend decision and prove exactly one mounted view plus one click. |
| NFT/Web3 | `/nfts/my-screen`, rewards, mine, marketplace, claim, purchase/status | Core routes present | Complete authenticated Rewards/Claimed/Marketplace UI and media/QR/download acceptance. |
| Solana fee quote | Static v10 strings contain `https://kumele-backend.ansht.workers.dev/api/v1/web3/fees/quote` | **Static integration concern; runtime pending** | Inspect the current call site. Remove the old Worker URL if active and call `GET https://api.kumele.com/api/v1/web3/fees/quote` through the shared API client. |
| Shop catalogs | `/subscriptions/tiers`, `/subscriptions/status`, `/event-plans`, `/event-plans/quote` | Correct route set | Render backend catalog and entitlement state; do not hard-code prices. |
| Stripe/PayPal payments | event-payment and PayPal connect/order/capture/status routes present | Route set present; authenticated/provider acceptance pending | Keep Stripe and PayPal state separate and verify on a signed-in sandbox build. |
| Notifications/profile/localization | notification, profile, app-config, and language routes present | Route set present | Validate models and token refresh during authenticated acceptance. |

### Brief Previously Observed UI/UX Findings For Later Review

- Prior emulator screenshots showed onboarding headline clipping in tablet landscape, oversized permission sheets in both tablet orientations, and excessive empty space on tablet portrait sign-in. These observations were not re-proven by the API evidence in this section.
- Prior emulator review showed missing/blank Blog thumbnails; video/YouTube playback and multiple-comment states still need a focused media review.
- Prior Shop/NFT review left screen acceptance incomplete: verify Rewards, Claimed, Marketplace, QR, image/video/Lottie/audio fallback, and error states.
- Phone layout review can wait; do not redesign frontend dimensions during this backend/API audit.

### Evidence

- APK SHA-256: `92e587f809a9577b21c0ef06ba89e0898dc6254844e62319d3e5255585daadd8`
- OpenAPI snapshot: `evidence/openapi-2026-10-05.json`
- Route inventory: `evidence/openapi-routes.tsv`
- APK string evidence: `evidence/apk-libapp-strings.txt`
- Live probes: `evidence/live-api-probes-2026-10-05.tsv`
- Filtered authentication log: `evidence/v10-auth-logcat-filtered.txt`
- Firebase official requirement checked 2026-10-05: register the Android SHA-1, enable Google provider, and replace the app's config with the refreshed `google-services.json` after configuration changes: https://firebase.google.com/docs/auth/android/google-signin
