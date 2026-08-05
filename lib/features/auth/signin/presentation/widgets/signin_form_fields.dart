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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KumeleTextField.fromAsset(
                  controller: emailController,
                  hintText: AuthConfig.emailHint,
                  prefixAssetPath: AuthConfig.emailIcon,
                ),
                Gap(fieldGap),
                KumeleTextField.password(
                  controller: passwordController,
                  hintText: AuthConfig.passwordHint,
                  prefixAssetPath: AuthConfig.lockIcon,
                  eyeAssetPath: AuthConfig.eyeIcon,
                ),
                Gap(fieldGap),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppCheckbox.label(
                        text: AuthConfig.rememberMeLabel,
                        value: state.rememberMe,
                        spaceBetween: 15.w,
                        onChanged: (value) => getIt<SigninBloc>().add(
                          SigninRememberMeChanged(value),
                        ),
                      ),
                    ),
                    AppButton.text(
                      label: AuthConfig.forgotPasswordLabel,
                      onPressed: onForgotPassword,
                      foregroundColor: ColorSet.lightBlueColor,
                    ),
                  ],
                ),
                Gap(sectionGap),
                Row(
                  children: [
                    Flexible(
                      child: AppCheckbox.label(
                        text: AuthConfig.captchaLabel,
                        value: state.imNotARobot,
                        spaceBetween: 15.w,
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
                  label: AuthConfig.signInLabel,
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
