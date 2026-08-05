import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/features/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

class ForgotPasswordPage extends StatefulWidget implements BasePage {
  const ForgotPasswordPage({
    super.key,
    this.initialEmail,
  });

  final String? initialEmail;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();

  @override
  String get screenName => 'ForgotPassword';
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
    getIt<ForgotPasswordBloc>().add(
      ForgotPasswordReset(initialEmail: widget.initialEmail),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    getIt<ForgotPasswordBloc>().add(
      ForgotPasswordSubmitted(email: _emailController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      bloc: getIt<ForgotPasswordBloc>(),
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        final errorMessage = state.errorMessage;
        if (errorMessage != null && errorMessage.isNotEmpty) {
          InjectionHelper.snackBar.showError(errorMessage);
        }

        if (state.status == ForgotPasswordStatus.success) {
          final email = state.email;
          InjectionHelper.snackBar.showSuccess(
            state.successMessage ?? AppStrings.forgotPasswordSuccessMessage,
          );
          getIt<ForgotPasswordBloc>().add(
            ForgotPasswordReset(initialEmail: email),
          );
          context.push(
            AppRoutes.resetPassword,
            extra: ResetPasswordRouteArgs(email: email),
          );
        }
      },
      builder: (context, state) {
        return WidgetByDevice(
          tablet: AppTitledDialog(
            title: AppStrings.forgotPasswordPageTitle,
            footer: Align(
              alignment: Alignment.centerRight,
              child: AppButton.primary(
                label: AppStrings.forgotPasswordSubmitLabel,
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
                    MobileHeader(label: AppStrings.forgotPasswordPageTitle),
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
                            label: AppStrings.forgotPasswordSubmitLabel,
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

  Widget _buildContent(ForgotPasswordState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.forgotPasswordSubtitle,
          style: context.textTheme.bodyLargeSemiBold.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        Gap(20.h),
        Text(
          AppStrings.forgotPasswordEmailLabel,
          style: context.textTheme.bodyMedium,
        ),
        Gap(10.h),
        KumeleTextField(
          controller: _emailController,
          hintText: AppStrings.forgotPasswordHint,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _onSubmit(),
        ),
        Gap(16.h),
      ],
    );
  }
}
