import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/theme/app_image.dart';
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
