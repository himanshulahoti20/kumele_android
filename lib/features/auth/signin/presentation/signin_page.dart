import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/auth/signin/bloc/signin_bloc.dart';
import 'package:kuemele/features/auth/signin/presentation/mixins/signin_actions_mixin.dart';
import 'package:kuemele/features/auth/signin/presentation/widgets/signin_header.dart';
import 'package:kuemele/features/auth/signin/presentation/widgets/signin_phone_body.dart';
import 'package:kuemele/features/auth/signin/presentation/widgets/signin_tablet_body.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/modals/bottom_sheet/permission_flow_bottom_sheet.dart';

class Signin extends StatefulWidget implements BasePage {
  const Signin({
    super.key,
    this.entryLabel,
    this.entryDescription,
  });

  final String? entryLabel;
  final String? entryDescription;

  @override
  State<Signin> createState() => _SigninState();

  @override
  String get screenName => 'Signin';
}

class _SigninState extends State<Signin> with SigninActionsMixin<Signin> {
  @override
  void initState() {
    super.initState();
    getIt<SigninBloc>().add(SigninInitialized());
    warmUpRecaptcha();
    // The one and only place the notification/photos/location primer runs:
    // right as the user lands on the login screen. Each step's OS dialog
    // (and, for location, PermissionFlowSheet -> LocationCubit.requestLocation)
    // fires from here, not silently at boot or after auth.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => PermissionFlowSheet.showIfNeeded(),
    );
  }

  @override
  void dispose() {
    disposeSigninControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return BlocListener<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      listenWhen: (previous, current) => previous.status != current.status,
      listener: onSigninAuthStateChanged,
      child: BlocListener<SigninBloc, SigninState>(
        bloc: getIt<SigninBloc>(),
        listenWhen: (previous, current) =>
            previous.preferencesGeneration != current.preferencesGeneration,
        listener: (context, state) {
          final rememberedEmail = state.rememberedEmail;
          if (rememberedEmail != null) {
            emailController.text = rememberedEmail;
          }
        },
        child: Container(
          color: ColorSet.bg3Color,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                SigninHeader(showTitle: responsive.isPhone),
                Expanded(
                  child: ResponsiveDeviceBuilder(
                    phone: SigninPhoneBody(
                      emailController: emailController,
                      passwordController: passwordController,
                      onSignIn: handleSignIn,
                      onForgotPassword: openForgotPasswordPage,
                      onCaptchaChanged: handleCaptchaChanged,
                      onPasskeyTap: showPasskeyDialog,
                      entryLabel: widget.entryLabel,
                      entryDescription: widget.entryDescription,
                    ),
                    tablet: SigninTabletBody(
                      emailController: emailController,
                      passwordController: passwordController,
                      onSignIn: handleSignIn,
                      onForgotPassword: openForgotPasswordPage,
                      onCaptchaChanged: handleCaptchaChanged,
                      onPasskeyTap: showPasskeyDialog,
                      entryLabel: widget.entryLabel,
                      entryDescription: widget.entryDescription,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
