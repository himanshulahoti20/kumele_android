import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/delete_account_event.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/delete_account_state.dart';
import 'package:kuemele/features/profile/presentation/security/domain/repositories/delete_account_repository.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

export 'delete_account_event.dart';
export 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountBloc({
    required DeleteAccountRepository deleteAccountRepository,
  })  : _deleteAccountRepository = deleteAccountRepository,
        super(const DeleteAccountState()) {
    on<DeleteAccountOpened>(_onOpened);
    on<DeleteAccountPasswordChanged>(_onPasswordChanged);
    on<DeleteAccountReasonChanged>(_onReasonChanged);
    on<DeleteAccountConfirmationChanged>(_onConfirmationChanged);
    on<DeleteAccountSubmitted>(_onSubmitted);
  }

  final DeleteAccountRepository _deleteAccountRepository;

  void _onOpened(
    DeleteAccountOpened event,
    Emitter<DeleteAccountState> emit,
  ) {
    emit(const DeleteAccountState());
  }

  void _onPasswordChanged(
    DeleteAccountPasswordChanged event,
    Emitter<DeleteAccountState> emit,
  ) {
    emit(state.copyWith(password: event.value, clearError: true));
  }

  void _onReasonChanged(
    DeleteAccountReasonChanged event,
    Emitter<DeleteAccountState> emit,
  ) {
    emit(state.copyWith(reason: event.value, clearError: true));
  }

  void _onConfirmationChanged(
    DeleteAccountConfirmationChanged event,
    Emitter<DeleteAccountState> emit,
  ) {
    emit(state.copyWith(confirmation: event.value, clearError: true));
  }

  Future<void> _onSubmitted(
    DeleteAccountSubmitted event,
    Emitter<DeleteAccountState> emit,
  ) async {
    final password = state.password.trim();
    final reason = state.reason.trim();

    if (password.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: AppLocalizationsEn().deleteAccountPasswordRequired,
        ),
      );
      return;
    }

    if (reason.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: AppLocalizationsEn().deleteAccountReasonRequired,
        ),
      );
      return;
    }

    if (!state.confirmation) {
      emit(
        state.copyWith(
          errorMessage:
              AppLocalizationsEn().deleteAccountConfirmationRequired,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: DeleteAccountStatus.submitting,
        clearError: true,
      ),
    );

    try {
      final message = await _deleteAccountRepository.deleteAccount(
        password: password,
        reason: reason,
        confirmation: true,
      );
      emit(
        state.copyWith(
          status: DeleteAccountStatus.success,
          successMessage: message,
        ),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: DeleteAccountStatus.initial,
          errorMessage:
              error.error ?? AppLocalizationsEn().deleteAccountSubmitFailed,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: DeleteAccountStatus.initial,
          errorMessage: AppLocalizationsEn().deleteAccountSubmitFailed,
        ),
      );
    }
  }
}
