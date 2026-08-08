import 'dart:io' show Platform;

import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/gen/assets.gen.dart';

class AuthConfig {
  AuthConfig._();

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

  static const String recaptchaAndroidSiteKey =
      '6LfxT0otAAAAAHf1numKx9h9LuBcu40VrN5G5lbz';
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

  static String get recaptchaSiteKey =>
      Platform.isAndroid ? recaptchaAndroidSiteKey : '';

  static String get kuemeleImage =>
      _iconPath(Assets.icons.kuemele, Assets.icons.kuemeleDark);

  static String get padlockAnimation => ColorSet.isDarkMode
      ? Assets.iconsJson.padlockDark.path
      : Assets.iconsJson.padlock.path;

  static String get emailSvgIcon => Assets.svg.iconEmail.path;

  static String get accountIcon =>
      _iconPath(Assets.icons.account, Assets.icons.accountDark);
}
