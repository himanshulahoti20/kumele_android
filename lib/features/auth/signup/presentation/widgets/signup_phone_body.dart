import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_entry_banner.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_form_fields.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_checkboxes.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_signin_link.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/components/app_button.dart';

class SignupPhoneBody extends StatelessWidget {
  const SignupPhoneBody({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.referralController,
    required this.betaController,
    required this.onSignUp,
    this.entryLabel,
    this.entryDescription,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController referralController;
  final TextEditingController betaController;
  final VoidCallback onSignUp;
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
        if (entryLabel != null) ...[
          const Gap(24),
          SignupEntryBanner(
            label: entryLabel!,
            description: entryDescription,
          ),
        ],
        const Gap(24),
        SignupFormFields(
          firstNameController: firstNameController,
          lastNameController: lastNameController,
          emailController: emailController,
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
          referralController: referralController,
          betaController: betaController,
          fieldGap: 24,
        ),
        const Gap(24),
        const SignupCheckboxes(),
        const Gap(24),
        BlocBuilder<AuthBloc, AuthState>(
          bloc: getIt<AuthBloc>(),
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.loadingAction != current.loadingAction,
          builder: (context, authState) {
            return AppButton.primary(
              label: 'Sign up',
              fullWidth: true,
              isLoading: authState.isLoading(AuthLoadingAction.signup),
              onPressed: onSignUp,
            );
          },
        ),
        const Gap(24),
        SignupSigninLink(
          entryLabel: entryLabel,
          entryDescription: entryDescription,
        ),
      ],
    );
  }
}
