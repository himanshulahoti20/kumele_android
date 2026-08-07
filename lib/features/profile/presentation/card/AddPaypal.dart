import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

import 'package:kuemele/shared/components/size.dart';

class AddpaypalDialog extends StatefulWidget {
  const AddpaypalDialog({super.key});

  @override
  State<AddpaypalDialog> createState() => _AddpaypalDialogState();
}

class _AddpaypalDialogState extends State<AddpaypalDialog> {
  TextEditingController cardHolderName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController cvc = TextEditingController();
  GlobalKey key = GlobalKey();
  String selectedCategory = '';
  int selectedCountry = 0;

  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: AppTitledDialog(
        title: '',
        child: buildContent(),
      ),
      phone: AppBottomSheet(child: buildContent()),
    );
  }

  Widget buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(IconSet.paypal),
        Gap(30),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            hintText: AppLocalizations.of(context)!.addPaypalEmailOrMobileHint,
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(height: size(40)),
        AppButton.primary(
          label: AppLocalizations.of(context)!.next,
          backgroundColor: Color(0xff0170BA),
          foregroundColor: Colors.white,
          onPressed: () {},
        ),
        SizedBox(height: size(35)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container(color: Colors.grey, height: 0.5)),
            SizedBox(width: size(20)),
            Text(AppLocalizations.of(context)!.orDividerLabel,
                style: context.textTheme.bodyMediumBold.copyWith(fontSize: 15)),
            SizedBox(width: size(20)),
            Expanded(child: Container(color: Colors.grey, height: 0.5)),
          ],
        ),
        SizedBox(height: size(35)),
        AppButton.primary(
          label: AppLocalizations.of(context)!.signup,
          foregroundColor: ColorSet.bg2Color,
          onPressed: () {},
        ),
      ],
    );
  }
}
