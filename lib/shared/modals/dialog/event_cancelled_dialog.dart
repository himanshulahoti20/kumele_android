import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/dialog/notification_alert_card.dart';

class EventCancelledDialog extends StatelessWidget {
  const EventCancelledDialog({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return NotificationAlertCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(IconSet.megaphone, width: 56, height: 56),
          const SizedBox(height: 14),
          Text(
            AppLocalizations.of(context)!.eventCancelledDialogTitle,
            textAlign: TextAlign.center,
            style: context.textTheme.heading3.copyWith(
              color: ColorSet.textColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message?.isNotEmpty == true
                ? message!
                : AppLocalizations.of(context)!.eventCancelledDialogMessage,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge.copyWith(
              color: ColorSet.textColor,
              fontSize: 15,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.premiumPurchaseIncludeLabel,
              style: context.textTheme.bodyLargeSemiBold.copyWith(
                color: ColorSet.textColor,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bullet(context,
                    AppLocalizations.of(context)!.premiumLocationChange),
                const SizedBox(height: 4),
                _bullet(
                    context, AppLocalizations.of(context)!.premiumHouseParty),
                const SizedBox(height: 4),
                _bullet(context, AppLocalizations.of(context)!.premiumNoAds),
                const SizedBox(height: 4),
                _bullet(
                  context,
                  AppLocalizations.of(context)!.premium7DaysAdvertising,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bullet(BuildContext context, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: context.textTheme.bodyLarge.copyWith(fontSize: 15)),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodyLarge.copyWith(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
