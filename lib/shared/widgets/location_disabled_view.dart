import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/cubit/location_cubit.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class LocationDisabledView extends StatelessWidget {
  final LocationState locationState;

  const LocationDisabledView({
    super.key,
    required this.locationState,
  });

  @override
  Widget build(BuildContext context) {
    final isPermanent =
        locationState.status == LocationStatus.permanentlyDenied;
    final isServiceOff = locationState.status == LocationStatus.serviceDisabled;

    final title =
        isServiceOff ? AppLocalizations.of(context)!.locationServicesOffTitle : AppLocalizations.of(context)!.locationAccessRequiredTitle;

    final message = isServiceOff
        ? AppLocalizations.of(context)!.locationServicesOffMessage
        : isPermanent
            ? AppLocalizations.of(context)!.locationPermissionPermanentlyDeniedMessage
            : AppLocalizations.of(context)!.locationAccessNeededMessage;

    return Scaffold(
      backgroundColor: ColorSet.bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off_rounded,
                size: 72,
                color: ColorSet.subTextColor,
              ),
              const Gap(24),
              Text(
                title,
                style:
                    AppTextTheme.titleLarge.copyWith(color: ColorSet.textColor),
                textAlign: TextAlign.center,
              ),
              const Gap(12),
              Text(
                message,
                style: AppTextTheme.bodyMedium
                    .copyWith(color: ColorSet.subTextColor),
                textAlign: TextAlign.center,
              ),
              const Gap(32),
              AppButton.primary(
                label: AppLocalizations.of(context)!.tryAgainLabel,
                onPressed: () =>
                    InjectionHelper.locationCubit.requestLocation(),
                fullWidth: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
