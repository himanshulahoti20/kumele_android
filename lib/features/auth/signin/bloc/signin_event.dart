sealed class SigninEvent {}

class SigninInitialized extends SigninEvent {
  SigninInitialized();
}

class SigninRememberMeChanged extends SigninEvent {
  SigninRememberMeChanged(this.value);

  final bool value;
}

class SigninCaptchaChanged extends SigninEvent {
  SigninCaptchaChanged(this.value);

  final bool value;
}

class SigninRecaptchaTokenReceived extends SigninEvent {
  SigninRecaptchaTokenReceived(this.token);

  final String token;
}

class SigninRecaptchaTokenCleared extends SigninEvent {
  SigninRecaptchaTokenCleared();
}
