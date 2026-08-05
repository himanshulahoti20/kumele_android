import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/input/app_input_formatters.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/two_factor_disable_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/widgets/two_factor_rich_step_text.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';

class TwoFactorDisableContent extends StatelessWidget {
  const TwoFactorDisableContent({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = InjectionHelper.twoFactorDisableBloc;

    return BlocConsumer<TwoFactorDisableBloc, TwoFactorDisableState>(
      bloc: bloc,
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == TwoFactorDisableStatus.success,
      listener: (context, state) => context.pop(),
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.twoFactorDisableDescription,
              style: context.textTheme.bodyMediumSemiBold.copyWith(
                fontWeight: FontWeight.w400,
                color: ColorSet.subTextColor,
                height: 1.45,
              ),
            ),
            Gap(24.h),
            const TwoFactorRichStepText(
              lead: AppStrings.twoFactorDisableCodeLead,
              bold: AppStrings.twoFactorSetupStep3Bold,
            ),
            Gap(16.h),
            KumeleTextField(
              hintText: AppStrings.twoFactorVerificationHint,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              enabled: !state.isSubmitting,
              inputFormatters: AppInputFormatters.otpCode(),
              onChanged: (value) =>
                  bloc.add(TwoFactorDisableCodeChanged(value)),
            ),
            Gap(24.h),
            AppButton.danger(
              label: AppStrings.twoFactorDisableConfirm,
              isLoading: state.isSubmitting,
              onPressed: state.canSubmit
                  ? () => bloc.add(const TwoFactorDisableSubmitted())
                  : null,
            ),
          ],
        );
      },
    );
  }
}
