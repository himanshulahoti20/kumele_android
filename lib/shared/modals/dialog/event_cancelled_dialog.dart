import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class EventCancelledDialog extends StatelessWidget {
  const EventCancelledDialog({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              iconSize: 26,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 30, height: 30),
              onPressed: () => context.pop(),
              icon: Icon(Icons.close, color: ColorSet.subTextColor),
            ),
          ),
          const SizedBox(height: 4),
          Icon(Icons.volume_up_rounded, size: 58, color: ColorSet.textColor),
          const SizedBox(height: 18),
          Text(
            AppLocalizations.of(context)!.eventCancelledDialogTitle,
            textAlign: TextAlign.center,
            style: context.textTheme.heading3.copyWith(
              color: ColorSet.textColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message?.isNotEmpty == true
                ? message!
                : AppLocalizations.of(context)!.eventCancelledDialogMessage,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge.copyWith(
              color: ColorSet.textColor,
              fontSize: 15,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.premiumPurchaseIncludeLabel,
              style: context.textTheme.bodyLargeSemiBold.copyWith(
                color: ColorSet.textColor,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bullet(context,
                    AppLocalizations.of(context)!.premiumLocationChange),
                _bullet(
                    context, AppLocalizations.of(context)!.premiumHouseParty),
                _bullet(context, AppLocalizations.of(context)!.premiumNoAds),
                _bullet(
                  context,
                  AppLocalizations.of(context)!.premium7DaysAdvertising,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bullet(BuildContext context, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: context.textTheme.bodyLarge.copyWith(fontSize: 15)),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodyLarge.copyWith(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
