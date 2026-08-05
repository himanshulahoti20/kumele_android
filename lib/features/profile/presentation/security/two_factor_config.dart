import 'package:kuemele/gen/assets.gen.dart';

class TwoFactorAuthenticatorApp {
  const TwoFactorAuthenticatorApp({
    required this.label,
    required this.assetPath,
  });

  final String label;
  final String assetPath;
}

class TwoFactorConfig {
  TwoFactorConfig._();

  static List<TwoFactorAuthenticatorApp> recommendedAuthenticatorApps() => [
        TwoFactorAuthenticatorApp(
          label: 'Google\nAuthenticator',
          assetPath: Assets.social.googleAuthenticatorPng.path,
        ),
        TwoFactorAuthenticatorApp(
          label: 'Authy',
          assetPath: Assets.social.authyAuthenticatorLogo.path,
        ),
        TwoFactorAuthenticatorApp(
          label: 'Duo',
          assetPath: Assets.social.duoAuthenticator.path,
        ),
        TwoFactorAuthenticatorApp(
          label: 'Microsoft\nAuthenticator',
          assetPath: Assets.social.microsoftAuthLogo.path,
        ),
      ];
}
