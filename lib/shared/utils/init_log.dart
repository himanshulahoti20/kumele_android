import 'package:flutter/foundation.dart';

class InitLog {
  static const _color = '\x1B[38;5;213m';
  static const _reset = '\x1B[0m';

  static void write(String message, {String tag = 'Init'}) {
    if (!kDebugMode) return;
    debugPrint('$_color[$tag] $message$_reset');
  }
}
