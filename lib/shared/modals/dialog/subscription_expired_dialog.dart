import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:lottie/lottie.dart';

class SubscriptionDialog extends StatelessWidget {
  const SubscriptionDialog({
    super.key,
    required this.tierName,
    required this.periodEnd,
  });

  final String tierName;
  final DateTime periodEnd;

  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: AppTitledDialog(
        showClose: false,
        titleWidget: buildTitle(context),
        child: buildContent(context),
      ),
      phone: AppTitledDialog(
        showClose: false,
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
        Lottie.asset(
          IconSet.jsonAnimMarshmallows,
          width: 80,
          height: 80,
          fit: BoxFit.fill,
        ),
        Text(
          'Subscription Expiration',
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
    final formattedDate = DateFormat('MMMM d, yyyy').format(periodEnd);
    return Text(
      'Your $tierName subscription will be expiring on $formattedDate and will be renewed automatically. If you want to update or cancel your subscription, do it before the charge.',
      textAlign: TextAlign.center,
      style: context.textTheme.bodyMedium.copyWith(
        fontSize: 13,
        color: ColorSet.textColor,
      ),
    );
  }
}
