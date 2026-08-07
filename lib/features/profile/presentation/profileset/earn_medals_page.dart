import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/features/profile/presentation/profileset/presentation/widgets/medals_list.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class EarnMedalsPage extends StatelessWidget implements BasePage {
  const EarnMedalsPage({
    super.key,
  });

  @override
  String get screenName => 'EarnMedals';

  @override
  Widget build(BuildContext context) {
    final session = getIt<AuthBloc>().state.session;
    final needsOnboarding = session?.needsOnboarding ?? false;

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
                  label: AppLocalizations.of(context)!.earnMedalsAndRewardsTitle,
                  showBackButton: !needsOnboarding,
                ),
                Gap(16.h),
                Expanded(
                  child: MedalsList(medals: ProfileConfig.medals),
                ),
                Gap(16.h),
                _buildContinueButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    final responsive = context.responsive;

    return Align(
      alignment: responsive.isTablet ? Alignment.centerRight : Alignment.center,
      child: AppButton.primary(
        label: AppLocalizations.of(context)!.continueLabel,
        fullWidth: !responsive.isTablet,
        width: responsive.isTablet ? 200.w : null,
        onPressed: () => _onContinue(context),
      ),
    );
  }

  void _onContinue(BuildContext context) {
    final session = getIt<AuthBloc>().state.session;
    final needsOnboarding = session?.needsOnboarding ?? false;

    if (needsOnboarding) {
      context.go(
        AppRoutes.onboarding,
        extra: const OnboardingRouteArgs(isFromSignUp: false),
      );
      return;
    }

    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }
}
