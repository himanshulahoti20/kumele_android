# Himanshu: iOS, tvOS And Flutter

## October 9 Shared Contract Corrections

Read the same [API/Shop/NFT/media corrections](</Volumes/Redmacbeth 2TB SSD/Projects/New Projects/Codex Agent Projects/georgebeghobaku/Workspaces/2026-10-09/do-not-ask-me-to-do/KUMELE_SHARED_API_CORRECTIONS_2026-10-09.md>) as Waqas. Backend corrections apply to iOS/iPadOS/tvOS and Flutter; no layout, bundle ID or client dimensions were changed.
Preserve Stripe and Firebase flows. Send a valid Solana `walletAddress` for NFT purchase and unwrap `data`. Full-credit checkout confirms with `localPaymentIntentId`; partial/no-credit Stripe checkout confirms with `paymentIntentId`. Send exactly one identifier, then poll purchase status; payment/credit success is not minted ownership. Free rewards still require mint-fee payment. Use Socket.IO `/chat` with `auth.token` and backend event payloads.
Handle media storage unavailable503 rather than treating it as uploaded/creating a fake image. Storage credentials and real upload acceptance remain required. Store-credit, add-on purchase, campaign paid status, subscription/event/event-creation/NFT credit splits, and PayPal event-capacity checkout are implemented in the consolidated backend source. PayPal account connect/callback/disconnect remains separate and must not be invented client-side. Notification deletion/business upgrade remain present.

Deployed-server update, October9. Shop-contract image `kumele-backend:20261009-shop-contracts-v3` is live and healthy. Final source Astra PASS is `astra-shop-final-integration4.md`; public and authenticated API checks passed after rollout.
This report does not transfer backend ownership or claim device UI acceptance.
Scope includes iOS/iPadOS, tvOS and Flutter Android clients. Native builds and
device/runtime integration are Himanshu's lane; no new AppleTV test is claimed.

## Assigned Demo Profile

Email: `Kumeleteam4@kumeletest.com`
Password: `sjdkdk4846`
Private testing credentials, included at George's explicit request. Do not publish.

## Deployment And API Notes

- Use https://api.kumele.com/api/v1; append the prefix once. Swagger /docs and OpenAPI /docs-json are on the same origin.
- Flutter identifier remains com.kumele.hobbies. Do not change it based on an iOS identifier. Existing Firebase/OAuth configuration must be preserved; no new simulator Google/passkey acceptance is claimed in this migration.
- POST /auth/login returns access_token and refresh_token. POST /auth/refresh accepts refreshToken. Mobile Firebase authentication uses POST /auth/firebase-login, not browser OAuth callbacks.
- Five demo accounts are kumeleteam1 through5@kumeletest.com with George's privately supplied distinct passwords. They are verified/no2FA synthetic accounts; ordinary accounts do not receive their fixture content.
- GET /hobbies/categories exposes icon and iconDark. Eight categories and27API media URLs passed the agent's final tests. Consume backend media; no substitute hardcoded category/status label.
- Ten event details expose description, startsAt, endsAt, location_details, cover_image/event_images and host_profile. Preserve actual category separately from event status. API field presence is verified, not device rendering or every semantic value.
- Shop catalogue uses public GET `/subscriptions/shop-catalog`. Store credit uses authenticated GET `/store-credit`, GET `/store-credit/history`, and POST `/payments/store-credit/purchase`; add-ons use GET `/payments/in-app-purchases`, GET `/payments/in-app-purchases/active`, and POST `/payments/in-app-purchases/{slug}/purchase`.
- Send `useStoreCredit` on subscription, event attendance, event-creation capacity, NFT purchase and add-on purchase. Render backend `requiresPayment`, `storeCreditApplied`, and `remainingCharged`; full-credit checkout must not initialize Stripe. PayPal event capacity uses POST `/payments/paypal/event-creation/{eventId}`.
- Preserve backend subscriptions/guest-ticket/NFT contracts and backend-provided assets. No frontend dimensions/layout changes made in this migration.
- Matching: GET /match/events requires matching JWT identity plus lat,lon,radius_km. Deterministic ordering/score/reasons and401/403/422 boundaries passed. Exact usr_match_qc ranking/exclusions and forcedfallback remain separate acceptance.
- AI/ML client location is authenticated GET `/match/events` on the normal API base. Admin event insight is GET `/admin/ai/recommendations/events`. Internal AI/ML host/key remain backend-only; AI chat stays suspended.
- Local ads are first-party user-created ads, not Google Ads. GET /ads/fetch with platform/placement; NOTIFICATIONS read passed. Do not enable suspended AIchat.
- NFT marketplace/media/QR andSolana fee quote passed bounded reads. Payment, wallet transfer and on-chain mint are not proven by those reads. Retain backend token_standard/blockchain/unique identifiers and QR, not Ethereum/ERC-721 hardcoding.
- Previously reported tablet portrait/landscape, video/player/clipping and Google/passkey UI issues remain developer/device-review items, not freshly reproduced backend defects. This deployment makes no broad Flutter/iOS edits.
- tvOS: consume the same authenticated API, backend category/theme assets, event/blog/shop/NFT media and first-party ad contracts where the current tvOS source supports them. Native bundle/auth configuration, remote-focus navigation and video/player rendering require client/runtime verification; no unsupported tvOS feature or newly completed test is asserted.

Evidence: migration-validation-current.md; final-migration-testing.md/json in
the sibling kumele-migration-readonly-review workspace. Final-audit-rollup.md/json
records the accepted bounded audit, not fresh device acceptance.
