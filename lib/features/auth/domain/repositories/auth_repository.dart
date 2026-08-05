import 'package:kuemele/shared/models/authen_models.dart';

abstract class AuthRepository {
  Future<LoginResult> login({
    required String email,
    required String password,
  });

  Future<AuthSession> verifyTwoFactorLogin({
    required String code,
    required String tempToken,
  });

  Future<AuthSession> signup({required UserModel user});

  Future<String> forgotPassword({required String email});

  Future<void> resetPassword({
    required String newPassword,
    required String token,
  });

  Future<void> sendVerificationEmail();

  Future<AuthSession> verifyEmail({required String otp});

  Future<void> activateSession(AuthSession session);

  Future<AuthSession> refreshSessionMetadata();

  Future<AuthSession> signInWithGoogle();

  Future<AuthSession> passkeyLogin({required String email});

  Future<void> registerPasskey({String? deviceName});
}
