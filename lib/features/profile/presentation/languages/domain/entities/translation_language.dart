class TranslationLanguage {
  const TranslationLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    this.rtl = false,
  });

  final String code;
  final String name;
  final String nativeName;
  final bool rtl;

  factory TranslationLanguage.fromJson(Map<String, dynamic> json) {
    return TranslationLanguage(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      nativeName: json['nativeName']?.toString() ?? '',
      rtl: json['rtl'] as bool? ?? false,
    );
  }
}
