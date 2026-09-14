import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/medals.dart';
import 'package:kuemele/shared/modals/dialog/notification_alert_card.dart';
import 'package:lottie/lottie.dart';

class CongratulationDialog extends StatelessWidget {
  const CongratulationDialog({
    super.key,
    this.status,
    this.discountCode,
    this.description,
    this.medalType,
  });

  final String? status;
  final String? discountCode;
  final String? description;

  /// When set (e.g. 'gold'/'silver'/'bronze'), [status] and [description]
  /// are sourced from [Medals.contentFor] — the same copy shown in the
  /// History & Statistics tier-info popup — instead of the backend fields.
  final String? medalType;

  @override
  Widget build(BuildContext context) {
    final tierContent =
        medalType != null ? Medals.contentFor(medalType!) : null;
    final resolvedStatus = tierContent?.status ?? status;
    final resolvedDescription = tierContent?.description ?? description;

    return NotificationAlertCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.congratulationsTitle,
            textAlign: TextAlign.center,
            style: context.textTheme.heading3.copyWith(
              color: ColorSet.textColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                IgnorePointer(
                  child: Lottie.asset(
                    Assets.animations.confetti.path,
                    height: 140,
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
                Lottie.asset(
                  Assets.animations.animMedalJson.path,
                  width: 58,
                  height: 58,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            resolvedStatus?.isNotEmpty == true
                ? resolvedStatus!
                : AppLocalizations.of(context)!.congratsNewStatusBronze,
            textAlign: TextAlign.center,
            style: context.textTheme.heading3.copyWith(
              color: ColorSet.textColor,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            discountCode?.isNotEmpty == true
                ? 'Discount Code: $discountCode'
                : AppLocalizations.of(context)!.congratsDiscountCode,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLargeSemiBold.copyWith(
              color: ColorSet.textColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            resolvedDescription?.isNotEmpty == true
                ? resolvedDescription!.replaceAll('\n', ' ')
                : AppLocalizations.of(context)!.congratsBronzeDescription,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge.copyWith(
              fontSize: 15,
              height: 1.3,
              color: ColorSet.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
