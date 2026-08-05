import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/edit_profile_bloc.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/widgets/app_loading_indicator.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class EditProfileUsernameField extends StatefulWidget {
  const EditProfileUsernameField({
    super.key,
    required this.value,
  });

  final String value;

  @override
  State<EditProfileUsernameField> createState() =>
      _EditProfileUsernameFieldState();
}

class _EditProfileUsernameFieldState extends State<EditProfileUsernameField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant EditProfileUsernameField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.value = _controller.value.copyWith(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      buildWhen: (previous, current) =>
          previous.isCheckingUsername != current.isCheckingUsername ||
          previous.isUsernameAvailable != current.isUsernameAvailable,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KumeleTextField(
              controller: _controller,
              labelText: AppStrings.onboardingUsernameLabel,
              hintText: AppStrings.onboardingUsernameHint,
              textInputAction: TextInputAction.next,
              prefixIcon: Padding(
                padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
                child: KumeleAssetWidget(
                  assetPath: AuthConfig.accountIcon,
                  width: 24,
                  height: 24,
                  color: ColorSet.textColor,
                ),
              ),
              onChanged: (value) {
                final bloc = context.read<EditProfileBloc>();
                bloc.add(EditProfileUsernameChanged(value));
                bloc.add(EditProfileCheckUsername(value));
              },
            ),
            Gap(4.h),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) {
                return _UsernameValidationMessage(
                  username: value.text.trim(),
                  originalUsername: state.originalUsername.trim(),
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
    required this.originalUsername,
    required this.state,
  });

  final String username;
  final String originalUsername;
  final EditProfileState state;

  @override
  Widget build(BuildContext context) {
    if (username.isEmpty || username == originalUsername) {
      return const SizedBox.shrink();
    }

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
