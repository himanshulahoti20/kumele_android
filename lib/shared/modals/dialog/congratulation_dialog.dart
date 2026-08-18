import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';

class CongratulationDialog extends StatelessWidget {
  const CongratulationDialog({
    super.key,
    this.status,
    this.discountCode,
    this.description,
  });

  final String? status;
  final String? discountCode;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.congratulationsTitle,
                  textAlign: TextAlign.center,
                  style: context.textTheme.heading3.copyWith(
                    color: ColorSet.textColor,
                    fontSize: 20,
                  ),
                ),
              ),
              IconButton(
                iconSize: 24,
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints.tightFor(width: 30, height: 30),
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close, color: ColorSet.subTextColor),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorSet.tileFillColor,
            ),
            child: Image.asset(IconSet.medalIcon),
          ),
          const SizedBox(height: 10),
          Text(
            status?.isNotEmpty == true
                ? status!
                : AppLocalizations.of(context)!.congratsNewStatusBronze,
            textAlign: TextAlign.center,
            style: context.textTheme.heading3.copyWith(
              color: ColorSet.textColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            discountCode?.isNotEmpty == true
                ? 'Discount Code: $discountCode'
                : AppLocalizations.of(context)!.congratsDiscountCode,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLargeSemiBold.copyWith(
              color: ColorSet.textColor,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description?.isNotEmpty == true
                ? description!
                : AppLocalizations.of(context)!.congratsBronzeDescription,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge.copyWith(
              fontSize: 15,
              height: 1.3,
              color: ColorSet.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
