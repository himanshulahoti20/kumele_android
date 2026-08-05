import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class AppTextTheme {
  static const String fontFamily = 'PlusJakartaSans';

  static TextStyle _base({
    required FontWeight fontWeight,
    required double fontSize,
  }) =>
      TextStyle(
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: ColorSet.tileFontColor,
      );

  // w300 (Light)
  static TextStyle get displayLargeLight =>
      _base(fontWeight: FontWeight.w300, fontSize: 57.sp);

  static TextStyle get displayMediumLight =>
      _base(fontWeight: FontWeight.w300, fontSize: 45.sp);

  static TextStyle get displaySmallLight =>
      _base(fontWeight: FontWeight.w300, fontSize: 36.sp);

  static TextStyle get headlineLargeLight =>
      _base(fontWeight: FontWeight.w300, fontSize: 32.sp);

  static TextStyle get headlineMediumLight =>
      _base(fontWeight: FontWeight.w300, fontSize: 28.sp);

  static TextStyle get headlineSmallLight =>
      _base(fontWeight: FontWeight.w300, fontSize: 24.sp);

  static TextStyle get titleLargeLight =>
      _base(fontWeight: FontWeight.w300, fontSize: 22.sp);

  static TextStyle get bodyLargeLight =>
      _base(fontWeight: FontWeight.w300, fontSize: 16.sp);

  static TextStyle get bodyMediumLight =>
      _base(fontWeight: FontWeight.w300, fontSize: 14.sp);

  static TextStyle get bodySmallLight =>
      _base(fontWeight: FontWeight.w300, fontSize: 12.sp);

  // w400 (Regular)
  static TextStyle get displayLarge =>
      _base(fontWeight: FontWeight.w400, fontSize: 57.sp);

  static TextStyle get displayMedium =>
      _base(fontWeight: FontWeight.w400, fontSize: 45.sp);

  static TextStyle get displaySmall =>
      _base(fontWeight: FontWeight.w400, fontSize: 36.sp);

  static TextStyle get headlineLarge =>
      _base(fontWeight: FontWeight.w400, fontSize: 32.sp);

  static TextStyle get headlineMedium =>
      _base(fontWeight: FontWeight.w400, fontSize: 28.sp);

  static TextStyle get headlineSmall =>
      _base(fontWeight: FontWeight.w400, fontSize: 24.sp);

  static TextStyle get titleLarge =>
      _base(fontWeight: FontWeight.w400, fontSize: 22.sp);

  static TextStyle get bodyLarge =>
      _base(fontWeight: FontWeight.w400, fontSize: 16.sp);

  static TextStyle get bodyMedium =>
      _base(fontWeight: FontWeight.w400, fontSize: 14.sp);

  static TextStyle get bodySmall =>
      _base(fontWeight: FontWeight.w400, fontSize: 12.sp);

  // w500 (Medium)
  static TextStyle get titleMedium =>
      _base(fontWeight: FontWeight.w500, fontSize: 16.sp);

  static TextStyle get labelLarge =>
      _base(fontWeight: FontWeight.w500, fontSize: 14.sp);

  static TextStyle get titleSmall =>
      _base(fontWeight: FontWeight.w500, fontSize: 14.sp);

  static TextStyle get labelMedium =>
      _base(fontWeight: FontWeight.w500, fontSize: 12.sp);

  static TextStyle get labelSmall =>
      _base(fontWeight: FontWeight.w500, fontSize: 11.sp);

  // w600 (SemiBold)
  static TextStyle get displayLargeSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 57.sp);

  static TextStyle get displayMediumSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 45.sp);

  static TextStyle get displaySmallSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 36.sp);

  static TextStyle get headlineLargeSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 32.sp);

  static TextStyle get headlineMediumSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 28.sp);

  static TextStyle get headlineSmallSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 24.sp);

  static TextStyle get titleLargeSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 22.sp);

  static TextStyle get heading3 =>
      _base(fontWeight: FontWeight.w600, fontSize: 20.sp);

  static TextStyle get titleMediumSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 16.sp);

  static TextStyle get buttonText =>
      _base(fontWeight: FontWeight.w600, fontSize: 16.sp);

  static TextStyle get bodyLargeSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 16.sp);

  static TextStyle get bodyMediumSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 14.sp);

  static TextStyle get titleSmallSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 14.sp);

  static TextStyle get labelLargeSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 14.sp);

  static TextStyle get bodySmallSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 12.sp);

  static TextStyle get labelMediumSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 12.sp);

  static TextStyle get labelSmallSemiBold =>
      _base(fontWeight: FontWeight.w600, fontSize: 11.sp);

  // w700 (Bold)
  static TextStyle get displayLargeBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 57.sp);

  static TextStyle get displayMediumBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 45.sp);

  static TextStyle get displaySmallBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 36.sp);

  static TextStyle get headlineLargeBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 32.sp);

  static TextStyle get headlineMediumBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 28.sp);

  static TextStyle get heading2 =>
      _base(fontWeight: FontWeight.w700, fontSize: 25.sp);

  static TextStyle get headlineSmallBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 24.sp);

  static TextStyle get titleLargeBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 22.sp);

  static TextStyle get titleMediumBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 18.sp);

  static TextStyle get bodyLargeBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 16.sp);

  static TextStyle get bodyMediumBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 14.sp);

  static TextStyle get titleSmallBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 14.sp);

  static TextStyle get labelLargeBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 14.sp);

  static TextStyle get bodySmallBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 12.sp);

  static TextStyle get labelMediumBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 12.sp);

  static TextStyle get labelSmallBold =>
      _base(fontWeight: FontWeight.w700, fontSize: 11.sp);

  // w800 (ExtraBold)
  static TextStyle get heading1 =>
      _base(fontWeight: FontWeight.w800, fontSize: 32.sp);
}
