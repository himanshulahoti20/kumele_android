import 'package:flutter/material.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/legal/widgets/terms_and_conditions_page_layout.dart';

class TermsAndConditions extends StatelessWidget implements BasePage {
  const TermsAndConditions({super.key});

  @override
  String get screenName => 'TermsAndConditions';

  @override
  Widget build(BuildContext context) {
    return const TermsAndConditionsPageLayout();
  }
}
