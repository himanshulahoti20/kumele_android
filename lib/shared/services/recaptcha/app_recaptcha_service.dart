import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
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

  static const String recaptchaAndroidSiteKey =
      '6LdikUstAAAAAEQ3SzEsfjhGbztZjwLaZHuEisu7';

  bool get isSupportedPlatform => Platform.isAndroid;

  Future<void> initialize() {
    if (_initialized || !isSupportedPlatform) {
      return Future.value();
    }
    return _initialization ??= _initializeClient();
  }

  Future<void> _initializeClient() async {
    try {
      _client = await Recaptcha.fetchClient(recaptchaAndroidSiteKey);
      _initialized = true;
    } catch (error) {
      _initialization = null;
      debugPrint('reCAPTCHA initialization failed: $error');
    }
  }

  Future<String> execute(RecaptchaAction action,
      {double timeout = 10000}) async {
    if (!isSupportedPlatform) {
      throw AppRecaptchaException('reCAPTCHA is only supported on Android.');
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
