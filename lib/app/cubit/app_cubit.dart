import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/authen/authen_repo.dart';
import 'package:kuemele/shared/utils/path_helper.dart';
import 'package:kuemele/shared/utils/utils.dart';

abstract class AppState {
  const AppState();
}

class AppInitial extends AppState {
  const AppInitial();
}

class AppLoading extends AppState {
  const AppLoading();
}

class AppReady extends AppState {
  final AdaptiveThemeMode savedThemeMode;

  const AppReady({required this.savedThemeMode});
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppInitial());

  Future<void> initialize() async {
    safeEmit(const AppLoading());

    await PathHelper.init();
    await _readStorage();

    try {
      await InjectionHelper.appInitializationService.initializeApp();
    } catch (_) {}

    InjectionHelper.locationCubit.requestLocation();

    final savedTheme = await AdaptiveTheme.getThemeMode();
    final themeMode = savedTheme ?? AdaptiveThemeMode.system;

    InjectionHelper.profileCubit.currentThemeMode = themeMode;

    safeEmit(AppReady(savedThemeMode: themeMode));
  }

  Future<void> _readStorage() async {
    final session = await InjectionHelper.authStorage.loadSession();
    if (session != null && !Utils.isNullOrEmpty(session.accessToken)) {
      ApiService.setToken(
        newToken: session.accessToken,
        newRefreshToken: session.refreshToken,
      );

      try {
        final user = (await AuthenRepo.getCurrentUser())?.data;
        if (user == null) throw Exception();
        final updatedSession = session.copyWith(
          email: user.email ?? session.email,
          userId: user.id ?? session.userId,
          profileStatus: user.profileStatus ?? session.profileStatus,
          isOnboardingCompleted:
              user.isOnboardingCompleted ?? session.isOnboardingCompleted,
          emailVerified: user.emailVerified ?? session.emailVerified,
        );
        await InjectionHelper.authStorage.saveSession(updatedSession);
        getIt<AuthBloc>().add(
          AuthSessionRestored(
            session: updatedSession,
          ),
        );
      } catch (_) {
        ApiService.clearToken();
        await InjectionHelper.authStorage.clear();
      }
    }
  }
}
