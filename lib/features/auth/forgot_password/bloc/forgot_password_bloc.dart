import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/auth/domain/repositories/auth_repository.dart';
import 'package:kuemele/features/auth/forgot_password/bloc/forgot_password_event.dart';
import 'package:kuemele/features/auth/forgot_password/bloc/forgot_password_state.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

export 'forgot_password_event.dart';
export 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const ForgotPasswordState()) {
    on<ForgotPasswordReset>(_onReset);
    on<ForgotPasswordSubmitted>(_onSubmitted);
  }

  final AuthRepository _authRepository;

  void _onReset(
    ForgotPasswordReset event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      ForgotPasswordState(
        email: event.initialEmail?.trim() ?? '',
      ),
    );
  }

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final email = event.email.trim();

    emit(state.copyWith(clearErrorMessage: true));

    if (email.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: AppLocalizationsEn().signInFillFieldsError,
        ),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      emit(
        state.copyWith(
          errorMessage: AppLocalizationsEn().invalidEmail,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ForgotPasswordStatus.loading,
        email: email,
        clearErrorMessage: true,
      ),
    );

    try {
      final successMessage = await _authRepository.forgotPassword(email: email);
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.success,
          email: email,
          successMessage: successMessage,
        ),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: error.error ?? AppLocalizationsEn().somethingWentWrong,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: AppLocalizationsEn().somethingWentWrong,
        ),
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
