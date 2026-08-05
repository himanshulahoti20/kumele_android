import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/radio.dart';

class CreateEventPaymentRadio extends StatelessWidget {
  const CreateEventPaymentRadio({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onSelected,
  });

  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall.copyWith(fontSize: 13),
        ),
        const Gap(7),
        GestureDetector(
          onTap: () => onSelected(value),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorSet.tileFillColor,
                  ),
                  child: Text(
                    value,
                    style: context.textTheme.bodySmall.copyWith(
                      fontSize: 14,
                      color: isSelected ? ColorSet.textColor : Colors.grey[400],
                    ),
                  ),
                ),
              ),
              const Gap(7),
              RARadio(
                onChanged: (_, __) => onSelected(value),
                groupValue: groupValue,
                value: value,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
