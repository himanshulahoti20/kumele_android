enum AuthenStatus {
  init,
  loading,
  loaded,
  error,
  loginSuccess,
  registerSuccess,
}

class AuthenState {
  const AuthenState({
    this.status = AuthenStatus.init,
    this.count = 0,
    this.error,
  });

  final AuthenStatus status;
  final int count;
  final String? error;

  static const init = AuthenState();

  static const loading = AuthenState(status: AuthenStatus.loading);

  static AuthenState loaded(int count) =>
      AuthenState(status: AuthenStatus.loaded, count: count);

  static AuthenState errorMessage(String error) =>
      AuthenState(status: AuthenStatus.error, error: error);

  static const loginSuccess = AuthenState(status: AuthenStatus.loginSuccess);

  static const registerSuccess =
      AuthenState(status: AuthenStatus.registerSuccess);
}
