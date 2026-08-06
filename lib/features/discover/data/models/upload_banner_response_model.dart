class UploadBannerResponseModel {
  const UploadBannerResponseModel({
    required this.url,
    this.width,
    this.height,
    this.format,
  });

  final String url;
  final int? width;
  final int? height;
  final String? format;

  factory UploadBannerResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadBannerResponseModel(
      url: json['url']?.toString() ?? '',
      width: _asInt(json['width']),
      height: _asInt(json['height']),
      format: json['format']?.toString(),
    );
  }
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}
