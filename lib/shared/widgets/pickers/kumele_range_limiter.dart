import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';
import 'package:kuemele/shared/components/limiter.dart';
import 'package:kuemele/shared/components/size.dart';

class KumeleRangeLimiter extends StatelessWidget {
  const KumeleRangeLimiter({
    super.key,
    required this.label,
    this.min = 18,
    this.max = 100,
    this.initialStart = 18,
    this.initialEnd = 35,
    this.onChanged,
    this.bgWidth,
    this.widthInset = 16,
    this.isRequired = false,
    this.labelGap,
    this.bgColor,
    this.valueColor,
    this.circleSize,
    this.bgRadius,
    this.bgHeight,
  });

  final String label;
  final int min;
  final int max;
  final int initialStart;
  final int initialEnd;
  final void Function(int start, int end)? onChanged;
  final double? bgWidth;
  final double widthInset;
  final bool isRequired;
  final double? labelGap;
  final Color? bgColor;
  final Color? valueColor;
  final double? circleSize;
  final double? bgRadius;
  final double? bgHeight;

  @override
  Widget build(BuildContext context) {
    final effectiveLabelGap = labelGap ?? 8.h;
    final effectiveFontSize = 15.sp;

    return LayoutBuilder(
      builder: (context, constraints) {
        final sliderWidth =
            bgWidth ?? _resolveWidth(constraints, context, widthInset);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLabel(effectiveFontSize),
            Gap(effectiveLabelGap),
            RALimiter(
              min: min,
              max: max,
              initialStart: initialStart,
              initialEnd: initialEnd,
              onChanged: onChanged,
              bgWidth: sliderWidth,
              bgColor: bgColor,
              valueColor: valueColor,
              circleSize: circleSize,
              bgRadius: bgRadius,
              bgHeight: bgHeight,
            ),
          ],
        );
      },
    );
  }

  double _resolveWidth(
    BoxConstraints constraints,
    BuildContext context,
    double inset,
  ) {
    if (constraints.hasBoundedWidth && constraints.maxWidth.isFinite) {
      return (constraints.maxWidth - inset).clamp(0.0, double.infinity);
    }
    return FinalSize.width(context) - inset;
  }

  Widget _buildLabel(double effectiveFontSize) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: (effectiveFontSize * 0.93).clamp(12, 18),
              fontWeight: FontWeight.w500,
              color: ColorSet.tileFontColor,
              fontFamily: AppTextTheme.fontFamily,
            ),
          ),
          if (isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(
                fontSize: (effectiveFontSize * 0.93).clamp(12, 18),
                fontWeight: FontWeight.w500,
                color: ColorSet.snackBarErrorBg,
                fontFamily: AppTextTheme.fontFamily,
              ),
            ),
        ],
      ),
    );
  }
}
