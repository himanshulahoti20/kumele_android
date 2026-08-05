enum LegalDocumentType {
  guidelines('guidelines'),
  privacyPolicy('privacy_policy'),
  terms('terms');

  const LegalDocumentType(this.apiValue);

  final String apiValue;

  static LegalDocumentType? fromApiValue(String? value) {
    if (value == null) return null;
    for (final type in LegalDocumentType.values) {
      if (type.apiValue == value) return type;
    }
    return null;
  }
}

class LegalDocument {
  const LegalDocument({
    this.id,
    this.type,
    this.title,
    this.content,
    this.version,
    this.isActive,
    this.updatedAt,
  });

  final String? id;
  final LegalDocumentType? type;
  final String? title;
  final String? content;
  final int? version;
  final bool? isActive;
  final String? updatedAt;

  factory LegalDocument.fromJson(Map<String, dynamic> json) {
    final rawType = (json['type'] ?? json['documentType'])?.toString();
    return LegalDocument(
      id: (json['id'] ?? json['_id'])?.toString(),
      type: LegalDocumentType.fromApiValue(rawType),
      title: (json['title'] ?? json['name'])?.toString(),
      content: (json['content'] ?? json['body'] ?? json['text'])?.toString(),
      version: json['version'] is int
          ? json['version'] as int
          : int.tryParse(json['version']?.toString() ?? ''),
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool?,
      updatedAt: (json['updatedAt'] ?? json['updated_at'])?.toString(),
    );
  }
}
