import 'package:intl/intl.dart';

class ConversionUtils {
  ConversionUtils._();

  static String? toNullableString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String toStringValue(dynamic value, {String fallback = ''}) {
    return toNullableString(value) ?? fallback;
  }

  static DateTime? parseDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static int parseInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static double? parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static String formatDouble(
    double value, {
    int fractionDigits = 2,
    bool trimTrailingZeros = true,
  }) {
    final formatted = value.toStringAsFixed(fractionDigits);
    if (!trimTrailingZeros) return formatted;

    return formatted
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  static String formatDateTime(
    DateTime dateTime,
    String pattern, {
    bool toLocal = true,
  }) {
    final value = toLocal ? dateTime.toLocal() : dateTime;
    return DateFormat(pattern).format(value);
  }

  static String formatEventTimeRange(DateTime start, DateTime? end) {
    final startTimeStr = formatDateTime(start, 'MMM dd, yyyy \u00b7 HH:mm');
    if (end == null) return startTimeStr;
    final endTimeStr = formatDateTime(end, 'HH:mm');
    return '$startTimeStr - $endTimeStr';
  }

  static String formatHyphenatedLabel(String? value) {
    if (value == null || value.isEmpty) return '';

    return value
        .split('-')
        .where((part) => part.isNotEmpty)
        .map(
          (part) => '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
  }
}
