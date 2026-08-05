# Kumele Android — Project Handover Document

**Project:** Kumele Mobile Application  
**Platform:** Flutter (Android & iOS)  
**Prepared By:** Development Team  
**Date:** July 2026

---

## Overview

Kumele is a social events platform built with Flutter. The app allows users to discover events, match with other attendees, chat in real time, read community blogs, manage their profiles, and handle payments and subscriptions. The app supports both light and dark themes and is designed to run on Android, iOS, and Web.

---

## SDK & Environment

- **Language:** Dart
- **Framework:** Flutter SDK `>=3.5.0 <4.0.0`
- **Flutter Version Manager:** FVM (Flutter Version Management)
- All Flutter commands in this project must be prefixed with `fvm` — for example `fvm flutter run` or `fvm flutter pub get`
- **Font:** Plus Jakarta Sans (bundled in assets)

---

## Project Structure

The project follows **Feature-First Clean Architecture**. Each feature is self-contained with its own business logic, data layer, and UI.

| Folder | Purpose |
|---|---|
| `lib/features/` | All app features (Auth, Chat, Blog, Explore, Profile, etc.) |
| `lib/core/` | App-wide setup — dependency injection, theme, responsive config |
| `lib/shared/` | Reusable services, UI components, models, and utilities |
| `lib/navigation/` | App routing configuration |
| `lib/app/` | Root app widget and global state initialization |
| `lib/gen/` | Auto-generated asset references — **never edit manually** |

---

## State Management

The app uses **flutter_bloc** as its state management solution.

- Complex business logic is handled by **BLoCs**
- Simpler UI state is handled by **Cubits**
- All states are immutable and modeled using **Freezed**
- Events follow the naming pattern: `[Feature][Action]` (e.g. `SignupEmailChanged`)

---

## Dependency Injection

All services, repositories, and BLoCs are registered in `service_locator.dart` using **get_it** as a service locator. Nothing is instantiated manually in the UI layer.

---

## Navigation

The app uses **go_router** for all navigation. Screens are navigated to by named routes. Direct use of `Navigator.push` is not permitted in this codebase.

---

## Integrated Services & APIs

### REST API
- Built on **Dio** HTTP client
- All requests go through a central `ApiService` class
- Supports automatic Bearer token injection and automatic token refresh on expiry
- Base URL is currently hardcoded — should be moved to environment configuration before production

### Real-Time Chat
- Real-time messaging is powered by **Socket.io**
- The chat socket connects on a dedicated namespace and handles room join/leave, message sending, and message moderation events

### Firebase — Push Notifications
- Firebase Cloud Messaging (FCM) is integrated for both foreground and background push notifications
- A background message handler is registered at app startup

### Google Sign-In
- Google OAuth is available as an alternative sign-in method
- Managed through a dedicated `GoogleAuthService`

### Passkeys (WebAuthn)
- The app supports passwordless login via Passkeys
- Managed through `PasskeyService` using the `passkeys` package

### reCAPTCHA Enterprise
- Registration flows are protected using Google reCAPTCHA Enterprise
- The service is initialized at app startup before the UI loads

### Maps & Location
- Interactive maps are powered by **flutter_map** (OpenStreetMap)
- Device geolocation is handled via the **geolocator** package

### Local Storage
- Persistent local data (auth tokens, user preferences) is stored using **Hive**

---

## UI Standards

| Rule | Standard |
|---|---|
| Sizing | Always use `flutter_screenutil` — `.w`, `.h`, `.sp`, `.r` — with integer values only |
| Colors | All colors must come from the `ColorSet` class. No raw hex values or `Colors.*` |
| Typography | All text styles come from `context.textTheme`. Font is Plus Jakarta Sans |
| Assets | All assets are rendered through `KumeleAssetWidget` with generated `Assets.*` paths |
| Dialogs | Use `AppDialog` and `AppBottomSheet` wrappers — never `showDialog` directly |
| Snackbars | Use `SnackBarService` — never `ScaffoldMessenger` directly |

---

## Key Features Implemented

- Email & Password Authentication
- Passkey (Biometric / WebAuthn) Login
- Google OAuth Sign-In
- Email OTP Verification
- Forgot / Reset Password
- Event Discovery with Swipe Cards
- Event Creation with Map Location Picker
- Real-Time Event Chat
- QR Code Scanning for Guest Entry
- Community Blog (list, detail, categories)
- User Profile with Edit, Photo Upload
- Followers & Connections
- Interested Hobbies & Medals
- 2-Factor Authentication (setup & disable)
- Change Password & Delete Account
- Push Notifications
- Light & Dark Theme Support
- In-App Debug Tools (API log viewer, network monitor)

---

## Immediate Action Items for the Next Developer

1. **Environment Configuration** — The API base URL is currently hardcoded. It should be extracted into a proper environment config before any production release.
2. **Code Generation** — After any model or asset change, run the build runner to regenerate code.
3. **Linting** — Run `fvm flutter analyze` after every change. The project expects zero lint warnings.
4. **Testing** — The `test/` directory exists but coverage is minimal. BLoC unit tests should be expanded.
5. **Review `rules.md`** — The project root contains a `rules.md` file with mandatory coding standards. All contributors must read and follow it strictly.

---

*This document is intended to give the next developer a clear understanding of the project before touching any code.*
