import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/utils/conversion_utils.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';
import 'package:kuemele/shared/widgets/app_loading_indicator.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class BlogShareBottomSheet extends StatefulWidget {
  const BlogShareBottomSheet({super.key, required this.blog});

  final BlogPostModel blog;

  static Future<void> show(BuildContext context, BlogPostModel blog) {
    return AppBottomSheet.show(
      context: context,
      titleWidget: Text(
        blog.title,
        style: context.textTheme.titleMediumBold.copyWith(
          color: ColorSet.textColor,
          fontSize: 17.sp,
          height: 1.25,
        ),
      ),
      child: BlogShareBottomSheet(blog: blog),
    );
  }

  @override
  State<BlogShareBottomSheet> createState() => _BlogShareBottomSheetState();
}

class _BlogShareBottomSheetState extends State<BlogShareBottomSheet> {
  bool _isCopying = false;

  Future<void> _copyLink() async {
    if (_isCopying) return;
    setState(() => _isCopying = true);

    try {
      final url = await InjectionHelper.blogRepository.getShareUrl(
        widget.blog.id,
      );
      await Clipboard.setData(ClipboardData(text: url));
      if (!mounted) return;
      InjectionHelper.snackBar
          .showSuccess(AppLocalizations.of(context)!.copiedMessage);
    } catch (_) {
      if (!mounted) return;
      InjectionHelper.snackBar.showError(
        AppLocalizations.of(context)!.somethingWentWrong,
      );
    } finally {
      if (mounted) setState(() => _isCopying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final blog = widget.blog;
    final parsedDate = ConversionUtils.parseDateTime(blog.createdAt);
    final dateLabel = parsedDate != null
        ? ConversionUtils.formatDateTime(parsedDate, 'dd MMMM, yyyy')
        : blog.createdAt;
    final category = blog.hobbyCategory?.name.trim();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                KumeleAssetWidget(
                  assetPath: (blog.coverImage?.trim().isNotEmpty ?? false)
                      ? blog.coverImage!
                      : IconSet.blogDefaultImage,
                  fit: BoxFit.cover,
                ),
                if (category != null && category.isNotEmpty)
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.78),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome,
                              color: Colors.white, size: 14.r),
                          SizedBox(width: 6.w),
                          Text(
                            category,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Gap(12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: ColorSet.tileFillColor,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              AppAvatar(
                imageUrl: blog.author.avatar,
                name: blog.author.displayName,
                size: 48.r,
                showShadow: false,
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoLine(label: 'Author', value: blog.author.displayName),
                    Gap(4.h),
                    _InfoLine(label: 'Published Date', value: dateLabel),
                  ],
                ),
              ),
            ],
          ),
        ),
        Gap(8.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: ColorSet.tileFillColor,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.howItWorks,
                style: context.textTheme.titleMediumBold.copyWith(
                  color: ColorSet.textColor,
                  fontSize: 15.sp,
                ),
              ),
              Gap(8.h),
              Text(
                '1. Click Url to open blog',
                style: context.textTheme.bodyMedium.copyWith(
                  color: ColorSet.textColor,
                  height: 1.4,
                ),
              ),
              Gap(4.h),
              Text(
                '2. Or search blog when logged in - to like',
                style: context.textTheme.bodyMedium.copyWith(
                  color: ColorSet.textColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        Gap(20.h),
        Text(
          AppLocalizations.of(context)!.inviteFriendsAndFamily,
          style: context.textTheme.titleMedium.copyWith(
            color: ColorSet.textColor,
          ),
        ),
        Gap(12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _copyLink,
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 28.r,
                    height: 28.r,
                    child: _isCopying
                        ? AppLoadingIndicator.circle(
                            size: 18.r,
                            color: ColorSet.textColor,
                          )
                        : Icon(
                            Icons.copy_outlined,
                            size: 20.r,
                            color: ColorSet.textColor,
                          ),
                  ),
                  Gap(8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.copyTo,
                        style: context.textTheme.labelSmall.copyWith(
                          color: ColorSet.textColor,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.clipboard,
                        style: context.textTheme.labelSmall.copyWith(
                          color: ColorSet.textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            KumeleAssetWidget(
              assetPath: 'assets/svg/icon_family.svg',
              width: 40.w,
              height: 40.w,
              color: ColorSet.specialYellowColor,
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: context.textTheme.bodyMedium.copyWith(
          color: ColorSet.textColor,
          fontSize: 14.sp,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
