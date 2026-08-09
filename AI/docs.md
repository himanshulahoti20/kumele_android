# Kumele Events API — Integration Guide for Flutter (Android)

This document is derived from the live iOS codebase (`Kumele/Services/Event/EventServices.swift`,
`Kumele/Services/API/UserEventExtendedService.swift`, `Kumele/Models/EventModel.swift`,
`Kumele/Networking/APIClient.swift`, `Kumele/Core/APIConstants.swift`) and the authoritative
implementation audit in `AI/05_ImplementedAPIs.md` (2026-07-30 re-audit). It gives you the exact
endpoints, request/response shapes, envelope handling, error semantics, and Flutter wiring
patterns used by the app — copy these in your Flutter/Android project as-is.

---

## 1. Base URL & Environment

| Key | Value |
|---|---|
| Base URL | `http://84.247.131.180:3000/api/v1/` |
| Auth | `Authorization: Bearer <JWT>` for protected calls |
| Refresh | `POST /auth/refresh` — called automatically by the client on 401, retried once |

Path segments are **snake_case** (e.g. `host_profile`, `attendee_count`, `starts_at`). Query
parameter names are **camelCase** (e.g. `hobbyCategoryId`, `centerLat`, `startAfter`). Request
bodies are **camelCase** (the one historical exception — `SendChatMessageRequest` with
`message_text` — was an app bug; the API contract is camelCase everywhere else).

---

## 2. Response Envelope (critical)

Most endpoints wrap data in an envelope. You **must** decode this before touching `data`.

```json
// Standard envelope — most GET endpoints
{
  "ok": true,
  "data": { ... },
  "meta": { ... }        // optional, pagination etc.
}
```

Some endpoints return a **bare array** or a **special shape** instead — handle these per-endpoint:

| Endpoint | Response shape |
|---|---|
| `GET /events` (search/list) | `{ "events": [...], "nextCursor": "..." }` (cursor pagination; the app also tolerates `data` / `items` and `pagination/cursor` / `meta/cursor` as aliases) |
| `GET /events/recommendations` | `{ "advisory_only": bool, "fallback_used": bool, "recommendations": [...] }` — backend currently returns an empty `recommendations` array; expect a `data` field too |
| `GET /events/{id}` | Standard envelope → `data` is the event object |
| `GET /events/{id}/ratings` | Standard envelope → `data` is an array of rating objects |
| `GET /events/{id}/ratings/summary` | Standard envelope → `data` is the summary object |
| `GET /users/{id}/host-profile` | Standard envelope → `data` |
| `POST /events` | `{ "data": {...}, "creationPlan": {...} }` — `creationPlan` is a **sibling of `data`**, not nested inside it |
| `POST /events/{id}/join` etc. | Empty 2xx body — treat as success if status 200–299 |
| `GET /event-plans` | Bare array of plan objects |
| `GET /event-plans/quote` | Bare quote object |
| `GET /tickets/my` | Bare `{ "tickets": [...] }` (the app's `TicketPage`) |

### Flutter envelope handling

```dart
// di/networking/api_envelope.dart
class ApiEnvelope<T> {
  final bool ok;
  final T? data;
  final Map<String, dynamic>? meta;

  ApiEnvelope({required this.ok, this.data, this.meta});

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson, {
    T? Function(Object?)? fromJsonDynamic,
  }) {
    // `data` may be an object, a list, or absent. Provide a cast helper.
    final raw = json['data'];
    return ApiEnvelope(
      ok: json['ok'] == true || json['success'] == true,
      data: raw == null
          ? null
          : fromJsonDynamic != null
              ? fromJsonDynamic(raw)
              : fromJson(raw as Map<String, dynamic>),
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }
}
```

**Guard pattern used in the iOS app:** for the chat messages endpoint the app explicitly checks
`response.ok` before returning data and throws a custom error otherwise. Do the same — never
assume `data` is valid when `ok == false`.

---

## 3. Error Handling

The iOS `APIError` enum distinguishes these structured failures. Mirror them in Dart:

| Error | Meaning |
|---|---|
| `twoFactorRequired` | `POST /auth/login` returned a `tempToken` (2FA challenge pending) |
| `ticketServiceUnavailable` | Ticket/payment backend refused |
| `validation([String])` | Body validation failed — backend returns `{ "message": ["prop should not exist", ...] }` (array of strings) |
| `unauthorized` | 401 — trigger `POST /auth/refresh` once, then retry the original request |
| `custom(String)` | Any other server message |

**401 handling pattern (must have in Flutter):**

```dart
class AuthInterceptor extends Interceptor {
  // On 401: call POST /auth/refresh with the stored refresh token,
  // store the new access token, replay the original request once.
  // If refresh itself 401s → force logout / re-login.
}
```

---

## 4. Events Endpoints — Full Reference

Base path `{baseUrl}events`.

### 4.1 Create event

```
POST /events
Authorization: Bearer <JWT>
```

**Request body (all camelCase):**

```json
{
  "title": "90's Hip-Hop Night",
  "description": "...",
  "hobbyCategoryId": "uuid-or-string",
  "eventStartTime": "2026-09-15T19:00:00+00:00",
  "eventEndTime": "2026-09-15T23:00:00+00:00",
  "capacity": 40,
  "isPaid": true,
  "basePriceEur": 9.99,
  "latitude": 52.52,
  "longitude": 13.405,
  "displayAddress": "Oranienburger Str. 1, Berlin",
  "coverImage": "https://...jpg"
}
```

- `eventStartTime`/`eventEndTime`: ISO-8601 UTC strings.
- `basePriceEur`: only meaningful when `isPaid == true`; omit/null for free events.
- `coverImage`: optional — can be uploaded first via `POST /upload/event-banner` (see §7).

**Response (special two-field shape — decode `data` and `creationPlan` separately):**

```json
{
  "data": { /* full EventModel, see §5 */ },
  "creationPlan": {
    "planKey": "cap_21_50",
    "priceEur": 19.99,
    "requiresPayment": true
  }
}
```

`creationPlan` tells the host **immediately** whether the chosen capacity tier needs payment
before the event can be published. Use it to route to checkout.

### 4.2 List / search nearby events

```
GET /events?centerLat=52.52&centerLon=13.405&radiusKm=50&city=Berlin&limit=10
GET /events?hobbyCategoryId=...&hostId=...&cursor=...&limit=20
```

**Query parameters (all optional except auth):**

| Param | Type | Notes |
|---|---|---|
| `centerLat`, `centerLon` | double | Center coordinates |
| `radiusKm` | int | Clamped `1–100` (the app rounds up, clamps, and sends as integer) |
| `city` | string | Reverse-geocoded city name, added alongside coordinates |
| `hobbyCategoryId` | string | Filter by category |
| `hobby` | string | Filter by hobby slug/key |
| `hostId` | string | Filter by host user ID — **this powers "My Events"** |
| `startAfter`, `startBefore` | ISO-8601 | Time window filters |
| `cursor` | string | **Cursor pagination** — pass the `nextCursor` from the previous response |
| `limit` | int | Default `20`; nearby-list uses `10` |

**Response:**

```json
{
  "events": [ /* EventModel[] */ ],
  "nextCursor": "opaque-string-or-null",
  "hasMore": true      // derived in the app: hasMore = nextCursor != null
}
```

**"My Events" implementation (from iOS):** `getEventOwned()` does a search with
`hostId = <current user id>` — there is no separate `/events/mine` endpoint.

### 4.3 Recommended / matched events

```
GET /events/recommendations?limit=10
Authorization: Bearer <JWT>
```

**Response — special shape, NOT the standard envelope:**

```json
{
  "advisory_only": true,
  "fallback_used": true,
  "recommendations": [],
  "data": []
}
```

The backend recommendation engine is currently in fallback mode (always empty
`recommendations`). Decode tolerantly: `recommendations ?? data ?? []`. This endpoint is what the
Watch app uses for the "Today/Upcoming" event list.

### 4.4 Get event by ID

```
GET /events/{id}
Authorization: optional (public read — `requiresAuthentication: false` in iOS)
```

**Response:** standard envelope → `data` is the full `EventModel`.

### 4.5 Join an event

```
POST /events/{id}/join
Authorization: Bearer <JWT>
```

Empty 2xx body. In the iOS app this is the first step of the paid flow: join → if
`EventModel.requiresPayment` → `POST /payments/paypal/create-order` → PayPal approval →
`POST /payments/paypal/capture/{orderId}` → `POST /tickets/events/{id}` (auto-issue ticket). For
free events, join alone is enough.

### 4.6 Cancel / un-join

```
POST /events/{id}/cancel
Authorization: Bearer <JWT>

{ "reason": "string" }
```

Empty 2xx body.

### 4.7 Event guests

```
GET /events/{id}/guests
Authorization: Bearer <JWT>
```

Returns the guest list. The iOS model decodes it as an array of User objects (not wrapped in the
standard envelope — decode as `List<User>`).

### 4.8 Host check-in (scan a guest's QR)

```
POST /events/{id}/checkin/host-scan
Authorization: Bearer <JWT>

{ "guestUserId": "uuid", "note": "optional" }
```

Returns generic JSON. This is the app's host-side verification flow (a separate
`POST /tickets/{id}/validate` exists for ticket-code scanning but is not used by the app).

### 4.9 Self check-in (geo-based)

```
POST /events/{id}/checkin/self
Authorization: Bearer <JWT>

{ "guestLat": 52.52, "guestLng": 13.405 }
```

Wired in code, **no UI currently calls it** in iOS. Available for your Android implementation.

### 4.10 Finalize matches / participation

```
POST /events/{id}/finalize-matches
POST /events/participations/{id}/finalize
Authorization: Bearer <JWT>
```

Both are correct in code but currently unreached from any iOS UI. Chat rooms auto-create on
finalize-matches per spec.

### 4.11 Rate an event

```
POST /events/{id}/ratings
Authorization: Bearer <JWT>

{
  "eventRating": 5,
  "comment": "Great night!",
  "communication": 5,
  "respect": 5,
  "professionalism": 5,
  "atmosphere": 4,
  "valueForMoney": 5
}
```

All sub-ratings are integer 1–5. Returns generic JSON (the app ignores the body).

### 4.12 Get event ratings (paginated)

```
GET /events/{id}/ratings?page=1&limit=20
Authorization: optional (public read)
```

**Response:** standard envelope → `data` is `[]` of rating objects (see §5.2).

### 4.13 Get my rating

```
GET /events/{id}/ratings/mine
Authorization: Bearer <JWT>
```

Returns generic JSON. Correct in code, no iOS UI calls it yet.

### 4.14 Get rating summary

```
GET /events/{id}/ratings/summary
Authorization: optional (public read)
```

**Response:** standard envelope → `data`:

```json
{
  "average_event_rating": 4.8,
  "average_host_rating": 4.6,
  "total_ratings": 32,
  "verified_attendee_count": 25,
  "sub_rating_averages": {
    "communication": 4.7,
    "respect": 4.8,
    "professionalism": 4.5,
    "atmosphere": 4.9,
    "value_for_money": 4.4
  }
}
```

### 4.15 Delete my rating

```
DELETE /events/{id}/ratings/{ratingId}
Authorization: Bearer <JWT>
```

Empty 2xx body. (Editing a rating — `PUT /events/{id}/ratings/{ratingId}` — is **not** implemented
in the iOS app; backend supports it.)

### 4.16 Report an event

```
POST /events/{id}/reports
Authorization: Bearer <JWT>

{ "reason": "offensive_content", "details": "optional long text" }
```

Empty 2xx body. `GET /events/{id}/reports` (list your reports) is **not implemented** client-side.

---

## 5. Event Models (JSON → Dart)

### 5.1 EventModel — the app decodes **both camelCase and snake_case** aliases

This is the exact alias set from `EventModel.swift`. In Dart, implement `fromJson` that prefers
snake_case (the backend's canonical form) and falls back to camelCase for resilience:

| Field (Dart) | JSON keys accepted | Type |
|---|---|---|
| `id` | `event_id`, `id` | String (prefer) / Int — **IDs can be int or string; cast to String** |
| `title` | `title`, `name` | String? |
| `subtitle` | `subtitle` | String? |
| `description` | `description` | String? |
| `host.name` | `host_profile.display_name`, `host_name` | String? |
| `host.id` | `host_profile.id`, `creator` | String? |
| `host.avatar` | `host_profile.avatar` | String? |
| `categoryName` | `hobby_key`, `hobbies[0].hobby.name` | String? |
| `categoryIcon` | `hobbies[0].hobby.icon` | String? |
| `imageUrl` | `cover_image` → `event_images[0]` → `event_image_url` → `image` | String? (http(s) only; `cdn.kumele.com` is dropped) |
| `eventImages` | `event_images` | List\<String\> |
| `startTime` | `event_date`, `starts_at`, `startsAt`, `start_time` | ISO-8601 string |
| `endTime` | `ends_at`, `endsAt`, `end_time` | ISO-8601 string |
| `durationHours` | derived from start/end, else `duration_hours` | int? |
| `minAge` / `maxAge` | `event_rules.min_age` / `max_age`, `age_range_min` / `age_range_max` | int? |
| `capacity` | `capacity`, `max_guests` | int? |
| `attendeeCount` | `attendee_count`, `current_attendees` | int? |
| `spotsRemaining` | `spots_remaining`, `spotsRemaining` | int? |
| `isJoinable` | `is_joinable`, `isJoinable`, else `spotsRemaining > 0` | bool |
| `price` | `price` — **can be a number or a string; coerce to string** | double? (coerce) |
| `currency` | `currency` | String? |
| `paymentType` | `payment_type`, else `"online"` if `is_paid` else `"free"` | String |
| `isPaid` | `is_paid`, `isPaid`, `flags.is_paid` | bool |
| `address/street` | `location_details.display_address` / `.address`, `location_name`, `street` | String? |
| `city` | `location_details.city`, `city_key`, `district` | String? |
| `country` | `location_details.country`, `state` | String? |
| `latitude` / `longitude` | `location_details.latitude` / `.longitude`, `latitude` / `longitude` | double? (coerce from string) |
| `isActive` | `is_active`, `isActive`, `flags.is_active` (default true) | bool |
| `isOwn` | `is_own`, `isOwn` | bool |
| `isFull` | `is_full`, `isFull`, `flags.is_full` | bool? |
| `status` | `status` | String? |
| `averageEventRating` | `average_event_rating` | double? |
| `averageHostRating` | `average_host_rating`, `host_rating` | double? |
| `totalRatings` | `total_ratings` | int? |
| `createdAt` | `created_at` | String? |

**Price coercion helper (important — the backend sends numbers as strings sometimes):**

```dart
double? toDouble(dynamic v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}
```

**Payment logic port from iOS:**

```dart
bool get requiresPayment {
  final type = (paymentType ?? 'free').toLowerCase();
  if (type == 'free' || type == 'cash_on_entry') return false;
  final amount = this.price ?? 0;
  return amount > 0;
}
```

### 5.2 EventRatingModel

| Field | JSON keys | Type |
|---|---|---|
| `id` | `id` | String? |
| `eventRating` | `event_rating`, `eventRating` (number or string) | double? |
| `comment` | `comment` | String? |
| `communication`, `respect`, `professionalism`, `atmosphere` | same names | double? |
| `valueForMoney` | `value_for_money`, `valueForMoney` | double? |
| `createdAt` | `created_at`, `createdAt` | String? |
| `author.id` | `author.id`, `author.user_id`, `user.id`, `reviewer.id`, `guest.id` | String? |
| `author.displayName` | `author.display_name`, `user.display_name`, … | String? |
| `author.avatar` | `author.avatar`, … | String? |

Accept `author` object **or** `user` / `reviewer` / `guest` as the author container.

### 5.3 EventRatingSummary — see §4.14 JSON above

### 5.4 EventHostProfileModel (GET /users/{id}/host-profile)

Fields: `id`, `display_name`, `avatar`, `bio`, `city`, `country`, `current_badge`,
`overall_host_rating` (double?), `total_reviews_received` (int?), `event_completion_rate`
(double?), `reward_tier`, `followers_count` (int?), `hosted_events_count` (int?),
`recent_ratings` (EventRatingModel[]), `sub_rating_averages` (sub-ratings object).

---

## 6. Suggested Flutter Project Structure

Mirror the iOS layering exactly — `Service` (repository) ↔ `ViewModel` (state) ↔ `View`:

```
lib/
  core/
    api_constants.dart          // base URL, path builders (like APIConstants.swift)
    di/dio_client.dart          // Dio + AuthInterceptor + logging interceptor
  networking/
    api_envelope.dart           // envelope decoding (see §2)
    api_error.dart              // structured APIError (see §3)
  models/events/
    event_model.dart            // EventModel.fromJson with aliases
    event_rating_model.dart
    event_rating_summary.dart
    event_host_profile.dart
    event_create_request.dart
    event_search_filter.dart    // toQueryParameters()
    event_search_page.dart      // events + nextCursor + hasMore
  services/events/
    event_service.dart          // 1:1 with EventServices.swift
    event_interaction_service.dart // 1:1 with EventInteractionService.swift
  viewmodels/
    event_view_model.dart       // states: loading / loaded / error
```

### Service example (1:1 with `EventServices.swift`)

```dart
class EventService {
  final Dio _dio;

  EventService(this._dio);

  // GET /events (nearby + search)
  Future<List<EventModel>> getEventList({
    required double latitude,
    required double longitude,
    double radiusKm = 50,
    String? city,
  }) async {
    final res = await _dio.get('/events', queryParameters: {
      'centerLat': latitude,
      'centerLon': longitude,
      'radiusKm': radiusKm.ceil().clamp(1, 100),
      'limit': 10,
      if (city != null && city.trim().isNotEmpty) 'city': city,
    });
    final envelope = ApiEnvelope<List<EventModel>>.fromJson(
      res.data, (json) => [],  // custom: raw is the whole body, not 'data'
    );
    // GET /events returns {events:[...]} -- decode directly:
    final body = res.data as Map<String, dynamic>;
    final events = (body['events'] as List? ?? body['data'] as List? ?? [])
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return events;
  }

  // GET /events/{id}
  Future<EventModel> getEvent(String id) async {
    final res = await _dio.get('/events/$id');
    final body = res.data as Map<String, dynamic>;
    return EventModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  // POST /events
  Future<EventModel> createEvent(CreateEventRequest request) async {
    final res = await _dio.post('/events', data: request.toJson());
    final body = res.data as Map<String, dynamic>;
    // creationPlan sits as a SIBLING of data -- decode both
    final event = EventModel.fromJson(body['data'] as Map<String, dynamic>);
    if (body['creationPlan'] != null) {
      event.creationPlan = EventCreationPlan.fromJson(body['creationPlan'] as Map<String, dynamic>);
    }
    return event;
  }

  // POST /events/{id}/join
  Future<void> joinEvent(String id) => _dio.post('/events/$id/join');

  // POST /events/{id}/cancel
  Future<void> cancelEvent(String id, String reason) =>
      _dio.post('/events/$id/cancel', data: {'reason': reason});

  // "My Events" -- same as search with hostId
  Future<EventSearchPage> getEventOwned(String currentUserId) =>
      searchEvents(EventSearchFilter(hostId: currentUserId, limit: 10));

  // GET /events/recommendations
  Future<List<EventModel>> getEventMatched() async {
    final res = await _dio.get('/events/recommendations', queryParameters: {'limit': 10});
    final body = res.data as Map<String, dynamic>;
    final recs = body['recommendations'] as List? ?? body['data'] as List? ?? [];
    return recs.map((e) => EventModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<EventSearchPage> searchEvents(EventSearchFilter f) async {
    final res = await _dio.get('/events', queryParameters: f.toQueryParameters());
    final body = res.data as Map<String, dynamic>;
    return EventSearchPage.fromJson(body);
  }
}
```

### Interaction service example (1:1 with `EventInteractionService.swift`)

```dart
class EventInteractionService {
  final Dio _dio;
  EventInteractionService(this._dio);

  Future<List<dynamic>> guests(String eventId) async {
    final res = await _dio.get('/events/$eventId/guests');
    return res.data as List; // bare array, NO envelope
  }

  Future<void> hostCheckIn(String eventId, String guestUserId, {String? note}) async {
    await _dio.post('/events/$eventId/checkin/host-scan',
        data: {'guestUserId': guestUserId, if (note != null) 'note': note});
  }

  Future<dynamic> selfCheckIn(String eventId, double lat, double lng) async {
    final res = await _dio.post('/events/$eventId/checkin/self',
        data: {'guestLat': lat, 'guestLng': lng});
    return res.data;
  }

  Future<void> rate(String eventId, RatingRequest req) async {
    await _dio.post('/events/$eventId/ratings', data: req.toJson());
  }

  Future<List<EventRatingModel>> ratings(String eventId, {int page = 1, int limit = 20}) async {
    final res = await _dio.get('/events/$eventId/ratings',
        queryParameters: {'page': page, 'limit': limit});
    final body = res.data as Map<String, dynamic>;
    return (body['data'] as List? ?? [])
        .map((e) => EventRatingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<EventRatingSummary> ratingSummary(String eventId) async {
    final res = await _dio.get('/events/$eventId/ratings/summary');
    final body = res.data as Map<String, dynamic>;
    return EventRatingSummary.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<void> deleteRating(String eventId, String ratingId) async {
    await _dio.delete('/events/$eventId/ratings/$ratingId');
  }

  Future<void> report(String eventId, String reason, String? details) async {
    await _dio.post('/events/$eventId/reports',
        data: {'reason': reason, if (details != null) 'details': details});
  }
}
```

---

## 7. Related Endpoints You Will Need for a Complete Events Feature

| Method | Path | Purpose | Notes |
|---|---|---|---|
| `GET` | `/event-plans` | Capacity tiers for **hosts** (`1-5 Free / 6-20 €9.99 / 21-50 €19.99 / 51-100 €39.99`) | Public, no auth. Drives the guest-count picker's max cap. |
| `GET` | `/event-plans/quote?capacity=40` | Priced quote for a chosen capacity (host checkout) | Public, no auth |
| `POST` | `/upload/event-banner` | Upload event cover image | Multipart with fields `eventId` + `file` (name `file`, image/jpeg) → `{ url }` |
| `GET` | `/users/{id}/host-profile` | Host profile card for event detail screen | Envelope → `data` |
| `POST` | `/tickets/events/{id}` | Auto-issue an attendee ticket after a successful payment | Called `try?` (best-effort) after PayPal capture in iOS |
| `GET` | `/tickets/my` | "My Tickets / Guest tickets" list | Response `{ tickets: [...] }` |
| `DELETE` | `/tickets/{id}` | Cancel a ticket | Empty 2xx |
| `POST` | `/payments/paypal/create-order` | Start PayPal checkout for a paid event | Body `{eventId, discountCode?, rewardDiscountId?}` → `{ approvalUrl, ... }` |
| `POST` | `/payments/paypal/capture/{orderId}` | Complete PayPal payment after approval | → payment status; then issue ticket |
| `POST` | `/payments/event-creation/{eventId}` | Host capacity-plan checkout (Stripe) | Returns `requiresPayment: false` for free tiers |
| `POST` | `/payments/paypal/event-creation/{eventId}` | Host capacity-plan checkout (PayPal) | Capture reuses the capture endpoint above |
| `GET` | `/events/{eventId}/chat/status` | Chat open/closed status | Redundant — status already embedded in `GET /chat/rooms` |
| `GET` | `/chat/rooms` | List chat rooms; each room already carries `is_open`, `opened_at`, `closes_at` | See §8 |
| `POST` | `/notifications/push-token` | Register FCM token | Body `{fcmToken, platform, deviceId}` — **required on first launch** to receive pushes |

---

## 8. Reference: How Chat / Blog / Notifications Are Wired (same patterns apply)

Since you asked for the data-layer wiring used for these, here's the exact pattern to copy for
events and everywhere else:

### Networking layer (shared)

- `APIClient` (actor singleton) on `URLSession`: attaches `Authorization: Bearer …`, auto-refreshes
  once on 401 via `POST /auth/refresh` (with in-flight de-duplication), decodes
  `APIEnvelope<T>` (`{ok/success, data, meta}`), throws structured `APIError`. DEBUG-only console
  request/response logging.
- **Flutter equivalent:** Dio + `AuthInterceptor` (401 → refresh → replay once) + `LogInterceptor`
  (debug only). One shared `Dio` instance, one base URL constant, path builders per feature.

### Chat (REST + socket)

- `GET /chat/rooms` → `ChatRoomService.fetchRooms()` → `ChatViewModel` (rooms list). Model
  `Chat` decodes snake_case: `event_id, event_name, event_date, event_image, host_id, host_name,
  host_image, status, is_open, opened_at, closes_at, closed_at`.
- `GET /events/{eventId}/chat/messages` → `ChatService.fetchMessages` → **checks `response.ok`
  explicitly, throws `APIError.custom` if false**, returns `data`. Envelope
  `{ok, data}` (array of messages).
- `POST /events/{eventId}/chat/messages` → `ChatService.sendMessage`, body `{ "message_text": "…" }`
  → checks `response.success != false`, throws with `response.message` otherwise.
- Real-time path (different from REST): Socket.IO at `ws://84.247.131.180` (default `/socket.io/`
  engine path), Bearer-authenticated, emits `joinRoom` to join, receives
  `newMessage` / `userTyping` / `userJoined` / `userLeft`.
- **Pattern lessons:** (1) different envelope shapes on the *same* base path — pick one
  decode shape per call, don't guess; (2) explicitly verify `ok`/`success` before using `data`;
  (3) rooms already embed status — avoid a redundant status call.

### Blog

- `GET /blogs/feed?limit=50` and `GET /blogs/feed?hobbyCategoryId=…&limit=50` →
  `BlogServices.fetchAllBlog[ByCategory]` → envelope `{data: [...]}` → `BlogViewModel`.
- `GET /blogs/{id}` AND `GET /blogs/{id}/comments?limit=50` are fetched **concurrently**
  (`async let`), then the comments are merged into the detail object before the view model gets it.
- `POST /blogs/{id}/comments` body `{content, parentId?}` → returns created comment (envelope).
- `POST /blogs/{id}/like` → empty 2xx.
- **Pattern lessons:** (1) fan-out multiple GETs concurrently and merge into one UI-facing
  aggregate — `Future.wait` in Dart; (2) flexible aliases in models
  (`cover_image`/`coverImage`, `created_at`/`createdAt`); (3) public endpoints don't need auth.

### Notifications

- `POST /notifications/push-token` body `{fcmToken, platform: "ios", deviceId}` — register once
  after login (deferred until post-auth). **For Android, use `platform: "android"`.**
- `GET /notifications?page=1&limit=20` → `NotificationService.notifications` →
  `NotificationPage` (paginated) → `NotificationViewModel.makeSectionItems` groups items by the
  `type` field — the app filters on hardcoded values `EVENT_MATCHED` / `CREATED_EVENT` / `OTHER`.
  ⚠️ These raw strings were **never confirmed against the live backend** (documented risk in
  `05_ImplementedAPIs.md §6`) — verify the real `type` values on staging before relying on them.
- `POST /notifications/{id}/read` → mark one read (tapping a card).
- `POST /notifications/read-all` → implemented, no iOS UI currently calls it — safe to wire on
  Android ("Mark all as read").
- **Pattern lessons:** (1) pagination via `page` + `limit` query params; (2) `markRead` is a
  POST (not PATCH) to a `/read` sub-path; (3) push-token registration payload is
  `{fcmToken, platform, deviceId}` exactly.

---

## 9. Checklist for Your Flutter Android Implementation

1. ✅ Set up `ApiConstants` with base URL `http://84.247.131.180:3000/api/v1/`.
2. ✅ Dio instance with `AuthInterceptor` (401 → refresh → replay-once) and debug logging.
3. ✅ `ApiEnvelope<T>` generic decoder; special-case the non-envelope endpoints
   (search `{events, nextCursor}`, recommendations `{recommendations}`, guest list bare array,
   `POST /events` with sibling `creationPlan`).
4. ✅ `ApiError` with `validation(List<String>)` — parse `message` as string-or-list, because the
   backend sends both forms.
5. ✅ `EventModel.fromJson` with the full alias table (§5.1) + number/string coercion.
6. ✅ `EventService` + `EventInteractionService` mirroring the Swift services 1:1.
7. ✅ Cursor pagination for search (`cursor` in, `nextCursor` out, `hasMore = nextCursor != null`).
8. ✅ "My Events" = search with `hostId = currentUser.id`.
9. ✅ Paid flow: `join` → `paypal/create-order` → approval → `paypal/capture` → auto-issue ticket
   (best-effort, non-fatal on ticket failure).
10. ✅ Push-token registration with `platform: "android"` post-login.
11. ⚠️ Verify notification `type` raw strings and event `payment_type` values on the real backend
    before production (both flagged as unconfirmed in the iOS audit).