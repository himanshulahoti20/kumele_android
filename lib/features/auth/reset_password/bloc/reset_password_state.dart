enum ResetPasswordStatus {
  initial,
  loading,
  success,
  failure,
}

class ResetPasswordState {
  const ResetPasswordState({
    this.status = ResetPasswordStatus.initial,
    this.email = '',
    this.errorMessage,
    this.successMessage,
    this.isResending = false,
    this.resendCooldownSeconds = 120,
  });

  final ResetPasswordStatus status;
  final String email;
  final String? errorMessage;
  final String? successMessage;
  final bool isResending;
  final int resendCooldownSeconds;

  bool get isLoading => status == ResetPasswordStatus.loading;
  bool get canResend => resendCooldownSeconds <= 0 && !isResending;

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
    String? email,
    String? errorMessage,
    String? successMessage,
    bool? isResending,
    int? resendCooldownSeconds,
    bool clearErrorMessage = false,
    bool clearSuccessMessage = false,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      isResending: isResending ?? this.isResending,
      resendCooldownSeconds:
          resendCooldownSeconds ?? this.resendCooldownSeconds,
    );
  }
}
