import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/auth/signin/bloc/signin_bloc.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_checkbox.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class SigninFormFields extends StatelessWidget {
  const SigninFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSignIn,
    required this.onForgotPassword,
    required this.onCaptchaChanged,
    this.fieldGap = 32,
    this.sectionGap = 24,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSignIn;
  final VoidCallback onForgotPassword;
  final ValueChanged<bool> onCaptchaChanged;
  final double fieldGap;
  final double sectionGap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.loadingAction != current.loadingAction,
      builder: (context, authState) {
        return BlocBuilder<SigninBloc, SigninState>(
          bloc: getIt<SigninBloc>(),
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KumeleTextField.fromAsset(
                  controller: emailController,
                  hintText: l10n.signInEmailHint,
                  prefixAssetPath: AuthConfig.emailIcon,
                ),
                Gap(fieldGap),
                KumeleTextField.password(
                  controller: passwordController,
                  hintText: l10n.signInPasswordHint,
                  prefixAssetPath: AuthConfig.lockIcon,
                  eyeAssetPath: AuthConfig.eyeIcon,
                ),
                Gap(fieldGap),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppCheckbox.label(
                        text: l10n.signInRememberMeLabel,
                        textSize: 16,
                        value: state.rememberMe,
                        spaceBetween: 15.w,
                        showCheckIcon: false,
                        borderColor: AuthConfig.tappableBorderColor,
                        borderWidth: AuthConfig.tappableBorderWidth,
                        onChanged: (value) => getIt<SigninBloc>().add(
                          SigninRememberMeChanged(value),
                        ),
                      ),
                    ),
                    AppButton.text(
                      label: l10n.signInForgotPasswordLabel,
                      fontSize: 16,
                      onPressed: onForgotPassword,
                      foregroundColor: ColorSet.specialBlueColor,
                    ),
                  ],
                ),
                Gap(sectionGap),
                Row(
                  children: [
                    Flexible(
                      child: AppCheckbox.label(
                        text: l10n.signInCaptchaLabel,
                        value: state.imNotARobot,
                        spaceBetween: 15.w,
                        showCheckIcon: false,
                        borderColor: AuthConfig.tappableBorderColor,
                        borderWidth: AuthConfig.tappableBorderWidth,
                        onChanged: onCaptchaChanged,
                      ),
                    ),
                    const Gap(10),
                    KumeleAssetWidget.square(
                      assetPath: AuthConfig.captchaIcon,
                      size: 38,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
                Gap(fieldGap),
                AppButton.primary(
                  label: l10n.signIn,
                  fullWidth: true,
                  isLoading: authState.isLoading(AuthLoadingAction.login),
                  onPressed: onSignIn,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
