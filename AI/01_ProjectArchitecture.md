# Kumele — Project Architecture

Documentation only. No code changes were made while producing this file.

## 1. Overview

Kumele is a SwiftUI multi-platform app (iPhone, iPad, Apple Watch, Apple TV) for discovering and hosting local "hobby" events, backed by a REST API at `https://testdomain.goodwish.com.np`. It is a single Xcode project (`Kumele.xcodeproj`, Xcode 26.4.1 / Swift 5.0) with 5 targets:

| Target | Bundle ID | Deployment target | Notes |
|---|---|---|---|
| `Kumele` (iPhone/iPad) | `com.kumele.hobbies` | iOS 18.2 | Main app |
| `Kumele Watch App` | `com.kumele.hobbies.watchkitapp` | watchOS 9.6 | Embedded companion |
| `Kumele TV` | `com.kumele.tv.Kumele-TV` | tvOS 18.5 | Separate app |
| `KumeleTests` | `com.Redmacbeth.KumeleTests` | — | Unit tests (currently empty scaffolding) |
| `KumeleUITests` | `com.Redmacbeth.KumeleUITests` | — | UI tests (currently empty scaffolding) |

**Read this alongside the root [`HANDOFF.md`](../HANDOFF.md) and [`APPLE_ACCOUNT_AND_BUILD_HANDOFF.md`](../APPLE_ACCOUNT_AND_BUILD_HANDOFF.md).** Two facts from those files govern all work in this repo:

- **API integration was explicitly incomplete when this doc was first written** — most services returned hardcoded local JSON instead of calling the network. **Since resolved**: see [05_ImplementedAPIs.md](05_ImplementedAPIs.md) for current per-endpoint status and [08_APICompleteReference.md](08_APICompleteReference.md) for why/how the rework happened.
- **The mobile (iPhone/iPad) UI/UX is the canonical, accepted design and must not be redesigned.** A separate "Sinan" source tree exists as a *selective* donor for networking/models/services/auth/localization only — never for mobile SwiftUI views, fonts, colors, or layout. When porting anything from Sinan, diff it in and validate against the current backend contract; never bulk-merge folders.

### Target membership (important, non-obvious)

The project uses Xcode 16 **file-system-synchronized groups**, not classic `PBXFileReference` lists — `Sources` build phases are empty; membership is determined by per-target *exception sets* in `project.pbxproj`.

- **`Kumele TV` shares real files with the main `Kumele` target** (multi-target membership, not copy/paste): `Networking/*`, `Services/*`, most `ViewModels/*`, `Core/APIConstants.swift`, `Models/AppState.swift, EventModel.swift, BlogModel.swift, User.swift, Chat.swift, ChatMessage.swift`, and many `Views/Common/*` / `Views/Components/*` files, plus fonts and Lottie assets. When you touch one of these shared files, you are changing behavior on **both** iOS and tvOS — check both call sites.
- **`Kumele Watch App` is fully isolated.** It has its own `Models/` and `Views/` only (no `Networking`/`Services`/`ViewModels` folders at all) and shares zero files with the main target. There is **no `WatchConnectivity`/`WCSession` usage anywhere in the repo** — the Watch app cannot currently talk to the phone app or the backend.

## 2. Dependencies (Swift Package Manager)

Resolved in `Kumele.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`:

- `SDWebImageSwiftUI` — async image loading/caching
- `lottie-spm` (Airbnb Lottie) — animations, see `Kumele/Views/Components/LottieView.swift`
- `Alamofire` — HTTP client, but see §4: it backs an unused secondary networking stack
- `swiftui-introspect`
- `IQKeyboardManager`

There is no dependency-injection framework, no local database (no Core Data / SwiftData / Realm), and no Keychain wrapper package.

## 3. App entry point & root navigation

- **Entry**: `Kumele/KumeleApp.swift` — `@main struct KumeleApp: App` creates `@StateObject var appState = AppState()` and injects it via `.environmentObject` into `RootView()`.
- **Root state machine**: `Kumele/Views/RootView.swift` switches on `appState.currentScreen`, an enum defined in `Kumele/Models/AppState.swift`:
  ```swift
  enum AppScreen { case intro, splash, login, content }
  ```
  This is a manual state machine, **not** a top-level `NavigationStack`. Screens are flipped by feature code calling `appState.currentScreen = .x` directly (e.g. `IntroView` → `.splash` on dismiss; `SplashScreenView` → `.content` if `@AppStorage("user")` decodes a `User`, else `.login` after a 1s delay; `LoginView`/passkey flows → `.content` on success; sign-out/delete-account popups → `.intro`).
- **iPhone vs iPad selection** is a **device-idiom check**, not a size-class check, repeated identically in every `Views/Common/**/XView.swift` router:
  ```swift
  if UIDevice.current.userInterfaceIdiom == .phone { XView_iPhone() } else { XView_iPad() }
  ```
  There is no adaptive/size-class branching — iPad Split View, Stage Manager, etc. always get the iPad tree.

### The `_iPhone` / `_iPad` split convention

For nearly every feature, there is a thin `Views/Common/<Feature>/XView.swift` router with no UI of its own, delegating to `Views/iPhone/<Feature>/XView_iPhone.swift` and `Views/iPad/<Feature>/XView_iPad.swift`. These are **independent view implementations**, not a shared body with tweaks — but they consume the same ViewModel/service layer. Examples: `HomeView`→`HomeView_iPhone`/`HomeView_iPad`, `BlogView`, `ProfileView`, `ChatView`, `ShopView`, `NotificationView`, `PaymentView`, `CreateEventView`, `HistoryStatisticsView`, `FilterHobbyView`, `SplashScreenView`, `IntroView`.

**When adding a new screen or API-driven feature, follow this convention**: put shared logic in a ViewModel, put a thin idiom router in `Views/Common`, and implement/extend the `_iPhone` and `_iPad` views separately.

## 4. State management

Two environment-injected app-wide objects, created once at the root in `RootView`/`KumeleApp` and passed down via `.environmentObject`:

- **`AppState`** (`Kumele/Models/AppState.swift`) — one `@Published var currentScreen: AppScreen`. Drives top-level navigation only.
- **`TabViewModel`** (`Kumele/ViewModels/TabViewModel.swift`) — a large `ObservableObject` holding dozens of `@Published` booleans/optionals that drive almost all sheet/fullScreenCover/popup presentation state app-wide (tab selection, chat menu, profile popups, create-event popups, shop/NFT state, etc.). This is the dominant "navigation" mechanism for secondary screens — most modals/overlays are `TabViewModel` flags combined with `.sheet`/`.fullScreenCover`/manual `ZStack` overlays, not `NavigationLink`/path-based routing.

Everything else is **local, per-screen state**: each feature view creates and owns its own `@StateObject` ViewModel(s) (e.g. `HomeView_iPhone` owns its own `EventViewModel`; `ContentView_iPhone`/`_iPad` own a `CreateEventViewModel` passed down via `.environmentObject`). There is no central DI container wiring ViewModels together.

Custom SwiftUI `Environment` keys/modifiers are used for a few cross-cutting overlay systems: dropdown menus, reply-comment composer, date picker, time picker (see `Views/Components/{DropDown,ReplyComment,DatePicker,TimePicker}`).

**Known gap**: there is no single source of truth for the logged-in user. `AuthViewModel`, `InterestSelectionViewModel`, and `TabViewModel` each independently read/decode `UserDefaults["user"]` via their own `@AppStorage("user")`. If you add a feature that needs the current user, follow the existing pattern (read `@AppStorage("user")` and decode `User` yourself) rather than inventing a new session manager — that would be an architecture change out of scope for API integration work.

## 5. Networking, services, auth, error handling

**⚠️ Updated 2026-07-24 (re-audit) — this section describes an old, superseded stack.** Full current detail in [05_ImplementedAPIs.md](05_ImplementedAPIs.md) §0. Summary of the *current* state:

- **Real networking layer (current)**: `Kumele/Networking/{APIClient, APIEndpoint}.swift`. `APIClient` is an `actor` singleton (`.shared`) wrapping `URLSession`, with Keychain-backed token storage (`KeychainTokenStore`), automatic 401 → `/auth/refresh` → retry-once, and `Bearer` auth headers. `APIEndpoint<Response>` + `client.send(_:)` is the standard call shape; `APIEnvelope<T>` decodes the real `{ok/success, data, meta}` list-endpoint shape.
- **Old networking layer (dead, do not use)**: `Kumele/Networking/{NetworkManager, NetworkManagerProtocol}.swift` (`APIResponse<T>`-based, `Token` auth header) — **zero call sites anywhere in the app**, fully superseded by `APIClient`. `Kumele/Services/NetworkService.swift` (Alamofire-based) is likewise dead — do not assume `Alamofire` is the real HTTP client.
- **Services layer**: `Kumele/Services/{Auth,Blog,Event,Chat,Notifications}/*.swift` plus a large `Kumele/Services/API/*.swift` group (`ProfileService`, `AdService`, `CommerceService`, `TicketPaymentService`, `SupportContentService`, `UserEventExtendedService`, etc.) — each a concrete class, most constructor-injected into ViewModels with a default argument (e.g. `AuthViewModel(authService: AuthServiceProtocol = AuthService())`). This is a much larger surface than the original 3-service (Auth/Blog/Event) layout — see 05_ImplementedAPIs.md for the full current inventory, including which of these `API/*.swift` services are actually wired to a ViewModel vs. dead code with correct-but-unreached endpoints.
- **Auth/session**: access + refresh JWT pair stored in the **Keychain** via `KeychainTokenStore` (no more plaintext `UserDefaults` token). `UserDefaults["user"]` is still used as a cache of the decoded `User` profile object for fast app-launch reads, not as the auth credential. Auth headers are attached automatically by `APIClient` (`Authorization: Bearer <access_token>`), not per-call.
- **Error model**: `APIError` (see `Kumele/Networking/`), including structured cases like `.twoFactorRequired(tempToken)` and `.ticketServiceUnavailable`, surfaced to views via `@Published var errorMessage: String?` on ViewModels.

## 6. Models

Plain `Codable` structs (mostly generated via quicktype from sample JSON, then hand-augmented with a convenience initializer for previews — see the header comment in `EventModel.swift`). Consistent `CodingKeys` map API `snake_case` to Swift `camelCase`. Fields are almost universally `Optional` for defensive decoding. There is no separate DTO-vs-domain-model layer — the same `Codable` struct flows from network response straight to the UI. A generic `PaginatedResponse<T: Decodable>` wrapper exists (`Models/PaginatedResponse.swift`) but is currently unused in any live code path (only referenced from commented-out service code) — pagination is designed but not implemented.

## 7. Watch app

Fully isolated target (own `Models/`, `Views/`, one `Helper/`), no networking, no `WatchConnectivity`. Every screen (events, chat, notifications, login, settings) renders hardcoded sample arrays. Login is a fake 2-second timer, not a real auth check. Treat any Watch API-integration task as **starting from zero** — there is no existing partial implementation to extend, and you will likely need to decide (with the user) whether the Watch app talks to the backend directly or relays through `WCSession` to the phone app, since neither exists today.

## 8. TV app

Shares the real `Networking`/`Services`/most `ViewModels`/`Models` files with the main iOS target (see §1). Its Home (event list/matched/owned), Blog (list/detail), and login/skip-login flows call the same live services as iOS. However several visible sections are still hardcoded sample content layered on top of that real plumbing: the ad carousel, the notification feed, the history/earnings charts, ad/birthday popup content, and the "Sign In with QR" flow (a static QR image with no real device-pairing logic). Treat TV API work as "finish wiring the remaining mock sections to the already-shared services," not as a from-scratch integration.

## 9. Tab bar / feature map

`Kumele/Views/Tabbar/AppTab.swift` defines one `AppTab` enum with per-platform tab lists:

- **iPhone**: `[.home, .blog, .more, .shop, .profile]` (bottom bar; "more" opens a quick-action sheet)
- **iPad**: `[.home, .blog, .shop, .chat, .chart, .palette, .binoculars, .trolly]` (left sidebar; profile reached via header avatar)
- **tvOS**: `[.home, .blog, .chart]`

Feature-area → API-wiring status (**⚠️ updated 2026-07-24, re-audit — see [05_ImplementedAPIs.md](05_ImplementedAPIs.md) for full per-endpoint detail; the table below is now correct, the old version describing "mocked"/"static" everywhere is not**):

| Feature | ViewModel/Service exists? | Status |
|---|---|---|
| Auth (login/signup/2FA/passkey/hobbies) | `AuthViewModel` + `AuthService`/`PasskeyService`/`FirebaseGoogleSignInService` | Live and correct, except `resetPassword` skips a required OTP-exchange step — see doc 05 §1 |
| Home / event discovery | `EventViewModel` + `EventServices` | Live and correct, except `getEventOwned()` always throws — see doc 05 §4 |
| Blog | `BlogViewModel` + `BlogServices` | Fully live and correct, including real comments |
| CreateEvent | `CreateEventViewModel` | Live — hobby fetch and event submission both call the real backend |
| Chat | `ChatViewModel` + `ChatSocketService` (Socket.IO) + `ChatService`/`ChatRoomService` (REST) | Live — real-time socket and REST history both wired; verify the socket path (doc 05 §5) |
| Notifications | `NotificationViewModel` + `NotificationService` (+ `AdService` for interleaved ads) | Live |
| Payments | `PaymentService`, `TicketService` | Live for PayPal + generic event payment + refunds; Stripe card flow and ticket purchase/validation UI not wired — see doc 05 §9 |
| Profile | `ProfileViewModel`/`ProfileFollowViewModel` + `ProfileService` | Live (profile, avatar, follow/followers, privacy/GDPR export & delete) |
| Shop | `ShopViewModel` + `SubscriptionService` (live), `ProductCartService`/`NFTService` (dead code — correct endpoints, no caller) | Partially live — subscriptions only |
| Rewards | `RewardRingsViewModel` + `RewardService` | Live |
| Ads | `AdService` | Live, feeds Notifications + Home |
| Support tickets | `SupportService` exists | Dead code — no UI wired |
| HistoryStatistics / user stats | none | No client code at all; backend has `/users/me/stats*` |
| Discounts, Event Plans, Newsletter, Beta codes | none | No client code at all |

If you're asked to integrate one of the still-missing areas, follow the pattern of the `API/*.swift` services (constructor-injected `APIClient`, one method per endpoint) — see doc 05 for the current inventory of what's live vs. dead vs. missing before assuming you need to start from scratch.
