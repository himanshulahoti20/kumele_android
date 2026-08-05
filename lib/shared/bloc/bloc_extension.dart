// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

extension CubitExt on Cubit {
  void safeEmit(dynamic state) {
    if (!isClosed) {
      return emit(state);
    }
  }

  void errorEmit(dynamic state, {VoidCallback? callback}) {
    callback?.call();
    safeEmit(state);
  }
}
