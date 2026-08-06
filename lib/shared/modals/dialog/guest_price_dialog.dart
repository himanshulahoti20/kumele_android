import 'package:flutter/material.dart';
import 'package:kuemele/features/discover/data/models/event_plan_model.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:lottie/lottie.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class GuestPriceDialog extends StatelessWidget {
  const GuestPriceDialog({
    super.key,
    required this.plans,
  });

  final List<EventPlanModel> plans;

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
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(IconSet.jsonAnimMarshmallows,
            width: 80, height: 80, fit: BoxFit.fill),
        Text(
          "Guest Prices",
          style: context.textTheme.titleLargeBold,
        ),
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 15,
      children: plans.isEmpty
          ? [Text('Guest prices are unavailable right now.')]
          : [
              for (final plan in plans)
                buildItem(
                  context,
                  plan.guestRangeLabel,
                  plan.priceLabel,
                  desc: plan == plans.last
                      ? '(Max guests ${plan.maxGuests})'
                      : null,
                ),
            ],
    );
  }

  Widget buildItem(BuildContext context, String label, String price,
      {String? desc}) {
    return Row(
      spacing: 10,
      children: [
        AppSvgImage(
            assetName: SVGAsset.icon_ticket,
            height: 35,
            width: 35,
            color: ColorSet.textColor),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.bodyLargeSemiBold,
              ),
              if (desc != null)
                Text(
                  desc,
                  style: context.textTheme.bodyLarge.copyWith(fontSize: 15),
                ),
            ],
          ),
        ),
        Text(
          price,
          style: context.textTheme.bodyLargeSemiBold,
        ),
      ],
    );
  }
}
