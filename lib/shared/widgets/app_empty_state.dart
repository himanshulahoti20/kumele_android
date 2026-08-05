import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.iconPath,
    this.action,
  });

  final String title;
  final String description;
  final Widget? icon;
  final String? iconPath;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              Gap(24.h),
            ] else if (iconPath != null) ...[
              Image.asset(
                iconPath!,
                width: 120.w,
                height: 120.w,
              ),
              Gap(24.h),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.titleLarge.copyWith(
                color: ColorSet.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(12.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium.copyWith(
                color: ColorSet.subTextColor,
              ),
            ),
            if (action != null) ...[
              Gap(32.h),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
