import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive_data.dart';

class ResponsiveScope extends InheritedWidget {
  const ResponsiveScope({
    super.key,
    required this.data,
    required super.child,
  });

  final ResponsiveData data;

  static ResponsiveData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ResponsiveScope>();
    assert(
      scope != null,
      'ResponsiveScope not found. Wrap your app with ResponsiveScope.',
    );
    return scope!.data;
  }

  static ResponsiveData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ResponsiveScope>()?.data;
  }

  @override
  bool updateShouldNotify(ResponsiveScope oldWidget) {
    return data.layout != oldWidget.data.layout ||
        data.screenSize != oldWidget.data.screenSize ||
        data.designSize != oldWidget.data.designSize;
  }
}
