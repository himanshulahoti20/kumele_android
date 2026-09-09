import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/components/app_colors.dart';

enum SecuritySettingAction {
  changePassword,
  registerPasskey,
  twoFactorAuth,
}

class SecuritySettingItem {
  const SecuritySettingItem({
    required this.title,
    required this.iconPath,
    required this.action,
    this.showTrailingArrow = true,
  });

  final String title;
  final String iconPath;
  final SecuritySettingAction action;
  final bool showTrailingArrow;
}

class SecurityConfig {
  SecurityConfig._();

  static String _iconPath(AssetGenImage light, AssetGenImage dark) {
    return ColorSet.isDarkMode ? dark.path : light.path;
  }

  static String get lockIcon =>
      _iconPath(Assets.icons.lock, Assets.icons.lockDark);

  static String get keyIcon =>
      _iconPath(Assets.icons.key, Assets.icons.keyDark);

  static String get twoFactorIcon => Assets.icons.captcha.path;

  static String get qrIcon => Assets.icons.qrSvg.path;

  static List<SecuritySettingItem> settings() {
    final l10n = AppLocalizationsEn();
    return [
        SecuritySettingItem(
          title: l10n.changePassword,
          iconPath: lockIcon,
          action: SecuritySettingAction.changePassword,
        ),
        SecuritySettingItem(
          title: l10n.registerPasskey,
          iconPath: keyIcon,
          action: SecuritySettingAction.registerPasskey,
        ),
        SecuritySettingItem(
          title: l10n.twoFactorAuth,
          iconPath: twoFactorIcon,
          action: SecuritySettingAction.twoFactorAuth,
        ),
      ];
  }
}
