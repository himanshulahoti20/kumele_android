import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/profile_page_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/two_factor_setup_event.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/two_factor_setup_state.dart';
import 'package:kuemele/features/profile/presentation/security/domain/repositories/two_factor_setup_repository.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

export 'two_factor_setup_event.dart';
export 'two_factor_setup_state.dart';

class TwoFactorSetupBloc
    extends Bloc<TwoFactorSetupEvent, TwoFactorSetupState> {
  TwoFactorSetupBloc({
    required TwoFactorSetupRepository repository,
  })  : _repository = repository,
        super(const TwoFactorSetupState()) {
    on<TwoFactorSetupOpened>(_onOpened);
    on<TwoFactorSetupStarted>(_onStarted);
    on<TwoFactorSetupRetried>(_onRetried);
    on<TwoFactorSetupCodeChanged>(_onCodeChanged);
    on<TwoFactorSetupSubmitted>(_onSubmitted);
  }

  final TwoFactorSetupRepository _repository;

  Future<void> _onOpened(
    TwoFactorSetupOpened event,
    Emitter<TwoFactorSetupState> emit,
  ) async {
    emit(const TwoFactorSetupState());
    await _loadSetup(emit);
  }

  Future<void> _onStarted(
    TwoFactorSetupStarted event,
    Emitter<TwoFactorSetupState> emit,
  ) async {
    await _loadSetup(emit);
  }

  Future<void> _onRetried(
    TwoFactorSetupRetried event,
    Emitter<TwoFactorSetupState> emit,
  ) async {
    await _loadSetup(emit);
  }

  void _onCodeChanged(
    TwoFactorSetupCodeChanged event,
    Emitter<TwoFactorSetupState> emit,
  ) {
    emit(
      state.copyWith(
        verificationCode: event.code,
        clearError: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    TwoFactorSetupSubmitted event,
    Emitter<TwoFactorSetupState> emit,
  ) async {
    if (!state.canSubmit || state.isSubmitting) return;

    emit(
      state.copyWith(
        status: TwoFactorSetupStatus.submitting,
        clearError: true,
      ),
    );

    try {
      await _repository.enable(code: state.verificationCode);
      emit(
        state.copyWith(status: TwoFactorSetupStatus.success),
      );
      InjectionHelper.snackBar
          .showSuccess(AppLocalizationsEn().twoFactorEnableSuccess);
      await InjectionHelper.profileCubit.loadUserData();
      InjectionHelper.profilePageBloc.add(const ProfilePageRefresh());
      InjectionHelper.navKey.currentState?.pop();
    } on ApiException catch (error) {
      final message = error.error ?? AppLocalizationsEn().twoFactorEnableFailed;
      InjectionHelper.snackBar.showError(message);
      emit(
        state.copyWith(
          status: TwoFactorSetupStatus.loaded,
          errorMessage: message,
        ),
      );
    } on Exception {
      InjectionHelper.snackBar
          .showError(AppLocalizationsEn().twoFactorEnableFailed);
      emit(
        state.copyWith(
          status: TwoFactorSetupStatus.loaded,
          errorMessage: AppLocalizationsEn().twoFactorEnableFailed,
        ),
      );
    }
  }

  Future<void> _loadSetup(Emitter<TwoFactorSetupState> emit) async {
    emit(
      state.copyWith(
        status: TwoFactorSetupStatus.loading,
        clearError: true,
        clearSetupData: true,
      ),
    );

    try {
      final setup = await _repository.setup();
      if (setup == null) {
        InjectionHelper.snackBar
            .showError(AppLocalizationsEn().twoFactorSetupLoadFailed);
        emit(
          state.copyWith(
            status: TwoFactorSetupStatus.loadFailed,
            errorMessage: AppLocalizationsEn().twoFactorSetupLoadFailed,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: TwoFactorSetupStatus.loaded,
          setupData: setup,
        ),
      );
    } on ApiException catch (error) {
      final message =
          error.error ?? AppLocalizationsEn().twoFactorSetupLoadFailed;
      InjectionHelper.snackBar.showError(message);
      emit(
        state.copyWith(
          status: TwoFactorSetupStatus.loadFailed,
          errorMessage: message,
        ),
      );
    } on Exception {
      InjectionHelper.snackBar
          .showError(AppLocalizationsEn().twoFactorSetupLoadFailed);
      emit(
        state.copyWith(
          status: TwoFactorSetupStatus.loadFailed,
          errorMessage: AppLocalizationsEn().twoFactorSetupLoadFailed,
        ),
      );
    }
  }
}
