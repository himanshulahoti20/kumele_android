import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';

/// Legacy screen-type enum kept for backward compatibility.
enum ScreenType { desktop, tablet, handset, watch }

/// Backward-compatible helpers. Prefer [BuildContext.responsive] in new code.
class FormFactor {
  static const double defaultTabletHorizontalPadding =
      ResponsiveBreakpoints.tabletHorizontalPadding;

  @Deprecated('Desktop layouts are not used in this mobile app.')
  static double desktop = 1250;

  static double tablet = ResponsiveBreakpoints.tablet;
  static double handset = 300;

  static bool get isMobileDevice => true;

  @Deprecated('Desktop layouts are not used in this mobile app.')
  static bool get isDesktopDevice => false;

  static bool get isMobileDeviceOrWeb => false;

  @Deprecated('Desktop layouts are not used in this mobile app.')
  static bool get isDesktopDeviceOrWeb => false;

  static ScreenType getFormFactor(BuildContext context) {
    final responsive = context.responsive;
    if (responsive.isTablet) {
      return ScreenType.tablet;
    }
    return ScreenType.handset;
  }

  static bool get isTablet {
    final context = InjectionHelper.navKey.currentContext;
    if (context == null) return false;
    return context.responsive.isTablet;
  }

  static bool get isPhone {
    final context = InjectionHelper.navKey.currentContext;
    if (context == null) return true;
    return context.responsive.isPhone;
  }

  static bool get isPortrait {
    final context = InjectionHelper.navKey.currentContext;
    if (context == null) return true;
    return context.responsive.isPortrait;
  }

  static bool get isLandscape {
    final context = InjectionHelper.navKey.currentContext;
    if (context == null) return false;
    return context.responsive.isLandscape;
  }

  static ResponsiveLayout get layout {
    final context = InjectionHelper.navKey.currentContext;
    if (context == null) return ResponsiveLayout.mobilePortrait;
    return context.responsive.layout;
  }

  static EdgeInsets tabletSymmetric({
    double vertical = 0.0,
    double horizontal = defaultTabletHorizontalPadding,
  }) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }
}
