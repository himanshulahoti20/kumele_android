import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/features/auth/signup/bloc/signup_bloc.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/components/app_checkbox.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class SignupCheckboxes extends StatelessWidget {
  const SignupCheckboxes({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        final bloc = context.read<SignupBloc>();
        return Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCheckbox.label(
                  text: 'I am a legal adult (18/21+)',
                  value: state.legalAdult,
                  spaceBetween: 20.w,
                  showCheckIcon: false,
                  borderColor: AuthConfig.tappableBorderColor,
                  borderWidth: AuthConfig.tappableBorderWidth,
                  onChanged: (val) => bloc.add(SignupLegalAdultChanged(val)),
                ),
                AppCheckbox.label(
                  text: 'Subscribe to newsletter',
                  value: state.subscribe,
                  spaceBetween: 20.w,
                  showCheckIcon: false,
                  borderColor: AuthConfig.tappableBorderColor,
                  borderWidth: AuthConfig.tappableBorderWidth,
                  onChanged: (val) => bloc.add(SignupSubscribeChanged(val)),
                ),
                AppCheckbox.link(
                  text: 'By Creating an account you agree to ',
                  linkedText: "Terms & Conditions",
                  linkedTextColor: ColorSet.specialBlueColor,
                  value: state.terms,
                  spaceBetween: 20.w,
                  showCheckIcon: false,
                  borderColor: AuthConfig.tappableBorderColor,
                  borderWidth: AuthConfig.tappableBorderWidth,
                  onChanged: (val) => bloc.add(SignupTermsChanged(val)),
                  linkOnTap: () => context.push(AppRoutes.signupTerms),
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                AppCheckbox.label(
                  text: 'I am not a robot',
                  value: state.imNotARobot,
                  spaceBetween: 20.w,
                  showCheckIcon: false,
                  borderColor: AuthConfig.tappableBorderColor,
                  borderWidth: AuthConfig.tappableBorderWidth,
                  onChanged: (val) => bloc.add(SignupCaptchaChanged(val)),
                ),
                KumeleAssetWidget.square(
                  assetPath: AuthConfig.captchaIcon,
                  size: 38,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
