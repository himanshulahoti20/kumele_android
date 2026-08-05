import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class BlogHeader extends StatelessWidget {
  const BlogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.blogsTitle,
      style: context.textTheme.headlineSmallBold.copyWith(
        color: ColorSet.textColor,
        fontSize: 23.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
