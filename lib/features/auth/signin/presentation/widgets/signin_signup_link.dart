import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';

class SigninSignupLink extends StatelessWidget {
  const SigninSignupLink({
    super.key,
    this.entryLabel,
    this.entryDescription,
    this.prefix,
    this.signUpFontSize,
  });

  final String? entryLabel;
  final String? entryDescription;
  final String? prefix;
  final double? signUpFontSize;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final linkStyle = context.textTheme.bodyLargeSemiBold.copyWith(
      fontWeight: FontWeight.w500,
      color: ColorSet.bg9Color,
    );
    final signUpStyle = context.textTheme.bodyLargeBold.copyWith(
      color: ColorSet.specialBlueColor,
      fontSize: signUpFontSize,
      decoration: TextDecoration.underline,
    );

    return Row(
      children: [
        Text(prefix ?? l10n.signInNotAMemberPrefix, style: linkStyle),
        ClickWidget(
          onPressed: () {
            context.push(
              AppRoutes.signup,
              extra: AuthRouteArgs(
                entryLabel: entryLabel,
                entryDescription: entryDescription,
              ),
            );
          },
          child: Text(l10n.signUpButtonLabel, style: signUpStyle),
        ),
      ],
    );
  }
}
