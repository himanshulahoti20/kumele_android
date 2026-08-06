import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/bottom_sheet/sign_up_passkey_bottom_sheet.dart';

class CreatePasskeyBottomSheetContent extends StatelessWidget {
  const CreatePasskeyBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Passkeys are easy to set up and let you securely sign in to your Kumele Account using the  security capabilities of your devices like Touch ID and Face ID.  Passkeys are way more secure and are easier to use than all current 2-factor authentication methods.',
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.color525252,
            fontSize: 14.57,
          ),
        ),
        const Gap(24),
        AppButton.primary(
          label: AppStrings.continueLabel,
          onPressed: () {
            context.pop();
            AppBottomSheet.show(
              context: context,
              title: 'Passkey',
              child: const SignUpPasskeyBottomSheetContent(),
            );
          },
        ),
      ],
    );
  }
}
