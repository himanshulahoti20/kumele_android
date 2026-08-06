import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/auth/bloc/auth_event.dart';
import 'package:kuemele/features/auth/bloc/auth_state.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/features/auth/domain/repositories/auth_repository.dart';
import 'package:kuemele/core/app_initialization/app_initialization_service.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

export 'auth_event.dart';
export 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
    required AppInitializationService appInitializationService,
  })  : _authRepository = authRepository,
        _appInitializationService = appInitializationService,
        super(const AuthState()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthVerifyEmailRequested>(_onVerifyEmailRequested);
    on<AuthVerifyEmailFailureHandled>(_onVerifyEmailFailureHandled);
    on<AuthSessionRestored>(_onSessionRestored);
    on<AuthSessionUpdated>(_onSessionUpdated);
    on<AuthGoogleLoginRequested>(_onGoogleLoginRequested);
    on<AuthPasskeyLoginRequested>(_onPasskeyLoginRequested);
    on<AuthPasskeyRegisterRequested>(_onPasskeyRegisterRequested);
    on<AuthTwoFactorCodeChanged>(_onTwoFactorCodeChanged);
    on<AuthTwoFactorVerifyRequested>(_onTwoFactorVerifyRequested);
    on<AuthTwoFactorCancelled>(_onTwoFactorCancelled);
    on<AuthStatusCleared>(_onStatusCleared);
  }

  final AuthRepository _authRepository;
  final AppInitializationService _appInitializationService;

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        loadingAction: AuthLoadingAction.login,
        clearError: true,
      ),
    );
    try {
      final result = await _authRepository.login(
        email: event.email,
        password: event.password,
      );

      switch (result) {
        case LoginTwoFactorChallengeResult(:final tempToken):
          emit(
            state.copyWith(
              status: AuthStatus.twoFactorRequired,
              twoFactorTempToken: tempToken,
              twoFactorVerificationCode: '',
              clearError: true,
              clearLoadingAction: true,
            ),
          );
          return;
        case LoginSessionResult(:final session):
          await _authRepository.activateSession(session);
          if (session.emailVerified == false) {
            emit(
              state.copyWith(
                status: AuthStatus.signupPendingEmailVerification,
                session: session,
                clearError: true,
                clearLoadingAction: true,
                clearTwoFactor: true,
              ),
            );
            return;
          }
          await _appInitializationService.initializeAuthenticatedSession();
          emit(
            state.copyWith(
              status: AuthStatus.loginSuccess,
              session: session,
              clearError: true,
              clearLoadingAction: true,
              clearTwoFactor: true,
            ),
          );
      }
    } catch (error) {
      _emitError(emit, error);
    }
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        loadingAction: AuthLoadingAction.signup,
        clearError: true,
      ),
    );
    try {
      final session = await _authRepository.signup(user: event.user);
      emit(
        state.copyWith(
          status: AuthStatus.signupPendingEmailVerification,
          session: session,
          clearError: true,
          clearLoadingAction: true,
        ),
      );
    } catch (error) {
      _emitError(emit, error);
    }
  }

  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        loadingAction: AuthLoadingAction.forgotPassword,
        clearError: true,
      ),
    );
    try {
      await _authRepository.forgotPassword(email: event.email);
      emit(
        state.copyWith(
          status: AuthStatus.forgotPasswordSuccess,
          clearError: true,
          clearLoadingAction: true,
        ),
      );
    } catch (error) {
      _emitError(emit, error);
    }
  }

  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        loadingAction: AuthLoadingAction.resetPassword,
        clearError: true,
      ),
    );
    try {
      await _authRepository.resetPassword(
        newPassword: event.newPassword,
        token: event.token,
      );
      emit(
        state.copyWith(
          status: AuthStatus.resetPasswordSuccess,
          clearError: true,
          clearLoadingAction: true,
        ),
      );
    } catch (error) {
      _emitError(emit, error);
    }
  }

  Future<void> _onVerifyEmailRequested(
    AuthVerifyEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        loadingAction: AuthLoadingAction.verifyEmail,
        clearError: true,
      ),
    );
    try {
      final session = await _authRepository.verifyEmail(otp: event.otp);
      await _appInitializationService.initializeAuthenticatedSession();

      emit(
        state.copyWith(
          status: AuthStatus.verifyEmailSuccess,
          session: session,
          clearError: true,
          clearLoadingAction: true,
        ),
      );
    } catch (error) {
      _emitError(emit, error);
    }
  }

  void _onVerifyEmailFailureHandled(
    AuthVerifyEmailFailureHandled event,
    Emitter<AuthState> emit,
  ) {
    if (state.session == null) return;

    emit(
      state.copyWith(
        status: AuthStatus.signupPendingEmailVerification,
        clearError: true,
        clearLoadingAction: true,
      ),
    );
  }

  void _onSessionRestored(
    AuthSessionRestored event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(session: event.session));
  }

  void _onSessionUpdated(
    AuthSessionUpdated event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(session: event.session));
  }

  Future<void> _onGoogleLoginRequested(
    AuthGoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        loadingAction: AuthLoadingAction.googleLogin,
        clearError: true,
      ),
    );
    try {
      final session = await _authRepository.signInWithGoogle();
      await _appInitializationService.initializeAuthenticatedSession();
      emit(
        state.copyWith(
          status: AuthStatus.loginSuccess,
          session: session,
          clearError: true,
          clearLoadingAction: true,
        ),
      );
    } on ApiException catch (error) {
      if (error.error == AuthConfig.googleSignInCanceled) {
        emit(
          state.copyWith(
            status: AuthStatus.initial,
            clearError: true,
            clearLoadingAction: true,
          ),
        );
        return;
      }
      _emitError(emit, error);
    } catch (error) {
      _emitError(emit, error);
    }
  }

  Future<void> _onPasskeyLoginRequested(
    AuthPasskeyLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        loadingAction: AuthLoadingAction.passkeyLogin,
        clearError: true,
      ),
    );
    try {
      final session = await _authRepository.passkeyLogin(email: event.email);
      await _appInitializationService.initializeAuthenticatedSession();
      emit(
        state.copyWith(
          status: AuthStatus.loginSuccess,
          session: session,
          clearError: true,
          clearLoadingAction: true,
        ),
      );
    } catch (error) {
      _emitError(emit, error);
    }
  }

  Future<void> _onPasskeyRegisterRequested(
    AuthPasskeyRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        loadingAction: AuthLoadingAction.passkeyRegister,
        clearError: true,
      ),
    );
    try {
      await _authRepository.registerPasskey(deviceName: event.deviceName);
      emit(
        state.copyWith(
          status: AuthStatus.passkeyRegisterSuccess,
          clearError: true,
          clearLoadingAction: true,
        ),
      );
    } catch (error) {
      _emitError(emit, error);
    }
  }

  void _onTwoFactorCodeChanged(
    AuthTwoFactorCodeChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        twoFactorVerificationCode: event.code,
        clearError: true,
      ),
    );
  }

  Future<void> _onTwoFactorVerifyRequested(
    AuthTwoFactorVerifyRequested event,
    Emitter<AuthState> emit,
  ) async {
    final tempToken = state.twoFactorTempToken;
    if (!state.canSubmitTwoFactor || tempToken == null) return;

    emit(
      state.copyWith(
        status: AuthStatus.loading,
        loadingAction: AuthLoadingAction.twoFactorVerify,
        clearError: true,
      ),
    );

    try {
      final session = await _authRepository.verifyTwoFactorLogin(
        code: state.twoFactorVerificationCode,
        tempToken: tempToken,
      );
      await _appInitializationService.initializeAuthenticatedSession();
      emit(
        state.copyWith(
          status: AuthStatus.loginSuccess,
          session: session,
          clearError: true,
          clearLoadingAction: true,
          clearTwoFactor: true,
        ),
      );
    } catch (error) {
      InjectionHelper.snackBar.showError(
        error is ApiException && error.error != null && error.error!.isNotEmpty
            ? error.error!
            : AppStrings.twoFactorLoginFailed,
      );
      emit(
        state.copyWith(
          status: AuthStatus.twoFactorRequired,
          clearLoadingAction: true,
        ),
      );
    }
  }

  void _onTwoFactorCancelled(
    AuthTwoFactorCancelled event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        status: AuthStatus.initial,
        clearTwoFactor: true,
        clearError: true,
        clearLoadingAction: true,
      ),
    );
  }

  void _onStatusCleared(
    AuthStatusCleared event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState());
  }

  void _emitError(Emitter<AuthState> emit, Object error) {
    emit(
      state.copyWith(
        status: AuthStatus.error,
        errorMessage: ExceptionMessages.from(error),
        clearLoadingAction: true,
      ),
    );
  }
}
