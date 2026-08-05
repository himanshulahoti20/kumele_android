import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/input/app_input_formatters.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/auth/bloc/auth_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/widgets/two_factor_rich_step_text.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';

class TwoFactorLoginContent extends StatelessWidget {
  const TwoFactorLoginContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = getIt<AuthBloc>();

    return BlocConsumer<AuthBloc, AuthState>(
      bloc: authBloc,
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == AuthStatus.loginSuccess,
      listener: (context, state) => context.pop(),
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.twoFactorLoginDescription,
              style: context.textTheme.bodyLarge.copyWith(
                color: ColorSet.subTextColor,
              ),
            ),
            Gap(24.h),
            const TwoFactorRichStepText(
              lead: AppStrings.twoFactorLoginCodeLead,
              bold: AppStrings.twoFactorLoginCodeBold,
            ),
            Gap(16.h),
            KumeleTextField(
              hintText: AppStrings.twoFactorVerificationHint,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              enabled: !state.isLoading(AuthLoadingAction.twoFactorVerify),
              inputFormatters: AppInputFormatters.otpCode(),
              onChanged: (value) =>
                  authBloc.add(AuthTwoFactorCodeChanged(value)),
            ),
            Gap(24.h),
            AppButton.primary(
              label: AppStrings.twoFactorLoginVerify,
              isLoading: state.isLoading(AuthLoadingAction.twoFactorVerify),
              onPressed: state.canSubmitTwoFactor
                  ? () => authBloc.add(const AuthTwoFactorVerifyRequested())
                  : null,
            ),
          ],
        );
      },
    );
  }
}
