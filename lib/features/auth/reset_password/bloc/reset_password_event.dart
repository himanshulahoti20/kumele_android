sealed class ResetPasswordEvent {
  const ResetPasswordEvent();
}

class ResetPasswordReset extends ResetPasswordEvent {
  const ResetPasswordReset({required this.email});

  final String email;
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  const ResetPasswordSubmitted({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  final String token;
  final String newPassword;
  final String confirmPassword;
}

class ResetPasswordResendRequested extends ResetPasswordEvent {
  const ResetPasswordResendRequested();
}

class ResetPasswordCooldownTicked extends ResetPasswordEvent {
  const ResetPasswordCooldownTicked(this.remainingSeconds);

  final int remainingSeconds;
}
