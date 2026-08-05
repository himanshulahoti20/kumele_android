import 'package:kuemele/shared/models/authen_models.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class AuthSignupRequested extends AuthEvent {
  const AuthSignupRequested({required this.user});

  final UserModel user;
}

class AuthForgotPasswordRequested extends AuthEvent {
  const AuthForgotPasswordRequested({required this.email});

  final String email;
}

class AuthResetPasswordRequested extends AuthEvent {
  const AuthResetPasswordRequested({
    required this.newPassword,
    required this.token,
  });

  final String newPassword;
  final String token;
}

class AuthVerifyEmailRequested extends AuthEvent {
  const AuthVerifyEmailRequested({required this.otp});

  final String otp;
}

class AuthVerifyEmailFailureHandled extends AuthEvent {
  const AuthVerifyEmailFailureHandled();
}

class AuthSessionRestored extends AuthEvent {
  const AuthSessionRestored({required this.session});

  final AuthSession session;
}

class AuthSessionUpdated extends AuthEvent {
  const AuthSessionUpdated({required this.session});

  final AuthSession session;
}

class AuthGoogleLoginRequested extends AuthEvent {
  const AuthGoogleLoginRequested();
}

class AuthPasskeyLoginRequested extends AuthEvent {
  const AuthPasskeyLoginRequested({required this.email});

  final String email;
}

class AuthPasskeyRegisterRequested extends AuthEvent {
  const AuthPasskeyRegisterRequested({this.deviceName});

  final String? deviceName;
}

class AuthTwoFactorCodeChanged extends AuthEvent {
  const AuthTwoFactorCodeChanged(this.code);

  final String code;
}

class AuthTwoFactorVerifyRequested extends AuthEvent {
  const AuthTwoFactorVerifyRequested();
}

class AuthTwoFactorCancelled extends AuthEvent {
  const AuthTwoFactorCancelled();
}

class AuthStatusCleared extends AuthEvent {
  const AuthStatusCleared();
}
