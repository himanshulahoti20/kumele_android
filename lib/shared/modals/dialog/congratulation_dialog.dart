import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class CongratulationDialog extends StatelessWidget {
  const CongratulationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTitledDialog(
      title: AppLocalizations.of(context)!.congratulationsTitle,
      child: Stack(
        children: [
          Column(
            spacing: 10,
            children: [
              Image.asset(IconSet.medalIcon, width: 30, height: 30),
              Text(
                AppLocalizations.of(context)!.congratsNewStatusBronze,
                textAlign: TextAlign.center,
                style: context.textTheme.titleLargeBold.copyWith(
                  color: ColorSet.textColor,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.congratsDiscountCode,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLargeSemiBold.copyWith(
                  color: ColorSet.textColor,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.congratsBronzeDescription,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge.copyWith(
                  fontSize: 15,
                  color: ColorSet.textColor,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Lottie.asset('assets/icons_json/Confetti.json', height: 400),
          ),
        ],
      ),
    );
  }
}
