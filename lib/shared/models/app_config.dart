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
      maintenanceMode:
          _asBool(json['maintenanceMode'] ?? json['maintenance_mode']),
      minSupportedVersion: ((json['minSupportedVersion'] ??
                  json['min_supported_version']) as Map?)
              ?.cast<String, dynamic>() ??
          const {},
      featureFlags: ((json['featureFlags'] ?? json['feature_flags']) as Map?)
              ?.cast<String, dynamic>() ??
          const {},
    );
  }
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  return value?.toString().toLowerCase() == 'true';
}
