import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive_data.dart';
import 'package:kuemele/core/responsive/responsive_extensions.dart';
import 'package:kuemele/core/responsive/responsive_layout.dart';

typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  ResponsiveData responsive,
);

class ResponsiveDeviceBuilder extends StatelessWidget {
  const ResponsiveDeviceBuilder({
    super.key,
    required this.phone,
    this.tablet,
  });

  final Widget phone;
  final Widget? tablet;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    if (responsive.isTablet && tablet != null) {
      return tablet!;
    }
    return phone;
  }
}

/// Builds UI for each supported layout mode.
class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder({
    super.key,
    required this.builder,
  });

  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, context.responsive);
  }
}

/// Applies standard horizontal screen padding based on layout.
class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({
    super.key,
    required this.child,
    this.phone,
    this.tablet,
    this.applyVertical = false,
  });

  final Widget child;
  final EdgeInsets? phone;
  final EdgeInsets? tablet;
  final bool applyVertical;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final padding = responsive.isTablet
        ? (tablet ?? responsive.tabletSymmetric())
        : (phone ??
            EdgeInsets.symmetric(
              horizontal: responsive.horizontalPadding,
              vertical: applyVertical ? responsive.verticalPadding : 0,
            ));

    return Padding(padding: padding, child: child);
  }
}

/// Centers content and constrains width on tablets.
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    super.key,
    required this.child,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final maxWidth = responsive.contentMaxWidth;

    if (maxWidth == null) {
      return child;
    }

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// Convenience builder for the four supported layout variants.
class ResponsiveVariantBuilder extends StatelessWidget {
  const ResponsiveVariantBuilder({
    super.key,
    required this.mobilePortrait,
    this.mobileLandscape,
    this.tabletPortrait,
    this.tabletLandscape,
  });

  final Widget mobilePortrait;
  final Widget? mobileLandscape;
  final Widget? tabletPortrait;
  final Widget? tabletLandscape;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return switch (responsive.layout) {
      ResponsiveLayout.mobilePortrait => mobilePortrait,
      ResponsiveLayout.mobileLandscape => mobileLandscape ?? mobilePortrait,
      ResponsiveLayout.tabletPortrait => tabletPortrait ?? mobilePortrait,
      ResponsiveLayout.tabletLandscape =>
        tabletLandscape ?? tabletPortrait ?? mobileLandscape ?? mobilePortrait,
    };
  }
}
