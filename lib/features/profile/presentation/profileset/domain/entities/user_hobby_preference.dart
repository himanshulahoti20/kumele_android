class UserHobbyPreference {
  final String hobbyId;
  final int skillLevel;
  final bool isPrimary;

  const UserHobbyPreference({
    required this.hobbyId,
    required this.skillLevel,
    required this.isPrimary,
  });

  static const defaultSkillLevel = 5;

  static List<UserHobbyPreference> fromSelectedHobbyIds(
    List<String> selectedHobbyIds, {
    int skillLevel = defaultSkillLevel,
  }) {
    return selectedHobbyIds.asMap().entries.map((entry) {
      return UserHobbyPreference(
        hobbyId: entry.value,
        skillLevel: skillLevel,
        isPrimary: entry.key == 0,
      );
    }).toList();
  }
}
