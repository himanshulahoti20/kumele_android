import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:lottie/lottie.dart';

class CongratulationDialog extends StatelessWidget {
  const CongratulationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTitledDialog(
      title: 'Congratulations',
      child: Stack(
        children: [
          Column(
            spacing: 10,
            children: [
              Image.asset(IconSet.medalIcon, width: 30, height: 30),
              Text(
                'New Status: Bronze',
                textAlign: TextAlign.center,
                style: context.textTheme.titleLargeBold.copyWith(
                  color: ColorSet.textColor,
                ),
              ),
              Text(
                'Discount Code: KEMELE20',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLargeSemiBold.copyWith(
                  color: ColorSet.textColor,
                ),
              ),
              Text(
                'You created a minimum of 3 events or user attended a minimum of 3 events without fail in the last 30 days. The user gets 4% discount of one in-app purchase of choice.',
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
