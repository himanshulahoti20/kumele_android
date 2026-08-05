import 'package:kuemele/shared/models/authen_models.dart';

enum AuthStatus {
  initial,
  loading,
  loginSuccess,
  signupSuccess,
  signupPendingEmailVerification,
  forgotPasswordSuccess,
  resetPasswordSuccess,
  verifyEmailSuccess,
  passkeyRegisterSuccess,
  twoFactorRequired,
  error,
}

enum AuthLoadingAction {
  login,
  signup,
  forgotPassword,
  resetPassword,
  verifyEmail,
  sendVerificationEmail,
  googleLogin,
  passkeyLogin,
  passkeyRegister,
  twoFactorVerify,
}

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.session,
    this.loadingAction,
    this.twoFactorTempToken,
    this.twoFactorVerificationCode = '',
  });

  final AuthStatus status;
  final String? errorMessage;
  final AuthSession? session;
  final AuthLoadingAction? loadingAction;
  final String? twoFactorTempToken;
  final String twoFactorVerificationCode;

  bool isLoading(AuthLoadingAction action) =>
      status == AuthStatus.loading && loadingAction == action;

  bool get canSubmitTwoFactor =>
      twoFactorVerificationCode.length == 6 &&
      twoFactorTempToken != null &&
      twoFactorTempToken!.isNotEmpty &&
      !isLoading(AuthLoadingAction.twoFactorVerify);

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    AuthSession? session,
    AuthLoadingAction? loadingAction,
    String? twoFactorTempToken,
    String? twoFactorVerificationCode,
    bool clearError = false,
    bool clearSession = false,
    bool clearLoadingAction = false,
    bool clearTwoFactor = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      session: clearSession ? null : (session ?? this.session),
      loadingAction:
          clearLoadingAction ? null : (loadingAction ?? this.loadingAction),
      twoFactorTempToken: clearTwoFactor
          ? null
          : (twoFactorTempToken ?? this.twoFactorTempToken),
      twoFactorVerificationCode: clearTwoFactor
          ? ''
          : (twoFactorVerificationCode ?? this.twoFactorVerificationCode),
    );
  }
}
