import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/features/auth/domain/repositories/auth_repository.dart';
import 'package:kuemele/features/auth/reset_password/bloc/reset_password_event.dart';
import 'package:kuemele/features/auth/reset_password/bloc/reset_password_state.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

export 'reset_password_event.dart';
export 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const ResetPasswordState()) {
    on<ResetPasswordReset>(_onReset);
    on<ResetPasswordSubmitted>(_onSubmitted);
    on<ResetPasswordResendRequested>(_onResendRequested);
    on<ResetPasswordCooldownTicked>(_onCooldownTicked);
  }

  final AuthRepository _authRepository;
  Timer? _resendTimer;

  void _onReset(
    ResetPasswordReset event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(
      ResetPasswordState(
        email: event.email.trim(),
      ),
    );
    _startResendCooldown();
  }

  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    final otp = event.token.trim();
    final newPassword = event.newPassword;
    final confirmPassword = event.confirmPassword;

    emit(state.copyWith(clearErrorMessage: true));

    if (otp.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: AuthConfig.fillFieldsError,
        ),
      );
      return;
    }

    if (newPassword.length < 6) {
      emit(
        state.copyWith(
          errorMessage: AppLocalizationsEn().passwordMinLengthError,
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      emit(
        state.copyWith(
          errorMessage: AppLocalizationsEn().passwordsDoNotMatchError,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ResetPasswordStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final token = await _authRepository.verifyResetOtp(
        email: state.email,
        otp: otp,
      );
      await _authRepository.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      emit(
        state.copyWith(
          status: ResetPasswordStatus.success,
        ),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: error.error ?? AppLocalizationsEn().somethingWentWrong,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: AppLocalizationsEn().somethingWentWrong,
        ),
      );
    }
  }

  Future<void> _onResendRequested(
    ResetPasswordResendRequested event,
    Emitter<ResetPasswordState> emit,
  ) async {
    if (!state.canResend) return;

    emit(
      state.copyWith(
        isResending: true,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final successMessage =
          await _authRepository.forgotPassword(email: state.email);
      _startResendCooldown();
      emit(
        state.copyWith(
          isResending: false,
          successMessage: successMessage,
          clearErrorMessage: true,
        ),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          isResending: false,
          errorMessage: error.error ?? AppLocalizationsEn().somethingWentWrong,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isResending: false,
          errorMessage: AppLocalizationsEn().somethingWentWrong,
        ),
      );
    }
  }

  void _onCooldownTicked(
    ResetPasswordCooldownTicked event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(state.copyWith(resendCooldownSeconds: event.remainingSeconds));
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    add(const ResetPasswordCooldownTicked(120));

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final nextValue = state.resendCooldownSeconds - 1;
      if (nextValue <= 0) {
        timer.cancel();
        add(const ResetPasswordCooldownTicked(0));
        return;
      }
      add(ResetPasswordCooldownTicked(nextValue));
    });
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }
}
