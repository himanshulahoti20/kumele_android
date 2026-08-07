import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/input/app_input_formatters.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/two_factor_setup_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/widgets/two_factor_rich_step_text.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';

class TwoFactorSetupStepThree extends StatelessWidget {
  const TwoFactorSetupStepThree({
    super.key,
    required this.state,
    required this.bloc,
  });

  final TwoFactorSetupState state;
  final TwoFactorSetupBloc bloc;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TwoFactorRichStepText(
          lead: l10n.twoFactorSetupStep3Lead,
          bold: l10n.twoFactorSetupStep3Bold,
        ),
        Gap(16.h),
        KumeleTextField(
          key: ValueKey(state.setupData?.qrCodeData),
          hintText: l10n.twoFactorVerificationHint,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          enabled: !state.isSubmitting,
          filled: true,
          fillColor: ColorSet.tileFillColor,
          inputFormatters: AppInputFormatters.otpCode(),
          onChanged: (value) => bloc.add(TwoFactorSetupCodeChanged(value)),
        ),
      ],
    );
  }
}
