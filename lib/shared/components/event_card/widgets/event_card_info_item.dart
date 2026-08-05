import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class EventCardInfoItem extends StatelessWidget {
  const EventCardInfoItem({
    super.key,
    required this.assetPath,
    required this.label,
    this.iconSize,
    this.fontSize,
    this.tintColor,
  });

  final String assetPath;
  final String label;
  final double? iconSize;
  final double? fontSize;
  final Color? tintColor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final resolvedIconSize = iconSize ?? responsive.w(14);
    final resolvedFontSize = fontSize;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        KumeleAssetWidget.square(
          assetPath: assetPath,
          size: resolvedIconSize,
          color: tintColor ?? ColorSet.textColor,
        ),
        Gap(responsive.w(1)),
        Text(
          label,
          overflow: TextOverflow.clip,
          style: context.textTheme.bodySmall.copyWith(
            fontSize: resolvedFontSize,
            color: ColorSet.textColor,
          ),
        ),
      ],
    );
  }
}
