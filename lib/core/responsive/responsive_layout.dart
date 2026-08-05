/// Device size class for native mobile apps (phone vs tablet).
enum DeviceClass {
  phone,
  tablet,
}

/// The four primary layout modes this app supports.
enum ResponsiveLayout {
  mobilePortrait,
  mobileLandscape,
  tabletPortrait,
  tabletLandscape,
}

extension ResponsiveLayoutX on ResponsiveLayout {
  String get label => switch (this) {
        ResponsiveLayout.mobilePortrait => 'Phone Portrait',
        ResponsiveLayout.mobileLandscape => 'Phone Landscape',
        ResponsiveLayout.tabletPortrait => 'Tablet Portrait',
        ResponsiveLayout.tabletLandscape => 'Tablet Landscape',
      };

  bool get isMobile =>
      this == ResponsiveLayout.mobilePortrait ||
      this == ResponsiveLayout.mobileLandscape;

  bool get isTablet =>
      this == ResponsiveLayout.tabletPortrait ||
      this == ResponsiveLayout.tabletLandscape;

  bool get isPortrait =>
      this == ResponsiveLayout.mobilePortrait ||
      this == ResponsiveLayout.tabletPortrait;

  bool get isLandscape =>
      this == ResponsiveLayout.mobileLandscape ||
      this == ResponsiveLayout.tabletLandscape;
}
