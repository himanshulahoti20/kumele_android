import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/two_factor_setup_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/widgets/two_factor_rich_step_text.dart';
import 'package:kuemele/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TwoFactorRichStepText(
          lead: l10n.twoFactorSetupStep2Lead,
          bold: l10n.twoFactorSetupStep2Bold,
        ),
        Gap(20.h),
        Center(
          child: AppQrCode(
            data: state.setupData?.qrCodeData ?? '',
            // Matches iOS's fixed 112x112 QR image, no border, no corner
            // radius, plain white backdrop — TwoFactorQRCodeView in
            // TwoFactorSecurityRow.swift.
            size: 112.w,
            padding: 0,
            borderRadius: 0,
            showBorder: false,
            backgroundColor: Colors.white,
            // Background is forced white to match iOS (so it scans in dark
            // mode too) — the foreground must be forced dark for the same
            // reason. Without this, the default foreground follows
            // ColorSet.textColor, which is white in dark mode and made the
            // fallback-generated QR (otpauthUrl with no image) invisible
            // against its own white backdrop.
            foregroundColor: Colors.black,
          ),
        ),
        Gap(10.h),
        // iOS shows the secret as small, 65%-opacity, regular-weight plain
        // text (`.textSelection(.enabled)` — long-press to copy, no
        // dedicated copy button/snackbar). SelectableText is the direct
        // Flutter equivalent of that native text-selection behavior.
        SelectableText(
          manualCode,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.textColor.withValues(alpha: 0.65),
            fontSize: 12,
          ),
        ),
        Gap(4.h),
        Text(
          l10n.twoFactorSetupCantScan,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.textColor,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
