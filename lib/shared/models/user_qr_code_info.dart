class UserQrCodeInfo {
  final String qrCodeUrl;
  final String? expiresAt;
  final String? usage;

  const UserQrCodeInfo({
    required this.qrCodeUrl,
    this.expiresAt,
    this.usage,
  });

  factory UserQrCodeInfo.fromJson(Map<String, dynamic> json) {
    return UserQrCodeInfo(
      qrCodeUrl: (json['qrCodeUrl'] ??
              json['qr_code_url'] ??
              json['qrCodeDataUrl'] ??
              json['dataUrl'] ??
              json['url'] ??
              '')
          .toString(),
      expiresAt: (json['expiresAt'] ?? json['expires_at'])?.toString(),
      usage: json['usage']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qrCodeUrl': qrCodeUrl,
      if (expiresAt != null) 'expiresAt': expiresAt,
      if (usage != null) 'usage': usage,
    };
  }
}
