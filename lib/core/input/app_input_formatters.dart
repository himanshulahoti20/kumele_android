import 'package:flutter/services.dart';

abstract final class AppInputFormatters {
  static final TextInputFormatter digitsOnly =
      FilteringTextInputFormatter.digitsOnly;

  static List<TextInputFormatter> digits({int? maxLength}) {
    if (maxLength == null) {
      return [digitsOnly];
    }

    return [
      digitsOnly,
      LengthLimitingTextInputFormatter(maxLength),
    ];
  }

  static List<TextInputFormatter> otpCode({int length = 6}) {
    return digits(maxLength: length);
  }
}
