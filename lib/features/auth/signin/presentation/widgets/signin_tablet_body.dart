import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/features/auth/signin/presentation/widgets/signin_entry_banner.dart';
import 'package:kuemele/features/auth/signin/presentation/widgets/signin_footer.dart';
import 'package:kuemele/features/auth/signin/presentation/widgets/signin_form_fields.dart';
import 'package:kuemele/features/auth/signin/presentation/widgets/signin_signup_link.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/language_selector.dart';

class SigninTabletBody extends StatelessWidget {
  const SigninTabletBody({
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

    return ResponsiveContent(
      child: Padding(
        padding:
            responsive.tabletSymmetric(vertical: responsive.verticalPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LanguageSelector(),
                  const Gap(30),
                  KumeleAssetWidget(
                    assetPath: AuthConfig.kuemeleImage,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
            Gap(responsive.gutter * 2),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.signIn,
                          style: context.textTheme.displaySmallBold.copyWith(
                            fontSize: 40,
                            color: ColorSet.textColor,
                          ),
                        ),
                        const Gap(10),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: AuthGoogleSignInButton(),
                        ),
                      ],
                    ),
                    const Gap(18),
                    SigninSignupLink(
                      entryLabel: entryLabel,
                      entryDescription: entryDescription,
                      prefix: AppLocalizations.of(context)!.signInNoAccountPrefix,
                      signUpFontSize: 25,
                    ),
                    const Gap(18),
                    if (entryLabel != null) ...[
                      SigninEntryBanner(
                        label: entryLabel!,
                        description: entryDescription,
                      ),
                      const Gap(18),
                    ],
                    SigninFormFields(
                      emailController: emailController,
                      passwordController: passwordController,
                      onSignIn: onSignIn,
                      onForgotPassword: onForgotPassword,
                      onCaptchaChanged: onCaptchaChanged,
                      fieldGap: 18,
                      sectionGap: 10,
                    ),
                    const Gap(24),
                    Center(
                      child: SigninFooter(onPasskeyTap: onPasskeyTap),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
