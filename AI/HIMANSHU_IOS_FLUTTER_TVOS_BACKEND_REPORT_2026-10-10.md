# Himanshu: iOS, Flutter and tvOS Backend Closure

Date: 2026-10-10
Environment: `https://api.kumele.com/api/v1`
OpenAPI: `https://api.kumele.com/docs-json`

## Private demo profile

- Email: `Kumeleteam4@kumeletest.com`
- Password: `sjdkdk4846`
- This profile is for Himanshu's UI/API testing and must not be published.

## Matching QC fixture

- User ID: `usr_match_qc`
- Email: `match-qc-user-v1@example.invalid`
- Password: `+dGiAlT4tTeqnIIp5A46xIhsO1HZgmpG`
- Coordinates: `64.1466, -21.9426` (Reykjavik), radius `20`, limit `10`
- Request: `GET /match/events?user_id=usr_match_qc&lat=64.1466&lon=-21.9426&radius_km=20&limit=10`
- Obtain a fresh access token through `POST /auth/login`. Access tokens last 15 minutes.
- Verified order: `evt_expected_best` #1 (`0.999166`), `evt_safe_second` #2 (`0.966642`).
- Verified exclusions: `evt_rejected`, `evt_full`, `evt_past`, `evt_outside_radius`, `evt_blocked`, `evt_sponsored_low_trust`.
- Verified: repeat order is deterministic; missing coordinates `422`; no/invalid token `401`; another user's token `403`.
- Response fields are documented in OpenAPI. Current metadata: `fallback_used: false`, `model_version: backend-deterministic-v1`.

## Closed backend issues

1. Ads: `GET /ads/fetch` and `POST /ads/track` accept `HOME`, `FEED`, `PROFILE`, `EVENT_LIST`, `SEARCH`, `DISCOVERY`, `EVENT_DECISION`, and `NOTIFICATIONS`. Limit `12` is accepted. Live view and click tracking both returned `200`.
2. Media: Cloudinary is no longer required. Uploads are stored on the Kumele server and return HTTPS URLs under `/media/...`. Event banner, profile/general image, blog image, and NFT image uploads were verified with real decoded images. Invalid/truncated files return `400`. Existing database records contain zero Cloudinary URLs in users, events, blogs, local ads, and NFTs.
3. Store credit: `GET /store-credit` returns `200` with `amount`, `amountMinor`, `currency`, and `expiresAt`.
4. PayPal Connect: `GET /payments/paypal/connect/status` and `GET /payments/paypal/connect?redirectUri=...` return `200`.
5. Stripe Connect: `GET /payments/stripe/connect/status` returns `200`. `POST /payments/stripe/connect/onboard` now accepts supported full country names and own aliases (`uk`, `UK`, and whitespace variants map to `GB`), rejects inherited object keys before Stripe, creates a Stripe test connected account, and returns `201` with `accountId`, `url`, and `expiresAt`.
6. Shop catalog: `GET /subscriptions/shop-catalog` returns subscriptions, guest tickets, default store-credit amount, EUR minor-unit prices, and Apple/Google product IDs for monthly/yearly Silver and Gold products.
7. Passkeys: `POST /auth/passkey/register/start` works without a browser Origin header for the trusted native-app flow. Live result was `200`, with challenge and RP ID `kumele.com`. Explicit untrusted origins remain rejected.
8. Audience estimate: `POST /events/audience-estimate` returned `201` and reached the internal AI/ML service. Current response includes `schema_version`, `model_version`, `predicted_attendance`, confidence data, `fallback_used`, and `features_used`.
9. Email: transactional SMTP verified from the running API container. Provider accepted the controlled verification message with `250 OK`; failures now return `503` instead of a false success. Acelle remains the newsletter integration; SMTP handles auth/verification mail.
10. Health: core API, PostgreSQL, and Redis are healthy. Full backend regression suite: 96 suites, 769 tests passed. Build: 405 files compiled.

Verified deployment: `kumele-backend:20261010-stripe-country-v3`, digest `sha256:02d8ff753b42e1e29ce2b5170cdd1a8a5dcf56b366adbe695e6a6e79f16d0ec5`.

## NFT contract for all mobile clients

- Unique NFT ID remains the collection UUID; compact display number is separate.
- `nft_details.token_standard`: `Metaplex Core`.
- `nft_details.blockchain`: `Solana`.
- Paid examples now use realistic EUR prices: Premium Membership Pass `9.99`, Berlin Creators `19.99`, music NFT `4.99`.
- Reward badges have `price: 0` and `isFree: true`, but checkout still charges the quoted blockchain processing fee.
- `GET /web3/fees/quote?operation=nft_mint&chain=solana&quantity=1` states `fee_payer: kumele_platform_wallet` and `charged_to_user: true`.
- `POST /nfts/{id}/purchase` requires a 32-44 character Solana Base58 `walletAddress`; invalid input returns standard Nest `400` (`message`, `error`, `statusCode`).
- Purchase response fields: `requiresPayment`, `paymentIntentId`, `clientSecret`, `amountMinor`, `storeCreditApplied`, `remainingCharged`, `currency`, `walletAddress`, `network`, `networkFeePayer`, `networkFeeStatus`, and `status`.
- `GET /nfts/{id}/purchase/status` fields: `owned`, `ownershipStatus`, `mintStatus`, `mintAddress`, `transactionSignature`, `network`, `networkFeePayer`, `networkFeeStatus`.
- In the purchase flow, ownership and `GET /nfts/mine` inclusion begin only after verified payment and successful mint callback. The pre-seeded Bronze badge is synthetic UI fixture ownership and is not evidence of a payment or on-chain mint.
- QR: authenticated `GET /nfts/{id}/qr` returns PNG. Demo NFT URLs intentionally return `404` without a demo user's Bearer token.
- The bundled demo music NFT exposes `download.url`, `mime_type`, and `filename` to authorized demo viewers, and its test MP3 is valid MPEG Layer III. The bundled test-media route is not an ownership gate. Production music downloads require a separate authenticated entitlement route before real MP3/FLAC assets are uploaded; clients must not treat the demo URL as proof of ownership.
- Mobile should open `share_url` using universal/deep-link handling with browser fallback.

## AI/ML routing

- Do not call the retired raw IP or port `8080` from iOS/Flutter.
- Use HTTPS main-API routes: `/events/audience-estimate`, `/events/recommendations`, and `/match/events`.
- Admin moderation is under `/admin/events/moderation` and `/admin/blogs/moderation`; it is not a mobile-client endpoint.
- Chatbot is intentionally suspended and is not an acceptance blocker.

## Frontend-only follow-up

- Use backend-provided media/icon URLs; do not hardcode Cloudinary or bundle replacements for dynamic content.
- Preserve `com.kumele.hobbies` for Flutter. Native iOS identifiers are separate.
- Render server field names exactly as documented above; remove legacy alias guessing.
