import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_shadows.dart';

class MyEventRulesSection extends StatelessWidget {
  const MyEventRulesSection({
    super.key,
    required this.detail,
  });

  final ExploreEventDetail detail;

  @override
  Widget build(BuildContext context) {
    final rules = detail.eventRules;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Rules & Info',
            style: context.textTheme.titleMediumBold.copyWith(
              color: ColorSet.textColor,
              fontSize: 16.sp,
            ),
          ),
          Gap(10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              if (rules.minAge != null || rules.maxAge != null)
                _RuleChip(
                  icon: Icons.cake_outlined,
                  label:
                      'Age: ${rules.minAge ?? 0} - ${rules.maxAge ?? 'No limit'}',
                ),
              if (rules.genderRestriction != null &&
                  rules.genderRestriction!.isNotEmpty)
                _RuleChip(
                  icon: Icons.people_outline,
                  label: 'Gender: ${rules.genderRestriction}',
                ),
              if (rules.languagePreference != null &&
                  rules.languagePreference!.isNotEmpty)
                _RuleChip(
                  icon: Icons.language_outlined,
                  label: 'Language: ${rules.languagePreference}',
                ),
              if (rules.requiresApproval)
                const _RuleChip(
                  icon: Icons.verified_user_outlined,
                  label: 'Requires Host Approval',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RuleChip extends StatelessWidget {
  const _RuleChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: ColorSet.textColor),
          Gap(6.w),
          Text(
            label,
            style: context.textTheme.bodySmall.copyWith(
              color: ColorSet.textColor,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
