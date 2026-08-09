import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise_flutter.dart';

class RecaptchaException implements Exception {
  RecaptchaException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RecaptchaService {
  RecaptchaClient? _client;
  bool _initialized = false;
  Future<void>? _initialization;

  static bool get hasConfiguredSiteKey {
    return AuthConfig.hasRecaptchaSiteKey;
  }

  bool get isSupportedPlatform => Platform.isAndroid;

  Future<void> initialize() {
    if (_initialized || !isSupportedPlatform || !hasConfiguredSiteKey) {
      return Future.value();
    }

    return _initialization ??= _initializeClient();
  }

  Future<void> _initializeClient() async {
    Object? lastError;
    for (final siteKey in AuthConfig.recaptchaSiteKeys) {
      try {
        _client = await Recaptcha.fetchClient(siteKey);
        _initialized = true;
        debugPrint('reCAPTCHA client initialized with site key: $siteKey');
        return;
      } on PlatformException catch (error) {
        lastError = error;
        if (_isSiteKeyConfigurationError(error)) {
          // The key itself cannot be used for this app (invalid key, wrong
          // key type, or package/certificate mismatch) – try the next one.
          debugPrint(
            'reCAPTCHA site key $siteKey rejected: '
            'code=${error.code}, message=${error.message}',
          );
          continue;
        }
        _initialization = null;
        rethrow;
      } catch (error) {
        _initialization = null;
        rethrow;
      }
    }

    _initialization = null;
    throw RecaptchaException(
      lastError == null
          ? AuthConfig.recaptchaNotConfigured
          : _buildConfigurationError(lastError),
    );
  }

  Future<String> executeLogin({double timeout = 10000}) async {
    if (!isSupportedPlatform) {
      throw RecaptchaException(AuthConfig.recaptchaUnsupportedPlatformError);
    }

    if (!hasConfiguredSiteKey) {
      throw RecaptchaException(AuthConfig.recaptchaNotConfigured);
    }

    await initialize();

    final client = _client;
    if (client == null) {
      throw RecaptchaException(AuthConfig.recaptchaNotConfigured);
    }

    try {
      return await client.execute(
        RecaptchaAction.LOGIN(),
        timeout: timeout,
      );
    } catch (error) {
      debugPrint('reCAPTCHA login execution failed: $error');
      throw RecaptchaException(AuthConfig.recaptchaFailedError);
    }
  }

  Future<String?> tryExecuteLogin({double timeout = 10000}) async {
    try {
      return await executeLogin(timeout: timeout);
    } catch (_) {
      return null;
    }
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

  String _buildConfigurationError(Object? lastError) {
    if (lastError is! PlatformException) {
      return AuthConfig.recaptchaInvalidSiteKey;
    }
    final message = lastError.message;
    return message == null || message.isEmpty
        ? '${AuthConfig.recaptchaInvalidSiteKey}\n'
            'Native error code: ${lastError.code}'
        : '${AuthConfig.recaptchaInvalidSiteKey}\n'
            'Native error code: ${lastError.code} ($message)';
  }
}
