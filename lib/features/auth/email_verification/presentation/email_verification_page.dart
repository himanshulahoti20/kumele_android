import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/auth/email_verification/bloc/email_verification_bloc.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/navigation/onboarding_navigation.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:pinput/pinput.dart';

class EmailVerificationPage extends StatefulWidget implements BasePage {
  const EmailVerificationPage({
    super.key,
    required this.email,
    this.isFromSignup = false,
  });

  final String email;
  final bool isFromSignup;

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();

  @override
  String get screenName => 'EmailVerification';
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getIt<EmailVerificationBloc>().add(
      EmailVerificationOpened(email: widget.email),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _onVerify() {
    final bloc = getIt<EmailVerificationBloc>();
    if (!bloc.state.canSubmit) return;

    bloc.add(const EmailVerificationSubmitStarted());
    getIt<AuthBloc>().add(AuthVerifyEmailRequested(otp: bloc.state.otp));
  }

  void _onResend() {
    final verificationBloc = getIt<EmailVerificationBloc>();
    verificationBloc.add(const EmailVerificationResendRequested());
    verificationBloc.add(const EmailVerificationCodeChanged(''));
    _pinController.clear();
    _pinFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      listenWhen: (previous, current) {
        if (current.status == AuthStatus.verifyEmailSuccess &&
            previous.status != AuthStatus.verifyEmailSuccess) {
          return true;
        }

        return previous.isLoading(AuthLoadingAction.verifyEmail) &&
            !current.isLoading(AuthLoadingAction.verifyEmail) &&
            current.status == AuthStatus.error;
      },
      listener: (context, state) {
        if (state.status == AuthStatus.verifyEmailSuccess) {
          if (widget.isFromSignup) {
            ApiService.clearToken();
            getIt<AuthBloc>().add(const AuthStatusCleared());
            InjectionHelper.snackBar.showSuccess(
                'Account created successfully! Please login to continue.');
            context.go(AppRoutes.signin);
          } else {
            InjectionHelper.snackBar.showSuccess(
              AppLocalizations.of(context)!.emailVerificationSuccessMessage,
            );
            OnboardingNavigation.navigateAfterAuthentication(context);
          }
          return;
        }

        getIt<EmailVerificationBloc>().add(
          EmailVerificationSubmitFailed(
            state.errorMessage ??
                AppLocalizations.of(context)!.emailVerificationFailedMessage,
          ),
        );
        getIt<AuthBloc>().add(const AuthVerifyEmailFailureHandled());
      },
      child: BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
        bloc: getIt<EmailVerificationBloc>(),
        listenWhen: (previous, current) =>
            previous.successMessage != current.successMessage ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          final successMessage = state.successMessage;
          if (successMessage != null && successMessage.isNotEmpty) {
            InjectionHelper.snackBar.showSuccess(successMessage);
          }

          final errorMessage = state.errorMessage;
          if (errorMessage != null && errorMessage.isNotEmpty) {
            InjectionHelper.snackBar.showError(errorMessage);
          }
        },
        builder: (context, state) {
          return WidgetByDevice(
            tablet: AppTitledDialog(
              title: AppLocalizations.of(context)!.emailVerificationPageTitle,
              footer: Align(
                alignment: Alignment.centerRight,
                child: AppButton.primary(
                  label: AppLocalizations.of(context)!
                      .emailVerificationVerifyLabel,
                  isLoading: state.isVerifying,
                  onPressed: state.canSubmit ? _onVerify : null,
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
                            .emailVerificationPageTitle,
                      ),
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
                                  .emailVerificationVerifyLabel,
                              isLoading: state.isVerifying,
                              onPressed: state.canSubmit ? _onVerify : null,
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
      ),
    );
  }

  Widget _buildContent(EmailVerificationState state) {
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
        Text(
          AppLocalizations.of(context)!.emailVerificationSubtitle,
          style: context.textTheme.bodyLargeSemiBold.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        if (state.email.isNotEmpty) ...[
          Gap(8.h),
          Text(
            state.email,
            style: context.textTheme.bodyMedium.copyWith(
              color: ColorSet.specialColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        Gap(28.h),
        Center(
          child: Pinput(
            controller: _pinController,
            focusNode: _pinFocusNode,
            length: 6,
            enabled: !state.isVerifying && !state.isSendingCode,
            keyboardType: TextInputType.number,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: defaultPinTheme,
            errorPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration?.copyWith(
                border: Border.all(color: ColorSet.snackBarErrorBg),
              ),
            ),
            onChanged: (value) => getIt<EmailVerificationBloc>().add(
              EmailVerificationCodeChanged(value),
            ),
            onCompleted: (_) => _onVerify(),
          ),
        ),
        Gap(24.h),
        Center(child: _buildResendButton(state)),
        Gap(16.h),
      ],
    );
  }

  Widget _buildResendButton(EmailVerificationState state) {
    if (state.canResend) {
      return TextButton(
        onPressed: state.isSendingCode ? null : _onResend,
        child: state.isSendingCode
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
