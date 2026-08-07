import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/models/scanned_guest_qr_payload.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';

class GuestCheckInConfirmSheet extends StatelessWidget {
  const GuestCheckInConfirmSheet({
    super.key,
    required this.payload,
    this.isLoading = false,
  });

  final ScannedGuestQrPayload payload;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppAvatar(
          imageUrl: payload.avatar,
          name: payload.name,
          size: 80,
          showShadow: false,
        ),
        Gap(16.h),
        Text(
          payload.name,
          style: context.textTheme.titleLargeBold,
          textAlign: TextAlign.center,
        ),
        Gap(8.h),
        Text(
          AppLocalizations.of(context)!.confirmGuestCheckInDescription,
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.subTextColor,
          ),
          textAlign: TextAlign.center,
        ),
        Gap(24.h),
        AppButton.primary(
          label: AppLocalizations.of(context)!.confirm,
          isLoading: isLoading,
          onPressed: isLoading ? null : () => context.pop(true),
        ),
      ],
    );
  }
}
