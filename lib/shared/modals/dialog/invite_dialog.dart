import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class InviteDialog extends StatelessWidget {
  const InviteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: AppTitledDialog(
        title: 'Invite your friends to Kumele',
        child: buildContent(context),
      ),
      phone: AppBottomSheet(
        title: 'Invite your friends to Kumele',
        child: buildContent(context),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Referral code',
          style: context.textTheme.bodyLarge.copyWith(color: Colors.grey[400]),
        ),
        Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'SXF2RS4',
              style: context.textTheme.titleLargeBold
                  .copyWith(fontSize: 28, color: ColorSet.lightBlueColor),
            ),
            Gap(20),
            GestureDetector(
              onTap: () {
                // Copy the referral code to clipboard
                Clipboard.setData(ClipboardData(text: 'SXF2RS4'));
                InjectionHelper.snackBar
                    .show('Referral code copied to clipboard');
              },
              child: Image.asset(
                IconSet.copyIcon,
                width: 24,
                height: 24,
                fit: BoxFit.fill,
                color: ColorSet.lightBlueColor,
              ),
            ),
          ],
        ),
        Gap(20),
        Divider(thickness: 0.5, color: Colors.grey[200]),
        Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildOptions(context, IconSet.copyIcon, 'Copy to clipboard',
                color: ColorSet.lightBlueColor),
            buildOptions(context, IconSet.bluetoothIcon, 'Bluetooth'),
            buildOptions(context, IconSet.gdriveIcon, 'Drive'),
            buildOptions(context, IconSet.whatsappIcon, 'Whatsapp'),
          ],
        ),
      ],
    );
  }

  Widget buildOptions(BuildContext context, String icon, String label,
      {Color? color}) {
    return Expanded(
      child: Column(
        children: [
          Image.asset(
            icon,
            width: 40,
            height: 40,
            fit: BoxFit.fill,
            color: color,
          ),
          Gap(10),
          Text(
            label,
            style: context.textTheme.bodyMedium.copyWith(fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
