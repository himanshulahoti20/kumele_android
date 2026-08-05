import 'dart:convert';

class ScannedGuestQrPayload {
  const ScannedGuestQrPayload({
    required this.type,
    required this.userId,
    required this.displayName,
    this.avatar,
    this.generatedAt,
  });

  final String type;
  final String userId;
  final String displayName;
  final String? avatar;
  final DateTime? generatedAt;

  String get name =>
      displayName.trim().isNotEmpty ? displayName.trim() : userId;

  factory ScannedGuestQrPayload.fromJson(Map<String, dynamic> json) {
    return ScannedGuestQrPayload(
      type: (json['type'] ?? 'kumele_user').toString(),
      userId: (json['userId'] ?? json['user_id'] ?? '').toString(),
      displayName:
          (json['displayName'] ?? json['display_name'] ?? '').toString(),
      avatar: json['avatar']?.toString(),
      generatedAt: json['generatedAt'] != null
          ? DateTime.tryParse(json['generatedAt'].toString())
          : null,
    );
  }

  static ScannedGuestQrPayload? tryParse(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map<String, dynamic>) {
        final payload = ScannedGuestQrPayload.fromJson(decoded);
        return payload.userId.isNotEmpty ? payload : null;
      }
    } catch (_) {
      return ScannedGuestQrPayload(
        type: 'kumele_user',
        userId: trimmed,
        displayName: '',
      );
    }

    return null;
  }
}
