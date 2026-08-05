import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';

enum SnackBarType {
  neutral,
  success,
  error,
  warning,
  info,
}

extension SnackBarTypeStyle on SnackBarType {
  Color get backgroundColor => switch (this) {
        SnackBarType.neutral => ColorSet.snackBarNeutralBg,
        SnackBarType.success => ColorSet.snackBarSuccessBg,
        SnackBarType.error => ColorSet.snackBarErrorBg,
        SnackBarType.warning => ColorSet.snackBarWarningBg,
        SnackBarType.info => ColorSet.snackBarInfoBg,
      };

  Color get foregroundColor => switch (this) {
        SnackBarType.neutral => ColorSet.snackBarNeutralText,
        SnackBarType.success => ColorSet.snackBarSuccessText,
        SnackBarType.error => ColorSet.snackBarErrorText,
        SnackBarType.warning => ColorSet.snackBarWarningText,
        SnackBarType.info => ColorSet.snackBarInfoText,
      };

  IconData? get icon => switch (this) {
        SnackBarType.neutral => null,
        SnackBarType.success => Icons.check_circle_outline_rounded,
        SnackBarType.error => Icons.error_outline_rounded,
        SnackBarType.warning => Icons.warning_amber_rounded,
        SnackBarType.info => Icons.info_outline_rounded,
      };
}
