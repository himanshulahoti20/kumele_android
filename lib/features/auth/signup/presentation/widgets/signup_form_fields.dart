import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_birthday_selector.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_gender_selector.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 15,
          children: [
            Expanded(
              child: KumeleTextField(
                controller: firstNameController,
                labelText: 'First name',
                hintText: 'Enter first name',
                isRequired: true,
              ),
            ),
            Expanded(
              child: KumeleTextField(
                controller: lastNameController,
                labelText: 'Last name',
                hintText: 'Enter last name',
              ),
            ),
          ],
        ),
        Gap(fieldGap),
        KumeleTextField.fromAsset(
          controller: emailController,
          hintText: "Enter email",
          prefixAssetPath: AuthConfig.emailIcon,
        ),
        Gap(fieldGap),
        const SignupGenderSelector(),
        Gap(fieldGap),
        const SignupBirthdaySelector(),
        Gap(fieldGap),
        KumeleTextField.password(
          controller: passwordController,
          hintText: "Enter Password",
        ),
        Gap(fieldGap),
        KumeleTextField.password(
          controller: confirmPasswordController,
          hintText: "Confirm Password",
        ),
        Gap(fieldGap),
        Row(
          spacing: 15,
          children: [
            Expanded(
              child: KumeleTextField(
                labelText: "Referral code",
                controller: referralController,
                hintText: " e.g. DF4R435",
              ),
            ),
            Expanded(
              child: KumeleTextField(
                labelText: "Beta code",
                controller: betaController,
                hintText: " e.g. DF4R435",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
