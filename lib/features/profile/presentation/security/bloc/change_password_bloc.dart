import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/change_password_event.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/change_password_state.dart';
import 'package:kuemele/features/profile/presentation/security/domain/repositories/change_password_repository.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

export 'change_password_event.dart';
export 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc({
    required ChangePasswordRepository changePasswordRepository,
  })  : _changePasswordRepository = changePasswordRepository,
        super(const ChangePasswordState()) {
    on<ChangePasswordCurrentChanged>(_onCurrentChanged);
    on<ChangePasswordNewChanged>(_onNewChanged);
    on<ChangePasswordConfirmChanged>(_onConfirmChanged);
    on<ChangePasswordOpened>(_onOpened);
    on<ChangePasswordSubmitted>(_onSubmitted);
  }

  final ChangePasswordRepository _changePasswordRepository;

  void _onCurrentChanged(
    ChangePasswordCurrentChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(currentPassword: event.value, clearError: true));
  }

  void _onNewChanged(
    ChangePasswordNewChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(newPassword: event.value, clearError: true));
  }

  void _onConfirmChanged(
    ChangePasswordConfirmChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(confirmPassword: event.value, clearError: true));
  }

  void _onOpened(
    ChangePasswordOpened event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(const ChangePasswordState());
  }

  Future<void> _onSubmitted(
    ChangePasswordSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    final currentPassword = state.currentPassword;
    final newPassword = state.newPassword;
    final confirmPassword = state.confirmPassword;

    if (currentPassword.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: AppStrings.changePasswordCurrentRequired,
        ),
      );
      return;
    }

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      emit(state.copyWith(errorMessage: AppStrings.requiredField));
      return;
    }

    if (newPassword.length < 6) {
      emit(state.copyWith(errorMessage: AppStrings.passwordMinLengthError));
      return;
    }

    if (newPassword != confirmPassword) {
      emit(state.copyWith(errorMessage: AppStrings.passwordsDoNotMatchError));
      return;
    }

    emit(
      state.copyWith(
        status: ChangePasswordStatus.submitting,
        clearError: true,
      ),
    );

    try {
      await _changePasswordRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      emit(state.copyWith(status: ChangePasswordStatus.success));
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: ChangePasswordStatus.initial,
          errorMessage: error.error ?? AppStrings.changePasswordSubmitFailed,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: ChangePasswordStatus.initial,
          errorMessage: AppStrings.changePasswordSubmitFailed,
        ),
      );
    }
  }
}
