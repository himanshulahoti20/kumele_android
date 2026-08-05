enum EmailVerificationStatus {
  initial,
  sendingCode,
  ready,
  verifying,
  success,
  failure,
}

class EmailVerificationState {
  const EmailVerificationState({
    this.status = EmailVerificationStatus.initial,
    this.email = '',
    this.otp = '',
    this.resendCooldownSeconds = 0,
    this.errorMessage,
    this.successMessage,
  });

  static const int resendCooldownDurationSeconds = 60;

  final EmailVerificationStatus status;
  final String email;
  final String otp;
  final int resendCooldownSeconds;
  final String? errorMessage;
  final String? successMessage;

  bool get canResend =>
      resendCooldownSeconds <= 0 &&
      status != EmailVerificationStatus.sendingCode &&
      status != EmailVerificationStatus.verifying;

  bool get canSubmit =>
      otp.length == 6 && status != EmailVerificationStatus.verifying;

  bool get isSendingCode => status == EmailVerificationStatus.sendingCode;

  bool get isVerifying => status == EmailVerificationStatus.verifying;

  EmailVerificationState copyWith({
    EmailVerificationStatus? status,
    String? email,
    String? otp,
    int? resendCooldownSeconds,
    String? errorMessage,
    String? successMessage,
    bool clearErrorMessage = false,
    bool clearSuccessMessage = false,
  }) {
    return EmailVerificationState(
      status: status ?? this.status,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      resendCooldownSeconds:
          resendCooldownSeconds ?? this.resendCooldownSeconds,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccessMessage ? null : (successMessage ?? this.successMessage),
    );
  }
}
