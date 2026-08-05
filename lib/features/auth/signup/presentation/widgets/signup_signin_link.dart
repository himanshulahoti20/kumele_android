import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/navigation/app_routes.dart';

class SignupSigninLink extends StatelessWidget {
  const SignupSigninLink({
    super.key,
    this.entryLabel,
    this.entryDescription,
    this.signInFontSize = 18,
  });

  final String? entryLabel;
  final String? entryDescription;
  final double signInFontSize;

  @override
  Widget build(BuildContext context) {
    final prefixStyle = context.textTheme.bodyLargeSemiBold.copyWith(
      fontWeight: FontWeight.w500,
      color: ColorSet.textColor,
    );
    final signInStyle = context.textTheme.bodyLargeBold.copyWith(
      color: ColorSet.lightBlueColor,
      fontSize: signInFontSize,
      decoration: TextDecoration.underline,
    );

    return Row(
      spacing: 5,
      children: [
        Text('Already have an account? ', style: prefixStyle),
        ClickWidget(
          onPressed: () {
            context.push(
              AppRoutes.signin,
              extra: AuthRouteArgs(
                entryLabel: entryLabel,
                entryDescription: entryDescription,
              ),
            );
          },
          child: Text('Sign in', style: signInStyle),
        ),
      ],
    );
  }
}
