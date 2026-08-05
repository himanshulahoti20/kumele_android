import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class SigninEntryBanner extends StatelessWidget {
  const SigninEntryBanner({
    super.key,
    required this.label,
    this.description,
  });

  final String label;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: ColorSet.lightBlueColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.titleMediumBold.copyWith(
              color: ColorSet.specialBlueColor,
            ),
          ),
          if (description != null) ...[
            const Gap(6),
            Text(
              description!,
              style: context.textTheme.bodyMediumSemiBold.copyWith(
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: ColorSet.profileSubTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
