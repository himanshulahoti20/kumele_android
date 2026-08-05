import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class EventCancelledDialog extends StatelessWidget {
  const EventCancelledDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTitledDialog(
      header: Container(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () => context.pop(),
          child: AppSvgImage(
            assetName: SVGAsset.icon_close,
            width: 30,
            height: 30,
            color: ColorSet.textColor,
          ),
        ),
      ),
      child: WidgetByDevice(
        tablet: buildTablet(context),
        phone: buildPhone(context),
      ),
    );
  }

  Widget buildTablet(BuildContext context) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSvgImage(
            assetName: SVGAsset.icon_speaker,
            width: 80,
            height: 80,
            color: ColorSet.textColor),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "Event Cancelled",
            style: context.textTheme.titleLargeBold,
          ),
        ),
        Text(
          "The host unfortunately cancelled the event. We apologize for the inconvenience. In case of prepayments please contact PayPal immediately for a refund.",
          style: context.textTheme.bodyLarge,
          textAlign: TextAlign.left,
        ),
        Text(
          "Premium In-app purchase include:",
          style: context.textTheme.bodyLargeSemiBold,
        ),
        Column(
          children: [
            buildRow(context, 'Location Change'),
            buildRow(context, 'House party (Max guest 10)'),
            buildRow(context, 'No Ads'),
            buildRow(context, '7 days pre event Advertising'),
          ],
        ),
      ],
    );
  }

  Widget buildPhone(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        AppSvgImage(
            assetName: SVGAsset.icon_speaker,
            width: 80,
            height: 80,
            color: ColorSet.textColor),
        Text(
          "Event Cancelled",
          style: context.textTheme.titleLargeBold,
        ),
        Text(
          "The host unfortunately cancelled the event. We apologize for the inconvenience. In case of prepayments please contact PayPal immediately for a refund.",
          style: context.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        Text(
          "Premium In-app purchase include:",
          style: context.textTheme.bodyLargeSemiBold,
        ),
        Column(
          children: [
            buildRow(context, 'Location Change'),
            buildRow(context, 'House party (Max guest 10)'),
            buildRow(context, 'No Ads'),
            buildRow(context, '7 days pre event Advertising'),
          ],
        ),
      ],
    );
  }

  Widget buildRow(BuildContext context, String label) {
    return Row(
      spacing: 10,
      children: [
        Text(
          "•",
          style: context.textTheme.bodyLarge,
        ),
        Text(
          label,
          style: context.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
