import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive_data.dart';
import 'package:kuemele/core/responsive/responsive_scope.dart';

extension ResponsiveContext on BuildContext {
  ResponsiveData get responsive => ResponsiveScope.of(this);

  ResponsiveData? get responsiveOrNull => ResponsiveScope.maybeOf(this);
}
