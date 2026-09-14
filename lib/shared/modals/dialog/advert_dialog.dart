import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:lottie/lottie.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class AdvertDialog extends StatelessWidget {
  const AdvertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      // iOS's InfoEventStartView has no combined icon+title header — just
      // the icon with a close button, then "Advert" as its own heading
      // above the price rows. Built separately from the phone bottom sheet
      // (which keeps its existing icon+title combo) so mobile is untouched.
      tablet: AppTitledDialog(
        header: _buildTabletHeader(context),
        child: _buildTabletContent(context),
      ),
      phone: AppBottomSheet(
        titleWidget: buildTitle(context),
        child: buildContent(context),
      ),
    );
  }

  Widget _buildTabletHeader(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Lottie.asset(
            IconSet.jsonAnimMarshmallows,
            width: 75,
            height: 75,
            fit: BoxFit.fill,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: AppRoundedIconButton(
              assetPath: IconSet.closeIcon,
              iconSize: 20,
              semanticLabel: AppLocalizations.of(context)!.close,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletContent(BuildContext context) {
    final priceRowStyle = context.textTheme.bodyLargeSemiBold.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: ColorSet.textColor,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocalizations.of(context)!.advertDialogTitle,
          textAlign: TextAlign.center,
          style: context.textTheme.titleLargeBold.copyWith(
            fontSize: 22,
            color: ColorSet.textColor,
          ),
        ),
        const Gap(16),
        _tabletPriceRow(
          AppLocalizations.of(context)!.advertEventStarts48hrs,
          '\$6.00',
          priceRowStyle,
        ),
        const Gap(16),
        _tabletPriceRow(
          AppLocalizations.of(context)!.advertEventStarts7days,
          '\$13.70',
          priceRowStyle,
        ),
      ],
    );
  }

  Widget _tabletPriceRow(String label, String price, TextStyle style) {
    return Row(
      spacing: 16,
      children: [
        KumeleAssetWidget(
          assetPath: SVGAsset.icon_speaker,
          color: ColorSet.textColor,
          width: 43,
          height: 43,
        ),
        Expanded(
          child: Text(label, style: style),
        ),
        Text(price, style: style),
      ],
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
          AppLocalizations.of(context)!.advertDialogTitle,
          style: context.textTheme.titleLargeBold,
        ),
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            KumeleAssetWidget(
                assetPath: SVGAsset.icon_speaker, color: ColorSet.textColor),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.advertEventStarts48hrs,
                style: context.textTheme.bodyLargeSemiBold,
              ),
            ),
            Text(
              '\$6.00',
              style: context.textTheme.bodyLargeSemiBold,
            ),
          ],
        ),
        SizedBox(height: size(15)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            KumeleAssetWidget(
                assetPath: SVGAsset.icon_speaker, color: ColorSet.textColor),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.advertEventStarts7days,
                style: context.textTheme.bodyLargeSemiBold,
              ),
            ),
            Text(
              '\$13.70',
              style: context.textTheme.bodyLargeSemiBold,
            ),
          ],
        ),
        SizedBox(height: size(15)),
      ],
    );
  }
}
