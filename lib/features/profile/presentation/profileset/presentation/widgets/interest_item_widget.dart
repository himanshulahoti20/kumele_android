import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/entities/hobby_interest.dart';
import 'package:kuemele/features/profile/presentation/profileset/presentation/widgets/hobby_icon_widget.dart';

class InterestItemWidget extends StatelessWidget {
  final HobbyInterest interest;
  final bool isSelected;
  final bool disabled;
  final VoidCallback? onTap;

  const InterestItemWidget({
    super.key,
    required this.interest,
    required this.isSelected,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor =
        isSelected ? ColorSet.specialYellowColor : ColorSet.tileFillColor;
    final contentColor =
        isSelected ? ColorSet.textColor : ColorSet.tileFontColor;
    final opacity = disabled ? 0.5 : 1.0;
    // Dark mode: selected items show darker icon for visual distinction.
    // Light mode: always neutral icon color.
    final isDarkMode = ColorSet.isDarkMode;
    final iconColor =
        isDarkMode && isSelected ? Colors.black : ColorSet.tileFontColor;

    return Opacity(
      opacity: opacity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HobbyIconWidget(
                  hobby: interest,
                  size: 40.w,
                  color: iconColor,
                  showBadge: false,
                ),
                Gap(8.h),
                Text(
                  interest.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: (isSelected
                          ? context.textTheme.labelSmallSemiBold
                          : context.textTheme.labelSmall)
                      .copyWith(
                    color: contentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
