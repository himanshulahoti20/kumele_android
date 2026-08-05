import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class CreateEventIconWithDrop extends StatelessWidget {
  const CreateEventIconWithDrop({
    super.key,
    required this.label,
    required this.leftImage,
    required this.rightImage,
    required this.value,
  });

  final String label;
  final String leftImage;
  final String rightImage;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmallSemiBold.copyWith(
            fontWeight: FontWeight.w400,
          ),
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
                assetPath: leftImage,
                size: 21,
                fit: BoxFit.contain,
              ),
              Expanded(
                child: Text(
                  value,
                  style: context.textTheme.bodySmallSemiBold.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              KumeleAssetWidget.square(
                assetPath: rightImage,
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
