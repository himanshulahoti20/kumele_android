import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/utils/device_utils.dart';

class AppInputStyles {
  static InputDecoration borderlessInputDeco(
          {double radius = 8, EdgeInsets? contentPadding}) =>
      InputDecoration(
        filled: true,
        isDense: true,
        fillColor: ColorSet.tileFontRevertColor,
        contentPadding:
            contentPadding ?? EdgeInsets.all(FormFactor.isTablet ? 20 : 12),
        hintStyle:
            AppTextTheme.bodyLarge.copyWith(fontSize: 15, color: Colors.grey),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(radius),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(radius),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}
