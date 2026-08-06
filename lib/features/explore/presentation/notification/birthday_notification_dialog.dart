import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

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
    return WidgetByDevice(
      tablet: buildTablet(),
      phone: AppTitledDialog(
        header: Container(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => context.pop(),
            child: KumeleAssetWidget(
              assetPath: SVGAsset.icon_close,
              width: 30,
              height: 30,
              color: ColorSet.textColor,
            ),
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                IconSet.birthdaybanner,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            mainView(),
          ],
        ),
      ),
    );
  }

  Widget buildTablet() {
    return AppScrollDialog(
      showClose: true,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              IconSet.birthdaybanner,
              height: Utils.getHeight * 0.25,
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
              Text("Wish you a Happy Birthday!",
                  style: context.textTheme.labelSmallBold.copyWith(
                      fontSize: FormFactor.isTablet ? 26 : 20,
                      fontWeight: FontWeight.w700)),
              SizedBox(height: size(3)),
              Visibility(
                visible:
                    !_isContainerVisible, // Hide text when container is visible
                child: Text(
                    '“Happy birthday! I hope all your birthday wishes\n and dreams come true.”',
                    style: context.textTheme.labelSmall.copyWith(
                        color: ColorSet.textColor,
                        fontSize: FormFactor.isTablet ? 18 : 15)),
              ),
              SizedBox(height: size(30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Kuemele Team  ",
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
