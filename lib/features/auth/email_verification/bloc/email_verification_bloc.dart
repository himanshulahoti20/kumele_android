import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/features/auth/domain/repositories/auth_repository.dart';
import 'package:kuemele/features/auth/email_verification/bloc/email_verification_event.dart';
import 'package:kuemele/features/auth/email_verification/bloc/email_verification_state.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

export 'email_verification_event.dart';
export 'email_verification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  EmailVerificationBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const EmailVerificationState()) {
    on<EmailVerificationOpened>(_onOpened);
    on<EmailVerificationCodeChanged>(_onCodeChanged);
    on<EmailVerificationSubmitStarted>(_onSubmitStarted);
    on<EmailVerificationSubmitFailed>(_onSubmitFailed);
    on<EmailVerificationResendRequested>(_onResendRequested);
    on<EmailVerificationCooldownTicked>(_onCooldownTicked);
  }

  final AuthRepository _authRepository;
  Timer? _resendTimer;

  Future<void> _onOpened(
    EmailVerificationOpened event,
    Emitter<EmailVerificationState> emit,
  ) async {
    emit(
      EmailVerificationState(
        email: event.email.trim(),
        status: EmailVerificationStatus.sendingCode,
      ),
    );
    await _sendVerificationCode(emit);
  }

  void _onCodeChanged(
    EmailVerificationCodeChanged event,
    Emitter<EmailVerificationState> emit,
  ) {
    emit(
      state.copyWith(
        otp: event.code,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );
  }

  void _onSubmitStarted(
    EmailVerificationSubmitStarted event,
    Emitter<EmailVerificationState> emit,
  ) {
    emit(
      state.copyWith(
        status: EmailVerificationStatus.verifying,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );
  }

  void _onSubmitFailed(
    EmailVerificationSubmitFailed event,
    Emitter<EmailVerificationState> emit,
  ) {
    emit(
      state.copyWith(
        status: EmailVerificationStatus.ready,
        errorMessage: event.message,
      ),
    );
  }

  Future<void> _onResendRequested(
    EmailVerificationResendRequested event,
    Emitter<EmailVerificationState> emit,
  ) async {
    if (!state.canResend) return;

    emit(
      state.copyWith(
        status: EmailVerificationStatus.sendingCode,
        otp: '',
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );
    await _sendVerificationCode(emit);
  }

  void _onCooldownTicked(
    EmailVerificationCooldownTicked event,
    Emitter<EmailVerificationState> emit,
  ) {
    emit(state.copyWith(resendCooldownSeconds: event.remainingSeconds));
  }

  Future<void> _sendVerificationCode(
      Emitter<EmailVerificationState> emit) async {
    try {
      await _authRepository.sendVerificationEmail();
      _startResendCooldown();
      emit(
        state.copyWith(
          status: EmailVerificationStatus.ready,
          successMessage: AppStrings.emailVerificationSentMessage,
          clearErrorMessage: true,
        ),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: EmailVerificationStatus.failure,
          errorMessage:
              error.error ?? AppStrings.emailVerificationSendFailedMessage,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: EmailVerificationStatus.failure,
          errorMessage: AppStrings.emailVerificationSendFailedMessage,
        ),
      );
    }
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    add(
      const EmailVerificationCooldownTicked(
        EmailVerificationState.resendCooldownDurationSeconds,
      ),
    );

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final nextValue = state.resendCooldownSeconds - 1;
      if (nextValue <= 0) {
        timer.cancel();
        add(const EmailVerificationCooldownTicked(0));
        return;
      }
      add(EmailVerificationCooldownTicked(nextValue));
    });
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }
}
