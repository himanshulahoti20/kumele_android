class SignupFlowService {
  String? _signupEmail;

  void setSignupEmail(String email) {
    _signupEmail = email;
  }

  String? getSignupEmail() {
    return _signupEmail;
  }

  void clear() {
    _signupEmail = null;
  }

  bool get isInSignupFlow => _signupEmail != null;
}
