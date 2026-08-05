import 'package:flutter/material.dart';

/// Breakpoints and design canvases for native mobile/tablet layouts.
abstract final class ResponsiveBreakpoints {
  static const double tablet = 600;

  static const double largeTablet = 840;

  static const Size phonePortraitDesign = Size(375, 812);
  static const Size phoneLandscapeDesign = Size(812, 375);
  static const Size tabletPortraitDesign = Size(834, 1194);
  static const Size tabletLandscapeDesign = Size(1194, 834);

  static const double phoneHorizontalPadding = 16;
  static const double phoneLandscapeHorizontalPadding = 24;
  static const double tabletHorizontalPadding = 40;
  static const double tabletLandscapeHorizontalPadding = 56;

  static const double phoneVerticalPadding = 16;
  static const double tabletVerticalPadding = 24;

  static const int phoneGridColumns = 2;
  static const int phoneLandscapeGridColumns = 3;
  static const int tabletPortraitGridColumns = 3;
  static const int tabletLandscapeGridColumns = 4;
}
