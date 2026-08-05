import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive_data.dart';

class SwipeCardLayout {
  const SwipeCardLayout(this.responsive);

  final ResponsiveData responsive;

  double get borderRadius => responsive.w(28);

  double get imageHeight => responsive.screenSize.height * imageHeightFactor;

  double get imageHeightFactor => responsive.pick(
        mobilePortrait: 0.32,
        mobileLandscape: 0.28,
        tabletPortrait: 0.28,
        tabletLandscape: 0.24,
      );

  double get landscapeImageWidth => responsive.pick(
        mobilePortrait: responsive.w(130),
        mobileLandscape: responsive.w(130),
        tabletPortrait: responsive.w(160),
        tabletLandscape: responsive.w(160),
      );

  double get landscapeImageHeight => responsive.pick(
        mobilePortrait: responsive.h(170),
        mobileLandscape: responsive.h(170),
        tabletPortrait: responsive.h(150),
        tabletLandscape: responsive.h(150),
      );

  double get infoIconSize => responsive.pick(
        mobilePortrait: responsive.w(23),
        mobileLandscape: responsive.w(18),
        tabletPortrait: responsive.w(16),
        tabletLandscape: responsive.w(13),
      );

  double get infoChipSpacing => responsive.pick(
        mobilePortrait: responsive.w(8),
        mobileLandscape: responsive.w(10),
        tabletPortrait: responsive.w(10),
        tabletLandscape: responsive.w(12),
      );

  double get titleToInfoGap => responsive.pick(
        mobilePortrait: responsive.h(34),
        mobileLandscape: responsive.h(20),
        tabletPortrait: responsive.h(24),
        tabletLandscape: responsive.h(18),
      );

  double get shareButtonSize => responsive.w(36);

  double get shareIconSize => responsive.w(20);

  double get expandButtonSize => responsive.w(40);

  double get categoryTagTop => responsive.h(15);

  double get categoryTagRight => responsive.w(10);

  double get titleFontSize => responsive.pick(
        mobilePortrait: responsive.sp(27),
        mobileLandscape: responsive.sp(22),
        tabletPortrait: responsive.sp(20),
        tabletLandscape: responsive.sp(17),
      );

  double get bodyFontSize => responsive.pick(
        mobilePortrait: responsive.sp(19),
        mobileLandscape: responsive.sp(16),
        tabletPortrait: responsive.sp(14),
        tabletLandscape: responsive.sp(12),
      );

  double get sectionTitleFontSize => responsive.sp(21);

  double get relatedEventsListHeight => responsive.h(250);

  double get swiperBottomPaddingCollapsed => responsive.h(20);

  double get swiperTopPadding => responsive.h(25);

  double get swiperExpandedBottomPadding => responsive.h(10);

  double get stackBottomInset => responsive.h(45);

  double get expandedTopGap => responsive.h(12);

  double get expandedSectionGap => responsive.h(16);

  double get expandedSectionGapSmall => responsive.h(12);

  EdgeInsets get contentPadding => EdgeInsets.fromLTRB(
        responsive.w(16),
        responsive.h(16),
        responsive.w(16),
        responsive.h(12),
      );

  EdgeInsets get landscapeContentPadding => EdgeInsets.fromLTRB(
        responsive.w(12),
        responsive.h(12),
        responsive.w(12),
        responsive.h(10),
      );

  EdgeInsets get expandedContentPadding => EdgeInsets.fromLTRB(
        responsive.w(16),
        responsive.h(16),
        responsive.w(16),
        responsive.h(8),
      );

  Duration get animationDuration => const Duration(milliseconds: 400);
}
