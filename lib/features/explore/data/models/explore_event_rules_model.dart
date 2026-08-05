import 'package:kuemele/features/explore/domain/entities/explore_event_rules.dart';

class ExploreEventRulesModel {
  const ExploreEventRulesModel({
    this.minAge,
    this.maxAge,
    this.genderRestriction,
    this.languagePreference,
    this.requiresApproval = false,
  });

  final int? minAge;
  final int? maxAge;
  final String? genderRestriction;
  final String? languagePreference;
  final bool requiresApproval;

  factory ExploreEventRulesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ExploreEventRulesModel();
    return ExploreEventRulesModel(
      minAge: json['minAge'] as int? ?? json['min_age'] as int?,
      maxAge: json['maxAge'] as int? ?? json['max_age'] as int?,
      genderRestriction: json['genderRestriction'] as String? ??
          json['gender_restriction'] as String?,
      languagePreference: json['languagePreference'] as String? ??
          json['language_preference'] as String?,
      requiresApproval: json['requiresApproval'] as bool? ??
          json['requires_approval'] as bool? ??
          false,
    );
  }

  ExploreEventRules toEntity() {
    return ExploreEventRules(
      minAge: minAge,
      maxAge: maxAge,
      genderRestriction: genderRestriction,
      languagePreference: languagePreference,
      requiresApproval: requiresApproval,
    );
  }
}
