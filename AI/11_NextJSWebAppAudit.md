# Kumele Next.js Web App — Flow & API Audit

Audited 2026-07-28 against `https://kumele-next-js-readiness-handover-2.vercel.app`
(demo account `host.demo@kumele.com`).

## Methodology (read this before trusting the findings)

No browser-automation tool (Playwright/Puppeteer/DevTools) was available in this
session, so the app could **not** be clicked through and watched in real time.
Instead:

1. Pulled the site's Next.js JS chunks directly (`curl` against `/_next/static/chunks/*`,
   ~2.6 MB across 44 chunks from `/authentication/signin`, `/user/home`,
   `/admin/partnership-home`, `/user/shop`, `/user/subscriptions`, `/user/chat`,
   `/user/profile`, `/user/blog`) and grepped the minified bundles for
   `` fetch(`${base}/...`) `` call sites.
2. Logged in directly against the backend with the provided credentials to see the
   real auth response, then used the access token to call several endpoints live
   (`/auth/me`, `/payments/cards`, `/ads/campaigns`, `/events/check-user-availability`,
   `/otp/create-user-beta-code`) and confirm which frontend code paths are actually
   wired to a working route vs. dead.

This surfaces **every endpoint the web bundle references**, but not full click-path
UX (form validation, loading states, error copy) — that would need a real browser
session.

## Backend confirmation

The web app and this iOS app call the **same backend**:

- Web: `NEXT_PUBLIC_API_V1_BASE_URL` inlined at build time → `http://84.247.131.180/api/v1`
- iOS: [`APIConstants.baseURLString`](../Kumele/Core/APIConstants.swift) → `http://84.247.131.180:3000/api/v1/`

`POST /auth/login` with the demo credentials returned a normal access/refresh JWT
pair, `role: "USER"`, `profile_status: "incomplete"` — same shape iOS already
decodes in `AuthViewModel`.

## Screens discovered (via direct route probing, not navigation)

| Route | Status | Notes |
|---|---|---|
| `/authentication/signin` | 200 | Email/password, "Remember me", reCAPTCHA, Passkey, Google, language picker (EN/FR/ES/DE/AR/ZH), forgot-password + sign-up links |
| `/authentication/signup` | 200 | — |
| `/user/home` | 200 | Client-side auth gate (SSR shell renders before redirect) |
| `/user/shop` | 200 | Products/cart |
| `/user/subscriptions` | 200 | |
| `/user/chat` | 200 | |
| `/user/profile` | 200 | |
| `/user/blog` | 200 | |
| `/admin/partnership-home` | 200 | A separate business/host-portal shell lives in the same Next.js app |
| everything else guessed (`/user/events`, `/user/nfts`, `/user/tickets`, `/user/wallet`, `/user/settings`, …) | 404 | Either nested dynamic routes only reachable via in-app links, or genuinely not top-level pages — can't tell without a browser |

## Endpoint inventory vs. this repo's existing docs

**Important finding:** this repo already tracks all 248 backend endpoints in
[`08_APICompleteReference.md`](08_APICompleteReference.md) /
[`10_APIStatusList.txt`](10_APIStatusList.txt), with deliberate
implemented/pending/not-relevant decisions. The web bundle was cross-checked
against that list rather than treated as a fresh source of truth.

### Confirms existing iOS coverage (no action needed)
Auth (login/signup/passkey/2FA/forgot-reset-password/change-password),
`users/profile`, `users/{id}/follow*`, `events` CRUD + join/cancel/chat/checkin,
`blogs` feed/comments/like, `subscriptions` (tiers/status/create), `notifications`,
`translation/profile`, `upload/event-banner` — all match what's already wired in
`APIConstants.swift` and marked implemented in `10_APIStatusList.txt`.

### Live and real, but already tracked as deliberately deferred — not new gaps
- **`/payments/cards`, `/payments/cards/save`, `/payments/cards/charge`,
  `/payments/cards/setup-intent`, `/payments/cards/setup-token`,
  `/payments/paypal/vault/setup-token`** — confirmed live (`GET /payments/cards` →
  `{"ok":true,"cards":[]}` with the demo token). This is real, working saved-card
  management in the web app. Already listed in `10_APIStatusList.txt` §2 as
  `[NOT BUILT]` with the reasoning "needs Stripe SDK (not present); wiring raw card
  fields directly would be a PCI-DSS violation." Nothing new here — just confirms
  the web app has the UI/flow this repo already decided to defer.
- **`/ads/campaigns`, `/ads/campaigns/{id}`, `/ads/dashboard/stats`** — confirmed
  live (`GET /ads/campaigns` → `{"campaigns":[],"total":0,...}`). This powers the
  `/admin/partnership-home` business/advertiser dashboard. Already listed in
  `10_APIStatusList.txt` §3 as "not relevant — advertiser/business account
  feature," i.e. intentionally out of scope for the consumer iOS app.

### Investigated as possible new gaps — turned out to be dead code, not real gaps
Two endpoints appeared in the web bundle with no match anywhere in this repo's
docs or in the live `/docs-json` Swagger spec:
- `POST /events/check-user-availability` — bundle calls this as `POST`, but the
  live backend has no route for it (`Cannot POST /api/v1/events/check-user-availability`,
  a Nest.js "no matching route" 404). The `GET` variant that returned
  `{"message":"Event not found"}` earlier was a false lead: that's `GET /events/:id`
  matching with `:id = "check-user-availability"`, not a real dedicated endpoint.
- `POST /otp/create-user-beta-code` — also `Cannot POST ...`, no matching route.

Both are stale frontend code left over from an earlier backend version — **do not
port these to iOS.**

### Legacy/disabled code paths in the web bundle (informational only)
A whole second set of endpoints (`/users/login/`, `/users/register`,
`/users/google-signin/`, `create-payment-intent`, `verify-payment`, `/stripe`,
`/create-advert`, `/adverts`, `create-user-subscription`) all read from
`process.env.NEXT_PUBLIC_BASE_URL`, which is unset in this deployment (falls back
to `""`). One of the payment functions even has the literal message "Legacy
payment service is not configured." These are vestigial code from an older
version of the web app and are not part of the live flow — ignore them.

## Bottom line

No undocumented, currently-working backend capability was found. This repo's own
API tracking (`05_ImplementedAPIs.md`, `08_APICompleteReference.md`,
`10_APIStatusList.txt`) is more complete and more accurate than what could be
reverse-engineered from the web bundle. The only two feature areas confirmed live
on the web that iOS doesn't have are **saved payment cards (Stripe)** and the
**ads/advertiser dashboard** — both already known, both deliberately deferred for
reasons already recorded. Building either is a multi-screen effort (Stripe SDK
integration + PCI handling, or a full business-portal surface) and needs an
explicit decision, not a silent implementation.
