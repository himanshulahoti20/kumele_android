import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/auth/signin/bloc/signin_event.dart';
import 'package:kuemele/features/auth/signin/bloc/signin_state.dart';
import 'package:kuemele/features/auth/signin/data/storage/signin_preferences_storage.dart';

export 'signin_event.dart';
export 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc({
    required SigninPreferencesStorage preferencesStorage,
  })  : _preferencesStorage = preferencesStorage,
        super(const SigninState()) {
    on<SigninInitialized>(_onInitialized);
    on<SigninRememberMeChanged>(_onRememberMeChanged);
    on<SigninCaptchaChanged>(_onCaptchaChanged);
    on<SigninRecaptchaTokenReceived>(_onRecaptchaTokenReceived);
    on<SigninRecaptchaTokenCleared>(_onRecaptchaTokenCleared);
  }

  final SigninPreferencesStorage _preferencesStorage;

  Future<void> _onInitialized(
    SigninInitialized event,
    Emitter<SigninState> emit,
  ) async {
    final preferences = await _preferencesStorage.load();
    emit(
      state.copyWith(
        rememberMe: preferences.rememberMe,
        rememberedEmail: preferences.email,
        preferencesGeneration: state.preferencesGeneration + 1,
      ),
    );
  }

  Future<void> persistCredentials({
    required String email,
    required bool rememberMe,
  }) {
    return _preferencesStorage.save(
      rememberMe: rememberMe,
      email: email,
    );
  }

  Future<void> _onRememberMeChanged(
    SigninRememberMeChanged event,
    Emitter<SigninState> emit,
  ) async {
    emit(
      state.copyWith(
        rememberMe: event.value,
        clearRememberedEmail: !event.value,
      ),
    );

    if (!event.value) {
      await _preferencesStorage.clear();
    }
  }

  void _onCaptchaChanged(
    SigninCaptchaChanged event,
    Emitter<SigninState> emit,
  ) {
    emit(
      state.copyWith(
        imNotARobot: event.value,
        clearRecaptchaToken: !event.value,
      ),
    );
  }

  void _onRecaptchaTokenReceived(
    SigninRecaptchaTokenReceived event,
    Emitter<SigninState> emit,
  ) {
    emit(state.copyWith(recaptchaToken: event.token));
  }

  void _onRecaptchaTokenCleared(
    SigninRecaptchaTokenCleared event,
    Emitter<SigninState> emit,
  ) {
    emit(state.copyWith(clearRecaptchaToken: true));
  }
}
