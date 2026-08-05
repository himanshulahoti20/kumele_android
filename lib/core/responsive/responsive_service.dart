import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive_breakpoints.dart';
import 'package:kuemele/core/responsive/responsive_data.dart';
import 'package:kuemele/core/responsive/responsive_layout.dart';

class ResponsiveService {
  const ResponsiveService();

  ResponsiveData fromContext(BuildContext context) {
    return fromMediaQuery(MediaQuery.of(context));
  }

  ResponsiveData fromMediaQuery(MediaQueryData mediaQuery) {
    final screenSize = mediaQuery.size;
    final shortestSide = screenSize.shortestSide;
    final longestSide = screenSize.longestSide;
    final orientation = mediaQuery.orientation;

    final deviceClass = shortestSide >= ResponsiveBreakpoints.tablet
        ? DeviceClass.tablet
        : DeviceClass.phone;

    final layout =
        _resolveLayout(deviceClass: deviceClass, orientation: orientation);
    final designSize = _designSizeFor(layout);
    final horizontalPadding = _horizontalPaddingFor(layout);
    final verticalPadding = deviceClass == DeviceClass.tablet
        ? ResponsiveBreakpoints.tabletVerticalPadding
        : ResponsiveBreakpoints.phoneVerticalPadding;

    return ResponsiveData(
      layout: layout,
      deviceClass: deviceClass,
      orientation: orientation,
      screenSize: screenSize,
      shortestSide: shortestSide,
      longestSide: longestSide,
      designSize: designSize,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
      contentMaxWidth: deviceClass == DeviceClass.tablet
          ? _tabletContentMaxWidth(screenSize.width, horizontalPadding)
          : null,
      gutter: deviceClass == DeviceClass.tablet ? 20 : 12,
      gridColumns: _gridColumnsFor(layout),
      scale: shortestSide / designSize.shortestSide,
      devicePixelRatio: mediaQuery.devicePixelRatio,
    );
  }

  ResponsiveLayout _resolveLayout({
    required DeviceClass deviceClass,
    required Orientation orientation,
  }) {
    return switch ((deviceClass, orientation)) {
      (DeviceClass.phone, Orientation.portrait) =>
        ResponsiveLayout.mobilePortrait,
      (DeviceClass.phone, Orientation.landscape) =>
        ResponsiveLayout.mobileLandscape,
      (DeviceClass.tablet, Orientation.portrait) =>
        ResponsiveLayout.tabletPortrait,
      (DeviceClass.tablet, Orientation.landscape) =>
        ResponsiveLayout.tabletLandscape,
    };
  }

  Size _designSizeFor(ResponsiveLayout layout) {
    return switch (layout) {
      ResponsiveLayout.mobilePortrait =>
        ResponsiveBreakpoints.phonePortraitDesign,
      ResponsiveLayout.mobileLandscape =>
        ResponsiveBreakpoints.phoneLandscapeDesign,
      ResponsiveLayout.tabletPortrait =>
        ResponsiveBreakpoints.tabletPortraitDesign,
      ResponsiveLayout.tabletLandscape =>
        ResponsiveBreakpoints.tabletLandscapeDesign,
    };
  }

  double _horizontalPaddingFor(ResponsiveLayout layout) {
    return switch (layout) {
      ResponsiveLayout.mobilePortrait =>
        ResponsiveBreakpoints.phoneHorizontalPadding,
      ResponsiveLayout.mobileLandscape =>
        ResponsiveBreakpoints.phoneLandscapeHorizontalPadding,
      ResponsiveLayout.tabletPortrait =>
        ResponsiveBreakpoints.tabletHorizontalPadding,
      ResponsiveLayout.tabletLandscape =>
        ResponsiveBreakpoints.tabletLandscapeHorizontalPadding,
    };
  }

  int _gridColumnsFor(ResponsiveLayout layout) {
    return switch (layout) {
      ResponsiveLayout.mobilePortrait => ResponsiveBreakpoints.phoneGridColumns,
      ResponsiveLayout.mobileLandscape =>
        ResponsiveBreakpoints.phoneLandscapeGridColumns,
      ResponsiveLayout.tabletPortrait =>
        ResponsiveBreakpoints.tabletPortraitGridColumns,
      ResponsiveLayout.tabletLandscape =>
        ResponsiveBreakpoints.tabletLandscapeGridColumns,
    };
  }

  double? _tabletContentMaxWidth(double screenWidth, double horizontalPadding) {
    final maxWidth = screenWidth - (horizontalPadding * 2);
    return maxWidth.clamp(640, 960);
  }
}
