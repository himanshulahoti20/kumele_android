import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive_breakpoints.dart';
import 'package:kuemele/core/responsive/responsive_layout.dart';

/// Snapshot of the current screen layout used across the app.
class ResponsiveData {
  const ResponsiveData({
    required this.layout,
    required this.deviceClass,
    required this.orientation,
    required this.screenSize,
    required this.shortestSide,
    required this.longestSide,
    required this.designSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.contentMaxWidth,
    required this.gutter,
    required this.gridColumns,
    required this.scale,
    required this.devicePixelRatio,
  });

  final ResponsiveLayout layout;
  final DeviceClass deviceClass;
  final Orientation orientation;
  final Size screenSize;
  final double shortestSide;
  final double longestSide;
  final double devicePixelRatio;

  /// Design canvas passed to [ScreenUtilInit].
  final Size designSize;
  final double horizontalPadding;
  final double verticalPadding;

  /// Maximum content width for centered tablet layouts. Null on phones.
  final double? contentMaxWidth;
  final double gutter;
  final int gridColumns;
  final double scale;

  bool get isPhone => deviceClass == DeviceClass.phone;
  bool get isTablet => deviceClass == DeviceClass.tablet;
  bool get isLargeTablet => shortestSide >= ResponsiveBreakpoints.largeTablet;
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  double get physicalWidth => screenSize.width * devicePixelRatio;
  double get physicalHeight => screenSize.height * devicePixelRatio;

  EdgeInsets get screenPadding => EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      );

  EdgeInsets tabletSymmetric({
    double vertical = 0,
    double? horizontal,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal ?? horizontalPadding,
      vertical: vertical,
    );
  }

  /// Pick a value for the active layout. Falls back in order:
  /// exact layout -> same device class portrait/landscape -> mobile portrait.
  T pick<T>({
    required T mobilePortrait,
    T? mobileLandscape,
    T? tabletPortrait,
    T? tabletLandscape,
  }) {
    return switch (layout) {
      ResponsiveLayout.mobilePortrait => mobilePortrait,
      ResponsiveLayout.mobileLandscape => mobileLandscape ?? mobilePortrait,
      ResponsiveLayout.tabletPortrait => tabletPortrait ?? mobilePortrait,
      ResponsiveLayout.tabletLandscape =>
        tabletLandscape ?? tabletPortrait ?? mobileLandscape ?? mobilePortrait,
    };
  }

  double sp(double value) => value * scale;

  double w(double value) {
    if (!value.isFinite) return value;
    return value * (screenSize.width / designSize.width);
  }

  double h(double value) {
    if (!value.isFinite) return value;
    return value * (screenSize.height / designSize.height);
  }

  /// Debug summary for console logging.
  String get debugSummary => '${layout.label} ($layout)\n'
      '  logical: ${screenSize.width.toStringAsFixed(1)} x '
      '${screenSize.height.toStringAsFixed(1)}\n'
      '  physical: ${physicalWidth.toStringAsFixed(0)} x '
      '${physicalHeight.toStringAsFixed(0)} '
      '(${devicePixelRatio.toStringAsFixed(2)}x DPR)\n'
      '  device: $deviceClass | orientation: $orientation | '
      'shortest: ${shortestSide.toStringAsFixed(1)} | '
      'longest: ${longestSide.toStringAsFixed(1)}\n'
      '  design: ${designSize.width.toStringAsFixed(0)} x '
      '${designSize.height.toStringAsFixed(0)} | '
      'scale: ${scale.toStringAsFixed(2)} | '
      'grid: $gridColumns cols';

  bool debugEquals(ResponsiveData other) {
    return layout == other.layout &&
        screenSize == other.screenSize &&
        devicePixelRatio == other.devicePixelRatio;
  }
}
