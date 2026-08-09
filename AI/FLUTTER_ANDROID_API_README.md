# Kumele API — Flutter (Android) Integration Reference

This README documents the **exact API wiring, data-layer structure, and response handling** used by the iOS Kumele app for:
**Payments & Refunds · Tickets · Support · Uploads/Media · Privacy · Rewards**

Use this as the contract for a Flutter Android client.

---

## 1. Base URLs & Versioning

| Env | Base URL |
|---|---|
| API | `APIConstants.baseURL` (replace with your server's URL) |
| Web3/NFT | `APIConstants.web3BaseURL` (separate base for wallet/NFT ops) |

> No version prefix is used in path components (`/api/v1` is included by host config if any).

---

## 2. Authentication & Session

- **Auth scheme:** Bearer token stored securely (iOS uses Keychain via `KeychainTokenStore`; Android equivalent = EncryptedSharedPreferences / Keystore).
- **Token lookup:** `APIClient.shared.currentTokens()` returns `(accessToken, refreshToken, userID)`.
- **Required rule:** nearly every endpoint below requires authentication (`requiresAuthentication: true` default). Only `GET /subscriptions/tiers`, `GET /products`, `GET /products/{id}`, `GET /event-plans`, and `GET /event-plans/quote` are public.
- **Expiry handling:** `401` → `APIError.unauthorized` / `.sessionExpired`; the app surfaces a "session expired" state and forces re-login. Your Flutter interceptor should do the same and attempt a token refresh before failing.

### Token object
```
{
  "accessToken": "…",
  "refreshToken": "…",
  "userID": "uuid"
}
```

---

## 3. Networking Layer (mirror this in Flutter)

### 3.1 Request builder

```
APIEndpoint<ResponseType>(
  responseType,
  path:      "…",                     // relative path string
  method:    GET | POST | PUT | DELETE,
  queryItems: [URLQueryItem],         // optional
  body:      .json(Encodable) | .multipart(MultipartFile…),   // optional
  requiresAuthentication: true        // default
)
```

### 3.2 Response envelope — two shapes the code tolerates

**`APIEnvelope<T>` (wrapper style)**
```json
{ "ok": true, "data": { … }, "message": "optional" }
```

**`APIResponse<T>` (flat style)**
```json
{ "success": true, "message": "…", "data": { … } }
```

**Client `send` behaviour (critical for Flutter):**
- Automatically unwraps `APIEnvelope.data` when the concrete type matches the envelope.
- For direct types it decodes the raw JSON body.
- Discards empty bodies with `EmptyResponse`.
- **Flexible list fallbacks:** `TicketPage`, `NotificationPage`, `NFTPage` tolerate payloads where the array lives under any of these keys:
  `tickets | items | results | data` and metadata under `meta | pagination`.

### 3.3 Errors — `APIError` cases

| Case | Meaning in app |
|---|---|
| `unauthorized` / `sessionExpired` | 401; show login |
| `validation([String])` | 422 field errors (array of messages) |
| `networkConnectionFailed` | No connectivity |
| `ticketServiceUnavailable` | Ticketing outage — **"No ticket was created or charged"** |
| `serverError` | 5xx |
| `notFound` | 404 |
| `custom(String)` | Backend-provided message |

Map HTTP status → these cases in your Dio/http interceptor.

### 3.4 Flexible JSON (`JSONValue`)

`JSONValue` is an untyped JSON tree (object/array/number/string/bool/null). It's used where the backend shape isn't stable:
- `GET /discounts/rewards` returns raw `JSONValue`.
- `UserRewardsResponse` decodes through `JSONValue` with **key-fuzzy matching** (see §9.2).

## 4. Payments & Refunds

### 4.1 Payment methods (`PaymentService` — protocol `PaymentServicing`)

| Method | HTTP | Path | Auth | Body | Returns |
|---|---|---|---|---|---|
| `createEventPayment(eventID:discountCode:rewardDiscountID:)` | `POST` | `/payments/event-payment` | ✅ | `{ eventId, discountCode?, rewardDiscountId? }` | `PaymentActionResponse` |
| `createEventCreationPayment(eventID:)` | `POST` | (same path, creation-plan variant) | ✅ | same | `{ clientSecret?, alreadyActive? }` |
| `createPayPalOrder(eventID:discountCode:rewardDiscountID:)` | `POST` | (PayPal order path) | ✅ | same | `{ approvalUrl?, orderId?, requiresPayment? }` |
| `createEventCreationPayPalOrder(eventID:)` | `POST` | (PayPal order, creation variant) | ✅ | same | `PaymentActionResponse` |
| `capturePayPal(orderID:)` | `POST` | `/payments/paypal/{orderId}/capture` | ✅ | — | `{ status? }` |
| `paypalStatus(orderID:)` | `GET` | `/payments/paypal/{orderId}/status` | ✅ | — | `PaymentActionResponse` |
| `confirm(paymentIntentID:)` | `POST` | (Stripe confirm path) | ✅ | — | `…` |
| `escrow(paymentID:)` | `GET` | `/payments/{paymentId}/escrow-status` | ✅ | — | `EscrowStatus` |
| `history(page:limit:)` | `GET` | `/payments/history?page=&limit=` | ✅ | — | `[PaymentModel]` |

> **Refunds:** the app does not expose a "refund" call; refunds are handled server-side. The client only *reads* payment status (`status` field on `PaymentModel`/`PaymentActionResponse`).

### 4.2 Payment flow — attendee (ticket) purchase

```
1. POST /payments/event-payment        -> { approvalUrl }          (PayPal)  OR clientSecret (Stripe)
2. (PayPal) app opens approvalUrl in browser
3. POST /payments/paypal/{orderId}/capture  -> { status }
   status contains "FAIL" or "CANCEL"  -> show failure, retry
   otherwise                           -> payment complete; ticket issued server-side
4. (Stripe) app presents Stripe PaymentSheet with clientSecret
5. POST confirm(paymentIntentId)       -> confirms charge & publishes purchase
```

`PaymentActionResponse` fields used by UI:
```dart
class PaymentActionResponse {
  final String? approvalUrl;    // PayPal hosted checkout
  final String? clientSecret;   // Stripe PaymentIntent client secret
  final String? orderId;        // PayPal order id
  final String? status;         // uppercased
  final bool? requiresPayment;
  final bool? alreadyActive;
}
```

### 4.3 Payment history — `PaymentHistoryViewModel` pattern

- `GET /payments/history?page=1&limit=50` → `List<PaymentModel>`
- Loaded **concurrently** with `GET /discounts/rewards` (both fire, UI waits on payments; discounts are best-effort `try?`).
- Loading guarded by `isLoading` + `hasLoaded` (load only once per screen unless pull-to-refresh).

`PaymentModel` (display mapping):
```dart
class PaymentModel {
  final String id;
  final String? eventId;       // "Event •••• ABCD"
  final String? provider;      // snake_case -> "Apple Pay"
  final String? status;        // snake_case -> "Completed"
  final String? currency;      // default EUR
  final double? amount;        // primary
  final int? amountMinor;      // fallback: amount ?? amountMinor/100
  final String? createdAt;     // ISO8601, fractional & non-fractional both parsed
}
```

### 4.4 Escrow status

`GET /payments/{paymentId}/escrow-status` → `EscrowStatus`. Loaded lazily per payment row (button tap), stored in `escrowByPaymentID` map, errors per-row in `escrowErrorByPaymentID`.

### 4.5 Saved cards (Stripe SetupIntent)

| Action | HTTP | Path | Body → Returns |
|---|---|---|---|
| `listCards()` | `GET` | `/payments/cards` | → `[SavedCard]` |
| `createCardSetupIntent()` | `POST` | `/payments/cards/setup-intent` | → `{ clientSecret }` |
| `saveCard(setupIntentID:)` | `POST` | `/payments/cards` | `{ setupIntentId }` |
| `setDefaultCard(id:)` | `PUT` | `/payments/cards/{id}/default` | — |
| `deleteCard(id:)` | `DELETE` | `/payments/cards/{id}` | — |

`SavedCard` fields used by UI:
```dart
class SavedCard {
  final String id;
  final String? last4;
  final String? brand;       // visa, mastercard…
  final String? expMonth;
  final String? expYear;
  final bool? isDefault;
}
```

**Card add flow (from `SavedCardsViewModel`):**
```
beginAddCard()
  -> POST /payments/cards/setup-intent
  -> clientSecret                       (field: setupClientSecret)
  -> Stripe PaymentSheet presented
  -> PaymentSheetResult.completed
finishAddingCard(setupIntentID)         (extract from client secret: part before "_secret_")
  -> POST /payments/cards { setupIntentId }
  -> reload() -> GET /payments/cards
```
Optimistic delete: card removed from local list immediately after `DELETE` succeeds; `mutatingCardID` shows per-row spinner.

## 5. Tickets

Service: `TicketService` (protocol `TicketServicing`).

| Method | HTTP | Path | Auth | Body | Returns |
|---|---|---|---|---|---|
| `create(eventID:)` | `POST` | `/tickets/for-event/{eventId}` | ✅ | — | `TicketModel` |
| `myTicketPage(page:limit:)` | `GET` | `/tickets/my?page=&limit=` | ✅ | — | `TicketPage` |
| `myTickets()` | `GET` | `/tickets/my?limit=50` (unwrap `.tickets`) | ✅ | — | `[TicketModel]` |
| `ticket(id:)` | `GET` | `/tickets/{id}` | ✅ | — | `TicketModel` |
| `cancel(id:)` | `DELETE` | `/tickets/{id}` | ✅ | — | `EmptyResponse` |
| `validate(id:code:)` | `POST` | `/tickets/{id}/validate` | ✅ | `{ ticketCode }` | `TicketModel` |

```dart
class TicketModel {
  final String id;
  final String? eventId;
  final String? eventTitle;      // displayed as row title
  final String? eventDate;       // ISO8601 -> "Jan 5, 2026, 6:30 PM"
  final String? ticketCode;      // "Code: ABC123"
  final String? status;          // any value containing "CANCEL" => red & hides cancel button
  final bool? isFree;            // optional
  final String? qrCodeUrl;       // optional
}

class TicketPage {
  final List<TicketModel> tickets;   // key fallbacks: tickets | items | results | data
  final int page;
  final int? limit;
  final int? total;
  final bool hasMore;
  // meta/pagination envelope keys are tolerated by the decoder
}
```

**Ticket row UI contract (`GuestTicketRowView`):**
- Left: ticket icon; Right: event title (bold 16), status chip (blue if active, **red if status contains "CANCEL"**), date line, `Code: {ticketCode}`.
- Cancel button only when not cancelled; on tap → `DELETE /tickets/{id}` with per-row `isCancelling` spinner.
- Status matching is **case-insensitive substring** `CANCEL`.

> Note: `TicketService` is fully implemented and unit-covered, but the current iOS app does not yet call it from a View/ViewModel — treat the service layer above as the definitive contract.

---

## 6. Support

Service: `SupportService` (protocol `SupportServicing`).

| Method | HTTP | Path | Auth | Body |
|---|---|---|---|---|
| `create(request:)` | `POST` | (support-ticket create path, see `APIConstants.Support`) | ✅ | `CreateSupportTicketRequest` |

```dart
class CreateSupportTicketRequest {
  final String subject;           // UI: the selected reason string
  final String description;       // UI: comment — min 20 chars enforced client-side
  final String category;          // "feature_request" | "other"
  final String? priority;         // optional
  final List<String>? attachmentUrls;  // optional, from uploads
  final String? relatedEntityId;       // optional
  final String? relatedEntityType;     // optional
}
```

**UI mapping (`SupportContactViewModel`):**
```
reason "Improvement"       -> category "feature_request"
everything else           -> category "other"
```
- Client validates `description.trim().length >= 20` before submitting (localized error otherwise).
- On success: `didSubmit = true` → UI shows success state.
- On error: `errorMessage = error.localizedDescription`.

## 7. Uploads / Media

### 7.1 Avatar upload (`ProfileViewModel.uploadAvatar`)

| Step | Method | Path | Body | Returns |
|---|---|---|---|---|
| 1 | `POST` (multipart) | (uploads path, `APIConstants.Uploads`) | multipart field `file` — JPEG data, compression 0.85, filename `avatar.jpg`, mime `image/jpeg` | `UploadResponse { url?, secureUrl? }` |
| 2 | `PATCH`/`PUT` | `/users/me` (profile update) | `UpdateProfileRequest { avatar: <secureUrl ?? url> }` | `User` |

**Critical correctness rules:**
- Use `secureUrl ?? url` for the avatar — **never the plain `url` if `secureUrl` is present** (HTTP vs HTTPS).
- If both are missing, surface: *"Upload succeeded but no image URL was returned."*
- Upload is `MultipartFile`-based; on Android use `http.MultipartRequest` / `dio.FormData`.

### 7.2 Event banner upload (`CreateEventViewModel.createEvent`)

```
POST /events                         -> EventModel { id, creationPlan{requiresPayment} }
if cover image selected:
  POST (upload banner, multipart)    -> uploadBanner(eventID:, data:)
  GET /events/{id}                   -> refreshed event
  NOTE: GET never returns creationPlan — carry the POST response's creationPlan forward
if creationPlan.requiresPayment:
  -> startEventCreationPayment / PayPal fallback
```

---

## 8. Privacy

### 8.1 Account deletion

| Method | HTTP | Path | Body |
|---|---|---|---|
| `deleteAccount(password:reason:)` | `DELETE` | `/users/me` (account deletion path) | `{ password, reason }` |

View model always sends `reason: "User requested account deletion"`. No UI confirmation beyond the password prompt. On success the app treats the session as dead.

### 8.2 Password change

| Method | HTTP | Path | Body |
|---|---|---|---|
| `changePassword(current:new:)` | `POST` | (auth password-change path) | `{ currentPassword, newPassword }` |

Client rules: `new == confirmation`, `new.count >= 8`.
On success: `successMessage = "Password updated."`. Note: the app does not force a re-login after password change on iOS — match that or enforce, your choice.

### 8.3 Profile reads/updates (used by privacy surfaces)

```
GET  /users/me          -> User            (cached locally under key "user")
PATCH/PUT /users/me     -> User            UpdateProfileRequest (all fields optional, JSON null for "don't change")
```

`UpdateProfileRequest` fields: `firstName, lastName, displayName, avatar, bio, dateOfBirth, gender, phone, city, country, latitude, longitude, locationRadius, preferredLanguage` (all nullable — send `null` to leave unchanged).

## 9. Rewards

### 9.1 Reward rings

| Method | HTTP | Path | Auth | Returns |
|---|---|---|---|---|
| `RewardService.rewardsForCurrentUser()` | `GET` | `/users/{userId}/rewards` | ✅ (requires `userID` from tokens; throws `APIError.unauthorized` if missing) | `UserRewardsResponse` |

```dart
class UserRewardsResponse {
  final int gold;
  final int silver;
  final int bronze;
  bool get isEmpty => gold == 0 && silver == 0 && bronze == 0;
}
```

### 9.2 ⚠️ Flexible decoding — `UserRewardsResponse`

The iOS decoder is **deliberately permissive**. It resolves `gold/silver/bronze` counts from *any* of these shapes:

- **Direct object:** `{ "gold": 3, "silver": 2, "bronze": 1 }`
- **Key variants:** `goldCount`, `goldMedalCount`, `goldMedals`, `goldRewardCount`, `countGold`, `goldBadges`, etc.
- **String/bool counts:** `"earned"|"achieved"|"true" → 1`, `"notearned"|"false" → 0`, numeric strings parsed.
- **Nested containers:** search order `data → counts → medals → rewards → rewardCounts → badgeCounts`, then any nested object recursively.
- **Array form:** items `{ "tier"/"type"/"name"/"medal"/"badge": "gold|silver|bronze", "count"/"quantity"…: n }` → summed per tier. Empty array = `(0,0,0)`.
- **Key matching is diacritic/case-insensitive letters-only** (e.g. `Gold_Medals` matches).

**Flutter guidance:** implement a tolerant parser — don't throw on unknown keys; recursively search for tier keys by fuzzy match; treat empty object as zeros.

**State machine (`RewardRingsViewModel`):**
```
idle -> loading -> loaded(empty=false) | empty(empty=true) | unauthorized | failed
401/sessionExpired -> unauthorized; CancellationError -> idle; other -> failed
```

### 9.3 Discount codes / reward data

| Method | HTTP | Path | Auth | Returns |
|---|---|---|---|---|
| `DiscountService.rewards()` | `GET` | `/discounts/rewards` | ✅ | `JSONValue` (arbitrary tree) |

**Usage (`CartViewModel.applyDiscountCode`):**
1. Fetch `JSONValue`.
2. Recursively walk object/array/string values for case- & diacritic-insensitive match of the typed code.
3. Found → `appliedDiscountCode = code`, message *"Discount code applied."* (green).
4. Not found → clear, *"Discount code not found."* (red).
5. Error → *"<error>"* (red).

### 9.4 AI/ML rewards suggestion (bonus, part of rewards surface)

`AIMLService.rewardsSuggestion(userID:)` → `AIMLRewardsSuggestion`. Called after rewards load, `try?` best-effort (failures silently ignored). Guarded by `userID` from tokens.

## 10. Wallet-style state patterns to replicate in Flutter

Every ViewModel follows the same shape — adopt these in your Provider/Riverpod/Bloc:

```dart
class XViewModel {
  bool isLoading;            // guards re-entry; UI shows ProgressView when true && data == null
  String? errorMessage;      // red banner text
  Object? data;              // @Published
  bool hasLoaded;            // loadIfNeeded() runs once per screen visit
}
```

- **List actions:** while mutating row X, set `mutatingID = X` (row spinner, whole-list `.disabled`), then clear it with a `defer`-equivalent.
- **Optimistic updates:** e.g. delete card/remove cart item removes locally *immediately after* the server call succeeds, then optionally re-syncs.
- **Concurrent loads:** payment history + reward discounts fetched with `async let` (parallel), the secondary result wrapped in `try?` so UI never breaks if it fails.
- **Pull-to-refresh:** `GET /cart` (etc.) wired to `.refreshable`; `.task` on appear.

---

## 11. Endpoint quick reference table

### Payments & Refunds
| # | Method | Path | Auth | Notes |
|---|---|---|---|---|
| 1 | POST | /payments/event-payment | ✅ | Stripe intent or PayPal order (attendee) |
| 2 | POST | /payments/paypal/{orderId}/capture | ✅ | publishes purchase / activates event |
| 3 | GET | /payments/paypal/{orderId}/status | ✅ | status poll |
| 4 | GET | /payments/history?page=&limit= | ✅ | list payments |
| 5 | GET | /payments/{paymentId}/escrow-status | ✅ | escrow per payment |
| 6 | GET | /payments/cards | ✅ | saved cards |
| 7 | POST | /payments/cards/setup-intent | ✅ | Stripe SetupIntent secret |
| 8 | POST | /payments/cards | ✅ | persist card from SetupIntent |
| 9 | PUT | /payments/cards/{id}/default | ✅ | set default |
| 10 | DELETE | /payments/cards/{id} | ✅ | remove card |

### Tickets
| # | Method | Path | Auth | Notes |
|---|---|---|---|---|
| 11 | POST | /tickets/for-event/{eventId} | ✅ | buy ticket |
| 12 | GET | /tickets/my?page=&limit= | ✅ | my tickets (paged) |
| 13 | GET | /tickets/{id} | ✅ | detail |
| 14 | DELETE | /tickets/{id} | ✅ | cancel |
| 15 | POST | /tickets/{id}/validate | ✅ | code validation |

### Support
| # | Method | Path | Auth | Notes |
|---|---|---|---|---|
| 16 | POST | (support ticket path) | ✅ | `CreateSupportTicketRequest` |

### Uploads / Media
| # | Method | Path | Auth | Notes |
|---|---|---|---|---|
| 17 | POST | (upload path) multipart `file` | ✅ | avatar/banner; use `secureUrl` |
| 18 | PATCH | /users/me | ✅ | attach uploaded URL |

### Privacy
| # | Method | Path | Auth | Notes |
|---|---|---|---|---|
| 19 | DELETE | /users/me (account) | ✅ | body `{ password, reason }` |
| 20 | POST | (password change) | ✅ | `{ currentPassword, newPassword }` |
| 21 | GET | /users/me | ✅ | profile read |

### Rewards
| # | Method | Path | Auth | Notes |
|---|---|---|---|---|
| 22 | GET | /users/{userId}/rewards | ✅ | gold/silver/bronze — fuzzy decode |
| 23 | GET | /discounts/rewards | ✅ | raw JSONValue discount tree |
| 24 | GET | (AI/ML suggestion) | ✅ | best-effort |

## 12. DTO summary (Dart equivalents)

```dart
class CreateEventPaymentRequest {
  final String eventId;
  final String? discountCode;
  final String? rewardDiscountId;
}

class UploadResponse {
  final String? url;        // plain (http?) — fallback
  final String? secureUrl;  // https — preferred
}

class ValidateTicketRequest {
  final String ticketCode;
}

class EscrowStatus { /* fields per backend; displayed raw-ish */ }
```

---

## 13. Implementation checklist for Flutter Android

- [ ] `ApiClient` (Dio or http) with: base URL, `Authorization: Bearer` header from secure storage, 401 refresh-then-retry or session-expired state, envelope unwrap interceptor.
- [ ] `APIError` enum mapping status codes (400/422 → validation, 401 → unauthorized, 404 → notFound, 5xx → serverError).
- [ ] `JSONValue` (dynamic tree) model + `UserRewardsResponse` fuzzy decoder.
- [ ] `PaymentService` (10 methods), `TicketService` (6 methods), `SupportService`, `UploadService`, `ProfileService`, `RewardService`, `DiscountService` with the exact paths above.
- [ ] Views/state: reuse the `isLoading + errorMessage + hasLoaded + mutatingID` pattern.
- [ ] Date handling: ISO8601 with and without fractional seconds.
- [ ] Money: `amount` double preferred; fallback `amountMinor/100`; currency default `EUR`.
- [ ] Status text: uppercase & snake_case → display (e.g. `waiting_for_capture` → "Waiting For Capture"); tickets red when status contains "CANCEL".
- [ ] Stripe PaymentSheet (clientSecret flow) + PayPal hosted checkout (approvalUrl + capture) for both attendee payments and event-creation fees.

---

## 14. Key files in the iOS source (for reference)

| Concern | File |
|---|---|
| Networking core | `Kumele/Networking/APIClient.swift`, `APIEndpoint.swift`, `APIError.swift`, `APIResponse.swift`, `JSONValue.swift`, `HTTPMethod.swift`, `MultipartFile.swift`, `KeychainTokenStore.swift` |
| Endpoint paths | `Kumele/Core/APIConstants.swift` |
| Payments/Tickets | `Kumele/Services/API/TicketPaymentService.swift` |
| Rewards | `Kumele/Services/API/RewardService.swift` |
| Discounts/Chat/Notifications | `Kumele/Services/API/CommunicationService.swift` |
| Commerce (cart/subscriptions/plans/NFT) | `Kumele/Services/API/CommerceService.swift` |
| Support | `Kumele/Services/API/SupportContentService.swift` |
| Models | `Kumele/Models/API/FeatureModels.swift`, `Kumele/Models/API/RewardModels.swift` |
| ViewModels (wiring patterns) | `SavedCardsViewModel.swift`, `EventPaymentViewModel.swift`, `CreateEventViewModel.swift`, `CartViewModel.swift`, `RewardRingsViewModel.swift`, `SupportContactViewModel.swift`, `ProfileViewModel.swift`, `PaymentView_iPhone.swift` |
