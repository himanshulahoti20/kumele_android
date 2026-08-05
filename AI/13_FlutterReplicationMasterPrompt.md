# Master Prompt — Flutter/Android API Replication

Copy the block below into a fresh Claude Code (or equivalent agent) session **inside the new
Flutter/Android project**, after copying in the two files it references (see the note under the
prompt). Fill in the `[bracketed]` placeholders first.

---

```
You are implementing the API integration layer for the Android/Flutter build of "Kumele", a
social event-hobby app. An iOS SwiftUI version of this app already exists and is fully wired to a
live backend — your job is to replicate its API integrations in this Flutter project, not to
design new ones. Do not invent endpoints, request shapes, or business rules; if something is
ambiguous or missing from the reference docs, ask before guessing.

## Ground truth (read these before writing any code)

1. `AI_docs/12_AndroidFlutterAPIGuide.md` — screen-by-screen breakdown of every API call the iOS
   app makes: which screen, which endpoint, what triggers it, what it sends/expects. This is the
   map of WHAT to build and WHEN each call fires.
2. `AI_docs/08_APICompleteReference.md` — full request/response JSON bodies and curl examples for
   every endpoint. This is the exact WIRE FORMAT to match.
3. `AI_docs/api-reference/openapi.json` (+ `openapi_ml.json` for the AI/ML host, `openapi_web3.json`
   for the NFT/Web3 host) — machine-readable specs; use these for codegen or to double check field
   types/nullability when the two docs above are ambiguous.

Treat #1 and #2 as authoritative over your own assumptions about REST conventions. If the two
disagree, #2 (full reference) wins on wire format; #1 wins on "does the app actually call this."

## Backend hosts

- Main API: `[fill in — see APIConstants.baseURLString in the iOS repo, currently http://84.247.131.180:3000/api/v1/]`
- AI/ML microservice (chatbot, content translation): `[http://84.247.131.180:8080]`
- Web3/NFT microservice: `[https://kumele-backend.ansht.workers.dev]`
- Chat WebSocket (Socket.IO): `[ws://84.247.131.180]`

Confirm these are still current before hardcoding — they're pulled from the iOS app's current
config and may have changed.

## Networking foundation — build this first

Before any screen, build a single HTTP client layer with these behaviors (mirrors the iOS
`APIClient`, described in Part 2 of the API guide):

1. **Auth header**: every authenticated request sends `Authorization: Bearer <accessToken>`.
2. **Token storage**: access + refresh tokens in secure storage (`flutter_secure_storage`), never
   SharedPreferences in plaintext.
3. **401 handling**: on a 401 from an authenticated call, POST the refresh token to `/auth/refresh`,
   store the new tokens, and retry the original request exactly once. If refresh also fails, clear
   the session and force a route to Login. If multiple requests 401 concurrently, only fire one
   refresh call and have the others await it (don't stampede the refresh endpoint).
4. **Response envelope**: responses may be a bare JSON object/array OR wrapped as `{"data": ...}`.
   Decode generically — try bare first, unwrap `data` on failure — rather than per-endpoint.
5. **Error mapping**: non-2xx bodies are typically `{"message": ...}` or `{"errors": [...]}`
   (sometimes nested under `data`). Extract into a validation-message list for 400/409/422; treat
   other codes as generic failures. A response containing a `tempToken` field means "2FA required" —
   surface that as a distinct state, not a generic error.
6. **Multipart uploads**: a single `file` field, used for avatar/event-banner/blog-image uploads.
   Response contains a `secureUrl`/`url` you then attach to the owning resource in a follow-up call.

## Implementation order

Build in this sequence (matches Part 3 of the API guide — highest-value, least
platform-specific first):

1. Networking foundation (above).
2. Auth: login, signup, OTP verification, forgot password. Skip passkeys for now — Android's
   passkey integration (Credential Manager API) is a different platform mechanism from iOS
   WebAuthn, not a direct port; revisit once core flows work.
3. Onboarding: hobby selection, profile setup.
4. Home feed, event detail, join (no payment first — add PayPal after core flow works).
5. Profile: view, edit, follow/followers. Security settings (2FA) after core profile works.
6. Chat: REST history/send first, then the Socket.IO real-time layer (events: `joinRoom`,
   `leaveRoom`, `typing` / `newMessage`, `userTyping`, `userJoined`, `userLeft`).
7. Create Event (multi-step form + payment).
8. Notifications list + tab-bar unread badge.
9. Shop/NFTs/Blog/Ads — lowest priority. Note several of these flows are themselves unwired or
   incomplete even on iOS (checkout "Pay now" is disabled, refunds have no UI, ad campaigns are
   dead code) — don't treat the absence of a working iOS reference for those as something to fix;
   ask before building UI beyond what's documented.

## Platform-specific calls-outs — do not blindly port these

- **Subscriptions**: iOS uses Apple StoreKit for purchases, verified via
  `POST /subscriptions/apple/verify`. Android needs Google Play Billing instead — confirm with
  backend whether an equivalent verify endpoint exists (don't assume `apple/verify` accepts a Play
  Billing purchase token).
- **Passkeys**: iOS uses WebAuthn tied to an Associated Domain. Android's equivalent is the
  Credential Manager passkeys API — different integration, same backend endpoints
  (`/auth/passkey/*`) in theory, but validate the WebAuthn `rpId`/origin requirements work for an
  Android app before assuming a direct port.
- **Push notifications**: `POST /notifications/push-token` expects an FCM token — this part
  **is** shared (Android already uses FCM), just make sure the payload shape matches what's
  documented.

## Architecture

Use whatever state-management approach fits this Flutter project's existing conventions (Provider/
Riverpod/Bloc/etc.) — the iOS app's MVVM structure is not something to mirror 1:1 in Dart, only its
API call sequencing and business rules (what fires when, in what order, with what fallback) matter.

## Testing

For each screen you wire up, add a test that mocks the HTTP client and asserts the right endpoint
is called with the right payload for the right user action — the API guide's "triggered by"
language for each row is what to assert against.

Work through the implementation order above one stage at a time. After each stage, stop and
summarize what you built and what's next rather than continuing through the whole list unprompted,
so I can redirect if something doesn't match what I actually want built.
```

---

## Before using this prompt

Copy these files (or the whole `AI/` folder minus the excluded ones — see note below) into the
Flutter project at `AI_docs/` (or update the paths in the prompt above to wherever you put them):

- `12_AndroidFlutterAPIGuide.md` (this guide)
- `08_APICompleteReference.md` (full request/response reference)
- `api-reference/` (the whole folder: `openapi.json`, `openapi_ml.json`, `openapi_web3.json`,
  Postman collection, endpoint catalog)

Do **not** copy `09_ChangeLog.md` (230KB of iOS-specific session history), `04_CodingRules.md`
(Swift/SwiftUI-specific), `06_UIUXWorkflow.md` (SwiftUI-specific), `01_ProjectArchitecture.md`
(iOS app architecture, not the backend) or `11_NextJSWebAppAudit.md` (web app, irrelevant here) —
they're either iOS-specific noise or not about the API surface at all, and would just burn context
in the new project for no benefit. `10_APIStatusList.txt` is optional — a terser implemented/pending
checklist that overlaps with this guide; skip it unless you want the quick-reference version too.
