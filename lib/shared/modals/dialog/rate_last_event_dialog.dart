import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';

/// Tablet-only, matches iOS PopUpRateLastEventView exactly — an
/// auto-dismissing message shown for 1 second, then closes itself and hands
/// off to [onDone] (the app-store rating dialog, in the real chain).
class RateLastEventDialog extends StatefulWidget {
  const RateLastEventDialog({super.key, this.onDone});

  final VoidCallback? onDone;

  @override
  State<RateLastEventDialog> createState() => _RateLastEventDialogState();
}

class _RateLastEventDialogState extends State<RateLastEventDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onDone?.call();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        // iOS bgAlertColor (white in light mode, black in dark) matches
        // Android's bg3Color.
        color: ColorSet.bg3Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(IconSet.doublestar, width: 77, height: 77),
          const SizedBox(height: 16),
          Text(
            'Please rate your last event',
            textAlign: TextAlign.center,
            style: context.textTheme.titleLargeBold.copyWith(
              fontSize: 24,
              color: ColorSet.textColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your ratings help to improve our community experience.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w300,
              fontSize: 15,
              color: ColorSet.textColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '-Thank You!',
            style: context.textTheme.bodyMedium.copyWith(
              fontSize: 15,
              color: ColorSet.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
