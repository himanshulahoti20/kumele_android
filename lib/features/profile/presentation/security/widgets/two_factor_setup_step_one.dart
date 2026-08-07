import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/profile/presentation/security/two_factor_config.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class TwoFactorSetupStepOne extends StatelessWidget {
  const TwoFactorSetupStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    final apps = TwoFactorConfig.recommendedAuthenticatorApps();
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.twoFactorSetupStep1,
          style: context.textTheme.bodyLarge.copyWith(
            color: ColorSet.textColor,
          ),
        ),
        Gap(8.h),
        Text(
          l10n.twoFactorSetupStep1Hint,
          style: context.textTheme.bodySmall.copyWith(
            fontSize: 13.sp,
            color: ColorSet.subTextColor,
          ),
        ),
        Gap(16.h),
        Row(
          children: [
            for (var i = 0; i < apps.length; i++) ...[
              if (i > 0) Gap(8.w),
              Expanded(child: _AuthenticatorAppTile(app: apps[i])),
            ],
          ],
        ),
      ],
    );
  }
}

class _AuthenticatorAppTile extends StatelessWidget {
  const _AuthenticatorAppTile({required this.app});

  final TwoFactorAuthenticatorApp app;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KumeleAssetWidget.square(
          assetPath: app.assetPath,
          size: 70.w,
          fit: BoxFit.contain,
        ),
        Gap(8.h),
        Text(
          app.label,
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall.copyWith(
            color: ColorSet.textColor,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}
