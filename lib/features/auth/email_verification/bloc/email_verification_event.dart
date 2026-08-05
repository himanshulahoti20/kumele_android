sealed class EmailVerificationEvent {
  const EmailVerificationEvent();
}

class EmailVerificationOpened extends EmailVerificationEvent {
  const EmailVerificationOpened({required this.email});

  final String email;
}

class EmailVerificationCodeChanged extends EmailVerificationEvent {
  const EmailVerificationCodeChanged(this.code);

  final String code;
}

class EmailVerificationSubmitStarted extends EmailVerificationEvent {
  const EmailVerificationSubmitStarted();
}

class EmailVerificationSubmitFailed extends EmailVerificationEvent {
  const EmailVerificationSubmitFailed(this.message);

  final String message;
}

class EmailVerificationResendRequested extends EmailVerificationEvent {
  const EmailVerificationResendRequested();
}

class EmailVerificationCooldownTicked extends EmailVerificationEvent {
  const EmailVerificationCooldownTicked(this.remainingSeconds);

  final int remainingSeconds;
}
