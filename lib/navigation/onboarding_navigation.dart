import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/profile/cubit/profile_cubit.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';

abstract final class OnboardingNavigation {
  static const flowRoutes = <String>[
    AppRoutes.emailVerification,
    AppRoutes.interestedHobbies,
    AppRoutes.earnMedals,
    AppRoutes.onboarding,
  ];

  static bool isFlowRoute(String location) => flowRoutes.contains(location);

  static void goToEntry(BuildContext context) {
    context.go(AppRoutes.interestedHobbies);
  }

  static void goAfterOnboarding(BuildContext context) {
    context.go(AppRoutes.home);
  }

  static Future<void> navigateAfterAuthentication(
    BuildContext context, {
    bool showWelcomeMessage = false,
  }) async {
    if (!ApiService.hasToken()) {
      context.go(AppRoutes.signin);
      return;
    }

    final profileCubit = getIt<ProfileCubit>();
    var profile = profileCubit.userData;

    if (profile == null) {
      try {
        await profileCubit.loadUserData();
        profile = profileCubit.userData;
      } catch (_) {}
    }

    if (!context.mounted) return;

    if (profile == null) {
      context.go(AppRoutes.home);
      return;
    }

    final session = getIt<AuthBloc>().state.session;
    if (session?.emailVerified == false) {
      context.go(
        AppRoutes.emailVerification,
        extra: EmailVerificationRouteArgs(
          email: profile.email ?? '',
          isFromSignup: false,
        ),
      );
      return;
    }

    if (profile.isOnboardingCompleted == false) {
      goToEntry(context);
      return;
    }

    context.go(
      AppRoutes.home,
      extra: HomeRouteArgs(showWelcomeMessage: showWelcomeMessage),
    );
  }
}
