import 'package:flutter/material.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/legal/widgets/terms_and_conditions_page_layout.dart';

class SignupTermsPage extends StatelessWidget implements BasePage {
  const SignupTermsPage({super.key});

  @override
  String get screenName => 'SignupTerms';

  @override
  Widget build(BuildContext context) {
    return const TermsAndConditionsPageLayout();
  }
}
