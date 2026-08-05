import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:lottie/lottie.dart';

class SigninFooter extends StatelessWidget {
  const SigninFooter({
    super.key,
    required this.onPasskeyTap,
  });

  final VoidCallback onPasskeyTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(color: ColorSet.textColor, height: 1),
            ),
            const Gap(10),
            Text(
              AuthConfig.passkeyDividerLabel,
              style: context.textTheme.bodyLargeSemiBold.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(10),
            Expanded(
              child: Container(color: ColorSet.textColor, height: 1),
            ),
          ],
        ),
        const Gap(16),
        GestureDetector(
          onTap: onPasskeyTap,
          child: Lottie.asset(
            AuthConfig.padlockAnimation,
            width: 45,
            height: 45,
          ),
        ),
        const Gap(16),
        Text(
          AuthConfig.passkeyDescription,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: context.textTheme.bodyMediumSemiBold.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: responsive.isTablet ? 18 : 14,
            color: ColorSet.lightBlueColor,
          ),
        ),
      ],
    );
  }
}
