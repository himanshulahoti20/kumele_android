import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/two_factor_setup_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/widgets/two_factor_rich_step_text.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_qr_code.dart';

class TwoFactorSetupStepTwo extends StatelessWidget {
  const TwoFactorSetupStepTwo({
    super.key,
    required this.state,
  });

  final TwoFactorSetupState state;

  @override
  Widget build(BuildContext context) {
    final manualCode = state.setupData?.manualCode ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TwoFactorRichStepText(
          lead: AppStrings.twoFactorSetupStep2Lead,
          bold: AppStrings.twoFactorSetupStep2Bold,
        ),
        Gap(20.h),
        Center(
          child: AppQrCode(
            data: state.setupData?.qrCodeData ?? '',
            size: 150.w,
            padding: 0,
            showBorder: false,
            backgroundColor: Colors.white,
          ),
        ),
        Gap(16.h),
        GestureDetector(
          onTap: () => _copyManualCode(manualCode),
          child: Text(
            manualCode,
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmallBold.copyWith(
              color: ColorSet.textColor,
              letterSpacing: 4,
            ),
          ),
        ),
        Gap(8.h),
        Text(
          AppStrings.twoFactorSetupCantScan,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.subTextColor,
          ),
        ),
      ],
    );
  }

  void _copyManualCode(String code) {
    if (code.isEmpty) return;

    Clipboard.setData(ClipboardData(text: code));
    InjectionHelper.snackBar.show(AppStrings.twoFactorManualCodeCopied);
  }
}
