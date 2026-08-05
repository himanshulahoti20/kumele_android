class SigninState {
  const SigninState({
    this.rememberMe = false,
    this.imNotARobot = false,
    this.preferencesGeneration = 0,
    this.rememberedEmail,
    this.recaptchaToken,
  });

  final bool rememberMe;
  final bool imNotARobot;
  final int preferencesGeneration;
  final String? rememberedEmail;
  final String? recaptchaToken;

  SigninState copyWith({
    bool? rememberMe,
    bool? imNotARobot,
    int? preferencesGeneration,
    String? rememberedEmail,
    bool clearRememberedEmail = false,
    String? recaptchaToken,
    bool clearRecaptchaToken = false,
  }) {
    return SigninState(
      rememberMe: rememberMe ?? this.rememberMe,
      imNotARobot: imNotARobot ?? this.imNotARobot,
      preferencesGeneration:
          preferencesGeneration ?? this.preferencesGeneration,
      rememberedEmail:
          clearRememberedEmail ? null : rememberedEmail ?? this.rememberedEmail,
      recaptchaToken:
          clearRecaptchaToken ? null : recaptchaToken ?? this.recaptchaToken,
    );
  }
}
