# Kumele: shared API and client corrections

Scope: Waqas Next.js, Himanshu iOS/iPadOS/tvOS/Flutter, Mohammed backend. Backend contracts apply equally to every client; this does not claim native/UI/provider acceptance or replace completed Stripe work. The scoped Shop-contract backend is deployed on October 9 as `kumele-backend:20261009-shop-contracts-v3`; live health and authenticated read checks passed.

## Previous-agent reconciliation

Read Kumele Backend Continuity, thread 01a11267-e629-7d03-ba2d-1c32d18449ce. Completion turn 01a11deb-35c3-7553-a981-ab73de00c797 reports secure notification deletion and transactional business upgrade, 25 tests, TypeScript/build and Astra PASS. Later Docker cutover turn 01a11e00-b108-73e0-a521-27e984041c3d verifies those two routes in the historical local 302-path candidate. These are preserved in the current 318-path/372-operation deployed API. Older deployment blockers are superseded by the accepted October 9 migration, not tasks to repeat.

## Correct Next.js environment settings

```dotenv
NEXT_PUBLIC_API_V1_BASE_URL=https://api.kumele.com/api/v1
NEXT_PUBLIC_BACKEND_URL=https://api.kumele.com
NEXT_PUBLIC_MEDIA_BASE_URL=https://api.kumele.com
NEXT_PUBLIC_APP_BASE_URL=https://kumele.com
```

This is a correction snippet, not a deployable complete environment file. Preserve existing valid Firebase/public payment settings; match them to backend/provider projects and sandbox accounts before rebuilding. Do not paste placeholders into production. The API prefix must be appended once.

- `https://api.kumele.com:3005` timed out; the canonical API health on HTTPS 443 returned 200 with valid TLS. Do not use port 3005 for backend/media links.
- `https://api.kumele.com:8080` produced a TLS protocol failure. AI/ML remains private at `http://kumele-aiml-aiml-1:8088` on its Docker network, using server-only credentials. This hostname is usable ONLY by a server attached to that network; it is not a public Next.js URL. Next-server reachability is not yet verified. Do not expose the suspended AI-chat feature.
- `NEXT_PUBLIC_*` values are compiled into the browser bundle: rebuild and redeploy after changing them, not only restart.
- `NEXT_PUBLIC_DEV_BETA_CODE=replace-with-beta-code` is not a real beta code. Keep beta provisioning distinct from newsletter subscription or admin code creation.
- Pasted AI/ML internal key and reCAPTCHA secret should be rotated through their owning services and dependent deployments. Values are intentionally not copied here. No credential rotation or auth identifier change was performed.
- Current Firebase ADC service-account file exists, contains a private key, and belongs to `kumele-2026`. Missing split FIREBASE_* environment variables alone do not mean Firebase sign-in is broken. Successful real Firebase ID-token login remains a separate test. Direct Google OAuth client/secret and backend reCAPTCHA secret were not configured in the inspected runtime; do not claim those independent flows verified.
- The supplied EVM wallet has valid address syntax, but company ownership/control is unverified. Base/USDC payment code and Solana NFTs are different chains. Do not substitute that EVM wallet for a Solana NFT destination or send funds during this audit.

Official references checked October 9: [Next.js environment variables](https://nextjs.org/docs/app/guides/environment-variables), [Cloudflare proxy ports](https://developers.cloudflare.com/fundamentals/reference/network-ports/).

## Current route status

Paths below are relative to `/api/v1`. Current source plus the live 318-path/372-operation specification were compared, not just unauthenticated status codes.

| Document item | Current result |
|---|---|
| M12 DELETE `/notifications/{id}` | Implemented; preserves owner scoping. Missing or another user's notification returns 404, not an existence-revealing 403. |
| M16 POST `/auth/business/upgrade` | Implemented; retain current password/role/concurrency safeguards and authenticated session response. |
| M1-M3 user store-credit balance/history/top-up | Implemented as authenticated GET `/store-credit`, GET `/store-credit/history`, and POST `/payments/store-credit/purchase`. Top-up grants credit only after verified payment. |
| M4-M7 add-on catalogue/active/purchase/campaign paid-status | Implemented as GET `/payments/in-app-purchases`, authenticated GET `/payments/in-app-purchases/active`, POST `/payments/in-app-purchases/{slug}/purchase`, and GET `/ads/campaigns/{id}/paid-status`. Prices and entitlement state are backend authority. |
| M8 PayPal event-creation capacity checkout | Implemented as authenticated POST `/payments/paypal/event-creation/{eventId}` while preserving the existing Stripe capacity checkout. |
| M9-M11 PayPal connect/callback/disconnect | Requested routes absent; ordinary PayPal order/capture is not account connection. |
| M13-M15 created events/delete past event/audience estimate | Requested routes absent. Listing/cancellation must not be relabelled as those contracts. |
| M17 GET `/config/ads` | Requested route absent. `/app/config` has `feature_flags.ads_enabled` but does not supply the requested placement map; not a drop-in alias. |
| M18 public email beta request | No agreed public route implemented. Do not use privileged `/beta/codes` from a landing page. |
| P1 `useStoreCredit` | Implemented for subscription, event attendance, event-creation capacity, NFT purchase, and add-on purchase. Full credit returns `requiresPayment:false`; partial credit returns the provider secret plus `storeCreditApplied` and `remainingCharged`. Credit is reserved before provider creation and committed only after verified success. |

Exact controller/DTO lines and timestamped OpenAPI evidence: [route comparison](</Volumes/Redmacbeth 2TB SSD/Projects/New Projects/Codex Agent Projects/georgebeghobaku/Workspaces/2026-10-09/kumele-migration-readonly-review/waqas-route-contract-corrections.md>). Worker Astra receipt is in that folder. None of the attached document's mutating smoke-test loops was executed. A 401 proves an authentication response, not checkout correctness; 404 can also mean an absent record. Use authenticated owned fixtures and payment/ledger assertions for functional acceptance.

## NFT purchase contract for every client

Bearer token required. Keep the existing Stripe-to-Solana implementation, not retired `/payments/nft/checkout` or `/payments/nft/mint-status` guesses.

1. POST `/nfts/{id}/purchase` body `{ "walletAddress": "<valid Solana destination>", "useStoreCredit": true|false }`.
2. Read `{ ok, data }`: `requiresPayment`, `paymentIntentId`, `clientSecret`, `amountMinor`, `currency`, `storeCreditApplied`, `remainingCharged`, `walletAddress`, `network`, `status`. Full credit returns `requiresPayment:false`, `status:"PAID"`, and no Stripe intent. Amounts are integer EUR minor units and backend authority.
3. Full-credit branch: do not initialize Stripe. POST `/nfts/{id}/purchase/confirm` with `{ "localPaymentIntentId": "<local order ID>" }`, then poll purchase status. This authorizes the pending mint only after the backend commits credit and limited-supply reservation; it does not itself prove on-chain ownership.
4. Partial/no-credit Stripe branch: confirm `clientSecret` using the existing Stripe client flow, then POST `/nfts/{id}/purchase/confirm` with `{ "paymentIntentId": "pi_..." }`. The signed Stripe webhook remains required before mint authorization; do not bypass it.
5. Confirmation data includes `paymentStatus`, `mintId`, `mintStatus`, `ownershipStatus`, `network` and network-fee fields. `AWAITING_PAYMENT_WEBHOOK` and `PENDING_MINT` are not ownership or successful minting.
6. GET `/nfts/{id}/purchase/status` data: `owned`, `ownershipStatus`, `mintStatus`, `mintAddress`, `transactionSignature`, `network` and network-fee fields. Show owned only when backend confirms ownership; payment/credit success alone is insufficient.

Free reward price does not remove the user's minting-fee payment. Platform pays SOL from its wallet and recovers the charge through Stripe. Do not credit ownership before mint success. Current source responses are documented here; no new real payment or on-chain acceptance is claimed.

## AI/ML integration boundary

- Frontend event matching: authenticated GET `/match/events?user_id=...&lat=...&lon=...&radius_km=...&limit=...` on the normal `/api/v1` base. The bearer-token user must match `user_id`.
- Admin event insight: authenticated admin GET `/admin/ai/recommendations/events` on the same public API base.
- The internal AI/ML service URL and shared key are backend-only configuration (`AIML_BASE_URL` in the Nest backend). Never expose either as `NEXT_PUBLIC_*`, never call `https://api.kumele.com:8080` from a frontend, and do not re-enable the suspended AI-chat feature.

## Other integration corrections

- Blocks: use GET `/blocks/section/{section}` with section `TEXT_POLICY`, `IMAGE_MEDIA` or `FUNCTIONALITY`, plus supported platform/consent query; response `{ section, count, blocks }`. Specific block uses `/blocks/resolve/{blockKey}`. Do not build legacy `/blocks/active` as a guessed alias.
- Socket.IO: backend namespace `/chat`, default transport path `/socket.io`, handshake `auth.token` bearer JWT. Connect to `https://api.kumele.com/chat`, not the `/api/v1` REST path. Events include `join_room`/`leave_room` with `{ eventId }`, `send_message` with `{ eventId, content }`, `typing_start`/`typing_stop`; receive `new_message` and `room_closed`. Room eligibility enforced by backend. The inspected Oct6 Next.js `src/utils/socket.ts` reads `NEXT_PUBLIC_BACKEND_URL` and connects to the root namespace; it does not read `NEXT_PUBLIC_SOCKET_URL`. Waqas's submitted document describes a possibly newer source: reconcile his latest checkout before changing its env variable. Himanshu must check equivalent native namespace/payloads. Transport 101 is not a complete chat interaction test.
- Webhooks: inspected current source explicitly registers POST `/webhooks/stripe` (excluded from Swagger), canonical HTTPS endpoint `https://api.kumele.com/api/v1/webhooks/stripe`. Do not relay via the old IP or reserialize signed bodies. No PayPal webhook receiver was found in the reviewed canonical source; do not advertise `/webhooks/paypal` as implemented. Provider-dashboard delivery tests remain open.
- Catalog: preserve EUR integer `amountMinor`/`priceMonthlyMinor`/`priceYearlyMinor`. Shop has monthly Silver 1500, monthly Gold 1875, yearly Gold 12000, and ONE_TIME descriptors event ads 707/location change 825. Silver tier advertises yearly 18000, but shop has no yearly Silver and checkout DTO has no interval selection. `storeCreditMinor:2500` is a static catalogue field, not proof of a grant/balance/top-up product. These inconsistencies need a reconciled product/billing contract; no price/product changes were invented.
- Saved cards: use existing Stripe payment-method/intent contracts, never successive guessed charge routes. Exact supported saved-method checkout remains to be mapped and tested, not claimed resolved here.
- Response DTOs: subscription lifecycle, ticket list and upload/NFT routes need complete OpenAPI response schemas. The source-described NFT envelope above does not mean Swagger was fixed.

## Media correction and remaining dependency

`/media/upload` previously inserted fabricated demo URLs when Cloudinary was missing. Source correction requires all three nonblank credentials, otherwise 503 without database write. Four focused tests and SWC build pass; separate deployment/live receipt records publication status. This fix protects all clients but is NOT storage provisioning.

- Direct `/upload/*` image services still depend on Cloudinary; limits are 5 MiB, JPEG/PNG/GIF/WebP.
- `/media/upload` accepts JPEG/PNG/GIF/WebP/MP4/WebM, 10 MiB. Successful real response has `id`, `url`, `mediaType`, `mimeType`, `size`, with provider dimensions/duration when supplied.
- `/media/upload-url` needs configured Cloudinary or S3/R2 `STORAGE_*` credentials. None was present at inspection. Cloudinary mode is a signed multipart provider upload, not PUT; S3 mode is a signed PUT. Do not infer working uploads merely from endpoint presence or existing fixture assets. Public URL persistence/completion acceptance remains open.
- Do not restore disabled Cloudinary credentials or fake uploaded media. Working storage configuration and real image/video upload/readback are prerequisites for closing this part.

## Preservation boundary

No auth, matching, categories, fixture rows, database migrations or frontend layouts were changed. The API-only derived image preserves the media-boundary base and updates only compiled/source files in ads, NFTs, payments, subscriptions and tickets. Existing Stripe/PayPal/Solana ownership gates remain; scoped mocked tests do not replace real provider settlement or on-chain acceptance.
