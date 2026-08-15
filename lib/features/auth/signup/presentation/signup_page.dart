import 'package:flutter/material.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/auth/signup/bloc/signup_bloc.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_header.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_phone_body.dart';
import 'package:kuemele/features/auth/signup/presentation/widgets/signup_tablet_body.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/base/base_page.dart';

class Signup extends StatefulWidget implements BasePage {
  const Signup({
    super.key,
    this.entryLabel,
    this.entryDescription,
  });

  final String? entryLabel;
  final String? entryDescription;

  @override
  State<Signup> createState() => _SignupState();

  @override
  String get screenName => 'Signup';
}

class _SignupState extends State<Signup> {
  final TextEditingController firstNameCTR = TextEditingController();
  final TextEditingController lastNameCTR = TextEditingController();
  final TextEditingController emailCTR = TextEditingController();
  final TextEditingController enterPasswordCTR = TextEditingController();
  final TextEditingController confirmPasswordCTR = TextEditingController();
  final TextEditingController referralCTR = TextEditingController();
  final TextEditingController betaCTR = TextEditingController();

  @override
  void initState() {
    super.initState();
    getIt<SignupBloc>().add(SignupReset());
  }

  @override
  void dispose() {
    firstNameCTR.dispose();
    lastNameCTR.dispose();
    emailCTR.dispose();
    enterPasswordCTR.dispose();
    confirmPasswordCTR.dispose();
    referralCTR.dispose();
    betaCTR.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = InjectionHelper.responsiveService.fromContext(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          bloc: getIt<AuthBloc>(),
          listenWhen: (previous, current) => previous.status != current.status,
          listener: _onAuthStateChanged,
        ),
        BlocListener<SignupBloc, SignupState>(
          bloc: getIt<SignupBloc>(),
          listenWhen: (previous, current) => previous.status != current.status,
          listener: _onSignupStateChanged,
        ),
      ],
      child: Container(
        color: ColorSet.bg3Color,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              SignupHeader(showTitle: responsive.isPhone),
              Expanded(
                child: ResponsiveDeviceBuilder(
                  phone: SignupPhoneBody(
                    firstNameController: firstNameCTR,
                    lastNameController: lastNameCTR,
                    emailController: emailCTR,
                    passwordController: enterPasswordCTR,
                    confirmPasswordController: confirmPasswordCTR,
                    referralController: referralCTR,
                    betaController: betaCTR,
                    onSignUp: _handleSignUp,
                    entryLabel: widget.entryLabel,
                    entryDescription: widget.entryDescription,
                  ),
                  tablet: SignupTabletBody(
                    firstNameController: firstNameCTR,
                    lastNameController: lastNameCTR,
                    emailController: emailCTR,
                    passwordController: enterPasswordCTR,
                    confirmPasswordController: confirmPasswordCTR,
                    referralController: referralCTR,
                    betaController: betaCTR,
                    onSignUp: _handleSignUp,
                    entryLabel: widget.entryLabel,
                    entryDescription: widget.entryDescription,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAuthStateChanged(BuildContext context, AuthState state) {
    switch (state.status) {
      case AuthStatus.error:
        final message = state.errorMessage;
        if (message != null && message.isNotEmpty) {
          InjectionHelper.snackBar.showError(message);
        }
        break;
      case AuthStatus.signupPendingEmailVerification:
        InjectionHelper.snackBar.showSuccess(
            AppLocalizations.of(context)!.accountCreatedSuccessMessage);
        context.go(
          AppRoutes.emailVerification,
          extra: EmailVerificationRouteArgs(
            email: emailCTR.text.trim(),
            isFromSignup: true,
          ),
        );
        break;
      default:
        break;
    }
  }

  void _onSignupStateChanged(BuildContext context, SignupState state) {
    if (state.status == SignupUIStatus.validationError &&
        state.errorMessage != null) {
      InjectionHelper.snackBar.showError(state.errorMessage!);
    } else if (state.status == SignupUIStatus.validationSuccess) {
      try {
        final firstName = firstNameCTR.text.trim();
        final lastName = lastNameCTR.text.trim();
        final user = UserModel(
          firstName: firstName,
          lastName: lastName.isEmpty ? null : lastName,
          email: emailCTR.text.trim(),
          password: enterPasswordCTR.text,
          referralCode:
              referralCTR.text.isEmpty ? null : referralCTR.text.trim(),
        );

        getIt<AuthBloc>().add(AuthSignupRequested(user: user));
      } catch (e) {
        InjectionHelper.snackBar.showError(
            AppLocalizations.of(context)!.signupFailedPrefix(e.toString()));
      }
    }
  }

  void _handleSignUp() {
    getIt<SignupBloc>().add(SignupSubmitted(
      firstName: firstNameCTR.text.trim(),
      lastName: lastNameCTR.text.trim(),
      email: emailCTR.text.trim(),
      password: enterPasswordCTR.text,
      confirmPassword: confirmPasswordCTR.text,
    ));
  }
}
