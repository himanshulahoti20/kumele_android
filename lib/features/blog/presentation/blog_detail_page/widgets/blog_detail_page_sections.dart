import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';

class BlogDetailMetaRow extends StatelessWidget {
  const BlogDetailMetaRow({
    super.key,
    required this.authorName,
    required this.dateLabel,
    required this.readingTimeLabel,
  });

  final String authorName;
  final String dateLabel;
  final String readingTimeLabel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 10.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16.r,
              backgroundColor: ColorSet.bg2Color,
              child: Text(
                authorName.isNotEmpty ? authorName[0].toUpperCase() : '?',
                style: context.textTheme.bodyMedium.copyWith(
                  color: ColorSet.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Gap(10.w),
            Text(
              authorName,
              style: context.textTheme.bodyMedium.copyWith(
                color: ColorSet.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        BlogDetailPill(label: dateLabel),
        BlogDetailPill(label: readingTimeLabel),
      ],
    );
  }
}

enum BlogDetailSocialAction {
  like,
  youtube,
  facebook,
  instagram,
  pinterest,
  twitter,
  share,
}

class BlogDetailSocialActionsRow extends StatelessWidget {
  const BlogDetailSocialActionsRow({
    super.key,
    required this.likeCount,
    this.isLiked = false,
    this.onActionTap,
  });

  final int likeCount;
  final bool isLiked;
  final ValueChanged<BlogDetailSocialAction>? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14.w,
      runSpacing: 10.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppRoundedIconButton(
              assetPath: Assets.icons.blogs.heart.path,
              onTap: () => onActionTap?.call(BlogDetailSocialAction.like),
              iconSize: 22,
              padding: 6,
              semanticLabel: AppLocalizations.of(context)!.blogLikePostSemanticLabel,
              backgroundColor: ColorSet.bg2Color,
              pressedColor: ColorSet.tileFillColor,
              iconColor: isLiked ? ColorSet.specialYellowColor : null,
            ),
            Gap(10.w),
            Text(
              '$likeCount ${AppLocalizations.of(context)!.blogLikesLabel}',
              style: context.textTheme.titleMedium.copyWith(
                color: ColorSet.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        _SocialActionButton(
          assetPath: Assets.icons.blogs.youtube.path,
          label: 'YouTube',
          onTap: () => onActionTap?.call(BlogDetailSocialAction.youtube),
        ),
        _SocialActionButton(
          assetPath: Assets.icons.blogs.facebook.path,
          label: 'Facebook',
          onTap: () => onActionTap?.call(BlogDetailSocialAction.facebook),
        ),
        _SocialActionButton(
          assetPath: Assets.icons.blogs.instagram.path,
          label: 'Instagram',
          onTap: () => onActionTap?.call(BlogDetailSocialAction.instagram),
        ),
        _SocialActionButton(
          assetPath: Assets.icons.blogs.pinterest.path,
          label: 'Pinterest',
          onTap: () => onActionTap?.call(BlogDetailSocialAction.pinterest),
        ),
        _SocialActionButton(
          assetPath: Assets.icons.blogs.twitter.path,
          label: 'Twitter',
          onTap: () => onActionTap?.call(BlogDetailSocialAction.twitter),
        ),
        _SocialActionButton(
          assetPath: Assets.icons.blogs.share.path,
          label: AppLocalizations.of(context)!.blogShareLabel,
          onTap: () => onActionTap?.call(BlogDetailSocialAction.share),
        ),
      ],
    );
  }
}

class BlogDetailInfoCard extends StatelessWidget {
  const BlogDetailInfoCard({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.titleSmallBold.copyWith(
              color: ColorSet.textColor,
            ),
          ),
          Gap(10.h),
          child,
        ],
      ),
    );
  }
}

class _SocialActionButton extends StatelessWidget {
  const _SocialActionButton({
    required this.assetPath,
    required this.label,
    required this.onTap,
  });

  final String assetPath;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppRoundedIconButton(
      assetPath: assetPath,
      onTap: onTap,
      iconSize: 20,
      padding: 10,
      backgroundColor: ColorSet.bg2Color,
      pressedColor: ColorSet.tileFillColor,
      semanticLabel: label,
    );
  }
}

class BlogDetailStatsRow extends StatelessWidget {
  const BlogDetailStatsRow({
    super.key,
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BlogDetailStatCard(
            label: leftLabel,
            value: leftValue,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: BlogDetailStatCard(
            label: rightLabel,
            value: rightValue,
          ),
        ),
      ],
    );
  }
}

class BlogDetailStatCard extends StatelessWidget {
  const BlogDetailStatCard({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: context.textTheme.headlineMediumBold.copyWith(
              color: ColorSet.textColor,
            ),
          ),
          Gap(4.h),
          Text(
            label,
            style: context.textTheme.bodyMedium.copyWith(
              color: ColorSet.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class BlogDetailDetailLine extends StatelessWidget {
  const BlogDetailDetailLine({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: context.textTheme.bodyMedium.copyWith(
              color: ColorSet.textColor.withValues(alpha: 0.7),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.textTheme.bodyMedium.copyWith(
              color: ColorSet.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class BlogDetailPill extends StatelessWidget {
  const BlogDetailPill({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: context.textTheme.bodySmall.copyWith(
          color: ColorSet.textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
