import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class KumelePickerField extends StatelessWidget {
  const KumelePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.leadingAsset,
    this.trailingAsset,
    this.placeholder = 'Select',
  });

  final String label;
  final String value;
  final String leadingAsset;
  final String? trailingAsset;
  final String placeholder;

  String get _displayValue =>
      value.isEmpty || value.startsWith('Select') ? placeholder : value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmallSemiBold,
        ),
        const Gap(7),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: ColorSet.createEventTileFillColor,
          ),
          child: Row(
            spacing: 7,
            children: [
              KumeleAssetWidget.square(
                assetPath: leadingAsset,
                size: 21,
                fit: BoxFit.contain,
              ),
              Expanded(
                child: Text(
                  _displayValue,
                  style: value.isEmpty || value.startsWith('Select')
                      ? context.textTheme.bodySmallSemiBold.copyWith(
                          color: ColorSet.subTextColor,
                        )
                      : context.textTheme.bodySmallSemiBold.copyWith(
                          color: ColorSet.textColor,
                        ),
                ),
              ),
              if (trailingAsset != null)
                KumeleAssetWidget.square(
                  assetPath: trailingAsset!,
                  size: 21,
                  fit: BoxFit.contain,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
