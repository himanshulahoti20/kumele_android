import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class TwoFactorRichStepText extends StatelessWidget {
  const TwoFactorRichStepText({
    super.key,
    required this.lead,
    required this.bold,
  });

  final String lead;
  final String bold;

  @override
  Widget build(BuildContext context) {
    final baseStyle = context.textTheme.bodyLarge.copyWith(
      color: ColorSet.textColor,
    );

    return Text.rich(
      TextSpan(
        text: lead,
        style: baseStyle,
        children: [
          TextSpan(
            text: bold,
            style: baseStyle.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
