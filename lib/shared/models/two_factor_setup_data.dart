class TwoFactorSetupData {
  const TwoFactorSetupData({
    required this.qrCodeData,
    required this.manualCode,
  });

  final String qrCodeData;
  final String manualCode;

  factory TwoFactorSetupData.fromJson(Map<String, dynamic> json) {
    final qr = (json['qrCode'] ??
            json['qr_code'] ??
            json['otpauthUrl'] ??
            json['otpauth_url'] ??
            json['qrCodeUrl'] ??
            json['qr_code_url'] ??
            '')
        .toString()
        .trim();

    final manual = (json['secret'] ??
            json['manualCode'] ??
            json['manual_code'] ??
            json['code'] ??
            '')
        .toString()
        .trim();

    return TwoFactorSetupData(
      qrCodeData: qr,
      manualCode: manual,
    );
  }

  bool get isValid => qrCodeData.isNotEmpty && manualCode.isNotEmpty;
}
