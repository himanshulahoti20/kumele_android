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
      width: json['width'] as int?,
      height: json['height'] as int?,
      format: json['format']?.toString(),
    );
  }
}
