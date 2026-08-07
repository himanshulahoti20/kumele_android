import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/responsive/responsive_extensions.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:kuemele/shared/widgets/pickers/kumele_picker_field.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class KumeleDatePickerWithLabel extends StatelessWidget {
  const KumeleDatePickerWithLabel({
    super.key,
    required this.label,
    required this.value,
    required this.onDateSelected,
    this.initialDate,
    this.selectedDate,
    this.minDate,
    this.maxDate,
    this.placeholder = 'Select date',
    this.leadingAsset,
    this.trailingAsset,
  });

  final String label;
  final String value;
  final DateTime? initialDate;
  final DateTime? selectedDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime> onDateSelected;
  final String placeholder;
  final String? leadingAsset;
  final String? trailingAsset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return InkWell(
          onTap: () => _showPicker(context, constraints.maxWidth),
          child: KumelePickerField(
            label: label,
            value: value,
            leadingAsset: Assets.icons.calendarSvg.path,
            trailingAsset: Assets.icons.bothTopDownArrows.path,
            placeholder: placeholder,
          ),
        );
      },
    );
  }

  Future<void> _showPicker(BuildContext context, double width) async {
    final picked = await KumeleDatePicker.showAttached(
      context: context,
      width: width,
      initialDate: initialDate,
      selectedDate: selectedDate,
      minDate: minDate,
      maxDate: maxDate,
    );
    if (picked != null) onDateSelected(picked);
  }
}

class KumeleDatePicker extends StatefulWidget {
  const KumeleDatePicker({
    super.key,
    this.initialDate,
    this.selectedDate,
    this.minDate,
    this.maxDate,
    this.onDateSelected,
    this.onCancel,
  });

  final DateTime? initialDate;
  final DateTime? selectedDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime>? onDateSelected;
  final VoidCallback? onCancel;

  static Future<DateTime?> showAttached({
    required BuildContext context,
    required double width,
    DateTime? initialDate,
    DateTime? selectedDate,
    DateTime? minDate,
    DateTime? maxDate,
  }) {
    DateTime? result;
    final responsive = context.responsive;
    final screenWidth = responsive.screenSize.width;
    final horizontalInset = responsive.horizontalPadding * 2;
    final pickerWidth =
        math.max(width, 280.0).clamp(0.0, screenWidth - horizontalInset);

    return SmartDialog.showAttach<DateTime>(
      targetContext: context,
      alignment: Alignment.bottomCenter,
      maskColor: ColorSet.bcColor,
      builder: (_) => SizedBox(
        width: pickerWidth,
        child: KumeleDatePicker(
          initialDate: initialDate,
          selectedDate: selectedDate,
          minDate: minDate,
          maxDate: maxDate,
          onCancel: SmartDialog.dismiss,
          onDateSelected: (date) {
            result = date;
            SmartDialog.dismiss();
          },
        ),
      ),
    ).then((_) => result);
  }

  @override
  State<KumeleDatePicker> createState() => _KumeleDatePickerState();
}

class _KumeleDatePickerState extends State<KumeleDatePicker> {
  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const _weekdayLabels = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  late DateTime _visibleMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final initial = widget.selectedDate ?? widget.initialDate ?? DateTime.now();
    _selectedDate = DateTime(initial.year, initial.month, initial.day);
    _visibleMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  DateTime? get _minDate {
    final min = widget.minDate;
    if (min == null) return null;
    return DateTime(min.year, min.month, min.day);
  }

  DateTime? get _maxDate {
    final max = widget.maxDate;
    if (max == null) return null;
    return DateTime(max.year, max.month, max.day);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isSelectable(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    final min = _minDate;
    final max = _maxDate;
    if (min != null && normalized.isBefore(min)) return false;
    if (max != null && normalized.isAfter(max)) return false;
    return true;
  }

  void _changeMonth(int offset) {
    setState(() {
      _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + offset,
      );
    });
  }

  void _selectDay(DateTime day) {
    if (!_isSelectable(day)) return;
    setState(() => _selectedDate = DateTime(day.year, day.month, day.day));
  }

  List<_CalendarCell> _buildCells() {
    final firstDay = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final leading = firstDay.weekday % 7;
    final cells = <_CalendarCell>[];

    final previousMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
    final previousMonthDays =
        DateTime(_visibleMonth.year, _visibleMonth.month, 0).day;

    for (var i = leading - 1; i >= 0; i--) {
      final day = previousMonthDays - i;
      cells.add(
        _CalendarCell(
          date: DateTime(previousMonth.year, previousMonth.month, day),
          isCurrentMonth: false,
        ),
      );
    }

    for (var day = 1; day <= daysInMonth; day++) {
      cells.add(
        _CalendarCell(
          date: DateTime(_visibleMonth.year, _visibleMonth.month, day),
          isCurrentMonth: true,
        ),
      );
    }

    var nextDay = 1;
    while (cells.length % 7 != 0) {
      cells.add(
        _CalendarCell(
          date: DateTime(_visibleMonth.year, _visibleMonth.month + 1, nextDay),
          isCurrentMonth: false,
        ),
      );
      nextDay++;
    }

    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final cells = _buildCells();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_monthNames[_visibleMonth.month - 1]} ${_visibleMonth.year}',
                  style: context.textTheme.titleMediumSemiBold.copyWith(
                    color: ColorSet.textColor,
                  ),
                ),
              ),
              RotatedBox(
                quarterTurns: 1,
                child: AppRoundedIconButton(
                  assetPath: Assets.icons.arrowDown.path,
                  iconSize: 20,
                  iconColor: ColorSet.revbg3Color,
                  onTap: () => _changeMonth(-1),
                ),
              ),
              const Gap(12),
              RotatedBox(
                quarterTurns: 1,
                child: AppRoundedIconButton(
                  assetPath: Assets.icons.arrowUp.path,
                  iconSize: 20,
                  iconColor: ColorSet.revbg3Color,
                  onTap: () => _changeMonth(1),
                ),
              ),
            ],
          ),
          const Gap(16),
          Row(
            children: _weekdayLabels
                .map(
                  (label) => Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: context.textTheme.labelSmallSemiBold.copyWith(
                          fontWeight: FontWeight.w400,
                          color: ColorSet.subTextColor,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const Gap(12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cells.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              final cell = cells[index];
              final isSelected = _isSameDay(cell.date, _selectedDate);
              final isSelectable = _isSelectable(cell.date);

              return GestureDetector(
                onTap: isSelectable ? () => _selectDay(cell.date) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        isSelected ? ColorSet.revbg3Color : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${cell.date.day}',
                    style: context.textTheme.bodyMediumSemiBold.copyWith(
                      fontWeight: FontWeight.w400,
                      color: isSelected
                          ? ColorSet.bg2Color
                          : !cell.isCurrentMonth
                              ? ColorSet.subTextColor.withValues(alpha: 0.5)
                              : isSelectable
                                  ? ColorSet.textColor
                                  : ColorSet.subTextColor
                                      .withValues(alpha: 0.4),
                    ),
                  ),
                ),
              );
            },
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  label: AppLocalizations.of(context)!.cancel,
                  onPressed: widget.onCancel ?? () => SmartDialog.dismiss(),
                ),
              ),
              const Gap(12),
              Expanded(
                child: AppButton.primary(
                  label: AppLocalizations.of(context)!.save,
                  onPressed: () => widget.onDateSelected?.call(_selectedDate),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalendarCell {
  const _CalendarCell({
    required this.date,
    required this.isCurrentMonth,
  });

  final DateTime date;
  final bool isCurrentMonth;
}
