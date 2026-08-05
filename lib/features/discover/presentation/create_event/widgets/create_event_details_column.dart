import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/discover/presentation/create_event/create_event_models.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_preview_button.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/modals/dialog/advert_dialog.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/widgets/app_cart_button.dart';
import 'package:kuemele/shared/widgets/app_divider.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/pickers/kumele_date_picker.dart';
import 'package:kuemele/shared/widgets/pickers/kumele_time_picker.dart';
import 'package:kuemele/shared/models/event_location.dart';
import 'package:kuemele/shared/widgets/event_address_card.dart';
import 'package:kuemele/shared/widgets/kumele_rich_text.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

class CreateEventDetailsColumn extends StatelessWidget {
  const CreateEventDetailsColumn({
    super.key,
    required this.titleController,
    required this.subtitleController,
    required this.descriptionController,
    required this.startsIn,
    required this.onStartsInDecrease,
    required this.onStartsInIncrease,
    required this.date,
    required this.selectedDate,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.onStartTimeSelected,
    required this.onEndTimeSelected,
    required this.onDateSelected,
    required this.onCheckUserAvailability,
    required this.onPreview,
    required this.onStartsInBuyTap,
    required this.selectedLocation,
    required this.onLocationSelected,
    required this.onClearLocation,
    this.showPreviewButton = false,
    this.previewHorizontalPadding = 40,
    this.previewVerticalPadding = 15,
  });

  final TextEditingController titleController;
  final TextEditingController subtitleController;
  final TextEditingController descriptionController;
  final EventTimeType startsIn;
  final VoidCallback onStartsInDecrease;
  final VoidCallback onStartsInIncrease;
  final String date;
  final DateTime? selectedDate;
  final String eventStartTime;
  final String eventEndTime;
  final TimeOfDay? selectedStartTime;
  final TimeOfDay? selectedEndTime;
  final ValueChanged<TimeOfDay> onStartTimeSelected;
  final ValueChanged<TimeOfDay> onEndTimeSelected;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onCheckUserAvailability;
  final VoidCallback onPreview;
  final VoidCallback onStartsInBuyTap;
  final EventLocation? selectedLocation;
  final ValueChanged<EventLocation> onLocationSelected;
  final VoidCallback onClearLocation;
  final bool showPreviewButton;
  final double previewHorizontalPadding;
  final double previewVerticalPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KumeleTextField.normal(
          controller: titleController,
          labelText: 'Event Name',
          isRequired: true,
          hintText: 'Add a title',
        ),
        const Gap(16),
        KumeleTextField.normal(
          controller: subtitleController,
          labelText: 'Subtitle',
          hintText: 'Add a subtitle',
        ),
        const Gap(16),
        KumeleTextArea(
          controller: descriptionController,
          maxLines: 8,
          maxLength: 1200,
          maxLengthText: 'Max',
          labelText: 'Description',
          isRequired: true,
          hintText: 'More about the event',
        ),
        const Gap(16),
        _StartsInSection(
          startsIn: startsIn,
          onDecrease: onStartsInDecrease,
          onIncrease: onStartsInIncrease,
          onBuyTap: onStartsInBuyTap,
        ),
        const Gap(16),
        KumeleDatePickerWithLabel(
          label: 'Date',
          value: date,
          selectedDate: selectedDate,
          minDate: DateTime.now(),
          onDateSelected: onDateSelected,
        ),
        const Gap(16),
        Row(
          spacing: 17,
          children: [
            Expanded(
              child: KumeleTimePickerWithLabel(
                label: 'Event Start time',
                value: eventStartTime,
                placeholder: 'Start time',
                initialTime: selectedStartTime ?? TimeOfDay.now(),
                onTimeSelected: onStartTimeSelected,
              ),
            ),
            Expanded(
              child: KumeleTimePickerWithLabel(
                label: 'Event End time',
                value: eventEndTime,
                placeholder: 'End time',
                initialTime: selectedEndTime ?? TimeOfDay.now(),
                onTimeSelected: onEndTimeSelected,
              ),
            ),
          ],
        ),
        const Gap(16),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Event Address',
                style: context.textTheme.bodySmallSemiBold.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: ' *',
                style: context.textTheme.bodySmallSemiBold.copyWith(
                  fontWeight: FontWeight.w400,
                  color: ColorSet.snackBarErrorBg,
                ),
              ),
            ],
          ),
        ),
        const Gap(7),
        EventAddressCard(
          selectedLocation: selectedLocation,
          onLocationSelected: onLocationSelected,
          onClearLocation: onClearLocation,
        ),
        const Gap(16),
        Row(
          spacing: 20,
          children: [
            Expanded(
              flex: 3,
              child: AppButton.primary(
                label: 'Check User Availability',
                fullWidth: true,
                onPressed: onCheckUserAvailability,
              ),
            ),
            Expanded(
              flex: 1,
              child: KumeleTextField(
                initialValue: '100',
                enabled: false,
                readOnly: true,
              ),
            ),
          ],
        ),
        const Gap(8),
        KumeleTextLink(
          leading: '*',
          trailing:
              'To use this, please add your address and number of guest. Disclaimer: we cannot guarantee 100%\nmatches due to certain factors beyond our control.',
          leadingStyle: context.textTheme.bodySmallBold.copyWith(
            color: const Color(0xFFFF0000),
          ),
          trailingStyle: context.textTheme.bodySmall,
          textAlign: TextAlign.justify,
          maxLines: 2,
        ),
        if (showPreviewButton)
          WidgetByDevice(
            tablet: Padding(
              padding: const EdgeInsets.only(top: 44),
              child: CreateEventPreviewButton(
                onPressed: onPreview,
                horizontalPadding: previewHorizontalPadding,
                verticalPadding: previewVerticalPadding,
              ),
            ),
          ),
      ],
    );
  }
}

class _StartsInSection extends StatelessWidget {
  const _StartsInSection({
    required this.startsIn,
    required this.onDecrease,
    required this.onIncrease,
    required this.onBuyTap,
  });

  final EventTimeType startsIn;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onBuyTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Event starts in',
              style: context.textTheme.bodySmallSemiBold.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(4),
            GestureDetector(
              onTap: () => _showAdvertDialog(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: KumeleAssetWidget.square(
                  assetPath: IconSet.iIcon,
                  size: 16,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        const Gap(8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              height: 38.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: ColorSet.revertBgColor,
              ),
              alignment: Alignment.center,
              child: Text(
                startsIn.label,
                style: context.textTheme.bodySmallSemiBold.copyWith(
                  fontWeight: FontWeight.w400,
                  color: ColorSet.bgColor,
                ),
              ),
            ),
            const Gap(8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: ColorSet.revertBgColor),
              ),
              child: SizedBox(
                height: 38.w,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StepperIconButton(
                      icon: Icons.remove,
                      onTap: onDecrease,
                      semanticLabel: 'Decrease time',
                    ),
                    AppDivider.vertical(
                      color: ColorSet.revertBgColor,
                      indent: 8,
                      endIndent: 8,
                    ),
                    _StepperIconButton(
                      icon: Icons.add,
                      onTap: onIncrease,
                      semanticLabel: 'Increase time',
                    ),
                  ],
                ),
              ),
            ),
            if (startsIn != EventTimeType.hours_24) ...[
              const Gap(8),
              AppCartButton(
                onTap: onBuyTap,
              ),
            ],
          ],
        ),
      ],
    );
  }

  void _showAdvertDialog(BuildContext context) {
    AppDialog.adaptive(
      context: context,
      width: AppDialogSize.widthFor(context),
      dialog: AdvertDialog(),
    );
  }
}

class _StepperIconButton extends StatefulWidget {
  const _StepperIconButton({
    required this.icon,
    required this.onTap,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? semanticLabel;

  @override
  State<_StepperIconButton> createState() => _StepperIconButtonState();
}

class _StepperIconButtonState extends State<_StepperIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.all(10),
        color: _pressed
            ? ColorSet.revertBgColor.withValues(alpha: 0.12)
            : Colors.transparent,
        child: Icon(
          widget.icon,
          size: 18,
          color: ColorSet.revertBgColor,
        ),
      ),
    );

    if (widget.semanticLabel == null) return button;
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: button,
    );
  }
}
