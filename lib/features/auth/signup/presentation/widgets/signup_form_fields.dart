import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_birthday_selector.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_gender_selector.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';

class SignupFormFields extends StatelessWidget {
  const SignupFormFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.referralController,
    required this.betaController,
    this.fieldGap = 24,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController referralController;
  final TextEditingController betaController;
  final double fieldGap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 15,
          children: [
            Expanded(
              child: KumeleTextField(
                controller: firstNameController,
                labelText: l10n.signupFirstNameLabel,
                hintText: l10n.signupFirstNameHint,
                isRequired: true,
              ),
            ),
            Expanded(
              child: KumeleTextField(
                controller: lastNameController,
                labelText: l10n.signupLastNameLabel,
                hintText: l10n.signupLastNameHint,
              ),
            ),
          ],
        ),
        Gap(fieldGap),
        KumeleTextField.fromAsset(
          controller: emailController,
          hintText: l10n.signupEmailHint,
          prefixAssetPath: AuthConfig.emailIcon,
        ),
        Gap(fieldGap),
        const SignupGenderSelector(),
        Gap(fieldGap),
        const SignupBirthdaySelector(),
        Gap(fieldGap),
        KumeleTextField.password(
          controller: passwordController,
          hintText: l10n.signupPasswordHint,
        ),
        Gap(fieldGap),
        KumeleTextField.password(
          controller: confirmPasswordController,
          hintText: l10n.signupConfirmPasswordHint,
        ),
        Gap(fieldGap),
        Row(
          spacing: 15,
          children: [
            Expanded(
              child: KumeleTextField(
                labelText: l10n.signupReferralCodeLabel,
                controller: referralController,
                hintText: l10n.signupCodeHint,
              ),
            ),
            Expanded(
              child: KumeleTextField(
                labelText: l10n.signupBetaCodeLabel,
                controller: betaController,
                hintText: l10n.signupCodeHint,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
