import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/auth/signin/bloc/signin_bloc.dart';
import 'package:kuemele/features/auth/signin/presentation/widgets/two_factor_login_bottom_sheet.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/navigation/onboarding_navigation.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/bottom_sheet/create_passkey_bottom_sheet.dart';
import 'package:kuemele/shared/services/recaptcha/recaptcha_service.dart';

mixin SigninActionsMixin<T extends StatefulWidget> on State<T> {
  late final emailController = TextEditingController();
  late final passwordController = TextEditingController();
  bool _twoFactorSheetVisible = false;

  void disposeSigninControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  void warmUpRecaptcha() {
    getIt<RecaptchaService>().initialize().catchError((_) {});
  }

  Future<void> onSigninAuthStateChanged(
    BuildContext context,
    AuthState state,
  ) async {
    switch (state.status) {
      case AuthStatus.error:
        getIt<SigninBloc>().add(SigninRecaptchaTokenCleared());
        final message = state.errorMessage;
        if (message != null && message.isNotEmpty) {
          InjectionHelper.snackBar.showError(message);
        }
        return;
      case AuthStatus.twoFactorRequired:
        if (_twoFactorSheetVisible || !context.mounted) {
          return;
        }
        _twoFactorSheetVisible = true;
        await TwoFactorLoginBottomSheet.show(context: context);
        _twoFactorSheetVisible = false;
        return;
      case AuthStatus.signupPendingEmailVerification:
        if (!context.mounted) return;
        context.go(
          AppRoutes.emailVerification,
          extra: EmailVerificationRouteArgs(
            email: emailController.text.trim(),
            isFromSignup: false,
          ),
        );
        return;
      case AuthStatus.loginSuccess:
        if (_twoFactorSheetVisible && context.mounted) {
          Navigator.of(context, rootNavigator: true).maybePop();
          _twoFactorSheetVisible = false;
        }
        await persistSigninCredentials();
        if (!context.mounted) {
          return;
        }
        getIt<SigninBloc>().add(SigninRecaptchaTokenCleared());
        Navigator.of(context, rootNavigator: true)
            .popUntil((route) => route is! PopupRoute);
        if (!context.mounted) {
          return;
        }
        InjectionHelper.snackBar
            .showSuccess(AppLocalizations.of(context)!.signInSuccessMessage);
        OnboardingNavigation.navigateAfterAuthentication(
          context,
          showWelcomeMessage: true,
        );
      default:
        break;
    }
  }

  Future<void> persistSigninCredentials() {
    final signinState = getIt<SigninBloc>().state;
    return getIt<SigninBloc>().persistCredentials(
      email: emailController.text.trim(),
      rememberMe: signinState.rememberMe,
    );
  }

  void handleCaptchaChanged(bool value) {
    final signinBloc = getIt<SigninBloc>();
    signinBloc.add(SigninCaptchaChanged(value));

    if (!value) {
      return;
    }

    _fetchRecaptchaTokenInBackground();
  }

  void _fetchRecaptchaTokenInBackground() {
    getIt<RecaptchaService>().tryExecuteLogin().then((token) {
      if (token != null && token.isNotEmpty) {
        getIt<SigninBloc>().add(SigninRecaptchaTokenReceived(token));
      }
    }).catchError((_) {});
  }

  void handleSignIn() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      InjectionHelper.snackBar
          .showError(AppLocalizations.of(context)!.signInFillFieldsError);
      return;
    }

    if (!getIt<SigninBloc>().state.imNotARobot) {
      InjectionHelper.snackBar.showError(
          AppLocalizations.of(context)!.signInCaptchaRequiredError);
      return;
    }

    final signinState = getIt<SigninBloc>().state;
    if (signinState.recaptchaToken == null) {
      _fetchRecaptchaTokenInBackground();
    }

    getIt<AuthBloc>().add(
      AuthLoginRequested(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );
  }

  void showPasskeyDialog() {
    AppBottomSheet.show(
      context: context,
      title: AppLocalizations.of(context)!.passkeySignInTitle,
      child: const CreatePasskeyBottomSheetContent(),
    );
  }

  void openForgotPasswordPage() {
    final email = emailController.text.trim();
    context.push(
      AppRoutes.forgotPassword,
      extra: ForgotPasswordRouteArgs(
        email: email.isEmpty ? null : email,
      ),
    );
  }
}
