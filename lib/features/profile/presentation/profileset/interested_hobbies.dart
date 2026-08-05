import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/interested_hobbies_bloc.dart';
import 'package:kuemele/features/profile/presentation/profileset/presentation/widgets/interests_grid.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';

class InterestedHobbies extends StatefulWidget implements BasePage {
  const InterestedHobbies({
    super.key,
  });

  @override
  State<InterestedHobbies> createState() => _InterestedHobbiesState();

  @override
  String get screenName => 'InterestedHobbies';
}

class _InterestedHobbiesState extends State<InterestedHobbies> {
  static const _maxSelections = 5;

  @override
  void initState() {
    super.initState();
    context.read<InterestedHobbiesBloc>().add(const InterestedHobbiesInit());
  }

  @override
  Widget build(BuildContext context) {
    final session = getIt<AuthBloc>().state.session;
    final needsOnboarding = session?.needsOnboarding ?? false;

    return BlocConsumer<InterestedHobbiesBloc, InterestedHobbiesState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.status == InterestedHobbiesStatus.success) {
          InjectionHelper.snackBar.showSuccess(
            state.successMessage ?? 'Interests saved successfully.',
          );
          context.go(
            AppRoutes.earnMedals,
            extra: const EarnMedalsRouteArgs(isFromSignUp: false),
          );
        } else if (state.errorMessage != null &&
            state.status == InterestedHobbiesStatus.loaded &&
            state.interests.isNotEmpty) {
          InjectionHelper.snackBar.showError(state.errorMessage!);
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: !needsOnboarding,
          child: Scaffold(
            backgroundColor: ColorSet.bg3Color,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MobileHeader(
                      label: 'Choose interests',
                      showBackButton: !needsOnboarding,
                    ),
                    Gap(16.h),
                    Expanded(child: _buildInterestsSection(context, state)),
                    Gap(16.h),
                    _buildSubmitButton(context, state, needsOnboarding),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInterestsSection(
    BuildContext context,
    InterestedHobbiesState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose up to $_maxSelections interests:',
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.textColor,
          ),
        ),
        Gap(16.h),
        Expanded(child: _buildInterestsContent(context, state)),
      ],
    );
  }

  Widget _buildInterestsContent(
    BuildContext context,
    InterestedHobbiesState state,
  ) {
    if (state.status == InterestedHobbiesStatus.failure &&
        state.interests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMessage ?? 'Failed to load interests.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium.copyWith(
                color: ColorSet.textColor,
              ),
            ),
            Gap(16.h),
            AppButton.primary(
              label: 'Retry',
              onPressed: () {
                context
                    .read<InterestedHobbiesBloc>()
                    .add(const InterestedHobbiesInit());
              },
            ),
          ],
        ),
      );
    }

    return InterestsGrid(
      interests: state.interests,
      selectedIds: state.selectedIds,
      isLoading: state.isFetching,
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    InterestedHobbiesState state,
    bool needsOnboarding,
  ) {
    final responsive = context.responsive;
    final label = needsOnboarding ? 'Continue' : 'Save';
    final isSaving = state.status == InterestedHobbiesStatus.saving;

    return Align(
      alignment: responsive.isTablet ? Alignment.centerRight : Alignment.center,
      child: AppButton.primary(
        label: label,
        fullWidth: !responsive.isTablet,
        width: responsive.isTablet ? 200.w : null,
        isLoading: isSaving,
        onPressed: state.isFetching || state.selectedCount == 0
            ? null
            : () {
                context
                    .read<InterestedHobbiesBloc>()
                    .add(const InterestedHobbiesSave());
              },
      ),
    );
  }
}
