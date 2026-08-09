import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/authen/authen_repo.dart';
import 'package:kuemele/shared/models/authen_models.dart';
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
    if (session == null || Utils.isNullOrEmpty(session.accessToken)) return;

    ApiService.setToken(
      newToken: session.accessToken,
      newRefreshToken: session.refreshToken,
    );

    try {
      await _applyCurrentUser(session);
    } on ApiException catch (e) {
      if (e.statusCode != 401 && e.statusCode != 403) {
        // Network/timeout/parse hiccup on cold start, not an auth
        // rejection — keep the session so the user isn't logged out just
        // because the profile refresh failed once.
        getIt<AuthBloc>().add(AuthSessionRestored(session: session));
        return;
      }

      // Token rejected — try a refresh before giving up on the session.
      if (await ApiService.refreshAccessToken()) {
        try {
          await _applyCurrentUser(session);
          return;
        } catch (_) {
          // Refreshed token still didn't work — fall through to logout.
        }
      }

      ApiService.clearToken();
      await InjectionHelper.authStorage.clear();
    } catch (_) {
      getIt<AuthBloc>().add(AuthSessionRestored(session: session));
    }
  }

  Future<void> _applyCurrentUser(AuthSession session) async {
    final user = (await AuthenRepo.getCurrentUser())?.data;
    if (user == null) throw ApiException(error: 'No user data');
    final updatedSession = session.copyWith(
      email: user.email ?? session.email,
      userId: user.id ?? session.userId,
      profileStatus: user.profileStatus ?? session.profileStatus,
      isOnboardingCompleted:
          user.isOnboardingCompleted ?? session.isOnboardingCompleted,
      emailVerified: user.emailVerified ?? session.emailVerified,
    );
    await InjectionHelper.authStorage.saveSession(updatedSession);
    getIt<AuthBloc>().add(AuthSessionRestored(session: updatedSession));
  }
}
