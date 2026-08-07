import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
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
          AppLocalizations.of(context)!.passkeyIntroDescription,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.color525252,
            fontSize: 14.57,
          ),
        ),
        const Gap(24),
        AppButton.primary(
          label: AppLocalizations.of(context)!.continueLabel,
          onPressed: () {
            context.pop();
            AppBottomSheet.show(
              context: context,
              title: AppLocalizations.of(context)!.passkeyTitle,
              child: const SignUpPasskeyBottomSheetContent(),
            );
          },
        ),
      ],
    );
  }
}
