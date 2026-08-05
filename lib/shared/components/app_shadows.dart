import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';

abstract final class AppShadows {
  AppShadows._();

  static const List<BoxShadow> none = [];

  static List<BoxShadow> get secondary => [
        BoxShadow(
          color: ColorSet.revbg3Color.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get primary => [
        BoxShadow(
          color: ColorSet.revbg3Color.withValues(alpha: 0.16),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: ColorSet.revbg3Color.withValues(alpha: 0.22),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: ColorSet.revbg3Color.withValues(alpha: 0.09),
          blurRadius: 22.39,
          offset: const Offset(0, 2.49),
        ),
      ];

  static List<BoxShadow> get dropdown => secondary;

  static List<BoxShadow> get circularButton => [
        BoxShadow(
          color: ColorSet.bcColor,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get avatar => [
        BoxShadow(
          color: ColorSet.revbg3Color.withValues(alpha: 0.22),
          blurRadius: 12,
          spreadRadius: 1,
          offset: const Offset(0, 5),
        ),
      ];
}
