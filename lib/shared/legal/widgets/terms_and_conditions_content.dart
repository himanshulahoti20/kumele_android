import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/legal/terms_and_conditions_data.dart';

class TermsAndConditionsContent extends StatelessWidget {
  const TermsAndConditionsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TermsAndConditionsData.documentTitle,
          style: context.textTheme.titleLargeBold.copyWith(
            color: ColorSet.textColor,
          ),
        ),
        Gap(8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: ColorSet.tileFillColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            TermsAndConditionsData.lastUpdated,
            style: context.textTheme.bodySmall.copyWith(
              color: ColorSet.lightBlueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Gap(20.h),
        Text(
          TermsAndConditionsData.introduction,
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.textColor,
            height: 1.5,
          ),
        ),
        Gap(24.h),
        ...TermsAndConditionsData.sections.map(
          (section) => Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _TermsSectionCard(section: section),
          ),
        ),
      ],
    );
  }
}

class _TermsSectionCard extends StatelessWidget {
  const _TermsSectionCard({required this.section});

  final TermsSection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorSet.border.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: context.textTheme.bodyLargeSemiBold.copyWith(
              color: ColorSet.textColor,
            ),
          ),
          Gap(10.h),
          Text(
            section.body,
            style: context.textTheme.bodyMedium.copyWith(
              color: ColorSet.textColor.withValues(alpha: 0.88),
              height: 1.55,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
