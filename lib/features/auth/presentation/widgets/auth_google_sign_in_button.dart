import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';

class AuthGoogleSignInButton extends StatelessWidget {
  const AuthGoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: InjectionHelper.authBloc,
      buildWhen: (previous, current) =>
          previous.loadingAction != current.loadingAction ||
          previous.status != current.status,
      builder: (context, state) {
        final isLoading = state.isLoading(AuthLoadingAction.googleLogin);

        return AppRoundedIconButton(
          assetPath: Assets.icons.google.path,
          iconSize: 26,
          isLoading: isLoading,
          onTap: isLoading
              ? null
              : () => InjectionHelper.authBloc.add(AuthGoogleLoginRequested()),
          semanticLabel: AppLocalizations.of(context)!.signInWithGoogleLabel,
        );
      },
    );
  }
}
