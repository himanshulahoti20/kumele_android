import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog_layout.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:lottie/lottie.dart';

/// Matches iOS's NotificationBirthdayView exactly — this is the one "compact
/// alert" popup where iPad does NOT share the phone's small card. Phone stays
/// Family A (320pt cap, image+close overlaid, 19/15/12pt text). Tablet jumps
/// to Family D, the wide detail card (620x512pt cap, image above a plain
/// close row, 26/20/30pt text) — see NotificationBirthdayView_iPad.swift.
class BirthdayNotificationDialog extends StatelessWidget {
  const BirthdayNotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return FormFactor.isTablet ? _buildTablet(context) : _buildPhone(context);
  }

  Widget _buildPhone(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    IconSet.birthdaybanner,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                AppRoundedIconButton(
                  assetPath: IconSet.closeIcon,
                  iconSize: 24,
                  padding: 4,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.birthdayNotificationTitle,
            style: context.textTheme.labelSmallBold.copyWith(
              color: ColorSet.textColor,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.birthdayNotificationMessage,
            style: context.textTheme.labelSmall.copyWith(
              color: ColorSet.textColor,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                AppLocalizations.of(context)!.birthdayNotificationSignature,
                style: context.textTheme.bodyMediumBold.copyWith(
                  color: ColorSet.textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Lottie.asset(IconSet.jsonGift, width: 28, height: 28),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTablet(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: AppDialogSize.compactAlertMaxHeightFor(context),
      ),
      child: Container(
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: ColorSet.bg3Color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppRoundedIconButton(
                  assetPath: IconSet.closeIcon,
                  iconSize: 40,
                  padding: 0,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 540 / 222,
                child: Image.asset(
                  IconSet.birthdaybanner,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.birthdayNotificationTitle,
              style: context.textTheme.labelSmallBold.copyWith(
                color: ColorSet.textColor,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.birthdayNotificationMessage,
              style: context.textTheme.labelSmall.copyWith(
                color: ColorSet.textColor,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  AppLocalizations.of(context)!.birthdayNotificationSignature,
                  style: context.textTheme.bodyMediumBold.copyWith(
                    color: ColorSet.textColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Lottie.asset(IconSet.jsonGift, width: 28, height: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
