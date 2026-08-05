import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/cubit/location_cubit.dart';

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
        isServiceOff ? 'Location Services Off' : 'Location Access Required';

    final message = isServiceOff
        ? 'Please enable location services on your device to discover events near you.'
        : isPermanent
            ? 'Location permission was permanently denied. Please enable it in app settings.'
            : 'Location access is needed to show events near you.';

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
                label: 'Try Again',
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
