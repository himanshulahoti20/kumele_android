import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/auth/signin/presentation/widgets/signin_entry_banner.dart';
import 'package:kuemele/features/auth/signin/presentation/widgets/signin_footer.dart';
import 'package:kuemele/features/auth/signin/presentation/widgets/signin_form_fields.dart';
import 'package:kuemele/features/auth/signin/presentation/widgets/signin_signup_link.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/shared/widgets/language_selector.dart';

class SigninPhoneBody extends StatelessWidget {
  const SigninPhoneBody({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSignIn,
    required this.onForgotPassword,
    required this.onCaptchaChanged,
    required this.onPasskeyTap,
    this.entryLabel,
    this.entryDescription,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSignIn;
  final VoidCallback onForgotPassword;
  final ValueChanged<bool> onCaptchaChanged;
  final VoidCallback onPasskeyTap;
  final String? entryLabel;
  final String? entryDescription;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.horizontalPadding + 11,
        vertical: responsive.verticalPadding,
      ),
      children: [
        const LanguageSelector(),
        if (entryLabel != null) ...[
          const Gap(24),
          SigninEntryBanner(
            label: entryLabel!,
            description: entryDescription,
          ),
        ],
        const Gap(24),
        SigninFormFields(
          emailController: emailController,
          passwordController: passwordController,
          onSignIn: onSignIn,
          onForgotPassword: onForgotPassword,
          onCaptchaChanged: onCaptchaChanged,
        ),
        const Gap(24),
        SigninSignupLink(
          entryLabel: entryLabel,
          entryDescription: entryDescription,
        ),
        const Gap(16),
        SigninFooter(onPasskeyTap: onPasskeyTap),
      ],
    );
  }
}
