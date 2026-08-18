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

    // No permission asks here: notifications/photos/location are all
    // requested together, once, from the login screen (see
    // PermissionFlowSheet via signin_page.dart). Returning users who skip
    // Signin already have these resolved from a prior session; Explore's
    // own lazy fetch (guarded by LocationStatus.initial) covers them
    // without prompting again.

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
      bool refreshed;
      try {
        refreshed = await ApiService.refreshAccessToken();
      } catch (_) {
        // Refresh itself hit a network/timeout hiccup, not a definitive
        // auth rejection — keep the session for the next attempt instead
        // of wiping it over a connectivity blip.
        getIt<AuthBloc>().add(AuthSessionRestored(session: session));
        return;
      }

      if (refreshed) {
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
    // The 401 interceptor may have refreshed and persisted rotated tokens
    // before getCurrentUser returned. Never save the stale session over them.
    final currentSession =
        await InjectionHelper.authStorage.loadSession() ?? session;
    final updatedSession = currentSession.copyWith(
      email: user.email ?? currentSession.email,
      userId: user.id ?? currentSession.userId,
      profileStatus: user.profileStatus ?? currentSession.profileStatus,
      isOnboardingCompleted:
          user.isOnboardingCompleted ?? currentSession.isOnboardingCompleted,
      emailVerified: user.emailVerified ?? currentSession.emailVerified,
    );
    await InjectionHelper.authStorage.saveSession(updatedSession);
    getIt<AuthBloc>().add(AuthSessionRestored(session: updatedSession));
  }
}
