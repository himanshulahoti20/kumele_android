import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/profile_page_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/two_factor_disable_event.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/two_factor_disable_state.dart';
import 'package:kuemele/features/profile/presentation/security/domain/repositories/two_factor_setup_repository.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

export 'two_factor_disable_event.dart';
export 'two_factor_disable_state.dart';

class TwoFactorDisableBloc
    extends Bloc<TwoFactorDisableEvent, TwoFactorDisableState> {
  TwoFactorDisableBloc({
    required TwoFactorSetupRepository repository,
  })  : _repository = repository,
        super(const TwoFactorDisableState()) {
    on<TwoFactorDisableOpened>(_onOpened);
    on<TwoFactorDisableCodeChanged>(_onCodeChanged);
    on<TwoFactorDisableSubmitted>(_onSubmitted);
  }

  final TwoFactorSetupRepository _repository;

  void _onOpened(
    TwoFactorDisableOpened event,
    Emitter<TwoFactorDisableState> emit,
  ) {
    emit(const TwoFactorDisableState());
  }

  void _onCodeChanged(
    TwoFactorDisableCodeChanged event,
    Emitter<TwoFactorDisableState> emit,
  ) {
    emit(state.copyWith(verificationCode: event.code));
  }

  Future<void> _onSubmitted(
    TwoFactorDisableSubmitted event,
    Emitter<TwoFactorDisableState> emit,
  ) async {
    if (!state.canSubmit) return;

    emit(state.copyWith(status: TwoFactorDisableStatus.submitting));

    try {
      await _repository.disable(code: state.verificationCode);
      emit(state.copyWith(status: TwoFactorDisableStatus.success));
      InjectionHelper.snackBar.showSuccess(AppStrings.twoFactorDisableSuccess);
      await InjectionHelper.profileCubit.loadUserData();
      InjectionHelper.profilePageBloc.add(const ProfilePageRefresh());
    } on ApiException catch (error) {
      InjectionHelper.snackBar.showError(
        error.error ?? AppStrings.twoFactorDisableFailed,
      );
      emit(state.copyWith(status: TwoFactorDisableStatus.initial));
    } on Exception {
      InjectionHelper.snackBar.showError(AppStrings.twoFactorDisableFailed);
      emit(state.copyWith(status: TwoFactorDisableStatus.initial));
    }
  }
}
