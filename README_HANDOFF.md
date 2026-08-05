# Kumele Android Remediation Handoff

## Toolchain

Use Flutter `3.44.7` stable with Dart `3.12.2` or a later compatible stable
release. This handoff was verified with that toolchain, Android Gradle Plugin
`8.11.1`, and Gradle `8.14`. Do not make an untested AGP 9 migration as part
of normal feature work.

## Required launch configuration

The app intentionally has no cleartext server-IP fallback. Supply a TLS-enabled API origin for all local, CI, and release builds:

```bash
flutter run \
  --dart-define=KUMELE_API_ORIGIN=https://api.your-production-domain.example \
  --dart-define=KUMELE_SOCKET_ORIGIN=https://api.your-production-domain.example \
  --dart-define=KUMELE_PASSKEY_RP_ID=kumele.com
```

The reverse proxy must support HTTPS and Socket.IO WebSocket upgrade. The final passkey RP ID must be a verified domain, and that domain must serve `/.well-known/assetlinks.json` for Android package `com.kumele.app` with the release signing certificate fingerprint.

## API catalog refresh

The generated catalog is based on an OpenAPI snapshot. Refresh it deliberately after backend approval:

```bash
curl -fsS https://api.your-production-domain.example/docs-json -o config/openapi.json
node tools/generate_api_catalog.mjs config/openapi.json \
  lib/shared/services/api_service/generated/generated_api_catalog.dart
flutter test
```

## Secrets and signing

- `android/key.properties` and the upload keystore are required for release builds and must never be committed.
- `android/app/google-services.json` currently corresponds to `com.kumele.app`. Re-download it from Firebase only if the registered Firebase app changes.
- Access tokens, refresh tokens and serialized auth sessions are stored using Android Keystore-backed `flutter_secure_storage`; legacy Hive values migrate once on read.
- Network debug logs are off by default. They can be enabled only for a debug build with `KUMELE_ENABLE_NETWORK_DEBUG_LOGS=true`; sensitive headers and fields are redacted.
