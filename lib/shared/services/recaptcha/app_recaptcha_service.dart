import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise_flutter.dart';

class AppRecaptchaException implements Exception {
  AppRecaptchaException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AppRecaptchaService {
  RecaptchaClient? _client;
  bool _initialized = false;
  Future<void>? _initialization;

  bool get isSupportedPlatform => Platform.isAndroid;

  Future<void> initialize() {
    if (_initialized || !isSupportedPlatform || !AuthConfig.hasRecaptchaSiteKey) {
      return Future.value();
    }
    return _initialization ??= _initializeClient();
  }

  Future<void> _initializeClient() async {
    PlatformException? lastError;
    for (final siteKey in AuthConfig.recaptchaSiteKeys) {
      try {
        _client = await Recaptcha.fetchClient(siteKey);
        _initialized = true;
        return;
      } on PlatformException catch (error) {
        lastError = error;
        _initialization = null;
        if (_isSiteKeyConfigurationError(error)) {
          // The key itself cannot be used for this app (invalid key, wrong
          // key type, or package/certificate mismatch) – try the next one.
          debugPrint(
            'reCAPTCHA site key $siteKey rejected: '
            'code=${error.code}, message=${error.message}',
          );
          continue;
        }
        debugPrint('reCAPTCHA initialization failed: $error');
        return;
      } catch (error) {
        _initialization = null;
        debugPrint('reCAPTCHA initialization failed: $error');
        return;
      }
    }

    debugPrint(
      lastError == null
          ? AuthConfig.recaptchaNotConfigured
          : '${AuthConfig.recaptchaInvalidSiteKey}\n'
              'Native error code: ${lastError.code} '
              '(${lastError.message ?? 'unknown'})',
    );
  }

  /// reCAPTCHA Enterprise reports these codes when a site key cannot be used
  /// with the current app:
  ///   2 = INVALID_SITE_KEY
  ///   3 = INVALID_KEY_TYPE (e.g. a checkbox key instead of a score key)
  ///   4 = INVALID_PACKAGE_NAME (package / signing certificate mismatch)
  bool _isSiteKeyConfigurationError(PlatformException error) {
    switch (error.code) {
      case '2':
      case '3':
      case '4':
        return true;
      default:
        return error.message?.toLowerCase().contains('site key invalid') ??
            false;
    }
  }

  Future<String> execute(RecaptchaAction action,
      {double timeout = 10000}) async {
    if (!isSupportedPlatform) {
      throw AppRecaptchaException('reCAPTCHA is only supported on Android.');
    }

    if (!AuthConfig.hasRecaptchaSiteKey) {
      throw AppRecaptchaException(AuthConfig.recaptchaNotConfigured);
    }

    try {
      await initialize();
    } catch (error) {
      throw AppRecaptchaException('reCAPTCHA initialization failed: $error');
    }

    final client = _client;
    if (client == null) {
      throw AppRecaptchaException(
          'reCAPTCHA client is null after initialization.');
    }

    try {
      return await client.execute(
        action,
        timeout: timeout,
      );
    } catch (error) {
      throw AppRecaptchaException('reCAPTCHA execution failed: $error');
    }
  }

  Future<String?> tryExecute(RecaptchaAction action,
      {double timeout = 10000}) async {
    try {
      return await execute(action, timeout: timeout);
    } catch (_) {
      return null;
    }
  }
}
