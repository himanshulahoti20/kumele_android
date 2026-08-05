import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive.dart';

class WidgetByDevice extends StatelessWidget {
  final Widget? phone;
  final Widget? tablet;

  const WidgetByDevice({super.key, this.phone, this.tablet});

  @override
  Widget build(BuildContext context) {
    return ResponsiveDeviceBuilder(
      phone: phone ?? const SizedBox.shrink(),
      tablet: tablet,
    );
  }
}

class DevicePadding extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? phonePadding;
  final EdgeInsets? tabletPadding;

  const DevicePadding({
    super.key,
    this.child,
    this.phonePadding,
    this.tabletPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      phone: phonePadding,
      tablet: tabletPadding,
      child: child ?? const SizedBox.shrink(),
    );
  }
}
