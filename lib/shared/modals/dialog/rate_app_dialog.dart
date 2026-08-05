import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/rating.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

class PleaseRateAppDialog extends StatelessWidget {
  const PleaseRateAppDialog({super.key});

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
        Image.asset(IconSet.doublestar),
        Text(
          'Please rate your last event',
          style: context.textTheme.titleLargeBold,
        ),
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    return Text(
      'Your rating help to improve our community experience\n\n -Thank you!',
      textAlign: TextAlign.center,
      style: context.textTheme.bodyLarge.copyWith(
        fontSize: 15,
        color: ColorSet.textColor,
      ),
    );
  }
}

class RateAppDialog extends StatefulWidget {
  const RateAppDialog({super.key});

  @override
  State<RateAppDialog> createState() => _RateAppDialogState();
}

class _RateAppDialogState extends State<RateAppDialog> {
  final commentCTR = TextEditingController();
  double currentRating = 3;

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
    return Text(
      'Rate this app',
      style: context.textTheme.titleLargeBold,
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "'How can we make it better?'",
          style: context.textTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorSet.textColor,
          ),
        ),
        SizedBox(height: size(10)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate this app',
              style: context.textTheme.bodyLargeSemiBold.copyWith(
                color: ColorSet.textColor,
              ),
            ),
            SizedBox(height: size(5)),
            RatingBar(
              value: currentRating,
              itemSize: 35,
              onChanged: (star) => setState(() => currentRating = star),
            ),
            SizedBox(height: size(5)),
            Text(
              'Your Comment',
              textAlign: TextAlign.left,
              style: context.textTheme.bodyMediumSemiBold.copyWith(
                color: ColorSet.textColor,
              ),
            ),
            SizedBox(height: size(5)),
            Container(
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: ColorSet.bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: commentCTR,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add Comment',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: size(20)),
        Align(
            alignment: Alignment.centerRight,
            child: AppButton.primary(
              label: 'Send',
            )),
      ],
    );
  }
}
