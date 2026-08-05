import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/auth/signup/bloc/signup_event.dart';
import 'package:kuemele/features/auth/signup/bloc/signup_state.dart';

import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/services/recaptcha/app_recaptcha_service.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise_flutter.dart';

export 'signup_event.dart';
export 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(const SignupState()) {
    on<SignupGenderChanged>(_onGenderChanged);
    on<SignupDateOfBirthChanged>(_onDateOfBirthChanged);
    on<SignupLegalAdultChanged>(_onLegalAdultChanged);
    on<SignupSubscribeChanged>(_onSubscribeChanged);
    on<SignupTermsChanged>(_onTermsChanged);
    on<SignupCaptchaChanged>(_onCaptchaChanged);
    on<SignupReset>(_onReset);
    on<SignupSubmitted>(_onSubmitted);
  }

  void _onGenderChanged(
    SignupGenderChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(selectedGender: event.gender));
  }

  void _onDateOfBirthChanged(
    SignupDateOfBirthChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(
      selectedDay: event.day ?? state.selectedDay,
      selectedMonth: event.month ?? state.selectedMonth,
      selectedYear: event.year ?? state.selectedYear,
    ));
  }

  void _onLegalAdultChanged(
    SignupLegalAdultChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(legalAdult: event.value));
  }

  void _onSubscribeChanged(
    SignupSubscribeChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(subscribe: event.value));
  }

  void _onTermsChanged(
    SignupTermsChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(terms: event.value));
  }

  void _onCaptchaChanged(
    SignupCaptchaChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(imNotARobot: event.value));
    if (event.value) {
      getIt<AppRecaptchaService>()
          .tryExecute(RecaptchaAction.SIGNUP())
          .then((token) {
        if (token != null) {
          // ignore: avoid_print
          print('reCAPTCHA verification successful, token: $token');
        } else {
          // ignore: avoid_print
          print('reCAPTCHA verification failed (bypass active)');
        }
      });
    }
  }

  void _onReset(
    SignupReset event,
    Emitter<SignupState> emit,
  ) {
    emit(const SignupState());
  }

  void _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) {
    if (event.firstName.isEmpty) {
      emit(state.copyWith(
        status: SignupUIStatus.validationError,
        errorMessage: 'Please enter your first name',
      ));
      emit(state.copyWith(status: SignupUIStatus.initial, errorMessage: null));
      return;
    }
    if (event.email.isEmpty) {
      emit(state.copyWith(
        status: SignupUIStatus.validationError,
        errorMessage: 'Please enter your email',
      ));
      emit(state.copyWith(status: SignupUIStatus.initial, errorMessage: null));
      return;
    }
    if (!_isValidEmail(event.email)) {
      emit(state.copyWith(
        status: SignupUIStatus.validationError,
        errorMessage: 'Please enter a valid email',
      ));
      emit(state.copyWith(status: SignupUIStatus.initial, errorMessage: null));
      return;
    }
    if (event.password.isEmpty) {
      emit(state.copyWith(
        status: SignupUIStatus.validationError,
        errorMessage: 'Please enter password',
      ));
      emit(state.copyWith(status: SignupUIStatus.initial, errorMessage: null));
      return;
    }
    if (event.password.length < 6) {
      emit(state.copyWith(
        status: SignupUIStatus.validationError,
        errorMessage: 'Password must be at least 6 characters',
      ));
      emit(state.copyWith(status: SignupUIStatus.initial, errorMessage: null));
      return;
    }
    if (event.confirmPassword.isEmpty) {
      emit(state.copyWith(
        status: SignupUIStatus.validationError,
        errorMessage: 'Please confirm password',
      ));
      emit(state.copyWith(status: SignupUIStatus.initial, errorMessage: null));
      return;
    }
    if (event.password != event.confirmPassword) {
      emit(state.copyWith(
        status: SignupUIStatus.validationError,
        errorMessage: 'Passwords do not match',
      ));
      emit(state.copyWith(status: SignupUIStatus.initial, errorMessage: null));
      return;
    }
    if (!state.legalAdult) {
      emit(state.copyWith(
        status: SignupUIStatus.validationError,
        errorMessage: 'You must confirm that you are of legal age',
      ));
      emit(state.copyWith(status: SignupUIStatus.initial, errorMessage: null));
      return;
    }
    if (!state.terms) {
      emit(state.copyWith(
        status: SignupUIStatus.validationError,
        errorMessage: 'You must accept the Terms & Conditions',
      ));
      emit(state.copyWith(status: SignupUIStatus.initial, errorMessage: null));
      return;
    }
    if (!state.imNotARobot) {
      emit(state.copyWith(
        status: SignupUIStatus.validationError,
        errorMessage: 'Please confirm you are not a robot',
      ));
      emit(state.copyWith(status: SignupUIStatus.initial, errorMessage: null));
      return;
    }

    emit(state.copyWith(
      status: SignupUIStatus.validationSuccess,
    ));
    emit(state.copyWith(status: SignupUIStatus.initial));
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
