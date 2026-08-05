class ExploreEventRules {
  const ExploreEventRules({
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

  bool get hasRules =>
      minAge != null ||
      maxAge != null ||
      (genderRestriction != null && genderRestriction!.isNotEmpty) ||
      (languagePreference != null && languagePreference!.isNotEmpty) ||
      requiresApproval;
}
