class TwoFactorSetupData {
  const TwoFactorSetupData({
    required this.qrCodeData,
    required this.manualCode,
  });

  final String qrCodeData;
  final String manualCode;

  factory TwoFactorSetupData.fromJson(Map<String, dynamic> json) {
    // Matches iOS's TwoFactorSetupResponse.localQRCodeImage: the server's
    // pre-rendered image (qrCodeUrl/qrCode, usually a base64 data URL) is
    // preferred — otpauthUrl is only a fallback for generating a QR
    // client-side when no image was sent. This order used to put
    // otpauthUrl first, so a response with both fields (like the real
    // /auth/2fa/setup payload) ignored the actual image and tried to
    // render the raw otpauth:// URI as a QR instead.
    final qr = (json['qrCodeUrl'] ??
            json['qr_code_url'] ??
            json['qrCode'] ??
            json['qr_code'] ??
            json['otpauthUrl'] ??
            json['otpauth_url'] ??
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
