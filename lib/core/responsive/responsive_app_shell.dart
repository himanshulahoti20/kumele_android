import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/responsive/responsive_data.dart';
import 'package:kuemele/core/responsive/responsive_scope.dart';
import 'package:kuemele/core/service_locator.dart';

/// Initializes [ScreenUtil] and exposes [ResponsiveScope] for the subtree.
class ResponsiveAppShell extends StatefulWidget {
  const ResponsiveAppShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ResponsiveAppShell> createState() => _ResponsiveAppShellState();
}

class _ResponsiveAppShellState extends State<ResponsiveAppShell> {
  ResponsiveData? _lastLogged;

  void _logResponsive(ResponsiveData responsive) {
    if (!kDebugMode) return;
    if (_lastLogged != null && _lastLogged!.debugEquals(responsive)) return;

    _lastLogged = responsive;
    developer.log(
      responsive.debugSummary,
      name: 'Responsive',
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = InjectionHelper.responsiveService.fromContext(context);
    _logResponsive(responsive);

    return ScreenUtilInit(
      // Design size == screen size makes .w/.h/.sp/.r 1:1 (raw dp), like iOS pt.
      designSize: responsive.screenSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => ResponsiveScope(
        data: responsive,
        child: widget.child,
      ),
    );
  }
}
