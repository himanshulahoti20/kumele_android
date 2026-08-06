import 'package:kuemele/features/profile/presentation/profileset/domain/entities/user_hobby_preference.dart';

class UserHobbyPreferenceModel {
  final String hobbyId;
  final int skillLevel;
  final bool isPrimary;

  const UserHobbyPreferenceModel({
    required this.hobbyId,
    required this.skillLevel,
    required this.isPrimary,
  });

  factory UserHobbyPreferenceModel.fromEntity(UserHobbyPreference entity) {
    return UserHobbyPreferenceModel(
      hobbyId: entity.hobbyId,
      skillLevel: entity.skillLevel,
      isPrimary: entity.isPrimary,
    );
  }

  factory UserHobbyPreferenceModel.fromJson(Map<String, dynamic> json) {
    final nestedHobby = json['hobby'];
    final hobbyId = (json['hobbyId'] ??
                json['hobby_id'] ??
                (nestedHobby is Map ? nestedHobby['id'] : null) ??
                json['id'])
            ?.toString() ??
        '';

    return UserHobbyPreferenceModel(
      hobbyId: hobbyId,
      skillLevel: _asInt(
        json['skillLevel'] ?? json['skill_level'],
        fallback: UserHobbyPreference.defaultSkillLevel,
      ),
      isPrimary: (json['isPrimary'] ?? json['is_primary']) as bool? ?? false,
    );
  }

  UserHobbyPreference toEntity() {
    return UserHobbyPreference(
      hobbyId: hobbyId,
      skillLevel: skillLevel,
      isPrimary: isPrimary,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hobbyId': hobbyId,
      'skillLevel': skillLevel,
      'isPrimary': isPrimary,
    };
  }
}

int _asInt(dynamic value, {required int fallback}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}
