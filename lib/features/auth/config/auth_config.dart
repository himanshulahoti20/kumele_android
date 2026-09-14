import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/gen/assets.gen.dart';

class AuthConfig {
  AuthConfig._();

  /// Outline every tappable control on the sign in / sign up screens
  /// carries, per design. Only these screens use it — elsewhere the
  /// components keep their own defaults.
  static const Color tappableBorderColor = Color(0xFF9999AE);
  static const double tappableBorderWidth = 2.48;

  static const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const double phoneHeaderHeightFactor = 0.27;
  static const double tabletHeaderHeightFactor = 0.2;

  /// Primary reCAPTCHA Enterprise site key (Android).
  ///
  /// NOTE: both legacy keys in this file are valid reCAPTCHA Enterprise keys,
  /// but they are registered for the Web platform only. The Android SDK
  /// therefore rejects them with `PlatformException(2, Site key invalid)`.
  /// Create a reCAPTCHA Enterprise key of type "Android app" for package
  /// `com.kumele.hobbies` (see `recaptchaInvalidSiteKey` below) and either
  /// replace `recaptchaAndroidSiteKey` with it or, faster, pass it at build
  /// time via `--dart-define=RECAPTCHA_ANDROID_SITE_KEY=<key>` – no code edit
  /// required (see `recaptchaAndroidSiteKeyOverride`).
  static const String recaptchaAndroidSiteKey =
      '6LfxT0otAAAAAHf1numKx9h9LuBcu40VrN5G5lbz';
  static const String recaptchaLegacyAndroidSiteKey =
      '6LdikUstAAAAAEQ3SzEsfjhGbztZjwLaZHuEisu7';

  /// Build-time override for the Android reCAPTCHA Enterprise site key.
  ///
  /// Lets you drop in a freshly created "Android app" key without editing this
  /// file:
  ///   flutter run --dart-define=RECAPTCHA_ANDROID_SITE_KEY=6Lxxx...
  static const String recaptchaAndroidSiteKeyOverride =
      String.fromEnvironment('RECAPTCHA_ANDROID_SITE_KEY');
  static const String recaptchaInvalidSiteKey =
      'reCAPTCHA verification is unavailable: none of the configured Android '
      'site keys is registered for this app. The current keys are valid '
      'reCAPTCHA Enterprise keys, but only for the Web platform – the Android '
      'SDK rejects them with "Site key invalid". Create a reCAPTCHA Enterprise '
      'key of type "Android app" in the Google Cloud Console for package '
      'com.kumele.hobbies, register the app signing certificate SHA-1 '
      'fingerprint (debug AND release), then either update '
      'AuthConfig.recaptchaAndroidSiteKey or run with '
      '--dart-define=RECAPTCHA_ANDROID_SITE_KEY=<key>.';
  static const String recaptchaNotConfigured =
      'reCAPTCHA is not configured. Set AuthConfig.recaptchaAndroidSiteKey in auth_config.dart.';
  static const String recaptchaFailedError =
      'reCAPTCHA verification failed. Please try again.';
  static const String recaptchaUnsupportedPlatformError =
      'reCAPTCHA is only supported on Android.';
  static const String googleSignInCanceled = 'Google sign-in was canceled';

  /// Web OAuth client ID (client_type: 3) from Firebase / Google Cloud.
  /// Firebase Console → Authentication → Sign-in method → Google → Web client ID
  /// Or Project Settings → Your apps → Web app → Client ID
  static const String googleServerClientId =
      '540234199221-ve5ppuvkr6328a8cl1hv6d08m6go8km2.apps.googleusercontent.com';
  static const String googleSignInNotConfigured =
      'Google Sign-In is not configured. Set AuthConfig.googleServerClientId or re-download google-services.json from Firebase with a Web OAuth client.';

  static String _iconPath(AssetGenImage light, AssetGenImage dark) {
    return ColorSet.isDarkMode ? dark.path : light.path;
  }

  static String get phoneBackgroundImage => Assets.images.signInBg.path;

  static String get tabletBackgroundImage => Assets.images.authbg.path;

  static String get logoImage => Assets.images.logo.path;

  static String get googleIcon =>
      _iconPath(Assets.icons.googleicon, Assets.icons.googleiconDark);

  static String get emailIcon =>
      _iconPath(Assets.icons.email, Assets.icons.emailDark);

  static String get lockIcon =>
      _iconPath(Assets.icons.lock, Assets.icons.lockDark);

  static String get eyeIcon =>
      _iconPath(Assets.icons.eye, Assets.icons.eyeDark);

  static String get captchaIcon => Assets.icons.captcha.path;

  static String get recaptchaSiteKey {
    if (!Platform.isAndroid) return '';
    return recaptchaAndroidSiteKeyOverride.isNotEmpty
        ? recaptchaAndroidSiteKeyOverride
        : recaptchaAndroidSiteKey;
  }

  static List<String> get recaptchaSiteKeys {
    if (!Platform.isAndroid) return const [];
    return {
      if (recaptchaAndroidSiteKeyOverride.isNotEmpty)
        recaptchaAndroidSiteKeyOverride,
      recaptchaAndroidSiteKey,
      recaptchaLegacyAndroidSiteKey,
    }
        .where((key) => key.isNotEmpty && !key.startsWith('REPLACE_WITH_'))
        .toList();
  }

  static bool get hasRecaptchaSiteKey =>
      recaptchaSiteKeys.isNotEmpty;

  static String get kuemeleImage =>
      _iconPath(Assets.icons.kuemele, Assets.icons.kuemeleDark);

  static String get padlockAnimation => ColorSet.isDarkMode
      ? Assets.animations.padlockDark.path
      : Assets.animations.padlock.path;

  static String get emailSvgIcon => Assets.svg.iconEmail.path;

  static String get accountIcon =>
      _iconPath(Assets.icons.account, Assets.icons.accountDark);
}
