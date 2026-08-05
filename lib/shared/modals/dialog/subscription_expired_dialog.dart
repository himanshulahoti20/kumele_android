import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:lottie/lottie.dart';

class SubscriptionDialog extends StatelessWidget {
  const SubscriptionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: AppTitledDialog(
        titleWidget: buildTitle(context),
        child: buildContent(context),
      ),
      phone: AppBottomSheet(
        titleWidget: buildTitle(context),
        child: buildContent(context),
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Column(
      spacing: 20,
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(IconSet.jsonAnimMarshmallows,
            width: 80, height: 80, fit: BoxFit.fill),
        Text(
          'Subscription Expired',
          textAlign: TextAlign.center,
          style: context.textTheme.titleLargeBold.copyWith(
            fontSize: 23,
            color: ColorSet.textColor,
          ),
        ),
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    return Text(
      'Your Yearly Gold subscription will be expiring within one month and will be updated automatically. If you want to update or cancel your subscription, do it before the charge.',
      textAlign: TextAlign.center,
      style: context.textTheme.bodyMedium.copyWith(
        fontSize: 13,
        color: ColorSet.textColor,
      ),
    );
  }
}
