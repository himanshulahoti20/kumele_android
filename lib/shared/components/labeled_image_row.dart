import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class LabeledImageRow extends StatelessWidget {
  final String? leftImage;
  final String? text;
  final double? textSize;
  final FontWeight? fontWeight;
  final String? rightImage;

  const LabeledImageRow({
    super.key,
    this.fontWeight,
    this.leftImage,
    this.rightImage,
    this.text,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leftImage != null)
          KumeleAssetWidget(
            assetPath: leftImage!,
            width: 25.w,
            height: 25.w,
          ),
        if (leftImage != null) SizedBox(width: 5.w),
        if (text != null)
          Flexible(
            child: Text(
              text!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall.copyWith(
                fontSize: textSize ?? 13.89.sp,
                fontWeight: fontWeight ?? FontWeight.w500,
              ),
            ),
          ),
        if (text != null && rightImage != null) SizedBox(width: 5.w),
        if (rightImage != null)
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: ColorSet.createEventTileFillColor,
            ),
            child: Center(
              child: KumeleAssetWidget(
                assetPath: rightImage!,
                width: 20.w,
                height: 20.w,
              ),
            ),
          ),
      ],
    );
  }
}
