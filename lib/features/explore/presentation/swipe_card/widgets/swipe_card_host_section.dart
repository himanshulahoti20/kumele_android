import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_shadows.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class SwipeCardHostSection extends StatelessWidget {
  const SwipeCardHostSection({super.key, required this.detail});

  final ExploreEventDetail detail;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final hostName = detail.hostName;
    final hostBio = detail.hostProfile.bio?.trim() ?? '';
    final avatarPath = detail.hostProfile.avatarUrl;
    final hostRating = detail.averageHostRating ??
        detail.averageEventRating ??
        ExploreConfig.swipeCardDefaultHostRating;
    final avatarSize = responsive.w(
      responsive.pick(
        mobilePortrait: 96.0,
        tabletPortrait: 108.0,
      ),
    );
    final avatarOverlap = avatarSize * 0.48;
    final followersCount = ExploreConfig.swipeCardDefaultFollowers;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.only(top: avatarOverlap),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorSet.hostTileColor,
              borderRadius: BorderRadius.circular(responsive.w(24)),
              boxShadow: AppShadows.primary,
            ),
            padding: EdgeInsets.fromLTRB(
              responsive.w(16),
              avatarOverlap + responsive.h(12),
              responsive.w(16),
              responsive.h(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HostTitleRow(responsive: responsive),
                if (hostBio.isNotEmpty) ...[
                  Gap(responsive.h(10)),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'About $hostName: ',
                          style: context.textTheme.bodyLargeBold.copyWith(
                            color: ColorSet.textColor,
                            fontSize: responsive.sp(15),
                          ),
                        ),
                        TextSpan(
                          text: hostBio,
                          style: context.textTheme.bodyLargeLight.copyWith(
                            fontSize: responsive.sp(15),
                            color: ColorSet.textColor,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: avatarSize,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: ExploreConfig.hostStatsBannerMargin(avatarSize),
                  ),
                  child: _HostStatsBanner(
                    contentPaddingLeft:
                        ExploreConfig.hostStatsBannerContentPadding(avatarSize),
                    followersCount: followersCount,
                    hostRating: hostRating,
                  ),
                ),
                AppAvatar(
                  imageUrl: avatarPath,
                  name: hostName,
                  size: responsive.pick(
                    mobilePortrait: 96.0,
                    tabletPortrait: 108.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HostTitleRow extends StatelessWidget {
  const _HostTitleRow({required this.responsive});

  final ResponsiveData responsive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          ExploreConfig.swipeCardHostLabel,
          style: context.textTheme.titleLargeBold.copyWith(
            fontSize: responsive.sp(18),
            color: ColorSet.textColor,
          ),
        ),
        Gap(responsive.w(12)),
        const _HostMedalBadge(),
        Gap(responsive.w(6)),
        Text(
          ExploreConfig.swipeCardHostMedalTierLabel,
          style: context.textTheme.bodyLargeLight.copyWith(
            fontSize: responsive.sp(17),
            color: ColorSet.textColor,
          ),
        ),
      ],
    );
  }
}

class _HostMedalBadge extends StatelessWidget {
  const _HostMedalBadge();

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final medalSize = responsive.w(25);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: responsive.h(8),
            right: responsive.w(10),
          ),
          child: KumeleAssetWidget.square(
            assetPath: Assets.icons.medalPng.path,
            size: medalSize,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(responsive.w(4)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorSet.specialYellowColor,
            ),
            child: Text(
              '${ExploreConfig.swipeCardHostMedalBadgeCount}',
              style: context.textTheme.labelSmallBold.copyWith(
                fontSize: responsive.sp(12),
                color: ColorSet.textColor,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HostStatsBanner extends StatelessWidget {
  const _HostStatsBanner({
    required this.contentPaddingLeft,
    required this.followersCount,
    required this.hostRating,
  });

  final double contentPaddingLeft;
  final int followersCount;
  final double hostRating;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      padding: EdgeInsets.fromLTRB(
        contentPaddingLeft,
        responsive.h(6),
        responsive.w(10),
        responsive.h(6),
      ),
      decoration: BoxDecoration(
        color: ColorSet.specialYellowColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(responsive.w(8)),
          bottomRight: Radius.circular(responsive.w(8)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$followersCount ${ExploreConfig.swipeCardFollowersSuffix}',
            style: context.textTheme.titleLargeBold.copyWith(
              fontSize: responsive.sp(17),
              color: ColorSet.textColor,
              height: 1.1,
            ),
          ),
          Gap(responsive.h(2)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              KumeleAssetWidget.square(
                assetPath: Assets.icons.star.path,
                size: responsive.w(15),
                color: ColorSet.textColor,
              ),
              Gap(responsive.w(4)),
              Text(
                '${hostRating.toStringAsFixed(1)} ${ExploreConfig.swipeCardOverallRatingsLabel}',
                style: context.textTheme.bodySmallLight.copyWith(
                  fontSize: responsive.sp(12),
                  color: ColorSet.textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
