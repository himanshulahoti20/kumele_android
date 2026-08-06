import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';

class EventGuestUserModel {
  const EventGuestUserModel({
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.avatarUrl,
  });

  final String id;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;

  factory EventGuestUserModel.fromJson(Map<String, dynamic> json) {
    return EventGuestUserModel(
      id: json['id']?.toString() ?? '',
      displayName: _resolveDisplayName(json),
      firstName: (json['firstName'] ?? json['first_name'])?.toString(),
      lastName: (json['lastName'] ?? json['last_name'])?.toString(),
      avatarUrl: (json['avatar'] ?? json['avatarUrl'] ?? json['profilePicture'])
          ?.toString(),
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

  EventGuestUserEntity toEntity() {
    return EventGuestUserEntity(
      id: id,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
    );
  }
}

class EventGuestModel {
  const EventGuestModel({
    required this.user,
    required this.status,
    this.joinedAt,
    required this.checkedIn,
  });

  final EventGuestUserModel user;
  final String status;
  final DateTime? joinedAt;
  final bool checkedIn;

  factory EventGuestModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return EventGuestModel(
      user: userJson is Map
          ? EventGuestUserModel.fromJson(userJson.cast<String, dynamic>())
          : const EventGuestUserModel(id: '', displayName: ''),
      status: json['status']?.toString() ?? '',
      joinedAt: json['joinedAt'] != null || json['joined_at'] != null
          ? DateTime.tryParse(
              (json['joinedAt'] ?? json['joined_at']).toString())
          : null,
      checkedIn: json['checkedIn'] == true || json['checked_in'] == true,
    );
  }

  EventGuestEntity toEntity() {
    return EventGuestEntity(
      user: user.toEntity(),
      status: status,
      joinedAt: joinedAt,
      checkedIn: checkedIn,
    );
  }
}
