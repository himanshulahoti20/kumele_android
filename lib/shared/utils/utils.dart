import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuemele/core/service_locator.dart';

extension StringExt on String? {
  void logDebug() {
    dev.log('PHONG: ${this ?? ''}');
  }

  Color toColor() {
    if (this == null || this!.isEmpty) return Colors.transparent;
    final buffer = StringBuffer();
    if (this!.length == 6 || this!.length == 7) buffer.write('ff');
    buffer.write(this!.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String capitalize() {
    if (this == null || this!.isEmpty) {
      return this ?? '';
    }
    String res = this?.toLowerCase() ?? '';
    return res[0].toUpperCase() + res.substring(1);
  }
}

class Utils {
  static bool isNullOrEmpty(dynamic value) {
    if (value == null) {
      return true;
    }
    if (value is String) {
      return value.toString().trim().isEmpty;
    }
    if (value is List && value.isEmpty) {
      return true;
    }
    if (value is Iterable && value.isEmpty) {
      return true;
    }
    if (value is Map && value.isEmpty) {
      return true;
    }
    return false;
  }

  static bool isNotNullOrEmpty(dynamic value) {
    return !isNullOrEmpty(value);
  }

  static T? jsonToModel<T>(dynamic json, T Function(Map<String, dynamic> data) factory) {
    return isNullOrEmpty(json) ? null : factory(json);
  }

  static List<T>? jsonToList<T>(dynamic json, T Function(Map<String, dynamic> data) factory) {
    return isNullOrEmpty(json) ? [] : (json as List? ?? []).map((model) => factory(model)).toList();
  }

  static T? stringToEnum<T>(String? str, List<T> values) {
    final valuesInStr = values.map((e) => enumToString(e as Enum)).toList();
    return isNullOrEmpty(str) || !valuesInStr.contains(str)
        ? null
        : values.firstWhere((e) => enumToString(e as Enum) == str);
  }

  static String enumToString(Enum? type) {
    return isNullOrEmpty(type) ? '' : type.toString().split('.')[1];
  }

  static String convertTimeInMillisecond(int? time, String formatPattern) {
    var format = DateFormat(formatPattern);
    return time == null ? '' : format.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static Uint8List dataFromBase64String(String base64String) {
    if (base64String.contains('data:image/png;base64,')) {
      base64String = base64String.replaceAll('data:image/png;base64,', '');
    } else if (base64String.contains('data:image/jpg;base64,')) {
      base64String = base64String.replaceAll('data:image/jpg;base64,', '');
    } else if (base64String.contains('data:image/jpeg;base64,')) {
      base64String = base64String.replaceAll('data:image/jpeg;base64,', '');
    } else if (base64String.contains('data:image/gif;base64,')) {
      base64String = base64String.replaceAll('data:image/gif;base64,', '');
    }
    return base64Decode(base64String);
  }

  static void logWithBreakLine(String msg) {
    if (kDebugMode) {
      try {
        if (!kReleaseMode) {
          dev.log('---------------------$msg---------------------');
        }
      } catch (e) {
        dev.log(e.toString());
      }
    }
  }

  static void logWithJson(String url, dynamic responseBody, int? statusCode, String? statusMessage) {
    try {
      String prettyprint = const JsonEncoder.withIndent('  ').convert(responseBody);
      if (!kReleaseMode) {
        dev.log(prettyprint);
      }
    } catch (e) {
      if (!kReleaseMode) {
        dev.log(responseBody);
      }
    }
  }

  static double get getWidth {
    final width = MediaQuery.of(InjectionHelper.navKey.currentState!.context).size.width;
    return width;
  }

  static double get getLongestSide {
    final width = MediaQuery.of(InjectionHelper.navKey.currentState!.context).size.longestSide;
    return width;
  }

  static double get getShortestSide {
    final width = MediaQuery.of(InjectionHelper.navKey.currentState!.context).size.shortestSide;
    return width;
  }

  static double get getHeight {
    final height = MediaQuery.of(InjectionHelper.navKey.currentState!.context).size.height;
    return height;
  }

  static void closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      // currentFocus.unfocus();
      currentFocus.requestFocus(FocusNode());
    }
  }

  static bool get isPortrait =>
      MediaQuery.of(InjectionHelper.navKey.currentState!.context).orientation == Orientation.portrait;

  static DateTime getDateTimeFromPattern(String? time, String pattern) {
    if (time == null || time.isEmpty) return DateTime.now();
    return DateFormat(pattern).parse(time);
  }

  static String convertDateTimeToPatternTime(DateTime now, String pattern) {
    return DateFormat(pattern).format(now);
  }
}
