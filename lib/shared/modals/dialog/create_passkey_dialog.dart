import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/modals/dialog/sign_up_passkey_dialog.dart';

class CreatePasskeyDialog extends StatelessWidget {
  const CreatePasskeyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDialogContent(
      title: 'Sign in with your Kumele passkey',
      onContinue: () {
        context.pop();
        AppDialog.show(
          context: context,
          width: AppDialogSize.widthFor(context),
          dialog: const SignUpPasskeyDialog(),
        );
      },
      child: Text(
        'Passkeys are easy to set up and let you securely sign in to your Kumele Account using the  security capabilities of your devices like Touch ID and Face ID.  Passkeys are way more secure and are easier to use than all current 2-factor authentication methods.',
        textAlign: TextAlign.center,
        style: context.textTheme.bodyMedium.copyWith(
          color: ColorSet.color525252,
          fontSize: 14.57,
        ),
      ),
    );
  }
}
