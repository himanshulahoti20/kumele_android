class AppConfig {
  final bool maintenanceMode;
  final Map<String, dynamic> minSupportedVersion;
  final Map<String, dynamic> featureFlags;

  const AppConfig({
    required this.maintenanceMode,
    required this.minSupportedVersion,
    required this.featureFlags,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      maintenanceMode: json['maintenance_mode'] as bool? ?? false,
      minSupportedVersion: (json['min_supported_version'] as Map?)?.cast<String, dynamic>() ?? const {},
      featureFlags: (json['feature_flags'] as Map?)?.cast<String, dynamic>() ?? const {},
    );
  }
}
