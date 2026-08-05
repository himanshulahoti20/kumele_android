# Kumele Android Remediation Handoff

## Package and Firebase identity

- The retained Android identity is `com.kumele.app`.
- `android/app/google-services.json` matches Firebase project `kumele-2026` and package `com.kumele.app`.
- Do not rename this package. The obsolete Google Play draft is `com.redmacbeth.kumele`.

## Completed repairs

1. Regenerated the API catalog from the captured live OpenAPI contract: 231 operations.
   The catalog test no longer relies on a stale hard-coded count. Regenerate with:
   `node tools/generate_api_catalog.mjs config/openapi.snapshot.2026-07-21.json lib/shared/services/api_service/generated/generated_api_catalog.dart`.
2. Removed the legacy Render endpoint. API and socket origins must now be supplied at build time with `KUMELE_API_ORIGIN` and `KUMELE_SOCKET_ORIGIN`; both must be HTTPS origins. Socket.io is WebSocket-only.
3. Disabled Android cleartext traffic and made startup reject a missing or non-HTTPS API configuration.
4. Moved access tokens, refresh tokens, and auth sessions from Hive to Android Keystore-backed `flutter_secure_storage`, with one-time migration of existing Hive values.
5. Made network debug logging opt-in only. The debug interceptor redacts authorization, cookie, token, password, and secret values.
6. Removed duplicate Kotlin DSL Gradle files and retained the active Groovy Gradle build configuration.
7. Added release-signing protection: debug builds work without credentials; release tasks fail before artifact creation until `android/key.properties` and the upload keystore are supplied.

## Verified quality gates

- Toolchain: Flutter `3.44.7` stable and Dart `3.12.2` are the verified
  baseline. Android SDK platforms through API 37 are installed; the Android
  build baseline is AGP `8.11.1` with Gradle `8.14`.
- `flutter pub get`: passed after resolving the secure-storage dependency compatibility issue.
- `flutter test`: passed (2 tests), both without runtime API configuration and with HTTPS/WSS deployment defines.
- `flutter analyze`: no errors; inherited codebase lint backlog remains informational only.
- `flutter build apk --debug`: passed under Flutter `3.44.7`, Gradle `8.14`,
  and AGP `8.11.1`. SHA-256:
  `fce9a4ecf1ea1aac7d539d48fa19f8bae48df7c7def3a09c98c1897f337d672f`.
- `./gradlew :app:assembleRelease --no-daemon`: correctly failed with the explicit missing-signing-key message.

## Framework and live-device update (2026-07-21)

- The handoff now pins Flutter `3.44.7` in `.fvm/` and removes the stale
  machine-specific `.fvm/flutter_sdk` symlink. Run `fvm use 3.44.7` (or point
  FVM at the same version) to recreate a local SDK link for a developer's own
  machine.
- `android/local.properties` was deliberately removed because it contained a
  stale local toolchain path. Copy `android/local.properties.example` and set
  paths for the developer's own Android SDK and Flutter SDK; never commit that
  local file.
- A Flutter `3.44.7`/Dart `3.12.2` test run passed (`2` tests) and a debug APK
  rebuilt successfully with AGP `8.11.1`, Kotlin `2.2.20`, Java `17`, and
  Gradle `8.14`.
- An AGP `9.3`/Gradle `9.5` trial was intentionally not promoted. Flutter's
  AGP 9 migration requires its new DSL, while the current `app_settings`
  plugin still registers the legacy Kotlin Android plugin. Retain the tested
  AGP 8.11.1/Gradle 8.14 pair until that dependency is upgraded and the full
  migration passes in CI.
- The debug APK was installed and launched on a dedicated API 35 Android
  emulator with HTTPS-only test configuration. It reached the existing Kumele
  sign-in screen and remained running. The custom UI was not changed. Runtime
  evidence is retained on the SSD at:

  ```text
  /Volumes/Redmacbeth 2TB SSD/Projects/New Projects/Codex Agent Projects/Kumele-Flutter-Framework-QC-2026-07-21/android-kumele-runtime-final.png
  ```

  The successful test used `https://kumele.com` only as a TLS configuration
  check. It is not an assertion that `https://api.kumele.com` is live; the
  production API and Socket.IO origins must still be supplied by deployment.

## Required before a Play release

1. Set the real TLS API origin and matching TLS Socket.io origin in CI. Do not use the previously audited bare-IP HTTP endpoint.
2. Create `android/key.properties` from `android/key.properties.example`, pointing to the protected release upload keystore. Never commit either credential.
3. Host `https://kumele.com/.well-known/assetlinks.json` for the `com.kumele.app` release certificate SHA-256 before enabling passkeys.
4. In Firebase/Google Cloud, add the release signing SHA-1/SHA-256 to the `com.kumele.app` Android app if Google Sign-In is enabled, then download a refreshed `google-services.json`.
5. The Google Play Console shows `com.kumele.app` as the correct retained draft. Delete the separate obsolete `com.redmacbeth.kumele` only through its own Play Console deletion flow.

## Handoff commands

```bash
flutter pub get
flutter test \
  --dart-define=KUMELE_API_ORIGIN=https://api.kumele.com \
  --dart-define=KUMELE_SOCKET_ORIGIN=https://api.kumele.com \
  --dart-define=KUMELE_PASSKEY_RP_ID=kumele.com

flutter build appbundle --release \
  --dart-define=KUMELE_API_ORIGIN=https://api.kumele.com \
  --dart-define=KUMELE_SOCKET_ORIGIN=https://api.kumele.com \
  --dart-define=KUMELE_PASSKEY_RP_ID=kumele.com
```
