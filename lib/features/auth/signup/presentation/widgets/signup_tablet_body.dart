import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_entry_banner.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_form_fields.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_checkboxes.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_signin_link.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class SignupTabletBody extends StatelessWidget {
  const SignupTabletBody({
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

    return ResponsiveContent(
      child: Padding(
        padding:
            responsive.tabletSymmetric(vertical: responsive.verticalPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KumeleAssetWidget(
                      assetPath: AuthConfig.kuemeleImage,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            Text(AppLocalizations.of(context)!.signup,
                                style: context.textTheme.headlineLargeBold
                                    .copyWith(
                                        color: ColorSet.textColor,
                                        fontWeight: FontWeight.bold)),
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: AuthGoogleSignInButton(),
                            ),
                          ],
                        ),
                        const Gap(18),
                        SignupSigninLink(
                          entryLabel: entryLabel,
                          entryDescription: entryDescription,
                          signInFontSize: 25,
                        ),
                        const Gap(18),
                        if (entryLabel != null) ...[
                          SignupEntryBanner(
                            label: entryLabel!,
                            description: entryDescription,
                          ),
                          const Gap(18),
                        ],
                        SignupFormFields(
                          firstNameController: firstNameController,
                          lastNameController: lastNameController,
                          emailController: emailController,
                          passwordController: passwordController,
                          confirmPasswordController: confirmPasswordController,
                          referralController: referralController,
                          betaController: betaController,
                          fieldGap: 18,
                        ),
                        const Gap(18),
                        const SignupCheckboxes(),
                        const Gap(18),
                        BlocBuilder<AuthBloc, AuthState>(
                          bloc: getIt<AuthBloc>(),
                          buildWhen: (previous, current) =>
                              previous.status != current.status ||
                              previous.loadingAction != current.loadingAction,
                          builder: (context, authState) {
                            return AppButton.primary(
                              label: AppLocalizations.of(context)!.signUpButtonLabel,
                              fullWidth: true,
                              isLoading:
                                  authState.isLoading(AuthLoadingAction.signup),
                              onPressed: onSignUp,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
