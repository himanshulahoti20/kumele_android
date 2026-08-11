/// Structured content model used to render native legal documents
/// (Terms of Use, Community Guidelines, FAQ) with a consistent layout,
/// mirroring the native iOS `LocalLegalDocuments.swift` views.
enum LegalBlockType {
  /// Main document title (24 bold)
  header,

  /// Section header (18 bold)
  section,

  /// Sub-section header (16 semibold)
  subSection,

  /// Regular body paragraph (15 regular)
  body,

  /// Bullet point (15 regular, prefixed with "•")
  bullet,
}

/// A single content block inside a legal document.
class LegalBlock {
  const LegalBlock.header(this.text)
      : type = LegalBlockType.header,
        description = null;

  const LegalBlock.section(this.text)
      : type = LegalBlockType.section,
        description = null;

  const LegalBlock.subSection(this.text)
      : type = LegalBlockType.subSection,
        description = null;

  const LegalBlock.body(this.text)
      : type = LegalBlockType.body,
        description = null;

  const LegalBlock.bullet(this.text)
      : type = LegalBlockType.bullet,
        description = null;

  final LegalBlockType type;
  final String text;
  final String? description;
}
