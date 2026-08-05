sealed class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

class ForgotPasswordReset extends ForgotPasswordEvent {
  const ForgotPasswordReset({this.initialEmail});

  final String? initialEmail;
}

class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  const ForgotPasswordSubmitted({required this.email});

  final String email;
}
