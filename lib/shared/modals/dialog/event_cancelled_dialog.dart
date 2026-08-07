import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';

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
            AppLocalizations.of(context)!.eventCancelledDialogTitle,
            style: context.textTheme.titleLargeBold,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.eventCancelledDialogMessage,
          style: context.textTheme.bodyLarge,
          textAlign: TextAlign.left,
        ),
        Text(
          AppLocalizations.of(context)!.premiumPurchaseIncludeLabel,
          style: context.textTheme.bodyLargeSemiBold,
        ),
        Column(
          children: [
            buildRow(context, AppLocalizations.of(context)!.premiumLocationChange),
            buildRow(context, AppLocalizations.of(context)!.premiumHouseParty),
            buildRow(context, AppLocalizations.of(context)!.premiumNoAds),
            buildRow(context, AppLocalizations.of(context)!.premium7DaysAdvertising),
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
          AppLocalizations.of(context)!.eventCancelledDialogTitle,
          style: context.textTheme.titleLargeBold,
        ),
        Text(
          AppLocalizations.of(context)!.eventCancelledDialogMessage,
          style: context.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        Text(
          AppLocalizations.of(context)!.premiumPurchaseIncludeLabel,
          style: context.textTheme.bodyLargeSemiBold,
        ),
        Column(
          children: [
            buildRow(context, AppLocalizations.of(context)!.premiumLocationChange),
            buildRow(context, AppLocalizations.of(context)!.premiumHouseParty),
            buildRow(context, AppLocalizations.of(context)!.premiumNoAds),
            buildRow(context, AppLocalizations.of(context)!.premium7DaysAdvertising),
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
