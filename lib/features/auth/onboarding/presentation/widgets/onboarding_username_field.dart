import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/features/auth/onboarding/bloc/onboarding_bloc.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/widgets/app_loading_indicator.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class OnboardingUsernameField extends StatelessWidget {
  const OnboardingUsernameField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      buildWhen: (previous, current) =>
          previous.isCheckingUsername != current.isCheckingUsername ||
          previous.isUsernameAvailable != current.isUsernameAvailable,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KumeleTextField(
              controller: controller,
              labelText: AppStrings.onboardingUsernameLabel,
              hintText: AppStrings.onboardingUsernameHint,
              prefixIcon: Padding(
                padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
                child: KumeleAssetWidget(
                  assetPath: AuthConfig.accountIcon,
                  width: 24,
                  height: 24,
                  color: ColorSet.textColor,
                ),
              ),
              onChanged: (value) => context
                  .read<OnboardingBloc>()
                  .add(OnboardingCheckUsername(value)),
            ),
            Gap(4.h),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                return _UsernameValidationMessage(
                  username: value.text.trim(),
                  state: state,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _UsernameValidationMessage extends StatelessWidget {
  const _UsernameValidationMessage({
    required this.username,
    required this.state,
  });

  final String username;
  final OnboardingState state;

  @override
  Widget build(BuildContext context) {
    if (username.isEmpty) return const SizedBox.shrink();

    final String? message;
    final Color color;
    final Widget icon;

    if (state.isCheckingUsername) {
      message = AppStrings.onboardingUsernameChecking;
      color = ColorSet.subTextColor;
      icon = AppLoadingIndicator.circle(
        size: 16.w,
      );
    } else if (state.isUsernameAvailable == true) {
      message = AppStrings.onboardingUsernameAvailable;
      color = ColorSet.snackBarSuccessBg;
      icon = KumeleAssetWidget.square(
        assetPath: Assets.icons.successCheck.path,
        size: 16.w,
      );
    } else if (state.isUsernameAvailable == false) {
      message = AppStrings.onboardingUsernameTaken;
      color = ColorSet.snackBarErrorBg;
      icon = KumeleAssetWidget.square(
        assetPath: Assets.icons.roundCancel.path,
        size: 16.w,
      );
    } else {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Gap(6.w),
        icon,
        Gap(6.w),
        Text(
          message,
          style: context.textTheme.bodySmall.copyWith(
            color: color,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
