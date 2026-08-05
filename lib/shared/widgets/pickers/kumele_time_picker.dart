import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/responsive/responsive_extensions.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/pickers/kumele_picker_field.dart';

class KumeleTimePickerWithLabel extends StatelessWidget {
  const KumeleTimePickerWithLabel({
    super.key,
    required this.label,
    required this.value,
    required this.initialTime,
    required this.onTimeSelected,
    this.placeholder = 'Select time',
  });

  final String label;
  final String value;
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return InkWell(
          onTap: () => _showPicker(context, constraints.maxWidth),
          child: KumelePickerField(
            label: label,
            value: value,
            leadingAsset: Assets.icons.clock.path,
            trailingAsset: Assets.icons.bothTopDownArrows.path,
            placeholder: placeholder,
          ),
        );
      },
    );
  }

  Future<void> _showPicker(BuildContext context, double width) async {
    final picked = await KumeleTimePicker.showAttached(
      context: context,
      width: width,
      initialTime: initialTime,
    );
    if (picked != null) onTimeSelected(picked);
  }
}

class KumeleTimePicker extends StatefulWidget {
  const KumeleTimePicker({
    super.key,
    required this.initialTime,
    this.onTimeSelected,
    this.onCancel,
  });

  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay>? onTimeSelected;
  final VoidCallback? onCancel;

  static Future<TimeOfDay?> showAttached({
    required BuildContext context,
    required double width,
    required TimeOfDay initialTime,
  }) {
    TimeOfDay? result;
    final responsive = context.responsive;
    final screenWidth = responsive.screenSize.width;
    final horizontalInset = responsive.horizontalPadding * 2;
    final pickerWidth =
        math.max(width, 280.0).clamp(0.0, screenWidth - horizontalInset);

    return SmartDialog.showAttach<TimeOfDay>(
      targetContext: context,
      alignment: Alignment.bottomCenter,
      maskColor: ColorSet.bcColor,
      builder: (_) => SizedBox(
        width: pickerWidth,
        child: KumeleTimePicker(
          initialTime: initialTime,
          onCancel: SmartDialog.dismiss,
          onTimeSelected: (time) {
            result = time;
            SmartDialog.dismiss();
          },
        ),
      ),
    ).then((_) => result);
  }

  @override
  State<KumeleTimePicker> createState() => _KumeleTimePickerState();
}

class _KumeleTimePickerState extends State<KumeleTimePicker> {
  static const _hours = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  static const _periods = ['AM', 'PM'];

  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  late int _hourIndex;
  late int _minute;
  late int _periodIndex;

  @override
  void initState() {
    super.initState();
    final time = widget.initialTime;
    final isPm = time.hour >= 12;
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;

    _hourIndex = _hours.indexOf(hour);
    _minute = time.minute;
    _periodIndex = isPm ? 1 : 0;

    _hourController = FixedExtentScrollController(initialItem: _hourIndex);
    _minuteController = FixedExtentScrollController(initialItem: _minute);
    _periodController = FixedExtentScrollController(initialItem: _periodIndex);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  TimeOfDay _buildSelectedTime() {
    var hour = _hours[_hourIndex];
    if (_periodIndex == 1 && hour != 12) {
      hour += 12;
    } else if (_periodIndex == 0 && hour == 12) {
      hour = 0;
    }
    return TimeOfDay(hour: hour, minute: _minute);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Set Time',
            style: context.textTheme.bodyMediumSemiBold.copyWith(
              fontWeight: FontWeight.w500,
              color: ColorSet.textColor,
            ),
          ),
          const Gap(12),
          SizedBox(
            height: 160,
            child: Row(
              children: [
                Expanded(
                  child: _buildWheel(
                    controller: _hourController,
                    itemCount: _hours.length,
                    label: (index) => _hours[index].toString().padLeft(2, '0'),
                    onSelected: (index) => setState(() => _hourIndex = index),
                  ),
                ),
                Text(
                  ':',
                  style: context.textTheme.titleLargeSemiBold.copyWith(
                    color: ColorSet.textColor,
                  ),
                ),
                Expanded(
                  child: _buildWheel(
                    controller: _minuteController,
                    itemCount: 60,
                    label: (index) => index.toString().padLeft(2, '0'),
                    onSelected: (index) => setState(() => _minute = index),
                  ),
                ),
                Expanded(
                  child: _buildWheel(
                    controller: _periodController,
                    itemCount: _periods.length,
                    label: (index) => _periods[index],
                    onSelected: (index) => setState(() => _periodIndex = index),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  label: 'Cancel',
                  onPressed: widget.onCancel ?? () => SmartDialog.dismiss(),
                ),
              ),
              const Gap(12),
              Expanded(
                child: AppButton.primary(
                  label: 'Save',
                  onPressed: () =>
                      widget.onTimeSelected?.call(_buildSelectedTime()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int index) label,
    required ValueChanged<int> onSelected,
  }) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          pickerTextStyle: context.textTheme.titleLargeSemiBold.copyWith(
            color: ColorSet.textColor,
          ),
        ),
      ),
      child: CupertinoPicker(
        scrollController: controller,
        itemExtent: 36,
        onSelectedItemChanged: onSelected,
        children: List.generate(
          itemCount,
          (index) => Center(child: Text(label(index))),
        ),
      ),
    );
  }
}
