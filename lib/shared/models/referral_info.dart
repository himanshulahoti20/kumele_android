class ReferralInfo {
  const ReferralInfo({
    required this.referralCode,
    required this.referralLink,
  });

  final String referralCode;
  final String referralLink;

  factory ReferralInfo.fromJson(Map<String, dynamic> json) {
    final referralCode =
        (json['referralCode'] ?? json['code'] ?? json['referral_code'] ?? '')
            .toString()
            .trim();
    return ReferralInfo(
      referralCode: referralCode,
      referralLink: (json['referralLink'] ??
              json['referral_link'] ??
              json['url'] ??
              json['link'] ??
              '')
          .toString()
          .trim(),
    );
  }

  bool get isValid => referralCode.isNotEmpty;
}
