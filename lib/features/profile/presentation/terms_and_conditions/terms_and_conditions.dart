import 'package:flutter/material.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/models/legal_document.dart';
import 'package:kuemele/shared/services/api_service/legal/legal_repo.dart';
import 'package:kuemele/shared/legal/widgets/terms_and_conditions_page_layout.dart';

class TermsAndConditions extends StatefulWidget implements BasePage {
  const TermsAndConditions({super.key});

  @override
  String get screenName => 'TermsAndConditions';

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  LegalDocument? _document;

  @override
  void initState() {
    super.initState();
    _loadTerms();
  }

  Future<void> _loadTerms() async {
    try {
      final document = await LegalRepo.getLegalDocumentByType(
        LegalDocumentType.terms,
      );
      if (!mounted) return;
      setState(() => _document = document);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return TermsAndConditionsPageLayout(
      title: _document?.title,
      content: _document?.content,
    );
  }
}
