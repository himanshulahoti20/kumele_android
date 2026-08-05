import 'dart:io' show Platform;

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
    final siteKey = AuthConfig.recaptchaSiteKey;
    return siteKey.isNotEmpty && !siteKey.startsWith('REPLACE_WITH_');
  }

  bool get isSupportedPlatform => Platform.isAndroid;

  Future<void> initialize() {
    if (_initialized || !isSupportedPlatform || !hasConfiguredSiteKey) {
      return Future.value();
    }

    return _initialization ??= _initializeClient();
  }

  Future<void> _initializeClient() async {
    try {
      _client = await Recaptcha.fetchClient(AuthConfig.recaptchaSiteKey);
      _initialized = true;
    } catch (error) {
      _initialization = null;
      rethrow;
    }
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
}
