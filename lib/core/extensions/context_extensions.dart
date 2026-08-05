import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';

class AppTextThemeStyles {
  const AppTextThemeStyles();

  // w300 (Light)
  TextStyle get displayLargeLight => AppTextTheme.displayLargeLight;
  TextStyle get displayMediumLight => AppTextTheme.displayMediumLight;
  TextStyle get displaySmallLight => AppTextTheme.displaySmallLight;
  TextStyle get headlineLargeLight => AppTextTheme.headlineLargeLight;
  TextStyle get headlineMediumLight => AppTextTheme.headlineMediumLight;
  TextStyle get headlineSmallLight => AppTextTheme.headlineSmallLight;
  TextStyle get titleLargeLight => AppTextTheme.titleLargeLight;
  TextStyle get bodyLargeLight => AppTextTheme.bodyLargeLight;
  TextStyle get bodyMediumLight => AppTextTheme.bodyMediumLight;
  TextStyle get bodySmallLight => AppTextTheme.bodySmallLight;

  // w400 (Regular)
  TextStyle get displayLarge => AppTextTheme.displayLarge;
  TextStyle get displayMedium => AppTextTheme.displayMedium;
  TextStyle get displaySmall => AppTextTheme.displaySmall;
  TextStyle get headlineLarge => AppTextTheme.headlineLarge;
  TextStyle get headlineMedium => AppTextTheme.headlineMedium;
  TextStyle get headlineSmall => AppTextTheme.headlineSmall;
  TextStyle get titleLarge => AppTextTheme.titleLarge;
  TextStyle get bodyLarge => AppTextTheme.bodyLarge;
  TextStyle get bodyMedium => AppTextTheme.bodyMedium;
  TextStyle get bodySmall => AppTextTheme.bodySmall;

  // w500 (Medium)
  TextStyle get titleMedium => AppTextTheme.titleMedium;
  TextStyle get labelLarge => AppTextTheme.labelLarge;
  TextStyle get titleSmall => AppTextTheme.titleSmall;
  TextStyle get labelMedium => AppTextTheme.labelMedium;
  TextStyle get labelSmall => AppTextTheme.labelSmall;

  // w600 (SemiBold)
  TextStyle get displayLargeSemiBold => AppTextTheme.displayLargeSemiBold;
  TextStyle get displayMediumSemiBold => AppTextTheme.displayMediumSemiBold;
  TextStyle get displaySmallSemiBold => AppTextTheme.displaySmallSemiBold;
  TextStyle get headlineLargeSemiBold => AppTextTheme.headlineLargeSemiBold;
  TextStyle get headlineMediumSemiBold => AppTextTheme.headlineMediumSemiBold;
  TextStyle get headlineSmallSemiBold => AppTextTheme.headlineSmallSemiBold;
  TextStyle get titleLargeSemiBold => AppTextTheme.titleLargeSemiBold;
  TextStyle get heading3 => AppTextTheme.heading3;
  TextStyle get titleMediumSemiBold => AppTextTheme.titleMediumSemiBold;
  TextStyle get buttonText => AppTextTheme.buttonText;
  TextStyle get bodyLargeSemiBold => AppTextTheme.bodyLargeSemiBold;
  TextStyle get bodyMediumSemiBold => AppTextTheme.bodyMediumSemiBold;
  TextStyle get titleSmallSemiBold => AppTextTheme.titleSmallSemiBold;
  TextStyle get labelLargeSemiBold => AppTextTheme.labelLargeSemiBold;
  TextStyle get bodySmallSemiBold => AppTextTheme.bodySmallSemiBold;
  TextStyle get labelMediumSemiBold => AppTextTheme.labelMediumSemiBold;
  TextStyle get labelSmallSemiBold => AppTextTheme.labelSmallSemiBold;

  // w700 (Bold)
  TextStyle get displayLargeBold => AppTextTheme.displayLargeBold;
  TextStyle get displayMediumBold => AppTextTheme.displayMediumBold;
  TextStyle get displaySmallBold => AppTextTheme.displaySmallBold;
  TextStyle get headlineLargeBold => AppTextTheme.headlineLargeBold;
  TextStyle get headlineMediumBold => AppTextTheme.headlineMediumBold;
  TextStyle get heading2 => AppTextTheme.heading2;
  TextStyle get headlineSmallBold => AppTextTheme.headlineSmallBold;
  TextStyle get titleLargeBold => AppTextTheme.titleLargeBold;
  TextStyle get titleMediumBold => AppTextTheme.titleMediumBold;
  TextStyle get bodyLargeBold => AppTextTheme.bodyLargeBold;
  TextStyle get bodyMediumBold => AppTextTheme.bodyMediumBold;
  TextStyle get titleSmallBold => AppTextTheme.titleSmallBold;
  TextStyle get labelLargeBold => AppTextTheme.labelLargeBold;
  TextStyle get bodySmallBold => AppTextTheme.bodySmallBold;
  TextStyle get labelMediumBold => AppTextTheme.labelMediumBold;
  TextStyle get labelSmallBold => AppTextTheme.labelSmallBold;

  // w800 (ExtraBold)
  TextStyle get heading1 => AppTextTheme.heading1;
}

extension ContextExtensions on BuildContext {
  AppTextThemeStyles get textTheme => const AppTextThemeStyles();

  TextTheme get materialTextTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
