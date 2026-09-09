import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/modals/dialog/notification_alert_card.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class BirthdayNotificationDialog extends StatefulWidget {
  const BirthdayNotificationDialog({
    super.key,
  });

  @override
  State<BirthdayNotificationDialog> createState() =>
      _BirthdayNotificationDialogState();
}

class _BirthdayNotificationDialogState
    extends State<BirthdayNotificationDialog> {
  final bool _isContainerVisible = false;

  @override
  Widget build(BuildContext context) {
    return NotificationAlertCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              IconSet.birthdaybanner,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          mainView(),
        ],
      ),
    );
  }

  Widget mainView() {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size(12)),
              Text(AppLocalizations.of(context)!.birthdayNotificationTitle,
                  style: context.textTheme.labelSmallBold.copyWith(
                      fontSize: FormFactor.isTablet ? 26 : 20,
                      fontWeight: FontWeight.w700)),
              SizedBox(height: size(3)),
              Visibility(
                visible:
                    !_isContainerVisible, // Hide text when container is visible
                child: Text(
                    AppLocalizations.of(context)!.birthdayNotificationMessage,
                    style: context.textTheme.labelSmall.copyWith(
                        color: ColorSet.textColor,
                        fontSize: FormFactor.isTablet ? 18 : 15)),
              ),
              SizedBox(height: size(30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                      AppLocalizations.of(context)!
                          .birthdayNotificationSignature,
                      style: context.textTheme.bodyMediumBold.copyWith(
                          color: ColorSet.textColor,
                          fontWeight: FontWeight.w700)),
                  Image.asset(
                    IconSet.gift,
                    height: size(20),
                    width: size(20),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
