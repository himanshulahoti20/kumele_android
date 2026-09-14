import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:lottie/lottie.dart';

/// Matches iOS's PopUpWelcomeView exactly — a single layout shared by iPhone
/// and iPad (no `_iPhone`/`_iPad` split in the Swift source), floating over a
/// flat 10%-opacity scrim rather than the black layered scrim used by the
/// "compact alert" family. Width is capped by
/// [AppDialogSize.notificationModalWidthFor] (min(screenWidth-32, 420)) —
/// wired at the call site in notification_actions.dart.
class WelcomeNotificationDialog extends StatelessWidget {
  const WelcomeNotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: FormFactor.isTablet
            ? const [BoxShadow(blurRadius: 10, color: Colors.black26)]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Lottie.asset(IconSet.jsonMarshmallows, width: 75, height: 75),
              const Spacer(),
              AppRoundedIconButton(
                assetPath: IconSet.closeIcon,
                iconSize: 24,
                padding: 0,
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.welcomeNotificationTitle,
            style: context.textTheme.headlineSmallBold.copyWith(
              color: ColorSet.textColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.welcomeNotificationBody,
            style: context.textTheme.bodyMedium.copyWith(
              color: ColorSet.textColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.premiumPurchaseIncludeLabel,
            style: context.textTheme.bodyMediumBold.copyWith(
              color: ColorSet.textColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          _bullet(context, AppLocalizations.of(context)!.premiumLocationChange),
          _bullet(context, AppLocalizations.of(context)!.premiumHouseParty),
          _bullet(context, AppLocalizations.of(context)!.premiumNoAds),
          _bullet(
            context,
            AppLocalizations.of(context)!.premium7DaysAdvertising,
          ),
        ],
      ),
    );
  }

  Widget _bullet(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorSet.textColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodySmall.copyWith(
                color: ColorSet.textColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
