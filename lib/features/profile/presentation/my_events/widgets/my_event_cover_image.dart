import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/event_card/widgets/category_tag.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class MyEventCoverImage extends StatelessWidget {
  const MyEventCoverImage({
    super.key,
    required this.detail,
  });

  final ExploreEventDetail detail;

  @override
  Widget build(BuildContext context) {
    final imageUrl = detail.primaryImageUrl;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            height: 220.h,
            width: double.infinity,
            color: ColorSet.tileFillColor,
            child: imageUrl.isNotEmpty
                ? KumeleAssetWidget(
                    assetPath: imageUrl,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 48.r,
                      color: ColorSet.subTextColor,
                    ),
                  ),
          ),
        ),
        Positioned(
          bottom: 12.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              detail.displayPrice,
              style: context.textTheme.labelMediumBold.copyWith(
                color: Colors.white,
                fontSize: 13.sp,
              ),
            ),
          ),
        ),
        if (detail.primaryHobby.isNotEmpty)
          Positioned(
            top: 12.h,
            right: 12.w,
            child: CategoryTag(
              label: detail.primaryHobby,
            ),
          ),
      ],
    );
  }
}
