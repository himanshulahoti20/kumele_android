import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/auth/reset_password/bloc/reset_password_bloc.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';

class ResetPasswordPage extends StatefulWidget implements BasePage {
  const ResetPasswordPage({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();

  @override
  String get screenName => 'ResetPassword';
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final TextEditingController _tokenController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  final _pinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    getIt<ResetPasswordBloc>().add(
      ResetPasswordReset(email: widget.email),
    );
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    getIt<ResetPasswordBloc>().add(
      ResetPasswordSubmitted(
        token: _tokenController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }

  void _onResend() {
    getIt<ResetPasswordBloc>().add(const ResetPasswordResendRequested());
    _tokenController.clear();
    _pinFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
      bloc: getIt<ResetPasswordBloc>(),
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        final errorMessage = state.errorMessage;
        if (errorMessage != null && errorMessage.isNotEmpty) {
          InjectionHelper.snackBar.showError(errorMessage);
        }

        final successMessage = state.successMessage;
        if (successMessage != null && successMessage.isNotEmpty) {
          InjectionHelper.snackBar.showSuccess(successMessage);
        }

        if (state.status == ResetPasswordStatus.success) {
          InjectionHelper.snackBar.showSuccess(
            AppLocalizations.of(context)!.resetPasswordSuccessMessage,
          );
          context.go(AppRoutes.signin);
        }
      },
      builder: (context, state) {
        return WidgetByDevice(
          tablet: AppTitledDialog(
            title: AppLocalizations.of(context)!.resetPasswordPageTitle,
            footer: Align(
              alignment: Alignment.centerRight,
              child: AppButton.primary(
                label: AppLocalizations.of(context)!.resetPasswordSubmitLabel,
                isLoading: state.isLoading,
                onPressed: state.isLoading ? null : _onSubmit,
              ),
            ),
            child: _buildContent(state),
          ),
          phone: Scaffold(
            backgroundColor: ColorSet.bg3Color,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
                child: Column(
                  children: [
                    MobileHeader(
                        label: AppLocalizations.of(context)!
                            .resetPasswordPageTitle),
                    Gap(22.h),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: _buildContent(state),
                            ),
                          ),
                          AppButton.primary(
                            label: AppLocalizations.of(context)!
                                .resetPasswordSubmitLabel,
                            isLoading: state.isLoading,
                            onPressed: state.isLoading ? null : _onSubmit,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(ResetPasswordState state) {
    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 56.h,
      textStyle: context.textTheme.headlineSmallBold.copyWith(
        color: ColorSet.textColor,
      ),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorSet.border),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: ColorSet.specialColor, width: 1.5),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            ColorSet.isDarkMode
                ? 'assets/icons/email_verification_dark.png'
                : 'assets/icons/email_verification.png',
            width: 73.w,
            height: 73.w,
          ),
        ),
        Gap(15.h),
        Text(
          AppLocalizations.of(context)!.resetPasswordSubtitle,
          style: context.textTheme.bodyLargeSemiBold.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        Gap(20.h),
        Text(
          AppLocalizations.of(context)!.resetPasswordTokenLabel,
          style: context.textTheme.bodyMedium,
        ),
        Gap(10.h),
        Center(
          child: Pinput(
            controller: _tokenController,
            focusNode: _pinFocusNode,
            length: 6,
            enabled: !state.isLoading && !state.isResending,
            keyboardType: TextInputType.number,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: defaultPinTheme,
            errorPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration?.copyWith(
                border: Border.all(color: ColorSet.snackBarErrorBg),
              ),
            ),
          ),
        ),
        Gap(16.h),
        Center(child: _buildResendButton(state)),
        Gap(16.h),
        Text(
          AppLocalizations.of(context)!.resetPasswordNewPasswordLabel,
          style: context.textTheme.bodyMedium,
        ),
        Gap(10.h),
        KumeleTextField.password(
          controller: _newPasswordController,
          hintText: AppLocalizations.of(context)!.resetPasswordNewPasswordHint,
          textInputAction: TextInputAction.next,
        ),
        Gap(16.h),
        Text(
          AppLocalizations.of(context)!.resetPasswordConfirmPasswordLabel,
          style: context.textTheme.bodyMedium,
        ),
        Gap(10.h),
        KumeleTextField.password(
          controller: _confirmPasswordController,
          hintText:
              AppLocalizations.of(context)!.resetPasswordConfirmPasswordHint,
          textInputAction: TextInputAction.done,
        ),
        Gap(16.h),
      ],
    );
  }

  Widget _buildResendButton(ResetPasswordState state) {
    if (state.canResend) {
      return TextButton(
        onPressed: state.isResending ? null : _onResend,
        child: state.isResending
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ColorSet.specialColor,
                ),
              )
            : Text(
                AppLocalizations.of(context)!.emailVerificationResendLabel,
                style: context.textTheme.bodyMedium.copyWith(
                  color: ColorSet.specialColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
      );
    }

    final minutes = state.resendCooldownSeconds ~/ 60;
    final seconds = state.resendCooldownSeconds % 60;
    final formattedTime =
        '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Text(
      '${AppLocalizations.of(context)!.emailVerificationResendInLabel} $formattedTime',
      style: context.textTheme.bodyMedium.copyWith(
        color: ColorSet.subTextColor,
      ),
    );
  }
}
