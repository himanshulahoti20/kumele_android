# Kumele — API Testing Workflow & Complete Reference

**This file merges the former `02_APIIntegrationGuide.md`, `03_APITestingWorkflow.md`, and `07_BackendContractFindings.md` (2026-07-24 consolidation)** — those three were split across separate files but had converged on describing the same thing (the pre-rework stub-era stack and the real-backend migration), largely duplicating each other and going stale independently. `02`'s content (the old `NetworkManager`/stub-pattern integration guide) added nothing not already superseded by [04_CodingRules.md](04_CodingRules.md)'s current naming/structure conventions, so it was dropped rather than folded in. **Use [05_ImplementedAPIs.md](05_ImplementedAPIs.md) as the current, verified source of truth** for what's implemented, correct, broken, or missing — this file is the testing checklist plus the raw per-endpoint curl/response reference.

## How to use this file

When asked to implement an endpoint not yet covered in [05_ImplementedAPIs.md](05_ImplementedAPIs.md): find it in the endpoint reference below, copy the curl command, run it against the real backend to confirm the live shape (per the testing checklist below), then implement the Service/ViewModel/View using that confirmed shape and the conventions in [04_CodingRules.md](04_CodingRules.md).

Base URL: `http://84.247.131.180/api/v1` (debug) / `https://api.kumele.com/api/v1` (release). Swagger UI: `http://84.247.131.180/docs`. Full spec: [`api-reference/openapi.json`](api-reference/openapi.json) (211 paths, 80 schemas), also as a readable table at [`api-reference/endpoint-catalog.md`](api-reference/endpoint-catalog.md).

**⚠️ Status column below is a frozen snapshot, not re-verified line-by-line** — the per-endpoint ✅/⚠️/❌ markers throughout the reference section were generated once against an early stub-era read of the codebase and never fully re-audited. Trust [05_ImplementedAPIs.md](05_ImplementedAPIs.md) for status; trust this file's curl commands and example responses (the backend's contract itself hasn't changed, only the app's coverage of it has).

## Testing checklist

Run this before and after wiring up any endpoint. All calls go through `Kumele/Networking/{APIClient,APIEndpoint}.swift` — an actor-based `URLSession` client with Keychain-backed token storage, automatic 401 → `/auth/refresh` → retry-once, and structured `APIError` cases (see [05_ImplementedAPIs.md](05_ImplementedAPIs.md) §0). Don't assume a screen "working" in the simulator proves the contract is right — confirm against a real request/response, not just that the UI renders.

**Before wiring a call:**

1. **Locate the endpoint** in `Kumele/Core/APIConstants.swift` — confirm the exact path and whether it needs query params, path params, or is body-only. Every endpoint must have a constant here (see `04_CodingRules.md`'s hard rules) — never an inline path literal in a Service file.
2. **Check auth requirement** — does it need `Authorization: Bearer <access_token>`? If so, confirm a valid session exists at the call site (`APIClient.currentTokens()`), not just that the endpoint is reachable.
3. **Check the response model** — does the existing `Codable` model's `CodingKeys` match what the real backend returns? Verify against a real response (the curl reference below), not just an assumed shape.
4. **Check for pagination** — list endpoints under Hobbies/Blogs/Events use `APIEnvelope<T>` (`{ok, data, meta}`, cursor-based via `meta.cursor`/`meta.hasNext`); Auth/Users endpoints return the raw DTO unwrapped. Confirm which shape applies before writing the decode call.

**After wiring a call, verify each explicitly** (don't assume any from a single happy-path run):

- ✔ Correct endpoint — right path, right HTTP method.
- ✔ Headers/auth — bearer token actually attached and non-empty at request time.
- ✔ Request body — field names match the real DTO (log the encoded JSON once if unsure).
- ✔ Response parsing — decodes without silently defaulting to `nil`/empty on a shape mismatch.
- ✔ Empty response — a legitimately empty list renders an empty state, not a stuck spinner or decode error.
- ✔ Invalid/malformed data — deliberately test a field the backend might omit or rename, confirm the failure surfaces as something the UI can act on.
- ✔ Network failure/timeout — confirm it surfaces as a catchable error the ViewModel's `@Published var ...Error: String?` picks up.
- ✔ Unauthorized (401) — confirm the real backend message reaches the user, not a generic fallback (see the passkey-401 fix in [09_ChangeLog.md](09_ChangeLog.md) for a case where this regressed).
- ✔ Pagination — if applicable, confirm cursor/`hasNext` advance correctly and there's a real "no more pages" condition.
- ✔ File upload — confirm the multipart boundary/field names match backend expectations if the endpoint uses `MultipartFormData`.

**Root-cause order when something fails**: (1) is the request even reaching the network — log the `URLRequest`; (2) is the response status actually 2xx; (3) does the raw response body match the model's `CodingKeys` field-for-field; (4) does the envelope assumption (`APIEnvelope<T>` vs. raw DTO) match this specific endpoint; (5) only after ruling out 1–4, consider whether the backend contract itself differs from what was assumed — and report the specific mismatch (field name, type, status code), not a vague "backend issue."

## Historical: why the networking stack was reworked

Kept for context on the app's history, not as an active task list — everything below is resolved; see [05_ImplementedAPIs.md](05_ImplementedAPIs.md) for current state.

The app originally targeted a placeholder host (`testdomain.goodwish.com.np`, never resolved via DNS) through a `NetworkManager`/`APIResponse<T>`-envelope stack, with most services returning hardcoded local JSON instead of calling the network. The real backend was subsequently identified (`http://84.247.131.180/api/v1`) and found to have a substantially different contract than the stub code assumed:

- **No single envelope shape.** Auth/Users endpoints return the raw DTO directly (no wrapper); Hobbies/Blogs/Events wrap in `{ok, data, meta}`. The old `APIResponse<T>` (`{data, message, success}`) assumption matched neither.
- **Field names differed completely** (e.g. real `SignupDto` uses `firstName`/`lastName`/no `confirm_password`, vs. the old code's `name`/`confirm_password`/`gender`/`date_of_birth` at signup).
- **Token model differed** — real backend issues an access/refresh JWT pair (`Bearer` auth, 15-min access-token expiry, real `/auth/refresh`) vs. the old code's single long-lived `userToken` sent as `Token <token>`.
- **Feature surface was much larger than assumed** — Chat, Notifications, Payments, Shop/NFTs, Subscriptions, Discounts, Refunds, Support, Legal/Privacy, CMS, Ads all had real backend support the old docs didn't know about.

This drove the full rework: new `APIClient`/`APIEndpoint` stack, Keychain-backed token pair storage, per-module decode strategy (unwrapped DTOs vs. `APIEnvelope<T>`), and the much larger `Service` inventory now catalogued in [05_ImplementedAPIs.md](05_ImplementedAPIs.md).

---

## Table of contents

- [Health](#health) (3)
- [Auth](#auth) (26)
- [Users](#users) (21)
- [beta](#beta) (4)
- [Upload](#upload) (4)
- [events](#events) (19)
- [users](#users) (1)
- [chat](#chat) (6)
- [event-plans](#event-plans) (6)
- [hobbies](#hobbies) (6)
- [Blogs](#blogs) (8)
- [payments](#payments) (14)
- [subscriptions](#subscriptions) (6)
- [discounts](#discounts) (7)
- [refunds](#refunds) (5)
- [Notifications](#notifications) (6)
- [Ads](#ads) (12)
- [Admin - Users](#admin-users) (3)
- [Admin - Events](#admin-events) (5)
- [Admin - Blogs](#admin-blogs) (2)
- [Admin - Ads](#admin-ads) (2)
- [Localization](#localization) (2)
- [App Config](#app-config) (2)
- [Share](#share) (2)
- [Media](#media) (1)
- [Support](#support) (5)
- [Admin - Support](#admin-support) (6)
- [Translation](#translation) (4)
- [tickets](#tickets) (6)
- [products](#products) (5)
- [cart](#cart) (5)
- [cms](#cms) (7)
- [legal](#legal) (7)
- [newsletter](#newsletter) (4)
- [Metrics](#metrics) (1)
- [Privacy](#privacy) (5)
- [NFTs](#nfts) (8)
- [Admin - NFTs](#admin-nfts) (4)
- [media](#media) (1)
- [dev](#dev) (7)


## Health

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/health` | Check application health |
| ❌ | GET | `/api/v1/health/live` | Liveness probe for Kubernetes |
| ❌ | GET | `/api/v1/health/ready` | Readiness probe for Kubernetes |

### GET `/api/v1/health`
**Status**: ❌ NOT IMPLEMENTED

Check application health

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/health"
```

**Response** (`200`): The Health Check is successful

### GET `/api/v1/health/live`
**Status**: ❌ NOT IMPLEMENTED

Liveness probe for Kubernetes

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/health/live"
```

**Response** (`200`): Application is alive

### GET `/api/v1/health/ready`
**Status**: ❌ NOT IMPLEMENTED

Readiness probe for Kubernetes

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/health/ready"
```

**Response** (`200`): The Health Check is successful


## Auth

| Status | Method | Path | Summary |
|---|---|---|---|
| ⚠️ | POST | `/api/v1/auth/signup` | Register a new user |
| ⚠️ | POST | `/api/v1/auth/login` | Login with email and password |
| ❌ | POST | `/api/v1/auth/business/signup` | Register a new business user |
| ❌ | POST | `/api/v1/auth/business/login` | Login for business users |
| ❌ | POST | `/api/v1/auth/logout` | Logout current session |
| ❌ | POST | `/api/v1/auth/logout-all` | Logout from all devices |
| ❌ | POST | `/api/v1/auth/refresh` | Refresh access token |
| ❌ | GET | `/api/v1/auth/google` | Initiate Google OAuth login |
| ❌ | GET | `/api/v1/auth/google/callback` | Google OAuth callback |
| ❌ | POST | `/api/v1/auth/firebase-login` | Firebase token login (Flutter / mobile) |
| ❌ | POST | `/api/v1/auth/passkey/register/start` | Start passkey registration |
| ❌ | POST | `/api/v1/auth/passkey/register/finish` | Complete passkey registration |
| ❌ | POST | `/api/v1/auth/passkey/login/start` | Start passkey login |
| ❌ | POST | `/api/v1/auth/passkey/login/finish` | Complete passkey login |
| ❌ | POST | `/api/v1/auth/forgot-password` | Request password reset OTP (sent to email) |
| ❌ | POST | `/api/v1/auth/verify-reset-otp` | Verify password reset OTP and get a one-time reset token |
| ❌ | POST | `/api/v1/auth/reset-password` | Reset password using token from /auth/verify-reset-otp |
| ❌ | POST | `/api/v1/auth/change-password` | Change password (authenticated) |
| ❌ | POST | `/api/v1/auth/send-verification-email` | Send email verification OTP |
| ⚠️ | POST | `/api/v1/auth/verify-email` | Verify email with OTP code |
| ❌ | POST | `/api/v1/auth/resend-verification` | Resend verification email |
| ❌ | POST | `/api/v1/auth/2fa/setup` | Set up 2FA — returns QR code and secret |
| ❌ | POST | `/api/v1/auth/2fa/enable` | Enable 2FA after verifying a TOTP code |
| ❌ | POST | `/api/v1/auth/2fa/disable` | Disable 2FA |
| ❌ | POST | `/api/v1/auth/2fa/verify` | Complete 2FA login with TOTP code |
| ❌ | GET | `/api/v1/auth/me` | Get current authenticated user |

### POST `/api/v1/auth/signup`
**Status**: ⚠️ PARTIAL/WRONG

> AuthService.register() calls the OLD contract (name/confirm_password/above_legal_age/terms_and_conditions/subscribe_to_newsletter) — real DTO wants firstName/lastName/recaptcha_token/betaCode, no confirm_password. Needs rewrite.

Register a new user

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/signup" \
  -H "Content-Type: application/json" \
  -d '{
  "email": "user@example.com",
  "password": "SecurePass123",
  "firstName": "John",
  "lastName": "Doe",
  "referralCode": "ABC12345",
  "recaptcha_token": "03AGdBq25..."
}'
```

**Example response** (`201`):
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "role": "USER",
  "profile_status": "complete",
  "isOnboardingCompleted": false,
  "emailVerified": false
}
```

### POST `/api/v1/auth/login`
**Status**: ⚠️ PARTIAL/WRONG

> AuthService.login() is 100% hardcoded/mocked — never calls the network at all, regardless of backend. Needs full implementation.

Login with email and password

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
  "email": "user@example.com",
  "password": "SecurePass123",
  "recaptcha_token": "03AGdBq25..."
}'
```

**Example response** (`200`):
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "role": "USER",
  "profile_status": "complete",
  "isOnboardingCompleted": false,
  "emailVerified": false
}
```

### POST `/api/v1/auth/business/signup`
**Status**: ❌ NOT IMPLEMENTED

Register a new business user

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/business/signup" \
  -H "Content-Type: application/json" \
  -d '{
  "email": "user@example.com",
  "password": "SecurePass123",
  "firstName": "John",
  "lastName": "Doe",
  "referralCode": "ABC12345",
  "recaptcha_token": "03AGdBq25..."
}'
```

**Example response** (`201`):
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "role": "USER",
  "profile_status": "complete",
  "isOnboardingCompleted": false,
  "emailVerified": false
}
```

### POST `/api/v1/auth/business/login`
**Status**: ❌ NOT IMPLEMENTED

Login for business users

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/business/login" \
  -H "Content-Type: application/json" \
  -d '{
  "email": "user@example.com",
  "password": "SecurePass123",
  "recaptcha_token": "03AGdBq25..."
}'
```

**Example response** (`200`):
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "role": "USER",
  "profile_status": "complete",
  "isOnboardingCompleted": false,
  "emailVerified": false
}
```

### POST `/api/v1/auth/logout`
**Status**: ❌ NOT IMPLEMENTED

Logout current session

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/logout" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Successfully logged out

### POST `/api/v1/auth/logout-all`
**Status**: ❌ NOT IMPLEMENTED

Logout from all devices

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/logout-all" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Successfully logged out from all devices

### POST `/api/v1/auth/refresh`
**Status**: ❌ NOT IMPLEMENTED

Refresh access token

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/refresh" \
  -H "Content-Type: application/json" \
  -d '{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}'
```

**Example response** (`200`):
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "role": "USER",
  "profile_status": "complete",
  "isOnboardingCompleted": false,
  "emailVerified": false
}
```

### GET `/api/v1/auth/google`
**Status**: ❌ NOT IMPLEMENTED

Initiate Google OAuth login

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/auth/google"
```

**Response** (`302`): Redirects to Google OAuth

### GET `/api/v1/auth/google/callback`
**Status**: ❌ NOT IMPLEMENTED

Google OAuth callback

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/auth/google/callback"
```

**Response** (`200`): Successfully authenticated with Google

### POST `/api/v1/auth/firebase-login`
**Status**: ❌ NOT IMPLEMENTED

Firebase token login (Flutter / mobile)

Verify a Firebase ID token obtained from Firebase Auth (Google Sign-In, Apple Sign-In, etc.). Automatically creates the user account in the database if it does not exist yet. Returns the same access_token / refresh_token pair as the regular login endpoint.

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/firebase-login"
```

**Response** (`201`): Authenticated — tokens returned

### POST `/api/v1/auth/passkey/register/start`
**Status**: ❌ NOT IMPLEMENTED

Start passkey registration

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/passkey/register/start" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "deviceName": "iPhone 15 Pro"
}'
```

**Response** (`200`): Registration options generated

### POST `/api/v1/auth/passkey/register/finish`
**Status**: ❌ NOT IMPLEMENTED

Complete passkey registration

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/passkey/register/finish" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "response": {
    "id": "base64url-encoded-credential-id",
    "rawId": "base64url-encoded-raw-id",
    "response": {
      "attestationObject": "base64url-encoded-attestation-object",
      "clientDataJSON": "base64url-encoded-client-data"
    },
    "type": "public-key"
  }
}'
```

**Response** (`201`): Passkey successfully registered

### POST `/api/v1/auth/passkey/login/start`
**Status**: ❌ NOT IMPLEMENTED

Start passkey login

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/passkey/login/start" \
  -H "Content-Type: application/json" \
  -d '{
  "email": "user@example.com"
}'
```

**Response** (`200`): Authentication options generated

### POST `/api/v1/auth/passkey/login/finish`
**Status**: ❌ NOT IMPLEMENTED

Complete passkey login

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/passkey/login/finish" \
  -H "Content-Type: application/json" \
  -d '{
  "email": "user@example.com",
  "response": {
    "id": "base64url-encoded-credential-id",
    "rawId": "base64url-encoded-raw-id",
    "response": {
      "authenticatorData": "base64url-encoded-authenticator-data",
      "clientDataJSON": "base64url-encoded-client-data",
      "signature": "base64url-encoded-signature",
      "userHandle": "base64url-encoded-user-handle"
    },
    "type": "public-key"
  }
}'
```

**Example response** (`200`):
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "role": "USER",
  "profile_status": "complete",
  "isOnboardingCompleted": false,
  "emailVerified": false
}
```

### POST `/api/v1/auth/forgot-password`
**Status**: ❌ NOT IMPLEMENTED

Request password reset OTP (sent to email)

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/forgot-password" \
  -H "Content-Type: application/json" \
  -d '{
  "email": "user@example.com"
}'
```

**Response** (`200`): Reset OTP sent (if account exists)

### POST `/api/v1/auth/verify-reset-otp`
**Status**: ❌ NOT IMPLEMENTED

Verify password reset OTP and get a one-time reset token

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/verify-reset-otp" \
  -H "Content-Type: application/json" \
  -d '{
  "email": "user@example.com",
  "otp": "482913"
}'
```

**Response** (`200`): OTP valid — returns reset_token for use in /auth/reset-password

### POST `/api/v1/auth/reset-password`
**Status**: ❌ NOT IMPLEMENTED

Reset password using token from /auth/verify-reset-otp

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/reset-password" \
  -H "Content-Type: application/json" \
  -d '{
  "token": "string",
  "newPassword": "NewSecure123"
}'
```

**Response** (`200`): Password reset successful

### POST `/api/v1/auth/change-password`
**Status**: ❌ NOT IMPLEMENTED

Change password (authenticated)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/change-password" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "currentPassword": "string",
  "newPassword": "NewSecure123"
}'
```

**Response** (`200`): Password changed

### POST `/api/v1/auth/send-verification-email`
**Status**: ❌ NOT IMPLEMENTED

Send email verification OTP

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/send-verification-email" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Verification email sent

### POST `/api/v1/auth/verify-email`
**Status**: ⚠️ PARTIAL/WRONG

> AuthViewModel.verification() calls AuthService.verificationEmail(email:code:) — anonymous, unauthenticated. Real endpoint takes {otp} only and requires a Bearer token (verify YOUR OWN email while logged in). Contract completely different.

Verify email with OTP code

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/verify-email" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "otp": "123456"
}'
```

**Response** (`200`): Email verified

### POST `/api/v1/auth/resend-verification`
**Status**: ❌ NOT IMPLEMENTED

Resend verification email

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/resend-verification" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Verification email resent

### POST `/api/v1/auth/2fa/setup`
**Status**: ❌ NOT IMPLEMENTED

Set up 2FA — returns QR code and secret

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/2fa/setup" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 2FA setup data returned

### POST `/api/v1/auth/2fa/enable`
**Status**: ❌ NOT IMPLEMENTED

Enable 2FA after verifying a TOTP code

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/2fa/enable" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "code": "123456"
}'
```

**Response** (`200`): 2FA enabled

### POST `/api/v1/auth/2fa/disable`
**Status**: ❌ NOT IMPLEMENTED

Disable 2FA

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/2fa/disable" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "code": "123456"
}'
```

**Response** (`200`): 2FA disabled

### POST `/api/v1/auth/2fa/verify`
**Status**: ❌ NOT IMPLEMENTED

Complete 2FA login with TOTP code

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/auth/2fa/verify" \
  -H "Content-Type: application/json" \
  -d '{
  "code": "123456",
  "tempToken": "string"
}'
```

**Example response** (`200`):
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "role": "USER",
  "profile_status": "complete",
  "isOnboardingCompleted": false,
  "emailVerified": false
}
```

### GET `/api/v1/auth/me`
**Status**: ❌ NOT IMPLEMENTED

Get current authenticated user

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/auth/me" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Current user info


## Users

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/users/profile` | Get current user profile |
| ❌ | PUT | `/api/v1/users/profile` | Update current user profile (full update) |
| ❌ | GET | `/api/v1/users/me/stats` | Consolidated activity stats for the current user (History & Statistics) |
| ❌ | GET | `/api/v1/users/me/stats/monthly` | Month-by-month activity for the History & Statistics chart |
| ❌ | GET | `/api/v1/users/check-username` | Check if a username is available (case-insensitive) |
| ❌ | PATCH | `/api/v1/users/{id}/profile` | Update user profile by ID (partial update) |
| ❌ | GET | `/api/v1/users/referral-code` | Get current user referral code |
| ❌ | GET | `/api/v1/users/{id}/referral-code` | Get user referral code by ID |
| ❌ | GET | `/api/v1/users/referral-code/{code}/validate` | Validate a referral code |
| ❌ | GET | `/api/v1/users/referrals` | Get users referred by current user |
| ❌ | GET | `/api/v1/users/{id}/host-profile` | Get host profile card (public — ratings, stats, recent reviews) |
| ❌ | GET | `/api/v1/users/{id}` | Get user by ID |
| ❌ | GET | `/api/v1/users/{id}/qr` | Generate QR code for user identity (for event check-in) |
| ❌ | GET | `/api/v1/users/{id}/rewards` | Get user reward/badge status |
| ❌ | GET | `/api/v1/users/{id}/profile-completeness` | Get user profile completeness |
| ❌ | POST | `/api/v1/users/{id}/follow` | Follow a user |
| ❌ | DELETE | `/api/v1/users/{id}/follow` | Unfollow a user |
| ❌ | GET | `/api/v1/users/{id}/followers` | Get user followers |
| ❌ | GET | `/api/v1/users/{id}/following` | Get users this user is following |
| ❌ | GET | `/api/v1/users/{id}/follow-stats` | Get follow statistics for a user |
| ❌ | GET | `/api/v1/users/follow/suggestions` | Get follow suggestions based on shared hobbies |

### GET `/api/v1/users/profile`
**Status**: ❌ NOT IMPLEMENTED

Get current user profile

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/profile" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): User profile returned

### PUT `/api/v1/users/profile`
**Status**: ❌ NOT IMPLEMENTED

Update current user profile (full update)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PUT \
  "http://84.247.131.180/api/v1/users/profile" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "username": "johnsmith123",
  "firstName": "John",
  "lastName": "Doe",
  "displayName": "JohnD",
  "avatar": "https://example.com/avatar.jpg",
  "bio": "Love hiking and photography"
}'
```

**Response** (`200`): Profile updated successfully

### GET `/api/v1/users/me/stats`
**Status**: ❌ NOT IMPLEMENTED

Consolidated activity stats for the current user (History & Statistics)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/me/stats" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Events created/attended, tickets, followers, host rating

### GET `/api/v1/users/me/stats/monthly`
**Status**: ❌ NOT IMPLEMENTED

Month-by-month activity for the History & Statistics chart

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/me/stats/monthly" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 12 months, each { label, value, events[] {title, price, category, icon} }

### GET `/api/v1/users/check-username`
**Status**: ❌ NOT IMPLEMENTED

Check if a username is available (case-insensitive)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/check-username?username=VALUE" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Availability result

### PATCH `/api/v1/users/{id}/profile`
**Status**: ❌ NOT IMPLEMENTED

Update user profile by ID (partial update)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PATCH \
  "http://84.247.131.180/api/v1/users/id/profile" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "username": "johnsmith123",
  "firstName": "John",
  "lastName": "Doe",
  "displayName": "JohnD",
  "avatar": "https://example.com/avatar.jpg",
  "bio": "Love hiking and photography"
}'
```

**Response** (`200`): Profile updated successfully

### GET `/api/v1/users/referral-code`
**Status**: ❌ NOT IMPLEMENTED

Get current user referral code

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/referral-code" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Referral code returned

### GET `/api/v1/users/{id}/referral-code`
**Status**: ❌ NOT IMPLEMENTED

Get user referral code by ID

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/id/referral-code" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Referral code returned

### GET `/api/v1/users/referral-code/{code}/validate`
**Status**: ❌ NOT IMPLEMENTED

Validate a referral code

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/referral-code/code/validate" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Validation result

### GET `/api/v1/users/referrals`
**Status**: ❌ NOT IMPLEMENTED

Get users referred by current user

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/referrals" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Referrals list returned

### GET `/api/v1/users/{id}/host-profile`
**Status**: ❌ NOT IMPLEMENTED

Get host profile card (public — ratings, stats, recent reviews)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/id/host-profile" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Host profile card returned

### GET `/api/v1/users/{id}`
**Status**: ❌ NOT IMPLEMENTED

Get user by ID

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): User found

### GET `/api/v1/users/{id}/qr`
**Status**: ❌ NOT IMPLEMENTED

Generate QR code for user identity (for event check-in)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/id/qr" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): QR code data URL returned

### GET `/api/v1/users/{id}/rewards`
**Status**: ❌ NOT IMPLEMENTED

Get user reward/badge status

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/id/rewards" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Reward status returned

### GET `/api/v1/users/{id}/profile-completeness`
**Status**: ❌ NOT IMPLEMENTED

Get user profile completeness

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/id/profile-completeness" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Profile completeness returned

### POST `/api/v1/users/{id}/follow`
**Status**: ❌ NOT IMPLEMENTED

Follow a user

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/users/id/follow" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Successfully followed

### DELETE `/api/v1/users/{id}/follow`
**Status**: ❌ NOT IMPLEMENTED

Unfollow a user

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/users/id/follow" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Successfully unfollowed

### GET `/api/v1/users/{id}/followers`
**Status**: ❌ NOT IMPLEMENTED

Get user followers

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/id/followers" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Followers list

### GET `/api/v1/users/{id}/following`
**Status**: ❌ NOT IMPLEMENTED

Get users this user is following

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/id/following" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Following list

### GET `/api/v1/users/{id}/follow-stats`
**Status**: ❌ NOT IMPLEMENTED

Get follow statistics for a user

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/id/follow-stats" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Follow stats

### GET `/api/v1/users/follow/suggestions`
**Status**: ❌ NOT IMPLEMENTED

Get follow suggestions based on shared hobbies

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/follow/suggestions" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Suggested users to follow


## beta

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | POST | `/api/v1/beta/validate` | Check whether a beta invite code is currently valid (public) |
| ❌ | POST | `/api/v1/beta/codes` | Create a beta invite code (admin) |
| ❌ | GET | `/api/v1/beta/codes` | List beta invite codes (admin) |
| ❌ | DELETE | `/api/v1/beta/codes/{id}` | Deactivate a beta invite code (admin) |

### POST `/api/v1/beta/validate`
**Status**: ❌ NOT IMPLEMENTED

Check whether a beta invite code is currently valid (public)

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/beta/validate" \
  -H "Content-Type: application/json" \
  -d '{
  "code": "KUMELE-BETA-2026"
}'
```

**Response** (`200`): { valid: boolean, reason?, remaining? }

### POST `/api/v1/beta/codes`
**Status**: ❌ NOT IMPLEMENTED

Create a beta invite code (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/beta/codes" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "code": "string",
  "maxUses": 1,
  "note": "string",
  "expiresAt": "string",
  "active": true
}'
```

**Response** (`201`): 

### GET `/api/v1/beta/codes`
**Status**: ❌ NOT IMPLEMENTED

List beta invite codes (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/beta/codes" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 

### DELETE `/api/v1/beta/codes/{id}`
**Status**: ❌ NOT IMPLEMENTED

Deactivate a beta invite code (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/beta/codes/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 


## Upload

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | POST | `/api/v1/upload/image` | Upload a profile image |
| ❌ | POST | `/api/v1/upload/event-banner` | Upload an event banner image |
| ❌ | POST | `/api/v1/upload/blog-image` | Upload a blog image |
| ❌ | POST | `/api/v1/upload/nft-image` | Upload an NFT image |

### POST `/api/v1/upload/image`
**Status**: ❌ NOT IMPLEMENTED

Upload a profile image

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/upload/image" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -F "file=@/path/to/file.jpg"
```

**Response** (`201`): Image uploaded successfully

### POST `/api/v1/upload/event-banner`
**Status**: ❌ NOT IMPLEMENTED

Upload an event banner image

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/upload/event-banner" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -F "file=@/path/to/file.jpg" \
  -F "eventId=value"
```

**Response** (`201`): Event banner uploaded successfully

### POST `/api/v1/upload/blog-image`
**Status**: ❌ NOT IMPLEMENTED

Upload a blog image

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/upload/blog-image" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -F "file=@/path/to/file.jpg" \
  -F "blogId=value"
```

**Response** (`201`): Blog image uploaded successfully

### POST `/api/v1/upload/nft-image`
**Status**: ❌ NOT IMPLEMENTED

Upload an NFT image

Uploads to Cloudinary under a unique public_id (fixes the "all cards show the same image" bug). Pass nftId to have imageUrl persisted directly to the NftCollection record.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/upload/nft-image" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -F "file=@/path/to/file.jpg" \
  -F "nftId=value"
```

**Response** (`201`): NFT image uploaded successfully


## events

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | POST | `/api/v1/events` | Create event (Host only) |
| ⚠️ | GET | `/api/v1/events` | List events with filters (cursor-based pagination) |
| ⚠️ | GET | `/api/v1/events/recommendations` | Get AI-powered personalised event recommendations |
| ❌ | GET | `/api/v1/events/{id}` | Get event details by ID |
| ❌ | POST | `/api/v1/events/{id}/join` | Join event (triggers matching) |
| ❌ | POST | `/api/v1/events/{id}/cancel` | Cancel event (host only) |
| ❌ | GET | `/api/v1/events/{id}/guests` | Get event guest list (host only) |
| ❌ | POST | `/api/v1/events/{id}/checkin/host-scan` | Host scans guest QR to check in |
| ❌ | POST | `/api/v1/events/{id}/checkin/self` | Self check-in via GPS (≤2km) |
| ❌ | POST | `/api/v1/events/{id}/finalize-matches` | Finalize all matches and create chat (host only) |
| ❌ | POST | `/api/v1/events/participations/{participationId}/finalize` | Finalize single match (host only) |
| ❌ | POST | `/api/v1/events/{id}/ratings` | Rate an event (verified attendees only, event must have ended) |
| ❌ | GET | `/api/v1/events/{id}/ratings` | Get event ratings (paginated) |
| ❌ | GET | `/api/v1/events/{id}/ratings/mine` | Get my rating for this event |
| ❌ | GET | `/api/v1/events/{id}/ratings/summary` | Get advanced ratings summary (averages, distribution, sub-ratings) |
| ❌ | PUT | `/api/v1/events/{id}/ratings/{ratingId}` | Update your event rating |
| ❌ | DELETE | `/api/v1/events/{id}/ratings/{ratingId}` | Delete your event rating |
| ❌ | POST | `/api/v1/events/{id}/reports` | Report an event |
| ❌ | GET | `/api/v1/events/{id}/reports` | Get event reports (admin only) |

### POST `/api/v1/events`
**Status**: ❌ NOT IMPLEMENTED

Create event (Host only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/events" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "title": "Football Match",
  "description": "Friendly game at the park",
  "hobbyCategoryId": "string",
  "eventStartTime": "2026-02-01T18:00:00Z",
  "eventEndTime": "2026-02-01T21:00:00Z",
  "capacity": 2,
  "isPaid": true,
  "latitude": 52.52,
  "longitude": 13.405,
  "displayAddress": "Berlin, Germany"
}'
```

**Response** (`201`): Event created successfully

### GET `/api/v1/events`
**Status**: ⚠️ PARTIAL/WRONG

> EventServices.getEventList() is hardcoded mock data; real endpoint is a single unified GET with hobbyCategoryId/city/hobby/hostId/centerLat/centerLon/radiusKm/cursor/limit query params (cursor pagination). No Swift call site matches this shape yet.

List events with filters (cursor-based pagination)

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/events?cursor=550e8400-e29b-41d4-a716-446655440000&limit=20"
```

**Response** (`200`): List of events (lightweight card projection)

### GET `/api/v1/events/recommendations`
**Status**: ⚠️ PARTIAL/WRONG

> EventServices.getEventMatched() is hardcoded mock data with no real call. Likely real equivalent of 'matched events' but unconfirmed with backend team — needs verification, not just uncommenting.

Get AI-powered personalised event recommendations

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/events/recommendations" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): AI event recommendations (advisory)

### GET `/api/v1/events/{id}`
**Status**: ❌ NOT IMPLEMENTED

Get event details by ID

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/events/id"
```

**Response** (`200`): Event details

### POST `/api/v1/events/{id}/join`
**Status**: ❌ NOT IMPLEMENTED

Join event (triggers matching)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/events/id/join" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Join request processed

### POST `/api/v1/events/{id}/cancel`
**Status**: ❌ NOT IMPLEMENTED

Cancel event (host only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/events/id/cancel" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "reason": "string"
}'
```

**Response** (`200`): Event cancelled successfully

### GET `/api/v1/events/{id}/guests`
**Status**: ❌ NOT IMPLEMENTED

Get event guest list (host only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/events/id/guests" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Guest list

### POST `/api/v1/events/{id}/checkin/host-scan`
**Status**: ❌ NOT IMPLEMENTED

Host scans guest QR to check in

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/events/id/checkin/host-scan" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "guestUserId": "string",
  "note": "string"
}'
```

**Response** (`200`): Guest checked in successfully

### POST `/api/v1/events/{id}/checkin/self`
**Status**: ❌ NOT IMPLEMENTED

Self check-in via GPS (≤2km)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/events/id/checkin/self" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "guestLat": 52.5205,
  "guestLng": 13.4049
}'
```

**Response** (`200`): Checked in successfully

### POST `/api/v1/events/{id}/finalize-matches`
**Status**: ❌ NOT IMPLEMENTED

Finalize all matches and create chat (host only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/events/id/finalize-matches" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Matches finalized, chat created

### POST `/api/v1/events/participations/{participationId}/finalize`
**Status**: ❌ NOT IMPLEMENTED

Finalize single match (host only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/events/participations/participationId/finalize" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Match finalized

### POST `/api/v1/events/{id}/ratings`
**Status**: ❌ NOT IMPLEMENTED

Rate an event (verified attendees only, event must have ended)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/events/id/ratings" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "eventRating": 1,
  "comment": "string",
  "communication": 1,
  "respect": 1,
  "professionalism": 1,
  "atmosphere": 1
}'
```

**Response** (`201`): Rating created

### GET `/api/v1/events/{id}/ratings`
**Status**: ❌ NOT IMPLEMENTED

Get event ratings (paginated)

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/events/id/ratings"
```

**Response** (`200`): Event ratings

### GET `/api/v1/events/{id}/ratings/mine`
**Status**: ❌ NOT IMPLEMENTED

Get my rating for this event

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/events/id/ratings/mine" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Your rating

### GET `/api/v1/events/{id}/ratings/summary`
**Status**: ❌ NOT IMPLEMENTED

Get advanced ratings summary (averages, distribution, sub-ratings)

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/events/id/ratings/summary"
```

**Response** (`200`): Ratings summary

### PUT `/api/v1/events/{id}/ratings/{ratingId}`
**Status**: ❌ NOT IMPLEMENTED

Update your event rating

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PUT \
  "http://84.247.131.180/api/v1/events/id/ratings/ratingId" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "eventRating": 1,
  "comment": "string",
  "communication": 1,
  "respect": 1,
  "professionalism": 1,
  "atmosphere": 1
}'
```

**Response** (`200`): Rating updated

### DELETE `/api/v1/events/{id}/ratings/{ratingId}`
**Status**: ❌ NOT IMPLEMENTED

Delete your event rating

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/events/id/ratings/ratingId" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Rating deleted

### POST `/api/v1/events/{id}/reports`
**Status**: ❌ NOT IMPLEMENTED

Report an event

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/events/id/reports" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "reason": "string",
  "details": "string"
}'
```

**Response** (`201`): Report submitted

### GET `/api/v1/events/{id}/reports`
**Status**: ❌ NOT IMPLEMENTED

Get event reports (admin only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/events/id/reports" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Event reports


## users

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/users/{id}/attendance` | Get user attendance history |

### GET `/api/v1/users/{id}/attendance`
**Status**: ❌ NOT IMPLEMENTED

Get user attendance history

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/users/id/attendance" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Attendance history


## chat

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/events/{eventId}/chat/status` | Get event chat room status |
| ❌ | POST | `/api/v1/events/{eventId}/chat/create` | Create event chat room (host only) |
| ❌ | POST | `/api/v1/events/{eventId}/chat/join` | Join event chat |
| ❌ | GET | `/api/v1/events/{eventId}/chat/messages` | Get chat messages (paginated) |
| ❌ | POST | `/api/v1/events/{eventId}/chat/messages` | Send a chat message |
| ❌ | GET | `/api/v1/chat/rooms` | Get all chat rooms for current user |

### GET `/api/v1/events/{eventId}/chat/status`
**Status**: ❌ NOT IMPLEMENTED

Get event chat room status

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/events/eventId/chat/status" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Chat status

### POST `/api/v1/events/{eventId}/chat/create`
**Status**: ❌ NOT IMPLEMENTED

Create event chat room (host only)

Allows the event host to create the chat room at any time. The room is also auto-created when the host calls POST /chat/join or POST /finalize-matches.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/events/eventId/chat/create" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`201`): Chat room created (or already exists)

### POST `/api/v1/events/{eventId}/chat/join`
**Status**: ❌ NOT IMPLEMENTED

Join event chat

Join an event chat room. Must be a matched participant or the host. If you are the host and no chat room exists yet, it will be created automatically.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/events/eventId/chat/join" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Joined chat room

### GET `/api/v1/events/{eventId}/chat/messages`
**Status**: ❌ NOT IMPLEMENTED

Get chat messages (paginated)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/events/eventId/chat/messages" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Chat messages

### POST `/api/v1/events/{eventId}/chat/messages`
**Status**: ❌ NOT IMPLEMENTED

Send a chat message

Sends a new message to the event chat room. The room must be ACTIVE. User must be the host or a matched participant. Also broadcasts to WebSocket subscribers in real time.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/events/eventId/chat/messages" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Example response** (`201`):
```json
{
  "ok": true,
  "data": {
    "id": "msg_123",
    "event_id": "event_456",
    "user_id": "user_789",
    "username": "Alkesh Kumar",
    "message_text": "Welcome to my event",
    "created_at": "2025-10-08T12:00:00Z"
  },
  "message": "Message sent",
  "statusCode": 201
}
```

### GET `/api/v1/chat/rooms`
**Status**: ❌ NOT IMPLEMENTED

Get all chat rooms for current user

Returns every chat room the user has access to — both ACTIVE and CLOSED. Use this to build the chat inbox / history screen. To read messages from a closed room, call GET /events/:id/chat/messages.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/chat/rooms" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Example response** (`200`):
```json
{
  "ok": true,
  "data": [
    {
      "id": "room_xxx",
      "event_id": "evt_xxx",
      "event_name": "Group Meditation",
      "event_date": "2026-10-08T00:00:00.000Z",
      "event_image": "https://res.cloudinary.com/...",
      "host_id": "usr_xxx",
      "host_name": "Alkesh Kumar",
      "host_image": "https://res.cloudinary.com/...",
      "status": "CLOSED",
      "is_open": false,
      "opened_at": "2026-10-08T18:00:00.000Z",
      "closes_at": "2026-10-09T18:00:00.000Z",
      "closed_at": "2026-10-09T18:00:05.000Z"
    }
  ]
}
```


## event-plans

| Status | Method | Path | Summary |
|---|---|---|---|
| 🟢 | GET | `/api/v1/event-plans` | List active create-event capacity plans (public) — wired 2026-07-28, `EventPlanService.plans()` |
| ❌ | POST | `/api/v1/event-plans` | Create a capacity tier (admin) |
| 🟢 | GET | `/api/v1/event-plans/quote` | Price to create an event of a given capacity (public) — wired 2026-07-28, `EventPlanService.quote(capacity:)` |
| ❌ | GET | `/api/v1/event-plans/admin/all` | List all tiers incl. inactive (admin) |
| ❌ | PATCH | `/api/v1/event-plans/{id}` | Update a capacity tier / its price (admin) |
| ❌ | DELETE | `/api/v1/event-plans/{id}` | Delete a capacity tier (admin) |

### GET `/api/v1/event-plans`
**Status**: ❌ NOT IMPLEMENTED

List active create-event capacity plans (public)

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/event-plans"
```

**Response** (`200`): Active tiers

### POST `/api/v1/event-plans`
**Status**: ❌ NOT IMPLEMENTED

Create a capacity tier (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/event-plans" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "label": "Medium (6-20 guests)",
  "minGuests": 6,
  "maxGuests": 20,
  "priceEurMinor": 999,
  "currency": "string",
  "active": true
}'
```

**Response** (`201`): 

### GET `/api/v1/event-plans/quote`
**Status**: ❌ NOT IMPLEMENTED

Price to create an event of a given capacity (public)

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/event-plans/quote?capacity=VALUE"
```

**Response** (`200`): { requiresPayment, priceEur, tier }

### GET `/api/v1/event-plans/admin/all`
**Status**: ❌ NOT IMPLEMENTED

List all tiers incl. inactive (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/event-plans/admin/all" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 

### PATCH `/api/v1/event-plans/{id}`
**Status**: ❌ NOT IMPLEMENTED

Update a capacity tier / its price (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PATCH \
  "http://84.247.131.180/api/v1/event-plans/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "label": "string",
  "minGuests": 1,
  "maxGuests": 1,
  "priceEurMinor": 1,
  "currency": "string",
  "active": true
}'
```

**Response** (`200`): 

### DELETE `/api/v1/event-plans/{id}`
**Status**: ❌ NOT IMPLEMENTED

Delete a capacity tier (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/event-plans/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 


## hobbies

| Status | Method | Path | Summary |
|---|---|---|---|
| ⚠️ | GET | `/api/v1/hobbies/categories` | Get all hobby categories |
| ❌ | GET | `/api/v1/hobbies/categories/{id}/hobbies` | Get hobbies by category |
| ❌ | GET | `/api/v1/hobbies/users/{id}` | Get user hobby preferences |
| ⚠️ | PUT | `/api/v1/hobbies/users/{id}` | Update user hobby preferences |
| ❌ | POST | `/api/v1/hobbies/seed` | Seed default hobbies (Admin only) |
| ❌ | POST | `/api/v1/hobbies/seed-icons` | Patch icon + color on existing hobby categories (Admin only) |

### GET `/api/v1/hobbies/categories`
**Status**: ⚠️ PARTIAL/WRONG

> AuthService.getHobbies() is hardcoded (25 static hobbies, flat list). Real endpoint returns a category→hobbies tree. Needs full rewrite + new model shape.

Get all hobby categories

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/hobbies/categories"
```

**Response** (`200`): List of hobby categories

### GET `/api/v1/hobbies/categories/{id}/hobbies`
**Status**: ❌ NOT IMPLEMENTED

Get hobbies by category

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/hobbies/categories/id/hobbies"
```

**Response** (`200`): List of hobbies in category

### GET `/api/v1/hobbies/users/{id}`
**Status**: ❌ NOT IMPLEMENTED

Get user hobby preferences

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/hobbies/users/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): User hobby preferences

### PUT `/api/v1/hobbies/users/{id}`
**Status**: ⚠️ PARTIAL/WRONG

> AuthService.setHobbies(hobbies:[Int]) posts to a different (dead) endpoint (/api/select-hobbies/) with a flat Int array. Real endpoint is PUT /hobbies/users/{id} with {hobbies:[{hobbyId, skillLevel?, isPrimary?}]}. Needs full rewrite.

Update user hobby preferences

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PUT \
  "http://84.247.131.180/api/v1/hobbies/users/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "hobbies": [
    {
      "hobbyId": "string",
      "skillLevel": 1,
      "isPrimary": true
    }
  ]
}'
```

**Response** (`200`): Updated hobby preferences

### POST `/api/v1/hobbies/seed`
**Status**: ❌ NOT IMPLEMENTED

Seed default hobbies (Admin only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/hobbies/seed" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Hobbies seeded successfully

### POST `/api/v1/hobbies/seed-icons`
**Status**: ❌ NOT IMPLEMENTED

Patch icon + color on existing hobby categories (Admin only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/hobbies/seed-icons" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Icons/colors updated for existing categories


## Blogs

| Status | Method | Path | Summary |
|---|---|---|---|
| ⚠️ | GET | `/api/v1/blogs/feed` | Get blog feed (cursor-based pagination, approved + visibility filtered) |
| ❌ | GET | `/api/v1/blogs/public/{slug}` | Get public SEO blog post by slug |
| ❌ | GET | `/api/v1/blogs/sitemap` | Get list of public SEO blog slugs for sitemap |
| ⚠️ | GET | `/api/v1/blogs/{id}` | Get blog post detail by ID (pass JWT to get is_liked) |
| ❌ | GET | `/api/v1/blogs/{id}/comments` | Get comments for a blog post (cursor-based) |
| ❌ | POST | `/api/v1/blogs/{id}/comments` | Add a comment to a blog post |
| ❌ | POST | `/api/v1/blogs` | Create a blog post (with markdown processing pipeline) |
| ❌ | POST | `/api/v1/blogs/{id}/like` | Toggle like on a blog post |

### GET `/api/v1/blogs/feed`
**Status**: ⚠️ PARTIAL/WRONG

> BlogServices.fetchAllBlog()/fetchAllBlogByCategory() are hardcoded mock data (6 static posts). Real endpoint is cursor-paginated with hobbyCategoryId/sortBy/cursor/limit query params. Needs full rewrite.

Get blog feed (cursor-based pagination, approved + visibility filtered)

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/blogs/feed?sortBy=most_recent&cursor=550e8400-e29b-41d4-a716-446655440000&limit=20"
```

**Response** (`200`): Blog feed returned

### GET `/api/v1/blogs/public/{slug}`
**Status**: ❌ NOT IMPLEMENTED

Get public SEO blog post by slug

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/blogs/public/slug"
```

**Response** (`200`): Blog post returned

### GET `/api/v1/blogs/sitemap`
**Status**: ❌ NOT IMPLEMENTED

Get list of public SEO blog slugs for sitemap

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/blogs/sitemap"
```

**Response** (`200`): List of public blog slugs

### GET `/api/v1/blogs/{id}`
**Status**: ⚠️ PARTIAL/WRONG

> BlogServices.fetchBlogDetail() is hardcoded mock data (fixed article id 101, ignores blogId param). Comments are additionally double-mocked client-side in BlogViewModel. Needs full rewrite; comments should use GET /blogs/{id}/comments.

Get blog post detail by ID (pass JWT to get is_liked)

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/blogs/id"
```

**Response** (`200`): Blog post returned

### GET `/api/v1/blogs/{id}/comments`
**Status**: ❌ NOT IMPLEMENTED

Get comments for a blog post (cursor-based)

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/blogs/id/comments"
```

**Response** (`200`): Comments returned

### POST `/api/v1/blogs/{id}/comments`
**Status**: ❌ NOT IMPLEMENTED

Add a comment to a blog post

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/blogs/id/comments" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "content": "Great post!",
  "parentId": "string"
}'
```

**Response** (`201`): Comment created

### POST `/api/v1/blogs`
**Status**: ❌ NOT IMPLEMENTED

Create a blog post (with markdown processing pipeline)

Processes markdown → HTML → sanitizes → calculates quality/spam scores → determines visibility and moderation status.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/blogs" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "title": "My Football Experience",
  "markdownSource": "## Overview\n\nGreat match today...",
  "content": "string",
  "coverImageUrl": "string",
  "bannerImageUrl": "string",
  "videoLink": "string"
}'
```

**Response** (`201`): Blog post created (may be pending review)

### POST `/api/v1/blogs/{id}/like`
**Status**: ❌ NOT IMPLEMENTED

Toggle like on a blog post

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/blogs/id/like" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Like toggled


## payments

| Status | Method | Path | Summary |
|---|---|---|---|
| 🟢 | POST | `/api/v1/payments/confirm` | Confirm a Stripe payment after client-side confirmation — wired 2026-07-28, `PaymentService.confirm(paymentIntentID:)`; unreachable from UI until a Stripe SDK exists to produce a confirmed PaymentIntent |
| ❌ | POST | `/api/v1/payments/event` | Create payment intent for event participation |
| 🟢 | POST | `/api/v1/payments/event-creation/{eventId}` | Checkout for the host's create-event capacity plan — wired 2026-07-28, `PaymentService.createEventCreationPayment(eventID:)` |
| ❌ | GET | `/api/v1/payments/history` | Get payment history |
| ❌ | GET | `/api/v1/payments/{id}/escrow` | Get escrow status for a payment |
| 🟢 | POST | `/api/v1/payments/paypal/create-order` | Create a PayPal order for event payment — wired 2026-07-28, `EventPaymentViewModel.startPayPalCheckout`, called from the swipe-card join action |
| 🟢 | POST | `/api/v1/payments/paypal/capture/{orderId}` | Capture a PayPal order after user approval — wired 2026-07-28, `EventPaymentViewModel.completeAfterApproval` |
| ❌ | GET | `/api/v1/payments/paypal/status/{orderId}` | Get PayPal order status |
| ❌ | POST | `/api/v1/payments/paypal/vault/setup-token` | Create a PayPal vault setup token |
| ❌ | POST | `/api/v1/payments/cards/setup-intent` | Create a Stripe SetupIntent to tokenize a new card |
| ❌ | POST | `/api/v1/payments/cards` | Save a card to the user profile after Stripe tokenization |
| ❌ | GET | `/api/v1/payments/cards` | List all saved cards for the current user |
| ❌ | PATCH | `/api/v1/payments/cards/{id}/default` | Set a card as the default payment method |
| ❌ | DELETE | `/api/v1/payments/cards/{id}` | Remove a saved card from profile and detach from Stripe |

### POST `/api/v1/payments/confirm`
**Status**: ❌ NOT IMPLEMENTED

Confirm a Stripe payment after client-side confirmation

Call this immediately after stripe.confirmCardPayment() resolves successfully. It fetches the PaymentIntent status from Stripe and updates the participation to CONFIRMED.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/payments/confirm" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Example response** (`200`):
```json
{
  "ok": true,
  "status": "SUCCEEDED",
  "message": "Payment confirmed and participation activated"
}
```

### POST `/api/v1/payments/event`
**Status**: ❌ NOT IMPLEMENTED

Create payment intent for event participation

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/payments/event" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "eventId": "string",
  "discountCode": "string",
  "rewardDiscountId": "string"
}'
```

**Response** (`200`): Payment intent created

### POST `/api/v1/payments/event-creation/{eventId}`
**Status**: ❌ NOT IMPLEMENTED

Checkout for the host's create-event capacity plan

Returns a clientSecret to pay the one-time plan for a DRAFT event. Once paid, call POST /payments/confirm to publish it (DRAFT -> ACTIVE). If the capacity is in a free bracket, the event is published immediately and no payment is required.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/payments/event-creation/eventId" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): clientSecret, or event published if free

### GET `/api/v1/payments/history`
**Status**: ❌ NOT IMPLEMENTED

Get payment history

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/payments/history" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Payment history

### GET `/api/v1/payments/{id}/escrow`
**Status**: ❌ NOT IMPLEMENTED

Get escrow status for a payment

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/payments/id/escrow" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Escrow status

### POST `/api/v1/payments/paypal/create-order`
**Status**: ❌ NOT IMPLEMENTED

Create a PayPal order for event payment

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/payments/paypal/create-order" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "eventId": "string",
  "discountCode": "string",
  "rewardDiscountId": "string"
}'
```

**Response** (`200`): PayPal order created with approval URL

### POST `/api/v1/payments/paypal/capture/{orderId}`
**Status**: ❌ NOT IMPLEMENTED

Capture a PayPal order after user approval

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/payments/paypal/capture/orderId" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Payment captured

### GET `/api/v1/payments/paypal/status/{orderId}`
**Status**: ❌ NOT IMPLEMENTED

Get PayPal order status

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/payments/paypal/status/orderId" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Order status

### POST `/api/v1/payments/paypal/vault/setup-token`
**Status**: ❌ NOT IMPLEMENTED

Create a PayPal vault setup token

Mints a PayPal Vault Setup Token server-side. Required by the PayPal SDK to show the real PayPal account-linking popup (Connect Escrow Account button). Returns { ok: true, id: "<token>" }.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/payments/paypal/vault/setup-token" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Example response** (`201`):
```json
{
  "ok": true,
  "id": "VAULT_SETUP_TOKEN_ID"
}
```

### POST `/api/v1/payments/cards/setup-intent`
**Status**: ❌ NOT IMPLEMENTED

Create a Stripe SetupIntent to tokenize a new card

Returns a client_secret. Pass it to stripe.confirmCardSetup() on the frontend.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/payments/cards/setup-intent" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Example response** (`201`):
```json
{
  "ok": true,
  "clientSecret": "seti_...",
  "setupIntentId": "seti_..."
}
```

### POST `/api/v1/payments/cards`
**Status**: ❌ NOT IMPLEMENTED

Save a card to the user profile after Stripe tokenization

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/payments/cards" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Example response** (`201`):
```json
{
  "ok": true,
  "card": {
    "id": "uuid",
    "brand": "visa",
    "last4": "4444",
    "expMonth": 12,
    "expYear": 2028,
    "isDefault": true
  }
}
```

### GET `/api/v1/payments/cards`
**Status**: ❌ NOT IMPLEMENTED

List all saved cards for the current user

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/payments/cards" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Saved cards list

### PATCH `/api/v1/payments/cards/{id}/default`
**Status**: ❌ NOT IMPLEMENTED

Set a card as the default payment method

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PATCH \
  "http://84.247.131.180/api/v1/payments/cards/id/default" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Default updated

### DELETE `/api/v1/payments/cards/{id}`
**Status**: ❌ NOT IMPLEMENTED

Remove a saved card from profile and detach from Stripe

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/payments/cards/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Card removed


## subscriptions

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/subscriptions/tiers` | Get available subscription tiers |
| ❌ | GET | `/api/v1/subscriptions/status` | Get current subscription status |
| ❌ | POST | `/api/v1/subscriptions` | Create new subscription (returns a PaymentIntent client secret for in-app payment) |
| ❌ | DELETE | `/api/v1/subscriptions` | Cancel subscription |
| ❌ | POST | `/api/v1/subscriptions/resume` | Resume subscription pending cancellation |
| ❌ | GET | `/api/v1/subscriptions/history` | Get subscription history |

### GET `/api/v1/subscriptions/tiers`
**Status**: ❌ NOT IMPLEMENTED

Get available subscription tiers

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/subscriptions/tiers"
```

**Response** (`200`): List of subscription tiers

### GET `/api/v1/subscriptions/status`
**Status**: ❌ NOT IMPLEMENTED

Get current subscription status

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/subscriptions/status" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Subscription status

### POST `/api/v1/subscriptions`
**Status**: ❌ NOT IMPLEMENTED

Create new subscription (returns a PaymentIntent client secret for in-app payment)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/subscriptions" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "tierId": "string",
  "discountCode": "string"
}'
```

**Response** (`200`): clientSecret + subscriptionId for stripe.confirmCardPayment

### DELETE `/api/v1/subscriptions`
**Status**: ❌ NOT IMPLEMENTED

Cancel subscription

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/subscriptions" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "reason": "string",
  "cancelImmediately": true
}'
```

**Response** (`200`): Subscription canceled

### POST `/api/v1/subscriptions/resume`
**Status**: ❌ NOT IMPLEMENTED

Resume subscription pending cancellation

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/subscriptions/resume" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Subscription resumed

### GET `/api/v1/subscriptions/history`
**Status**: ❌ NOT IMPLEMENTED

Get subscription history

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/subscriptions/history" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Subscription history


## discounts

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | POST | `/api/v1/discounts/validate` | Validate a discount code |
| ❌ | GET | `/api/v1/discounts/rewards` | Get user available reward discounts |
| ❌ | POST | `/api/v1/discounts` | Create discount code (Admin) |
| ❌ | GET | `/api/v1/discounts` | List discount codes (Admin) |
| ❌ | GET | `/api/v1/discounts/{code}` | Get discount code details (Admin) |
| ❌ | PUT | `/api/v1/discounts/{code}` | Update discount code (Admin) |
| ❌ | DELETE | `/api/v1/discounts/{code}` | Deactivate discount code (Admin) |

### POST `/api/v1/discounts/validate`
**Status**: ❌ NOT IMPLEMENTED

Validate a discount code

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/discounts/validate" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "code": "string",
  "productType": "string",
  "amountMinor": 1
}'
```

**Response** (`200`): Validation result

### GET `/api/v1/discounts/rewards`
**Status**: ❌ NOT IMPLEMENTED

Get user available reward discounts

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/discounts/rewards" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): List of available reward discounts

### POST `/api/v1/discounts`
**Status**: ❌ NOT IMPLEMENTED

Create discount code (Admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/discounts" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "code": "string",
  "type": "PERCENTAGE",
  "value": 1,
  "productTypes": [
    "string"
  ],
  "minAmountMinor": 1,
  "maxUses": 1
}'
```

**Response** (`201`): Discount code created

### GET `/api/v1/discounts`
**Status**: ❌ NOT IMPLEMENTED

List discount codes (Admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/discounts" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): List of discount codes

### GET `/api/v1/discounts/{code}`
**Status**: ❌ NOT IMPLEMENTED

Get discount code details (Admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/discounts/code" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Discount code details

### PUT `/api/v1/discounts/{code}`
**Status**: ❌ NOT IMPLEMENTED

Update discount code (Admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PUT \
  "http://84.247.131.180/api/v1/discounts/code" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "type": "PERCENTAGE",
  "value": 1,
  "maxUses": 1,
  "validUntil": "string",
  "isActive": true
}'
```

**Response** (`200`): Discount code updated

### DELETE `/api/v1/discounts/{code}`
**Status**: ❌ NOT IMPLEMENTED

Deactivate discount code (Admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/discounts/code" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Discount code deactivated


## refunds

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/refunds/eligibility/{paymentId}` | Check refund eligibility for a payment |
| ❌ | POST | `/api/v1/refunds` | Request a refund |
| ❌ | GET | `/api/v1/refunds/my-requests` | Get my refund requests |
| ❌ | GET | `/api/v1/refunds/pending` | Get pending refund requests (Admin) |
| ❌ | POST | `/api/v1/refunds/process` | Process refund request (Admin) |

### GET `/api/v1/refunds/eligibility/{paymentId}`
**Status**: ❌ NOT IMPLEMENTED

Check refund eligibility for a payment

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/refunds/eligibility/paymentId" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Eligibility status

### POST `/api/v1/refunds`
**Status**: ❌ NOT IMPLEMENTED

Request a refund

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/refunds" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "paymentId": "string",
  "reason": "EVENT_CANCELLED",
  "details": "string"
}'
```

**Response** (`200`): Refund request created

### GET `/api/v1/refunds/my-requests`
**Status**: ❌ NOT IMPLEMENTED

Get my refund requests

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/refunds/my-requests" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): List of refund requests

### GET `/api/v1/refunds/pending`
**Status**: ❌ NOT IMPLEMENTED

Get pending refund requests (Admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/refunds/pending" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Pending refund requests

### POST `/api/v1/refunds/process`
**Status**: ❌ NOT IMPLEMENTED

Process refund request (Admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/refunds/process" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "refundRequestId": "string",
  "approved": true,
  "notes": "string"
}'
```

**Response** (`200`): Refund processed


## Notifications

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | POST | `/api/v1/notifications/push-token` | Register FCM push token for current device |
| ❌ | POST | `/api/v1/notifications/tokens` | Register APNs/FCM push token (iOS alias) |
| ❌ | POST | `/api/v1/notifications/test` | Send a test push notification to your own registered devices |
| ❌ | GET | `/api/v1/notifications` | Get notification feed (paginated) |
| ❌ | POST | `/api/v1/notifications/{id}/read` | Mark a notification as read |
| ❌ | POST | `/api/v1/notifications/read-all` | Mark all notifications as read |

### POST `/api/v1/notifications/push-token`
**Status**: ❌ NOT IMPLEMENTED

Register FCM push token for current device

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/notifications/push-token" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "fcmToken": "string",
  "platform": "ios",
  "deviceId": "string",
  "language": "string"
}'
```

**Response** (`200`): Token registered successfully

### POST `/api/v1/notifications/tokens`
**Status**: ❌ NOT IMPLEMENTED

Register APNs/FCM push token (iOS alias)

iOS-friendly alias for POST /notifications/push-token. Accepts { token, deviceType, deviceId } instead of { fcmToken, platform, deviceId }.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/notifications/tokens" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "token": "802be59971e22db7...",
  "deviceType": "ios",
  "deviceId": "0B7B1ED9-FE0E-434D-8BD3-478E09B22D01"
}'
```

**Response** (`200`): Token registered successfully

### POST `/api/v1/notifications/test`
**Status**: ❌ NOT IMPLEMENTED

Send a test push notification to your own registered devices

Sends a "Kumele test" push to every active token registered for the current user. Returns how many tokens were found and the FCM success/failure counts. Use it to verify push delivery after registering a device token.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/notifications/test" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Example response** (`200`):
```json
{
  "tokensFound": 1,
  "success": 1,
  "failure": 0,
  "invalidTokens": 0
}
```

### GET `/api/v1/notifications`
**Status**: ❌ NOT IMPLEMENTED

Get notification feed (paginated)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/notifications?page=1&limit=20" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Example response** (`200`):
```json
{
  "notifications": [
    {
      "id": "string",
      "userId": "string",
      "type": "string",
      "title": "string",
      "body": "string",
      "isRead": true,
      "createdAt": "string"
    }
  ],
  "total": 1,
  "unreadCount": 1,
  "page": 1,
  "limit": 1,
  "hasMore": true
}
```

### POST `/api/v1/notifications/{id}/read`
**Status**: ❌ NOT IMPLEMENTED

Mark a notification as read

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/notifications/id/read" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Notification marked as read

### POST `/api/v1/notifications/read-all`
**Status**: ❌ NOT IMPLEMENTED

Mark all notifications as read

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/notifications/read-all" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): All notifications marked as read


## Ads

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | POST | `/api/v1/ads/campaigns` | Create a new ad campaign |
| ❌ | GET | `/api/v1/ads/campaigns` | List my ad campaigns |
| ❌ | PUT | `/api/v1/ads/campaigns/{id}` | Update an ad campaign |
| ❌ | GET | `/api/v1/ads/campaigns/{id}` | Get campaign details with ads |
| ❌ | GET | `/api/v1/ads/dashboard/stats` | Get ad campaign history and statistics |
| ❌ | GET | `/api/v1/ads/fetch` | Fetch ads for display (ML + fallback) |
| ❌ | POST | `/api/v1/ads/track` | Track ad view/click/conversion |
| ❌ | GET | `/api/v1/ads/admob/context` | Get AdMob context for fallback |
| ❌ | POST | `/api/v1/ads` | Create a new ad (triggers moderation) |
| ❌ | PUT | `/api/v1/ads/{id}` | Update an ad |
| ❌ | GET | `/api/v1/ads/{id}` | Get ad details with stats |
| ❌ | DELETE | `/api/v1/ads/{id}` | Delete an ad |

### POST `/api/v1/ads/campaigns`
**Status**: ❌ NOT IMPLEMENTED

Create a new ad campaign

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/ads/campaigns" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "name": "string",
  "dailyImpressionCap": 1
}'
```

**Example response** (`201`):
```json
{
  "id": "string",
  "ownerId": "string",
  "name": "string",
  "status": "string",
  "createdAt": "string",
  "updatedAt": "string"
}
```

### GET `/api/v1/ads/campaigns`
**Status**: ❌ NOT IMPLEMENTED

List my ad campaigns

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/ads/campaigns?page=VALUE&limit=VALUE" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 

### PUT `/api/v1/ads/campaigns/{id}`
**Status**: ❌ NOT IMPLEMENTED

Update an ad campaign

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PUT \
  "http://84.247.131.180/api/v1/ads/campaigns/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "name": "string",
  "status": "draft",
  "dailyImpressionCap": 1
}'
```

**Example response** (`200`):
```json
{
  "id": "string",
  "ownerId": "string",
  "name": "string",
  "status": "string",
  "createdAt": "string",
  "updatedAt": "string"
}
```

### GET `/api/v1/ads/campaigns/{id}`
**Status**: ❌ NOT IMPLEMENTED

Get campaign details with ads

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/ads/campaigns/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 

### GET `/api/v1/ads/dashboard/stats`
**Status**: ❌ NOT IMPLEMENTED

Get ad campaign history and statistics

Returns summary metrics and a monthly chart for a specific ad campaign. Filter by campaign_id (the dropdown), year, and an optional date range (date_from / date_to). If no campaign_id is given, aggregates across all campaigns owned by the user.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/ads/dashboard/stats?campaign_id=VALUE&year=VALUE&date_from=VALUE&date_to=VALUE" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Stats returned

### GET `/api/v1/ads/fetch`
**Status**: ❌ NOT IMPLEMENTED

Fetch ads for display (ML + fallback)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/ads/fetch?placement=FEED&limit=1" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Example response** (`200`):
```json
{
  "placement": "EVENT_DECISION",
  "ad_source": "ML",
  "strict": true,
  "first_party_ad": {
    "id": "string",
    "campaignId": "string",
    "title": "string",
    "mediaType": "string",
    "destinationType": "string",
    "moderationStatus": "string",
    "createdAt": "string"
  },
  "admob_context": {}
}
```

### POST `/api/v1/ads/track`
**Status**: ❌ NOT IMPLEMENTED

Track ad view/click/conversion

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/ads/track" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "adId": "string",
  "campaignId": "string",
  "impressionId": "string",
  "eventType": "view",
  "placement": "string",
  "hobbyContext": "string"
}'
```

**Response** (`200`): Event tracked

### GET `/api/v1/ads/admob/context`
**Status**: ❌ NOT IMPLEMENTED

Get AdMob context for fallback

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/ads/admob/context?placement=VALUE&location_key=VALUE" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 

### POST `/api/v1/ads`
**Status**: ❌ NOT IMPLEMENTED

Create a new ad (triggers moderation)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/ads" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "campaignId": "string",
  "title": "string",
  "mediaType": "image",
  "destinationType": "event",
  "body": "string",
  "mediaUrl": "string"
}'
```

**Example response** (`201`):
```json
{
  "id": "string",
  "campaignId": "string",
  "title": "string",
  "mediaType": "string",
  "destinationType": "string",
  "moderationStatus": "string",
  "createdAt": "string"
}
```

### PUT `/api/v1/ads/{id}`
**Status**: ❌ NOT IMPLEMENTED

Update an ad

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PUT \
  "http://84.247.131.180/api/v1/ads/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "title": "string",
  "body": "string",
  "mediaUrl": "string",
  "mediaType": "image",
  "destinationType": "event",
  "destinationId": "string"
}'
```

**Example response** (`200`):
```json
{
  "id": "string",
  "campaignId": "string",
  "title": "string",
  "mediaType": "string",
  "destinationType": "string",
  "moderationStatus": "string",
  "createdAt": "string"
}
```

### GET `/api/v1/ads/{id}`
**Status**: ❌ NOT IMPLEMENTED

Get ad details with stats

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/ads/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 

### DELETE `/api/v1/ads/{id}`
**Status**: ❌ NOT IMPLEMENTED

Delete an ad

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/ads/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 


## Admin - Users

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/admin/users` | List all users (admin) |
| ❌ | GET | `/api/v1/admin/users/{id}` | Get user details (admin) |
| ❌ | POST | `/api/v1/admin/users/{id}/suspend` | Suspend or unsuspend a user |

### GET `/api/v1/admin/users`
**Status**: ❌ NOT IMPLEMENTED

List all users (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/admin/users?page=1&limit=20&sortOrder=asc" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 

### GET `/api/v1/admin/users/{id}`
**Status**: ❌ NOT IMPLEMENTED

Get user details (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/admin/users/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 

### POST `/api/v1/admin/users/{id}/suspend`
**Status**: ❌ NOT IMPLEMENTED

Suspend or unsuspend a user

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/admin/users/id/suspend" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "action": "suspend",
  "reason": "string"
}'
```

**Response** (`200`): 


## Admin - Events

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/admin/events/moderation` | List events pending moderation |
| ❌ | POST | `/api/v1/admin/events/{id}/moderate` | Approve, reject, or takedown an event |
| ❌ | GET | `/api/v1/admin/events/ratings` | List all event ratings (admin — filterable, paginated) |
| ❌ | PATCH | `/api/v1/admin/events/ratings/{ratingId}/flag` | Flag/unflag a rating (admin moderation) |
| ❌ | DELETE | `/api/v1/admin/events/ratings/{ratingId}` | Delete a rating (admin) |

### GET `/api/v1/admin/events/moderation`
**Status**: ❌ NOT IMPLEMENTED

List events pending moderation

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/admin/events/moderation?page=1&limit=20&sortOrder=asc" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 

### POST `/api/v1/admin/events/{id}/moderate`
**Status**: ❌ NOT IMPLEMENTED

Approve, reject, or takedown an event

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/admin/events/id/moderate" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "action": "approve",
  "reasonCode": "string",
  "reasonText": "string"
}'
```

**Response** (`200`): 

### GET `/api/v1/admin/events/ratings`
**Status**: ❌ NOT IMPLEMENTED

List all event ratings (admin — filterable, paginated)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/admin/events/ratings" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Paginated ratings list

### PATCH `/api/v1/admin/events/ratings/{ratingId}/flag`
**Status**: ❌ NOT IMPLEMENTED

Flag/unflag a rating (admin moderation)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PATCH \
  "http://84.247.131.180/api/v1/admin/events/ratings/ratingId/flag" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Rating flag status updated

### DELETE `/api/v1/admin/events/ratings/{ratingId}`
**Status**: ❌ NOT IMPLEMENTED

Delete a rating (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/admin/events/ratings/ratingId" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Rating deleted


## Admin - Blogs

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/admin/blogs/moderation` | List blogs pending moderation |
| ❌ | POST | `/api/v1/admin/blogs/{id}/moderate` | Approve, reject, or takedown a blog post |

### GET `/api/v1/admin/blogs/moderation`
**Status**: ❌ NOT IMPLEMENTED

List blogs pending moderation

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/admin/blogs/moderation?page=1&limit=20&sortOrder=asc" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 

### POST `/api/v1/admin/blogs/{id}/moderate`
**Status**: ❌ NOT IMPLEMENTED

Approve, reject, or takedown a blog post

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/admin/blogs/id/moderate" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "action": "approve",
  "reasonCode": "string",
  "reasonText": "string"
}'
```

**Response** (`200`): 


## Admin - Ads

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/admin/ads/review` | List ads pending review |
| ❌ | POST | `/api/v1/admin/ads/{id}/review` | Approve, reject, or takedown an ad |

### GET `/api/v1/admin/ads/review`
**Status**: ❌ NOT IMPLEMENTED

List ads pending review

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/admin/ads/review?page=1&limit=20&sortOrder=asc" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 

### POST `/api/v1/admin/ads/{id}/review`
**Status**: ❌ NOT IMPLEMENTED

Approve, reject, or takedown an ad

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/admin/ads/id/review" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "action": "approve",
  "reasonCode": "string",
  "reasonText": "string"
}'
```

**Response** (`200`): 


## Localization

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/localization/strings` | Get localization strings by language |
| ❌ | GET | `/api/v1/localization/languages` | Get available languages |

### GET `/api/v1/localization/strings`
**Status**: ❌ NOT IMPLEMENTED

Get localization strings by language

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/localization/strings?lang=en&namespace=ui&version=1"
```

**Response** (`200`): Localization strings

### GET `/api/v1/localization/languages`
**Status**: ❌ NOT IMPLEMENTED

Get available languages

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/localization/languages"
```

**Response** (`200`): 


## App Config

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/app/config` | Get app configuration (maintenance mode, versions, feature flags) |
| ❌ | GET | `/api/v1/app/health` | App health check (for load balancers) |

### GET `/api/v1/app/config`
**Status**: ❌ NOT IMPLEMENTED

Get app configuration (maintenance mode, versions, feature flags)

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/app/config"
```

**Response** (`200`): App configuration

### GET `/api/v1/app/health`
**Status**: ❌ NOT IMPLEMENTED

App health check (for load balancers)

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/app/health"
```

**Response** (`200`): 


## Share

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | POST | `/api/v1/share/token` | Generate a share token for an entity |
| ❌ | GET | `/api/v1/share/resolve/{token}` | Resolve a share token to its entity |

### POST `/api/v1/share/token`
**Status**: ❌ NOT IMPLEMENTED

Generate a share token for an entity

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/share/token" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "entityType": "event",
  "entityId": "string",
  "expiresAt": "string"
}'
```

**Example response** (`201`):
```json
{
  "token": "string",
  "shareUrl": "string",
  "entityType": "string",
  "entityId": "string",
  "expiresAt": "string"
}
```

### GET `/api/v1/share/resolve/{token}`
**Status**: ❌ NOT IMPLEMENTED

Resolve a share token to its entity

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/share/resolve/token"
```

**Example response** (`200`):
```json
{
  "entityType": "string",
  "entityId": "string",
  "deepLink": "string",
  "entity": {}
}
```


## Media

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | POST | `/api/v1/media/upload` | Upload image or video |

### POST `/api/v1/media/upload`
**Status**: ❌ NOT IMPLEMENTED

Upload image or video

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/media/upload?mediaType=VALUE&entityId=VALUE" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -F "file=@/path/to/file.jpg" \
  -F "mediaType=value" \
  -F "entityId=value"
```

**Response** (`201`): File uploaded successfully


## Support

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | POST | `/api/v1/support/tickets` | Create a new support ticket |
| ❌ | GET | `/api/v1/support/tickets` | Get user's support tickets |
| ❌ | GET | `/api/v1/support/tickets/{id}` | Get support ticket details |
| ❌ | POST | `/api/v1/support/tickets/{id}/reply` | Add a reply to a support ticket |
| ❌ | POST | `/api/v1/support/tickets/{id}/close` | Close a support ticket |

### POST `/api/v1/support/tickets`
**Status**: ❌ NOT IMPLEMENTED

Create a new support ticket

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/support/tickets" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "subject": "Unable to process payment",
  "description": "When I try to purchase tickets for an event, the payment fails with error code 500.",
  "category": "payment",
  "priority": "medium",
  "attachmentUrls": [
    "https://res.cloudinary.com/kumele/image/upload/screenshot1.png"
  ],
  "relatedEntityId": "clxyz123456"
}'
```

**Response** (`201`): Support ticket created successfully

### GET `/api/v1/support/tickets`
**Status**: ❌ NOT IMPLEMENTED

Get user's support tickets

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/support/tickets?status=open" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): List of user support tickets

### GET `/api/v1/support/tickets/{id}`
**Status**: ❌ NOT IMPLEMENTED

Get support ticket details

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/support/tickets/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Ticket details

### POST `/api/v1/support/tickets/{id}/reply`
**Status**: ❌ NOT IMPLEMENTED

Add a reply to a support ticket

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/support/tickets/id/reply" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "message": "Thank you for your response. I have tried the suggested solution...",
  "attachmentUrls": []
}'
```

**Response** (`200`): Reply added successfully

### POST `/api/v1/support/tickets/{id}/close`
**Status**: ❌ NOT IMPLEMENTED

Close a support ticket

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/support/tickets/id/close" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Ticket closed successfully


## Admin - Support

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/admin/support/tickets` | Get all support tickets (admin) |
| ❌ | GET | `/api/v1/admin/support/tickets/{id}` | Get support ticket details (admin) |
| ❌ | PUT | `/api/v1/admin/support/tickets/{id}/status` | Update ticket status |
| ❌ | POST | `/api/v1/admin/support/tickets/{id}/assign` | Assign ticket to support agent |
| ❌ | POST | `/api/v1/admin/support/tickets/{id}/reply` | Add admin reply to ticket |
| ❌ | GET | `/api/v1/admin/support/statistics` | Get support ticket statistics |

### GET `/api/v1/admin/support/tickets`
**Status**: ❌ NOT IMPLEMENTED

Get all support tickets (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/admin/support/tickets?status=open&category=account&priority=low" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): List of all support tickets

### GET `/api/v1/admin/support/tickets/{id}`
**Status**: ❌ NOT IMPLEMENTED

Get support ticket details (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/admin/support/tickets/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Ticket details

### PUT `/api/v1/admin/support/tickets/{id}/status`
**Status**: ❌ NOT IMPLEMENTED

Update ticket status

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PUT \
  "http://84.247.131.180/api/v1/admin/support/tickets/id/status" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "status": "in_progress",
  "internalNote": "Escalated to payment team"
}'
```

**Response** (`200`): Ticket status updated

### POST `/api/v1/admin/support/tickets/{id}/assign`
**Status**: ❌ NOT IMPLEMENTED

Assign ticket to support agent

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/admin/support/tickets/id/assign" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "assigneeId": "clxyz789012"
}'
```

**Response** (`200`): Ticket assigned successfully

### POST `/api/v1/admin/support/tickets/{id}/reply`
**Status**: ❌ NOT IMPLEMENTED

Add admin reply to ticket

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/admin/support/tickets/id/reply" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "message": "Thank you for your response. I have tried the suggested solution...",
  "attachmentUrls": []
}'
```

**Response** (`200`): Reply sent to user

### GET `/api/v1/admin/support/statistics`
**Status**: ❌ NOT IMPLEMENTED

Get support ticket statistics

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/admin/support/statistics" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Support statistics


## Translation

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/translation/strings` | Get localized strings |
| ❌ | GET | `/api/v1/translation/languages` | Get available languages |
| ❌ | GET | `/api/v1/translation/profile` | Get profile page content (backward compatibility) |
| ❌ | GET | `/api/v1/translation/detect` | Detect language from Accept-Language header |

### GET `/api/v1/translation/strings`
**Status**: ❌ NOT IMPLEMENTED

Get localized strings

Fetch UI strings in the specified language. Falls back to English if language not found.

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/translation/strings?lang=en&namespace=ui&version=1" \
  -H "accept-language: <ACCEPT-LANGUAGE>"
```

**Example response** (`200`):
```json
{
  "lang": "en",
  "namespace": "ui",
  "version": 1,
  "strings": {
    "common.save": "Save",
    "common.cancel": "Cancel",
    "profile.title": "Profile"
  }
}
```

### GET `/api/v1/translation/languages`
**Status**: ❌ NOT IMPLEMENTED

Get available languages

Returns list of languages that have translations available

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/translation/languages"
```

**Example response** (`200`):
```json
{
  "available": [
    "en",
    "fr",
    "es",
    "de",
    "ar",
    "zh"
  ],
  "supported": [
    {
      "code": "en",
      "name": "English",
      "nativeName": "English"
    },
    {
      "code": "fr",
      "name": "French",
      "nativeName": "Fran\u00e7ais"
    }
  ]
}
```

### GET `/api/v1/translation/profile`
**Status**: ❌ NOT IMPLEMENTED

Get profile page content (backward compatibility)

Returns translated profile page strings based on user preference. Compatible with old API.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/translation/profile" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Example response** (`200`):
```json
{
  "success": true,
  "message": "Profile page contents fetched successfully",
  "data": {
    "title": "Profile",
    "editHobbies": "Edit Hobbies",
    "following": "Following",
    "followers": "Followers",
    "GoldStatus": "Gold Status",
    "settings": "Settings"
  }
}
```

### GET `/api/v1/translation/detect`
**Status**: ❌ NOT IMPLEMENTED

Detect language from Accept-Language header

Returns the best matching language based on the Accept-Language header

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/translation/detect" \
  -H "accept-language: <ACCEPT-LANGUAGE>"
```

**Example response** (`200`):
```json
{
  "detected": "en",
  "header": "en-US,en;q=0.9,fr;q=0.8"
}
```


## tickets

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | POST | `/api/v1/tickets/events/{id}` | Generate a guest ticket for an event |
| ❌ | GET | `/api/v1/tickets/events/{id}` | Get tickets for an event (organizer only) |
| ❌ | GET | `/api/v1/tickets/my` | Get my tickets |
| ❌ | GET | `/api/v1/tickets/{id}` | Get ticket details |
| ❌ | DELETE | `/api/v1/tickets/{id}` | Cancel a ticket |
| ❌ | POST | `/api/v1/tickets/{id}/validate` | Validate a ticket (organizer only) |

### POST `/api/v1/tickets/events/{id}`
**Status**: ❌ NOT IMPLEMENTED

Generate a guest ticket for an event

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/tickets/events/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`201`): Ticket created

### GET `/api/v1/tickets/events/{id}`
**Status**: ❌ NOT IMPLEMENTED

Get tickets for an event (organizer only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/tickets/events/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Event tickets list

### GET `/api/v1/tickets/my`
**Status**: ❌ NOT IMPLEMENTED

Get my tickets

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/tickets/my" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): My tickets list

### GET `/api/v1/tickets/{id}`
**Status**: ❌ NOT IMPLEMENTED

Get ticket details

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/tickets/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Ticket details

### DELETE `/api/v1/tickets/{id}`
**Status**: ❌ NOT IMPLEMENTED

Cancel a ticket

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/tickets/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Ticket cancelled

### POST `/api/v1/tickets/{id}/validate`
**Status**: ❌ NOT IMPLEMENTED

Validate a ticket (organizer only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/tickets/id/validate" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "ticketCode": "string"
}'
```

**Response** (`200`): Ticket validated


## products

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/products` | Get all products (public) |
| ❌ | POST | `/api/v1/products` | Create a product (admin only) |
| ❌ | GET | `/api/v1/products/{idOrSlug}` | Get product by ID or slug |
| ❌ | PUT | `/api/v1/products/{id}` | Update a product (admin only) |
| ❌ | DELETE | `/api/v1/products/{id}` | Delete a product (admin only) |

### GET `/api/v1/products`
**Status**: ❌ NOT IMPLEMENTED

Get all products (public)

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/products"
```

**Response** (`200`): Products list

### POST `/api/v1/products`
**Status**: ❌ NOT IMPLEMENTED

Create a product (admin only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/products" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "name": "string",
  "price": 29.99,
  "description": "string",
  "currency": "string",
  "images": [
    "string"
  ],
  "category": "string"
}'
```

**Response** (`201`): Product created

### GET `/api/v1/products/{idOrSlug}`
**Status**: ❌ NOT IMPLEMENTED

Get product by ID or slug

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/products/idOrSlug"
```

**Response** (`200`): Product details

### PUT `/api/v1/products/{id}`
**Status**: ❌ NOT IMPLEMENTED

Update a product (admin only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PUT \
  "http://84.247.131.180/api/v1/products/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "name": "string",
  "description": "string",
  "price": 1,
  "currency": "string",
  "images": [
    "string"
  ],
  "category": "string"
}'
```

**Response** (`200`): Product updated

### DELETE `/api/v1/products/{id}`
**Status**: ❌ NOT IMPLEMENTED

Delete a product (admin only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/products/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Product deleted


## cart

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/cart` | Get my cart |
| ❌ | DELETE | `/api/v1/cart` | Clear entire cart |
| ❌ | POST | `/api/v1/cart/items` | Add item to cart |
| ❌ | PUT | `/api/v1/cart/items/{id}` | Update cart item quantity |
| ❌ | DELETE | `/api/v1/cart/items/{id}` | Remove item from cart |

### GET `/api/v1/cart`
**Status**: ❌ NOT IMPLEMENTED

Get my cart

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/cart" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Cart contents

### DELETE `/api/v1/cart`
**Status**: ❌ NOT IMPLEMENTED

Clear entire cart

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/cart" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Cart cleared

### POST `/api/v1/cart/items`
**Status**: ❌ NOT IMPLEMENTED

Add item to cart

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/cart/items" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "productId": "string",
  "quantity": 1
}'
```

**Response** (`201`): Item added to cart

### PUT `/api/v1/cart/items/{id}`
**Status**: ❌ NOT IMPLEMENTED

Update cart item quantity

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PUT \
  "http://84.247.131.180/api/v1/cart/items/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "quantity": 1
}'
```

**Response** (`200`): Cart item updated

### DELETE `/api/v1/cart/items/{id}`
**Status**: ❌ NOT IMPLEMENTED

Remove item from cart

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/cart/items/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Item removed


## cms

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/cms/pages` | Get all published CMS pages |
| ❌ | GET | `/api/v1/cms/pages/slug/{slug}` | Get CMS page by slug |
| ❌ | GET | `/api/v1/cms/admin/pages` | Get all CMS pages including unpublished (admin) |
| ❌ | POST | `/api/v1/cms/admin/pages` | Create a CMS page (admin only) |
| ❌ | GET | `/api/v1/cms/admin/pages/{id}` | Get CMS page by ID (admin) |
| ❌ | PUT | `/api/v1/cms/admin/pages/{id}` | Update a CMS page (admin only) |
| ❌ | DELETE | `/api/v1/cms/admin/pages/{id}` | Delete a CMS page (admin only) |

### GET `/api/v1/cms/pages`
**Status**: ❌ NOT IMPLEMENTED

Get all published CMS pages

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/cms/pages"
```

**Response** (`200`): CMS pages list

### GET `/api/v1/cms/pages/slug/{slug}`
**Status**: ❌ NOT IMPLEMENTED

Get CMS page by slug

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/cms/pages/slug/slug"
```

**Response** (`200`): CMS page

### GET `/api/v1/cms/admin/pages`
**Status**: ❌ NOT IMPLEMENTED

Get all CMS pages including unpublished (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/cms/admin/pages" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): All CMS pages

### POST `/api/v1/cms/admin/pages`
**Status**: ❌ NOT IMPLEMENTED

Create a CMS page (admin only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/cms/admin/pages" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "title": "string",
  "content": "string",
  "section": "string",
  "sortOrder": 1,
  "isPublished": true
}'
```

**Response** (`201`): CMS page created

### GET `/api/v1/cms/admin/pages/{id}`
**Status**: ❌ NOT IMPLEMENTED

Get CMS page by ID (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/cms/admin/pages/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): CMS page

### PUT `/api/v1/cms/admin/pages/{id}`
**Status**: ❌ NOT IMPLEMENTED

Update a CMS page (admin only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PUT \
  "http://84.247.131.180/api/v1/cms/admin/pages/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "title": "string",
  "content": "string",
  "section": "string",
  "sortOrder": 1,
  "isPublished": true
}'
```

**Response** (`200`): CMS page updated

### DELETE `/api/v1/cms/admin/pages/{id}`
**Status**: ❌ NOT IMPLEMENTED

Delete a CMS page (admin only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/cms/admin/pages/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): CMS page deleted


## legal

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/legal` | Get all active legal documents |
| ❌ | GET | `/api/v1/legal/type/{type}` | Get legal document by type (guidelines, terms, privacy_policy) |
| ❌ | GET | `/api/v1/legal/admin` | Get all legal documents including inactive (admin) |
| ❌ | POST | `/api/v1/legal/admin` | Create a legal document (admin only) |
| ❌ | GET | `/api/v1/legal/admin/{id}` | Get legal document by ID (admin) |
| ❌ | PUT | `/api/v1/legal/admin/{id}` | Update a legal document (admin only) |
| ❌ | DELETE | `/api/v1/legal/admin/{id}` | Delete a legal document (admin only) |

### GET `/api/v1/legal`
**Status**: ❌ NOT IMPLEMENTED

Get all active legal documents

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/legal"
```

**Response** (`200`): Legal documents list

### GET `/api/v1/legal/type/{type}`
**Status**: ❌ NOT IMPLEMENTED

Get legal document by type (guidelines, terms, privacy_policy)

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/legal/type/type"
```

**Response** (`200`): Legal document

### GET `/api/v1/legal/admin`
**Status**: ❌ NOT IMPLEMENTED

Get all legal documents including inactive (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/legal/admin" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): All legal documents

### POST `/api/v1/legal/admin`
**Status**: ❌ NOT IMPLEMENTED

Create a legal document (admin only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/legal/admin" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "type": "string",
  "title": "string",
  "content": "string",
  "version": 1,
  "isActive": true
}'
```

**Response** (`201`): Legal document created

### GET `/api/v1/legal/admin/{id}`
**Status**: ❌ NOT IMPLEMENTED

Get legal document by ID (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/legal/admin/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Legal document

### PUT `/api/v1/legal/admin/{id}`
**Status**: ❌ NOT IMPLEMENTED

Update a legal document (admin only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PUT \
  "http://84.247.131.180/api/v1/legal/admin/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "title": "string",
  "content": "string",
  "version": 1,
  "isActive": true
}'
```

**Response** (`200`): Legal document updated

### DELETE `/api/v1/legal/admin/{id}`
**Status**: ❌ NOT IMPLEMENTED

Delete a legal document (admin only)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/legal/admin/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Legal document deleted


## newsletter

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | POST | `/api/v1/newsletter/subscribe` | Subscribe an email to the newsletter (public) |
| ❌ | GET | `/api/v1/newsletter/unsubscribe` | Unsubscribe via emailed token (public) |
| ❌ | GET | `/api/v1/newsletter/subscribers` | List newsletter subscribers (admin) |
| ❌ | POST | `/api/v1/newsletter/broadcast` | Send the newsletter to all subscribers (admin) |

### POST `/api/v1/newsletter/subscribe`
**Status**: ❌ NOT IMPLEMENTED

Subscribe an email to the newsletter (public)

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/newsletter/subscribe" \
  -H "Content-Type: application/json" \
  -d '{
  "email": "jane@example.com",
  "source": "footer"
}'
```

**Response** (`200`): Subscribed

### GET `/api/v1/newsletter/unsubscribe`
**Status**: ❌ NOT IMPLEMENTED

Unsubscribe via emailed token (public)

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/newsletter/unsubscribe?token=VALUE"
```

**Response** (`200`): Unsubscribed

### GET `/api/v1/newsletter/subscribers`
**Status**: ❌ NOT IMPLEMENTED

List newsletter subscribers (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/newsletter/subscribers?status=VALUE" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): 

### POST `/api/v1/newsletter/broadcast`
**Status**: ❌ NOT IMPLEMENTED

Send the newsletter to all subscribers (admin)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/newsletter/broadcast" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "subject": "Kumele \u2014 August events near you",
  "html": "string"
}'
```

**Response** (`200`): 


## Metrics

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/metrics` | Get Prometheus metrics |

### GET `/api/v1/metrics`
**Status**: ❌ NOT IMPLEMENTED

Get Prometheus metrics

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/metrics"
```

**Example response** (`200`):
```json
"# HELP http_requests_total Total number of HTTP requests\n# TYPE http_requests_total counter\nhttp_requests_total{method=\"GET\",route=\"/api/v1/health\",status_code=\"200\"} 42"
```


## Privacy

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/privacy/preferences` | Get privacy preferences |
| ❌ | PATCH | `/api/v1/privacy/consent` | Update consent settings (GDPR Article 7) |
| ❌ | GET | `/api/v1/privacy/export` | Export all user data (GDPR Article 20 - Data Portability) |
| ❌ | PATCH | `/api/v1/privacy/rectify` | Rectify personal data (GDPR Article 16) |
| ❌ | POST | `/api/v1/privacy/delete` | Delete account (GDPR Article 17 - Right to Erasure) |

### GET `/api/v1/privacy/preferences`
**Status**: ❌ NOT IMPLEMENTED

Get privacy preferences

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/privacy/preferences" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Example response** (`200`):
```json
{
  "userId": "string",
  "marketingConsent": true,
  "analyticsConsent": true,
  "thirdPartyConsent": true,
  "pushNotificationConsent": true,
  "emailNotificationConsent": true,
  "updatedAt": "string"
}
```

### PATCH `/api/v1/privacy/consent`
**Status**: ❌ NOT IMPLEMENTED

Update consent settings (GDPR Article 7)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PATCH \
  "http://84.247.131.180/api/v1/privacy/consent" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "marketingConsent": true,
  "analyticsConsent": true,
  "thirdPartyConsent": true,
  "pushNotificationConsent": true,
  "emailNotificationConsent": true
}'
```

**Example response** (`200`):
```json
{
  "userId": "string",
  "marketingConsent": true,
  "analyticsConsent": true,
  "thirdPartyConsent": true,
  "pushNotificationConsent": true,
  "emailNotificationConsent": true,
  "updatedAt": "string"
}
```

### GET `/api/v1/privacy/export`
**Status**: ❌ NOT IMPLEMENTED

Export all user data (GDPR Article 20 - Data Portability)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/privacy/export" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Example response** (`200`):
```json
{
  "profile": {},
  "events": [
    "string"
  ],
  "payments": [
    "string"
  ],
  "blogs": [
    "string"
  ],
  "chatMessages": [
    "string"
  ],
  "notifications": [
    "string"
  ],
  "supportTickets": [
    "string"
  ],
  "hobbies": [
    "string"
  ],
  "metadata": {}
}
```

### PATCH `/api/v1/privacy/rectify`
**Status**: ❌ NOT IMPLEMENTED

Rectify personal data (GDPR Article 16)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PATCH \
  "http://84.247.131.180/api/v1/privacy/rectify" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "firstName": "string",
  "lastName": "string",
  "displayName": "string",
  "phone": "string",
  "city": "string",
  "country": "string"
}'
```

**Response** (`200`): Personal data rectified

### POST `/api/v1/privacy/delete`
**Status**: ❌ NOT IMPLEMENTED

Delete account (GDPR Article 17 - Right to Erasure)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/privacy/delete" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "password": "string",
  "reason": "string",
  "confirmation": true
}'
```

**Response** (`200`): Account deleted successfully


## NFTs

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/nfts/my-screen` | Get personalized NFT screen (owned, claimable, marketplace, exclusive) |
| ❌ | GET | `/api/v1/nfts/rewards` | Get all reward NFTs (earned status per user) |
| ❌ | GET | `/api/v1/nfts/mine` | Get all NFTs owned by the current user |
| ❌ | GET | `/api/v1/nfts/marketplace` | Browse NFT marketplace (filterable, paginated) |
| ❌ | GET | `/api/v1/nfts/{id}` | Get NFT details by ID |
| ❌ | POST | `/api/v1/nfts/{id}/claim` | Claim a free reward NFT |
| ❌ | POST | `/api/v1/nfts/{id}/purchase` | Purchase an NFT |
| ❌ | POST | `/api/v1/nfts/internal/auto-issue` | Auto-issue reward NFTs when user earns a tier (internal — X-Service-Key) |

### GET `/api/v1/nfts/my-screen`
**Status**: ❌ NOT IMPLEMENTED

Get personalized NFT screen (owned, claimable, marketplace, exclusive)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/nfts/my-screen" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Personalized NFT feed

### GET `/api/v1/nfts/rewards`
**Status**: ❌ NOT IMPLEMENTED

Get all reward NFTs (earned status per user)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/nfts/rewards" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): Reward NFTs list

### GET `/api/v1/nfts/mine`
**Status**: ❌ NOT IMPLEMENTED

Get all NFTs owned by the current user

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/nfts/mine" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): User NFT collection

### GET `/api/v1/nfts/marketplace`
**Status**: ❌ NOT IMPLEMENTED

Browse NFT marketplace (filterable, paginated)

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/nfts/marketplace?category=ART&nftType=REWARD&sortBy=createdAt&sortOrder=desc&page=1&limit=20"
```

**Response** (`200`): Marketplace NFTs

### GET `/api/v1/nfts/{id}`
**Status**: ❌ NOT IMPLEMENTED

Get NFT details by ID

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/nfts/id"
```

**Response** (`200`): NFT details

### POST `/api/v1/nfts/{id}/claim`
**Status**: ❌ NOT IMPLEMENTED

Claim a free reward NFT

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/nfts/id/claim" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`201`): NFT claimed

### POST `/api/v1/nfts/{id}/purchase`
**Status**: ❌ NOT IMPLEMENTED

Purchase an NFT

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/nfts/id/purchase" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "transactionRef": "string",
  "walletAddress": "string"
}'
```

**Response** (`201`): NFT purchased

### POST `/api/v1/nfts/internal/auto-issue`
**Status**: ❌ NOT IMPLEMENTED

Auto-issue reward NFTs when user earns a tier (internal — X-Service-Key)

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/nfts/internal/auto-issue" \
  -H "x-service-key: <X-SERVICE-KEY>"
```

**Response** (`201`): Reward NFTs auto-issued


## Admin - NFTs

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | GET | `/api/v1/admin/nfts` | List all NFTs (admin view, paginated) |
| ❌ | POST | `/api/v1/admin/nfts` | Create a new NFT collection item |
| ❌ | PUT | `/api/v1/admin/nfts/{id}` | Update an NFT collection item |
| ❌ | DELETE | `/api/v1/admin/nfts/{id}` | Delete an NFT collection item |

### GET `/api/v1/admin/nfts`
**Status**: ❌ NOT IMPLEMENTED

List all NFTs (admin view, paginated)

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/admin/nfts" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): NFT list

### POST `/api/v1/admin/nfts`
**Status**: ❌ NOT IMPLEMENTED

Create a new NFT collection item

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/admin/nfts" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "name": "string",
  "category": "ART",
  "imageUrl": "string",
  "nftType": "REWARD",
  "description": "string",
  "thumbnailUrl": "string"
}'
```

**Response** (`201`): NFT created

### PUT `/api/v1/admin/nfts/{id}`
**Status**: ❌ NOT IMPLEMENTED

Update an NFT collection item

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X PUT \
  "http://84.247.131.180/api/v1/admin/nfts/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "name": "string",
  "description": "string",
  "category": "ART",
  "imageUrl": "string",
  "thumbnailUrl": "string",
  "price": 1
}'
```

**Response** (`200`): NFT updated

### DELETE `/api/v1/admin/nfts/{id}`
**Status**: ❌ NOT IMPLEMENTED

Delete an NFT collection item

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/admin/nfts/id" \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

**Response** (`200`): NFT deleted


## media

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | POST | `/api/v1/media/upload-url` | Get a pre-signed upload URL for direct media upload to storage |

### POST `/api/v1/media/upload-url`
**Status**: ❌ NOT IMPLEMENTED

Get a pre-signed upload URL for direct media upload to storage

Returns a pre-signed PUT URL valid for 5 minutes. Flutter uploads directly to storage, bypassing the API server.

**Auth**: Requires `Authorization: Bearer <token>`

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/media/upload-url" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
  "media_type": "event",
  "event_id": "550e8400-e29b-41d4-a716-446655440000",
  "extension": "jpg"
}'
```

**Response** (`201`): Pre-signed upload URL generated


## dev

| Status | Method | Path | Summary |
|---|---|---|---|
| ❌ | POST | `/api/v1/dev/seed` | ⚠️ Create demo seed data (TEMPORARY) |
| ❌ | DELETE | `/api/v1/dev/seed` | ⚠️ Delete demo data |
| ❌ | GET | `/api/v1/dev/check` | Check if demo data exists |
| ❌ | POST | `/api/v1/dev/escrow/simulate` | 🎯 DEMO: Create REAL Stripe payment + escrow flow |
| ❌ | POST | `/api/v1/dev/escrow/checkin` | 🎯 DEMO: Simulate check-in (attendance verified) |
| ❌ | POST | `/api/v1/dev/escrow/release` | 🎯 DEMO: Release escrow funds to host |
| ❌ | GET | `/api/v1/dev/escrow/status` | 📊 DEMO: Check current escrow status |

### POST `/api/v1/dev/seed`
**Status**: ❌ NOT IMPLEMENTED

⚠️ Create demo seed data (TEMPORARY)

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/dev/seed"
```

**Response** (`201`): Demo data created

### DELETE `/api/v1/dev/seed`
**Status**: ❌ NOT IMPLEMENTED

⚠️ Delete demo data

**Auth**: Public — no auth required

```bash
curl -X DELETE \
  "http://84.247.131.180/api/v1/dev/seed"
```

**Response** (`200`): 

### GET `/api/v1/dev/check`
**Status**: ❌ NOT IMPLEMENTED

Check if demo data exists

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/dev/check"
```

**Response** (`200`): 

### POST `/api/v1/dev/escrow/simulate`
**Status**: ❌ NOT IMPLEMENTED

🎯 DEMO: Create REAL Stripe payment + escrow flow

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/dev/escrow/simulate"
```

**Response** (`201`): 

### POST `/api/v1/dev/escrow/checkin`
**Status**: ❌ NOT IMPLEMENTED

🎯 DEMO: Simulate check-in (attendance verified)

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/dev/escrow/checkin"
```

**Response** (`201`): 

### POST `/api/v1/dev/escrow/release`
**Status**: ❌ NOT IMPLEMENTED

🎯 DEMO: Release escrow funds to host

**Auth**: Public — no auth required

```bash
curl -X POST \
  "http://84.247.131.180/api/v1/dev/escrow/release"
```

**Response** (`201`): 

### GET `/api/v1/dev/escrow/status`
**Status**: ❌ NOT IMPLEMENTED

📊 DEMO: Check current escrow status

**Auth**: Public — no auth required

```bash
curl -X GET \
  "http://84.247.131.180/api/v1/dev/escrow/status"
```

**Response** (`200`): 

