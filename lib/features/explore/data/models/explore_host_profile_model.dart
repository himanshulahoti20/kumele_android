import 'package:kuemele/features/explore/domain/entities/explore_host_profile.dart';

class ExploreHostProfileModel {
  const ExploreHostProfileModel({
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.bio,
  });

  final String id;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final String? bio;

  factory ExploreHostProfileModel.fromJson(Map<String, dynamic> json) {
    return ExploreHostProfileModel(
      id: json['id'] as String? ?? '',
      displayName: _resolveDisplayName(json),
      firstName: json['firstName'] as String? ?? json['first_name'] as String?,
      lastName: json['lastName'] as String? ?? json['last_name'] as String?,
      avatarUrl: json['avatar'] as String?,
      bio: json['bio'] as String?,
    );
  }

  static String _resolveDisplayName(Map<String, dynamic> json) {
    final displayName =
        json['displayName'] as String? ?? json['display_name'] as String?;
    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName.trim();
    }

    final firstName =
        json['firstName'] as String? ?? json['first_name'] as String? ?? '';
    final lastName =
        json['lastName'] as String? ?? json['last_name'] as String? ?? '';
    return '$firstName $lastName'.trim();
  }

  ExploreHostProfile toEntity() {
    return ExploreHostProfile(
      id: id,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
      bio: bio,
    );
  }
}
