import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';

class SignUpPasskeyBottomSheetContent extends StatefulWidget {
  const SignUpPasskeyBottomSheetContent({super.key});

  @override
  State<SignUpPasskeyBottomSheetContent> createState() =>
      _SignUpPasskeyBottomSheetContentState();
}

class _SignUpPasskeyBottomSheetContentState
    extends State<SignUpPasskeyBottomSheetContent> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      InjectionHelper.snackBar.showError(AuthConfig.fillFieldsError);
      return;
    }

    getIt<AuthBloc>().add(AuthPasskeyLoginRequested(email: email));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.loadingAction != current.loadingAction,
      builder: (context, authState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sign in using passkey',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium.copyWith(
                color: ColorSet.color525252,
                fontSize: 14.57,
              ),
            ),
            const Gap(30),
            KumeleTextField(
              controller: _emailController,
              hintText: 'Enter your e-mail',
            ),
            const Gap(24),
            AppButton.primary(
              label: AppStrings.continueLabel,
              isLoading: authState.isLoading(AuthLoadingAction.passkeyLogin),
              onPressed: _onContinue,
            ),
          ],
        );
      },
    );
  }
}
