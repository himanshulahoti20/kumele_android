# Kumele — Ads & Commerce API Reference for Flutter (Android)

> **Source of truth traced from**: `AI/05_ImplementedAPIs.md` (§8 Ads, §9 Commerce, §16b Event Plans), `Kumele/Services/API/{AdService,CommerceService}.swift`, `Kumele/Models/API/{AdModels,FeatureModels}.swift`, `Kumele/ViewModels/{ShopViewModel,CartViewModel,NFTsViewModel}.swift`, and `Kumele/Networking/{APIClient,APIEndpoint}.swift`.
>
> **Audience**: Flutter/Dart developers building the Android companion app against the same Kumele backend.

---

## 1. Base URLs & Environment

| Environment | Base URL | Notes |
|---|---|---|
| **Main API** | `http://84.247.131.180:3000/api/v1/` | HTTP (not HTTPS) — main backend |
| **Web3/NFT relay** | `https://kumele-backend.ansht.workers.dev` | Solana transaction signing relay (`/list`, `/cancel`, `/mint`) |
| **AI/ML microservice** | `http://84.247.131.180:8080` | Out of scope for Ads/Commerce |

```dart
const String kumeleBaseURL = 'http://84.247.131.180:3000/api/v1/';
const String web3BaseURL  = 'https://kumele-backend.ansht.workers.dev';
```

All paths below are relative to the **main API** unless marked **Web3**.

---

## 2. Authentication & Networking Layer (what the iOS app does — replicate in Flutter)

The iOS app routes every request through one actor singleton: `APIClient`. Your Flutter equivalent should mirror these behaviors exactly:

### 2.1 Token flow
- **Login** → `POST /auth/login` returns `accessToken` + `refreshToken`. Store in secure storage (Keychain on iOS → `flutter_secure_storage` on Android).
- Every request sends `Authorization: Bearer <accessToken>`.
- On **401** → automatically call `POST /auth/refresh` with body `{"refreshToken": "<refreshToken>"}` → **retry the original request once**.
- If refresh fails → clear tokens, emit session-expired event.

### 2.2 Request defaults
| Header | Value |
|---|---|
| `Accept` | `application/json` |
| `Content-Type` | `application/json` (when body present) |
| `Authorization` | `Bearer <accessToken>` (only when authenticated) |
| Timeout | 30s request / 60s resource |

### 2.3 Response envelope handling — **critical**
The backend mixes **three response shapes**. Your Dio/Http interceptor must try them in this order:

1. **Raw model** (e.g. `GET /products` → `[...]`, `GET /cart` → `{...}`)
2. **Envelope** `{"ok": true, "data": {...}, "meta": {...}}` — also accepts key `success` instead of `ok`
3. **Flat/root fields** (e.g. `GET /event-plans/quote` returns quote fields at the root next to `ok`)

The Swift `APIClient.decode` does EXACTLY this:
```swift
if let value = try? decoder.decode(Response.self, from: data) { return value }       // 1. raw
if let envelope = try? decoder.decode(APIDataEnvelope<Response>.self, from: data),
   let value = envelope.data { return value }                                       // 2. envelope
throw APIError.decodingFailure(...)
```

**Dart equivalent:**
```dart
Future<T> _decode<T>(dynamic modelFromJson) async {
  final decoded = modelFromJson(data);          // raw first
  return decoded ?? modelFromJson(json['data']); // else envelope
}
```
Use `json_serializable` with a custom `JsonKey(fromJson:)` for flexible field parsing (see §7.4).

### 2.4 Error shape
On non-2xx, the backend returns JSON like `{"message": ["...", "..."], "statusCode": 400}`. The iOS layer maps:
- 400/409/422 with messages → **validation error** (show first message)
- 401 → **unauthorized** (trigger refresh)
- 500 on `tickets/events/*` → **ticket service unavailable**
- `tempToken` in body → **2FA required** (auth only)

---

## 3. 📢 Ads (3 endpoints) — Live ✅

**Service on iOS**: `AdService` (`Kumele/Services/API/AdService.swift`)
**Wired into**: Home feed (iPhone/iPad/TV), Notifications feed (iPhone/iPad).

| Method | Path | Auth | Status | Notes |
|---|---|---|---|---|
| GET | `/ads/fetch` | ✅ Bearer | 🟢 Live | Fetch ads for a placement |
| POST | `/ads/track` | ✅ Bearer | 🟢 Live | Fire-and-forget impression/click/conversion tracking |
| GET | `/ads/admob/context` | — | ❌ Not used | No AdMob SDK in app; ignore for Android unless you integrate AdMob |

### 3.1 `GET /ads/fetch`

**Query parameters** (all optional):

| Param | Type | Example |
|---|---|---|
| `placement` | enum string | `EVENT_DECISION`, `NOTIFICATIONS`, `FEED`, `HOME`, `PROFILE`, `EVENT_LIST`, `SEARCH`, `DISCOVERY` |
| `locationKey` | string | `""` |
| `hobbyContext` | string | e.g. `"music"` |
| `lang` | string | `"en"`, `"fr"` etc. |
| `limit` | int | `5` |

**Response shape** — one of:
```json
{ "firstPartyAds": [ ...AdModel ] }
{ "ads": [ ...AdModel ] }
{ "firstPartyAd": { ...AdModel } }
```

**`AdModel`** (Dart):
```dart
class AdModel {
  final String id;
  final String campaignId;   // REQUIRED — decode both `campaignId` and `campaign_id`
  final String title;        // defaults to ""
  final String? body;
  final String? mediaUrl;    // also `media_url`
  final String? mediaType;   // also `media_type` — "image"/"video"/"none"
  final String? destinationType; // "event" | "blog" | other
  final String? destinationId;
  final String? destinationUrl;
  final String? moderationStatus;
  final String? createdAt;
  final String impressionId; // ⚠️ NOT from backend — iOS generates UUID().uuidString locally
}
```
> ⚠️ **`impressionId` is client-generated** (UUID). The backend does not send it. Generate it once per ad impression on Android too, and reuse it for the subsequent `track` call so impressions ↔ clicks correlate.

**Image URL helper**: backend may set `mediaType == "none"` → no image. In Dart, compute `mediaType?.toLowerCase() != 'none' ? mediaUrl : null`.

**CTA helper**: `destinationType == "event"` → "View event"; `"blog"` → "Read more"; else "Learn more".

### 3.2 `POST /ads/track`

**Body** — camelCase keys are **mandatory** (a prior snake_case bug caused 400 `property ad_id should not exist`):
```json
{
  "adId": "uuid",
  "campaignId": "uuid",
  "impressionId": "uuid-from-fetch",
  "eventType": "view",          // or "click" | "conversion"
  "placement": "HOME",          // same enum as fetch
  "hobbyContext": null          // optional
}
```
Fire-and-forget: **swallow errors** (analytics must never break UI). Log to console in debug only.

---

## 4. 💳 Subscriptions (7 endpoints) — Migrated to In-App Purchase

**Service on iOS**: `SubscriptionService` (`Kumele/Services/API/CommerceService.swift`)
**iOS purchase flow**: StoreKit 2 → `POST /subscriptions/apple/verify`.
**Android**: equivalent is **Google Play Billing** — see §4.4 for what changes.

| Method | Path | Auth | Status | Notes |
|---|---|---|---|---|
| GET | `/subscriptions/tiers` | ❌ No auth | 🟢 Live | Public catalog |
| GET | `/subscriptions/status` | ✅ | 🟢 Live | Current subscription state |
| POST | `/subscriptions/apple/verify` | ✅ | 🟢 Live | Apple IAP server-side verification (JWS) |
| POST | `/subscriptions` | ✅ | ⚪ Dead | Stripe-era; removed from app |
| DELETE | `/subscriptions` | ✅ | ⚪ Dead | Cancel not called from app (uses Apple Manage sheet) |
| POST | `/subscriptions/resume` | ✅ | ⚪ Dead | |
| GET | `/subscriptions/history` | ✅ | ⚪ Dead | |

### 4.1 `GET /subscriptions/tiers`

**No auth required.** Returns raw array (no envelope):
```json
[
  {
    "id": "basic",
    "name": "Basic",
    "description": "...",
    "priceMonthlyMinor": 499,
    "priceYearlyMinor": 4799,
    "currency": "EUR",
    "features": ["...", "..."],
    "priceMonthly": 4.99,
    "priceYearly": 47.99,
    "isActive": false,
    "appleProductId": "com.kumele.sub.basic"      // ← StoreKit product ID (iOS only)
  }
]
```

**Dart model:**
```dart
class SubscriptionTier {
  final String id;
  final String? name;
  final String? description;
  final int? priceMonthlyMinor;
  final int? priceYearlyMinor;
  final String? currency;
  final List<String>? features;
  final double? priceMonthly;
  final double? priceYearly;
  final bool? isActive;
  final String? appleProductId;   // IGNORE on Android — see §4.4
}
```

### 4.2 `GET /subscriptions/status`

**Returns envelope**: `{"data": {...}, "ok": true}` → unwrap `.data`.

> ⚠️ **Critical iOS gotcha**: every field on this model is nullable, so decoding the raw envelope trivially "succeeds" with all fields `nil` (which would hide an active subscription). iOS explicitly unwraps the envelope with `APIEnvelope<SubscriptionStatus>`. **Do the same in Dart — always decode `.data` first.**

```json
{
  "ok": true,
  "data": {
    "id": "sub_123",
    "tier": "premium",                  // ← field is `tier`, NOT `tierId`
    "hasActiveSubscription": true,
    "status": "ACTIVE",
    "currentPeriodEnd": "2026-08-30T00:00:00Z",
    "cancelAtPeriodEnd": false,
    "storeCredit": 12.5,
    "storeCreditCurrency": "EUR"
  }
}
```

**Dart model:**
```dart
class SubscriptionStatus {
  final String? id;
  final String? tier;                    // ⚠️ real key is `tier`, not `tierId`
  final bool? hasActiveSubscription;
  final String? status;
  final String? currentPeriodEnd;
  final bool? cancelAtPeriodEnd;
  final double? storeCredit;
  final String? storeCreditCurrency;
}
```

### 4.3 `POST /subscriptions/apple/verify`

**iOS-only** (Apple JWS). The backend derives tier/expiry from the verified JWS itself.
```json
{ "signedTransactionInfo": "<JWS-from-StoreKit>" }
```
Response: same `SubscriptionStatus` envelope as §4.2.

### 4.4 🔄 Android / Google Play Billing adaptation

**This is the one endpoint you cannot call as-is on Android.** The iOS app posts Apple's signed JWS to `/subscriptions/apple/verify`. Android uses Google Play Billing — you need ONE of:

- **(A) Backend support**: ask backend to add `POST /subscriptions/google/verify` (or `/play/verify`) accepting a Google Play `purchaseToken` + `productId`. Google's server-side verification uses `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/{token}` (needs a service account — backend work).
- **(B) Client-side fallback**: purchase via `in_app_purchase` / `billing_client` Flutter package, then keep `GET /subscriptions/status` as the source of truth and rely on the backend to learn of the purchase through Play Console webhooks (only if the backend already listens for Play RTDN).

Do **not** send the Apple JWS format from Android.

### 4.5 UI flow to replicate (`ShopViewModel` on iOS)
1. `load()` → fetch `tiers` + `status` in parallel.
2. Show prices from **backend** (iOS actually prefers Apple-quoted prices; on Android, use `ProductDetails` from Play Billing if available, fall back to backend `priceMonthly`/`priceYearly`).
3. User taps **Subscribe** → Play Billing purchase flow → `verify` against backend (see §4.4).
4. `isPurchasable` gate: tier with no store product id → show "not available".
5. **Restore purchases**: Android users restore via Play Billing `queryPurchases`; then re-check `GET /subscriptions/status`.

---

## 5. 🏷️ Products (2 endpoints) — Dead code on iOS

**Service on iOS**: `ProductCartService.products(_:)` / `product(idOrSlug:)`

| Method | Path | Auth | Status |
|---|---|---|---|
| GET | `/products?page=1&limit=20` | ❌ No auth | ⚪ Dead |
| GET | `/products/{idOrSlug}` | ❌ No auth | ⚪ Dead |

No product-catalog UI exists in the iOS app. The Cart screen says *"Add subscriptions or products to get started"* — the plumbing is there but no screen browses standalone products. **Android can implement these freely** if you want a product catalog.

**`ProductModel`**:
```dart
class ProductModel {
  final String id;
  final String? name;
  final String? slug;
  final String? description;
  final double? price;
  final String? currency;
  final List<String>? images;
  final String? category;
  final int? stock;
}
```

---

## 6. 🛒 Cart (5 endpoints) — Live on iOS (real Cart screen)

**Service on iOS**: `ProductCartService` → `CartViewModel`
**iOS UI**: `PaymentView_iPhone` (tab-bar payment icon → "Cart" screen) with quantity stepper, per-item delete, "Clear All", discount-code field, running total.

| Method | Path | Auth | Status | Notes |
|---|---|---|---|---|
| GET | `/cart` | ✅ | 🟢 Live | Load cart on screen `.task` + pull-to-refresh |
| POST | `/cart/items` | ✅ | 🟡 **SUSPECTED BUG** | iOS passes an event-plan tier ID as `productId` — see §6.3 |
| PUT | `/cart/items/{id}` | ✅ | 🟢 Live | Body `{"quantity": N}` |
| DELETE | `/cart/items/{id}` | ✅ | 🟢 Live | Remove single item |
| DELETE | `/cart` | ✅ | 🟢 Live | Clear all |

### 6.1 `GET /cart` — response model
```json
{
  "id": "cart_uuid",
  "items": [
    {
      "id": "item_uuid",
      "productId": "product_uuid",
      "quantity": 2,
      "product": { "id": "...", "name": "...", "price": 9.99, "currency": "EUR", ... }
    }
  ],
  "total": 19.98,
  "currency": "EUR"
}
```
**Dart:**
```dart
class CartItem {
  final String id;
  final String? productId;
  final int? quantity;
  final ProductModel? product;
  String get displayName => product?.name ?? 'Item';
  double? get unitPrice => product?.price;
  double get lineTotal => (unitPrice ?? 0) * (quantity ?? 1);
}

class CartModel {
  final String? id;
  final List<CartItem> items;
  final double? total;
  final String? currency;
  bool get isEmpty => items.isEmpty;
}
```

### 6.2 Mutations
| Endpoint | Body |
|---|---|
| `POST /cart/items` | `{"productId": "<uuid>", "quantity": 1}` |
| `PUT /cart/items/{id}` | `{"quantity": 3}` (if quantity `<= 0` iOS treats as remove) |
| `DELETE /cart/items/{id}` | no body |
| `DELETE /cart` | no body |

### 6.3 ⚠️ Known bug to avoid on Android
The iOS app's `CreateEventViewModel` adds an **event-plan capacity tier ID** as the cart's `productId` — the same bug class that was already confirmed-fixed elsewhere (subscription tier IDs aren't real catalog rows either; those failed with `"productId must be a UUID"`). **On Android, always ensure `productId` is a real product from `GET /products` before calling `POST /cart/items`.**

### 6.4 Discount codes (Bonus — iOS wires it)
Cart screen also calls **`GET /discounts/rewards`** (auth required) returning a `JSONValue`, then checks the entered code against the response via case-insensitive/diacritic-insensitive substring match. Not in the formal Commerce §9 list (it's in §17 "no client code" — but iOS's `CartViewModel` **does** call it). If the backend supports discount codes, replicate this flow:
1. Fetch `GET /discounts/rewards` → parse as flexible JSON (string | array | object).
2. `applyDiscountCode(code)` → search the JSON tree for the code.
3. Show "applied" / "not found".

---

## 7. 🖼️ NFTs (7 REST + 3 Web3 endpoints)

**Service on iOS**: `NFTService` (`Kumele/Services/API/CommerceService.swift`) — with a **second** `APIClient` pointed at `web3BaseURL`.
**iOS UI**: `ShopView_iPhone` → "NFTs" tab (`ShopNFTsView_iPhone`) — 3-way tab switcher: **Rewards** / **Claimed** / **Market Place**.

| Method | Path | Auth | Status | Notes |
|---|---|---|---|---|
| GET | `/nfts/my-screen` | ✅ | ⚪ Dead | Combined summary — iOS has no matching screen |
| GET | `/nfts/rewards` | ✅ | 🟢 Live | Rewards tab; "Claim" button unless `owned == true` |
| GET | `/nfts/mine?page=1&limit=20` | ✅ | 🟢 Live | Claimed tab |
| GET | `/nfts/marketplace?page=1&limit=20` | ❌ No auth | 🟢 Live | Market Place tab |
| GET | `/nfts/{id}` | ❌ No auth | ⚪ Dead | No detail screen |
| POST | `/nfts/{id}/claim` | ✅ | 🟢 Live | Claim a reward NFT |
| POST | `/nfts/{id}/purchase` | ✅ | 🟢 Live | Buy marketplace NFT (params optional) |
| POST | `/list` *(Web3)* | ❌ | ⚪ Dead | Solana listing (needs Phantom signing) |
| POST | `/cancel` *(Web3)* | ❌ | ⚪ Dead | Solana cancel listing |
| POST | `/mint` *(Web3)* | ❌ | ⚪ Dead | Solana mint |

### 7.1 `NFTModel` — ⚠️ flexible type decoding is MANDATORY

The iOS decoder was rewritten because the live backend returns **`"price": "12"` (JSON string)**, which breaks the whole array with strict typing. Also `owned` must be decoded. Your Dart model must use tolerant parsing (see §7.4).

```dart
class NFTModel {
  final String id;
  final String? name;
  final String? description;
  final String? imageUrl;         // image_url (both accepted)
  final String? thumbnailUrl;     // thumbnail_url
  final double? price;            // ⚠️ string OR number in JSON
  final String? currency;
  final bool? isFree;             // is_free
  final String? nftType;          // nft_type
  final bool? comingSoon;         // coming_soon
  final bool? owned;
  final String? tokenId;          // token_id
  final String? tokenStandard;    // token_standard
  final String? blockchain;
  final String? creator;
  final String? transactionBase64;// transaction_base64
  final bool? earned;
  final bool? claimed;
}
```

### 7.2 Pagination (`NFTPage`)

`GET /nfts/mine` and `GET /nfts/marketplace` return one of these shapes (iOS NFTPage decoder accepts ALL):
```json
// Shape A — direct array
[ {...NFTModel}, ... ]

// Shape B — wrapped
{
  "nfts": [ ... ],
  "page": 1, "limit": 20, "total": 5, "hasMore": true
}

// Shape C — meta/pagination variants
{
  "items": [ ... ], // or "results" or "data"
  "meta": { "total": 5, "hasMore": true }
}
```

**Dart:**
```dart
class NFTPage {
  final List<NFTModel> nfts;
  final int page;
  final int limit;
  final int? total;
  final bool hasMore;
}
```
Standard pagination: `page` (1-based) + `limit` (default 20).

### 7.3 Mutations

**`POST /nfts/{id}/claim`** — auth. Returns full `NFTModel`. After success: reload Rewards + Claimed tabs.

**`POST /nfts/{id}/purchase`** — auth. Optional body (iOS passes nulls):
```json
{ "transactionRef": null, "walletAddress": null }
```
> These fields are documented server-side as "for future on-chain minting" — optional strings. On Android you can pass `null`/omit them, same as iOS.

**Web3 relay** (`https://kumele-backend.ansht.workers.dev`):
- `POST /list` → `{"assetId": "...", "price": 12.5, "seller": "...", "buyer": null}` → `{"escrowPDA": "...", "transaction": "<base64>", "message": "..."}`
- `POST /cancel` → `{"escrowPDA": "...", "seller": "...", "assetId": null}`
- `POST /mint` → `{"uri": "...", "name": "...", "owner": "..."}` → `{"assetId": "...", "transaction": "<base64>"}`

All three return a base64 **Solana transaction the user must sign in a wallet** (Phantom etc.) — iOS surfaces it in a "sign in Phantom" sheet, then refreshes. On Android, deep-link to the wallet app with the base64 transaction.

### 7.4 Dart flexible JSON parsing (replicating iOS `flexibleString/flexibleDouble/flexibleBool`)

```dart
double? flexibleDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

String? flexibleString(dynamic v) {
  if (v == null) return null;
  if (v is String) return v;
  if (v is num) return v.toString();
  return null;
}

bool? flexibleBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    switch (v.trim().toLowerCase()) {
      case 'true': case '1': case 'yes': return true;
      case 'false': case '0': case 'no': return false;
    }
  }
  return null;
}
```
Apply these in every `fromJson` for `AdModel.campaignId`, `NFTModel.price/owned/imageUrl`, `CartModel.total`, `SubscriptionStatus.hasActiveSubscription`, etc. Also accept **snake_case aliases** for `NFTModel` (`image_url`, `thumbnail_url`, `is_free`, `nft_type`, `coming_soon`, `token_id`, `token_standard`, `transaction_base64`).

---

## 8. Event Plans (used by Cart/NFT Shop wiring) — Live ✅

**Service on iOS**: `EventPlanService` (in `CommerceService.swift`)

| Method | Path | Auth | Status |
|---|---|---|---|
| GET | `/event-plans` | ❌ | 🟢 Live |
| GET | `/event-plans/quote?capacity=50` | ❌ | 🟢 Live |

`GET /event-plans` returns a raw array (flat, no envelope) of:
```json
{
  "id": "...",
  "label": "6-20 Guests",
  "minGuests": 6,
  "maxGuests": 20,
  "priceEur": 9.99,
  "priceEurMinor": 999,
  "currency": "EUR",
  "isFree": false,
  "isActive": false
}
```

`GET /event-plans/quote?capacity={n}` returns **flat root fields** (NOT under `data`):
```json
{
  "ok": true,
  "capacity": 50,
  "requiresPayment": true,
  "priceEur": 19.99,
  "priceEurMinor": 1999,
  "tier": { "id": "...", "label": "21-50 Guests", "minGuests": 21, "maxGuests": 50 }
}
```
Real tiers confirmed live: `1-5 Free / 6-20 €9.99 / 21-50 €19.99 / 51-100 €39.99`. Used as the guest-count cap when creating events and as the "guest tickets" catalog in the Shop screen.

---

## 9. Complete Endpoint Reference Table (Ads + Commerce)

| # | Method | Path | Auth | Status | Flutter notes |
|---|---|---|---|---|---|
| 1 | GET | `/ads/fetch` | ✅ | 🟢 | `placement` enum: `EVENT_DECISION`, `NOTIFICATIONS`, `FEED`, `HOME`, `PROFILE`, `EVENT_LIST`, `SEARCH`, `DISCOVERY` |
| 2 | POST | `/ads/track` | ✅ | 🟢 | **camelCase body only**; fire-and-forget |
| 3 | GET | `/ads/admob/context` | — | ❌ | Only if you integrate Google AdMob |
| 4 | GET | `/subscriptions/tiers` | ❌ | 🟢 | public; raw array |
| 5 | GET | `/subscriptions/status` | ✅ | 🟢 | **unwrap envelope `.data`** |
| 6 | POST | `/subscriptions/apple/verify` | ✅ | 🟢 | **iOS-only**; see §4.4 for Android |
| 7 | POST | `/subscriptions` | ✅ | ⚪ | Stripe legacy — skip |
| 8 | DELETE | `/subscriptions` | ✅ | ⚪ | Cancel — use Play Billing `cancel`/`BillingFlowParams` instead |
| 9 | POST | `/subscriptions/resume` | ✅ | ⚪ | skip |
| 10 | GET | `/subscriptions/history` | ✅ | ⚪ | skip |
| 11 | GET | `/products` | ❌ | ⚪ | optional Android catalog |
| 12 | GET | `/products/{idOrSlug}` | ❌ | ⚪ | optional |
| 13 | GET | `/cart` | ✅ | 🟢 | loads on screen open |
| 14 | POST | `/cart/items` | ✅ | 🟡 | **must pass a real product UUID** |
| 15 | PUT | `/cart/items/{id}` | ✅ | 🟢 | body `{"quantity": n}` |
| 16 | DELETE | `/cart/items/{id}` | ✅ | 🟢 | |
| 17 | DELETE | `/cart` | ✅ | 🟢 | |
| 18 | GET | `/nfts/my-screen` | ✅ | ⚪ | combined summary — build 3 tabs instead |
| 19 | GET | `/nfts/rewards` | ✅ | 🟢 | claim if `owned != true` |
| 20 | GET | `/nfts/mine` | ✅ | 🟢 | `page`, `limit` query |
| 21 | GET | `/nfts/marketplace` | ❌ | 🟢 | public |
| 22 | GET | `/nfts/{id}` | ❌ | ⚪ | skip |
| 23 | POST | `/nfts/{id}/claim` | ✅ | 🟢 | returns `NFTModel` |
| 24 | POST | `/nfts/{id}/purchase` | ✅ | 🟢 | null body ok |
| 25 | POST | `/list` *(Web3)* | ❌ | ⚪ | Solana signing |
| 26 | POST | `/cancel` *(Web3)* | ❌ | ⚪ | Solana signing |
| 27 | POST | `/mint` *(Web3)* | ❌ | ⚪ | Solana signing |
| 28 | GET | `/event-plans` | ❌ | 🟢 | raw array, flat |
| 29 | GET | `/event-plans/quote` | ❌ | 🟢 | `capacity` query, **root-level fields** |
| 30 | GET | `/discounts/rewards` | ✅ | 🟢 (iOS) | flex JSON; used by Cart discount code |

**Total: 21 Commerce endpoints (per the doc header) + 3 Ads + 2 Event Plans + 1 discount = 27 rows.**

---

## 10. Recommended Flutter Project Structure (mirrors iOS)

```
lib/
  core/
    api_constants.dart          # base URLs, paths as constants
    api_client.dart             # Dio wrapper: auth header, 401-refresh, envelope decode, error mapping
    api_error.dart              # typed errors (validation, unauthorized, sessionExpired...)
    token_store.dart            # flutter_secure_storage wrapper
  models/
    ad_models.dart              # AdModel, AdFetchResponse, AdPlacement, AdTrackEventType
    subscription_models.dart    # SubscriptionTier, SubscriptionStatus
    product_cart_models.dart    # ProductModel, CartItem, CartModel, AddCartItemRequest
    nft_models.dart             # NFTModel, NFTPage, NFTMyScreen
    event_plan_models.dart      # EventPlan, EventPlanQuote
  services/
    ad_service.dart             # fetch(placement), track(...)
    subscription_service.dart   # tiers(), status(), verifyGooglePurchase(...)
    product_cart_service.dart   # cart(), add(), update(), remove(), clear()
    nft_service.dart            # rewards(), mine(), marketplace(), claim(), purchase()
  providers/  (or controllers/)
    shop_provider.dart          # tiers + status + purchase flow (≈ ShopViewModel)
    cart_provider.dart          # cart state + mutations (≈ CartViewModel)
    nfts_provider.dart          # rewards/claimed/marketplace state (≈ NFTsViewModel)
```

### 10.1 Dio setup sketch

```dart
class ApiClient {
  final Dio dio;
  final TokenStore tokens;

  ApiClient(this.tokens)
      : dio = Dio(BaseOptions(
          baseUrl: kumeleBaseURL,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
          headers: {'Accept': 'application/json'},
        )) {
    dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokens.readAccessToken();
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          final refreshed = await _tryRefresh();          // POST /auth/refresh
          if (refreshed) {
            final opts = e.requestOptions;
            opts.headers['Authorization'] = 'Bearer ${await tokens.readAccessToken()}';
            handler.resolve(await dio.fetch(opts));        // retry once
            return;
          }
          await tokens.clear();
          // emit sessionExpired
        }
        handler.next(e);
      },
    ));
  }

  Future<T> send<T>(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? query,
    Object? body,
    bool auth = true,
    required T Function(dynamic json) fromJson,
  }) async {
    final res = await dio.request(path,
        queryParameters: query, data: body, options: Options(method: method));
    // 1) raw                                     2) envelope.data
    return fromJson(res.data) ?? fromJson(res.data?['data']);
  }
}
```

---

## 11. Known Gotchas Checklist (learned from live-ish iOS debugging)

1. **Envelope shapes differ per endpoint**: `tiers`, `products`, `event-plans` → raw arrays. `status`, `apple/verify` → `{data}` envelope. `event-plans/quote` → flat root. `nfts/mine|marketplace` → array OR `{nfts}` OR `{items}` OR `{data}`. Decode leniently.
2. **Flexible types**: `NFTModel.price` can be a JSON **string** (`"12"`) — strict decode kills the whole array.
3. **snake_case vs camelCase**: request bodies are **camelCase** (`adId`, `campaignId`, `impressionId`, `eventType`). A prior snake_case attempt returned 400. Response fields tolerate both (`image_url` / `imageUrl`) — accept both.
4. **`SubscriptionStatus.tier`** (not `tierId`) — old client decoded nothing and hid active subs.
5. **`/subscriptions/apple/verify` is Apple-specific** — do not call from Android. Coordinate with backend for a Google Play verify endpoint.
6. **`GET /ads/fetch` does NOT return `impressionId`** — generate a UUID client-side per impression and reuse it for `POST /ads/track`.
7. **`POST /cart/items` must receive a real `/products` UUID** — event-plan/capacity-tier IDs are NOT valid catalog products and likely 400.
8. **Checkout is not implemented** — iOS Cart's "Pay now" button is `.disabled(true)` with no action. On Android you'd need to wire Stripe/PayPal/Google Pay yourself against the Payments endpoints (§10 of the API doc) still missing a live consumer flow.

---

## 12. Status Legend Recap

- 🟢 **Live** — called from a real screen; verified via grep/live curl.
- 🟡 **Live but wrong** — reachable, but the request shape is suspect (`POST /cart/items`).
- ⚪ **Dead code** — correct endpoint exists but no UI calls it. Safe to implement on Android as new UI.
- ❌ **Not implemented** — no client code at all (AdMob context).

For anything outside Ads/Commerce (auth, events, chat, notifications, tickets, payments), see `AI/05_ImplementedAPIs.md` and `Docs/EVENTS_API_README.md`.