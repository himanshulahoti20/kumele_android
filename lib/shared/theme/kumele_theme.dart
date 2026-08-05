import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';

abstract final class KumeleTheme {
  static ThemeData light() => _build(
        scaffold: LightColors.bgColor,
        scheme: _lightScheme,
        divider: LightColors.border,
        dialogBackground: LightColors.bg2Color,
      );

  static ThemeData dark() => _build(
        scaffold: DarkColors.bgColor,
        scheme: _darkScheme,
        divider: DarkColors.border,
        dialogBackground: DarkColors.bg2Color,
      );

  static final ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: LightColors.specialBlueColor,
    onPrimary: Colors.white,
    secondary: LightColors.specialYellowColor,
    onSecondary: LightColors.textColor,
    surface: LightColors.bg2Color,
    onSurface: LightColors.textColor,
    error: LightColors.snackBarErrorBg,
    onError: LightColors.snackBarErrorText,
    outline: LightColors.border,
    surfaceContainerHighest: LightColors.tileFillColor,
  );

  static final ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: DarkColors.specialBlueColor,
    onPrimary: Colors.white,
    secondary: DarkColors.specialYellowColor,
    onSecondary: DarkColors.textColor,
    surface: DarkColors.bg2Color,
    onSurface: DarkColors.textColor,
    error: DarkColors.snackBarErrorBg,
    onError: DarkColors.snackBarErrorText,
    outline: DarkColors.border,
    surfaceContainerHighest: DarkColors.tileFillColor,
  );

  static ThemeData _build({
    required Color scaffold,
    required ColorScheme scheme,
    required Color divider,
    required Color dialogBackground,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      scaffoldBackgroundColor: scaffold,
      colorScheme: scheme,
      dividerColor: divider,
      canvasColor: Colors.transparent,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
      iconTheme: IconThemeData(color: scheme.onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: dialogBackground,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: dialogBackground,
        surfaceTintColor: Colors.transparent,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor:
              WidgetStatePropertyAll(scheme.surfaceContainerHighest),
          elevation: const WidgetStatePropertyAll(0),
        ),
      ),
    );
  }
}
