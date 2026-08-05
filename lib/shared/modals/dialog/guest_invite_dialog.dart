import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:wheel_picker/wheel_picker.dart';

class GuestInviteDialog extends StatefulWidget {
  const GuestInviteDialog({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final int initialValue;
  final ValueChanged<int> onChanged;

  @override
  State<GuestInviteDialog> createState() => _GuestInviteDialogState();
}

class _GuestInviteDialogState extends State<GuestInviteDialog> {
  late int numberOfGuest = widget.initialValue;
  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: AppTitledDialog(
        header: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTitle(),
            GestureDetector(
              onTap: () => context.pop(),
              child: AppSvgImage(
                  assetName: SVGAsset.icon_close,
                  width: 24,
                  height: 24,
                  color: ColorSet.textColor),
            ),
          ],
        ),
        child: buildContent(),
      ),
      phone: AppBottomSheet(
        titleWidget: buildTitle(),
        child: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row with icon, title, and close button
          NumberWheelPicker(
              initialValue: numberOfGuest,
              onChange: (value) {
                setState(() => numberOfGuest = value);
                widget.onChanged(value);
              }),
          // Total Guests text
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: ColorSet.textColor,
                ),
                children: [
                  TextSpan(text: 'Total Guests '),
                  TextSpan(
                    text: '$numberOfGuest',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Disclaimer text
          Text(
            '* Max 150 Guests. Disclaimer: we cannot guarantee 100% matches due to certain factors beyond our control.',
            style: TextStyle(
              fontSize: 12,
              color: ColorSet.textColor,
              height: 1.3,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Icon similar to screenshot
            AppSvgImage(
                assetName: SVGAsset.icon_ticket,
                color: ColorSet.textColor,
                width: 64,
                height: 64),
            const SizedBox(width: 12),
            Text(
              'Guest Invite',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: ColorSet.textColor,
              ),
            ),
          ],
        ),
        Gap(8),
        Text(
          '1–5 Free',
          style: TextStyle(
            fontSize: 14,
            color: ColorSet.textColor,
          ),
        ),
      ],
    );
  }
}

class NumberWheelPicker extends StatefulWidget {
  final void Function(int value) onChange;
  final int initialValue;

  const NumberWheelPicker({
    super.key,
    required this.onChange,
    required this.initialValue,
  });

  @override
  State<NumberWheelPicker> createState() => _NumberWheelPickerState();
}

class _NumberWheelPickerState extends State<NumberWheelPicker> {
  late int first = (widget.initialValue ~/ 100) % 10;
  late int second = (widget.initialValue ~/ 10) % 10;
  late int third = widget.initialValue % 10;

  late final WheelPickerController firstController;
  late final WheelPickerController secondController;
  late final WheelPickerController thirdController;

  @override
  void initState() {
    super.initState();
    firstController = WheelPickerController(itemCount: 2, initialIndex: first);
    secondController =
        WheelPickerController(itemCount: 10, initialIndex: second);
    thirdController = WheelPickerController(itemCount: 10, initialIndex: third);
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    super.dispose();
  }

  void onChange() {
    int res = int.tryParse('$first$second$third') ?? 2;
    if (res < 2) res = 2;
    if (res > 150) res = 150;
    widget.onChange(res);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildWheel(firstController, (index) {
                setState(() => first = index);
                onChange();
              }),
              buildWheel(secondController, (index) {
                setState(() => second = index);
                onChange();
              }),
              buildWheel(thirdController, (index) {
                setState(() => third = index);
                onChange();
              }),
            ],
          ),
          IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorSet.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Gap(60),
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: ColorSet.border,
                      indent: 12,
                      endIndent: 12,
                    ),
                    Gap(60),
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: ColorSet.border,
                      indent: 12,
                      endIndent: 12,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildWheel(WheelPickerController controller,
      void Function(int index) onIndexChanged) {
    final pickerStyle = TextStyle(
      fontSize: 14,
      color: ColorSet.textColor,
    );
    return SizedBox(
      width: 60,
      child: WheelPicker(
        builder: (context, index) => Text("$index", style: pickerStyle),
        controller: controller,
        onIndexChanged: (index, interactionType) => onIndexChanged(index),
        style: WheelPickerStyle(
          itemExtent: 30,
          squeeze: 0.8,
          diameterRatio: .8,
          surroundingOpacity: .45,
          magnification: 1.5,
        ),
      ),
    );
  }
}

class NumberColumn extends StatelessWidget {
  final String topNumber;
  final String mainNumber;
  final String bottomNumber;

  const NumberColumn({
    super.key,
    required this.topNumber,
    required this.mainNumber,
    required this.bottomNumber,
  });

  static const Color textGrayLight = Color(0xFF9CA3AF); // Tailwind gray-400
  static const Color textBlack = Colors.black;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            topNumber,
            style: const TextStyle(
              fontSize: 12,
              color: textGrayLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            mainNumber,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: textBlack,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            bottomNumber,
            style: const TextStyle(
              fontSize: 12,
              color: textGrayLight,
            ),
          ),
        ],
      ),
    );
  }
}
