class ReferralInfo {
  const ReferralInfo({
    required this.referralCode,
    required this.referralLink,
  });

  final String referralCode;
  final String referralLink;

  factory ReferralInfo.fromJson(Map<String, dynamic> json) {
    return ReferralInfo(
      referralCode:
          (json['referralCode'] ?? json['code'] ?? json['referral_code'] ?? '')
              .toString()
              .trim(),
      referralLink: (json['referralLink'] ?? json['referral_link'] ?? '')
          .toString()
          .trim(),
    );
  }

  bool get isValid => referralCode.isNotEmpty && referralLink.isNotEmpty;
}
