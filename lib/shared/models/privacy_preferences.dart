class PrivacyPreferences {
  const PrivacyPreferences({
    required this.marketingConsent,
    required this.analyticsConsent,
    required this.thirdPartyConsent,
    required this.pushNotificationConsent,
    required this.emailNotificationConsent,
    this.updatedAt,
  });

  final bool marketingConsent;
  final bool analyticsConsent;
  final bool thirdPartyConsent;
  final bool pushNotificationConsent;
  final bool emailNotificationConsent;
  final DateTime? updatedAt;

  factory PrivacyPreferences.fromJson(Map<String, dynamic> json) {
    return PrivacyPreferences(
      marketingConsent: json['marketingConsent'] == true,
      analyticsConsent: json['analyticsConsent'] == true,
      thirdPartyConsent: json['thirdPartyConsent'] == true,
      pushNotificationConsent: json['pushNotificationConsent'] == true,
      emailNotificationConsent: json['emailNotificationConsent'] == true,
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toConsentJson() => {
        'marketingConsent': marketingConsent,
        'analyticsConsent': analyticsConsent,
        'thirdPartyConsent': thirdPartyConsent,
        'pushNotificationConsent': pushNotificationConsent,
        'emailNotificationConsent': emailNotificationConsent,
      };

  PrivacyPreferences copyWith({
    bool? marketingConsent,
    bool? analyticsConsent,
    bool? thirdPartyConsent,
    bool? pushNotificationConsent,
    bool? emailNotificationConsent,
  }) {
    return PrivacyPreferences(
      marketingConsent: marketingConsent ?? this.marketingConsent,
      analyticsConsent: analyticsConsent ?? this.analyticsConsent,
      thirdPartyConsent: thirdPartyConsent ?? this.thirdPartyConsent,
      pushNotificationConsent:
          pushNotificationConsent ?? this.pushNotificationConsent,
      emailNotificationConsent:
          emailNotificationConsent ?? this.emailNotificationConsent,
      updatedAt: updatedAt,
    );
  }
}
