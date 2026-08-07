import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/two_factor_setup_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/widgets/two_factor_setup_step_one.dart';
import 'package:kuemele/features/profile/presentation/security/widgets/two_factor_setup_step_three.dart';
import 'package:kuemele/features/profile/presentation/security/widgets/two_factor_setup_step_two.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/widgets/app_loading_indicator.dart';

class TwoFactorSetupContent extends StatelessWidget {
  const TwoFactorSetupContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TwoFactorSetupBloc, TwoFactorSetupState>(
      bloc: InjectionHelper.twoFactorSetupBloc,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(bottom: 32.h),
          child: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TwoFactorSetupState state) {
    if (state.isLoadingSetup) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: const Center(child: AppLoadingIndicator.circle()),
      );
    }

    if (state.isLoadFailed) {
      return _buildLoadFailed(context, state);
    }

    final bloc = InjectionHelper.twoFactorSetupBloc;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TwoFactorSetupStepOne(),
        Gap(28.h),
        TwoFactorSetupStepTwo(state: state),
        Gap(28.h),
        TwoFactorSetupStepThree(state: state, bloc: bloc),
        Gap(24.h),
        AppButton.primary(
          label: AppLocalizations.of(context)!.submit,
          isLoading: state.isSubmitting,
          onPressed: state.canSubmit
              ? () => bloc.add(const TwoFactorSetupSubmitted())
              : null,
        ),
      ],
    );
  }

  Widget _buildLoadFailed(BuildContext context, TwoFactorSetupState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.primary(
          label: AppLocalizations.of(context)!.retry,
          onPressed: () => InjectionHelper.twoFactorSetupBloc
              .add(const TwoFactorSetupRetried()),
        ),
      ],
    );
  }
}
