import 'package:kuemele/features/auth/data/storage/auth_storage.dart';
import 'package:kuemele/features/auth/domain/repositories/auth_repository.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/authen/authen_repo.dart';
import 'package:kuemele/shared/services/google_auth/google_auth_service.dart';
import 'package:kuemele/shared/services/passkey/passkey_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthStorage authStorage,
    required PasskeyService passkeyService,
    required GoogleAuthService googleAuthService,
  })  : _authStorage = authStorage,
        _passkeyService = passkeyService,
        _googleAuthService = googleAuthService;

  final AuthStorage _authStorage;
  final PasskeyService _passkeyService;
  final GoogleAuthService _googleAuthService;

  @override
  Future<LoginResult> login({
    required String email,
    required String password,
  }) {
    return AuthenRepo.login(email: email, password: password);
  }

  @override
  Future<AuthSession> verifyTwoFactorLogin({
    required String code,
    required String tempToken,
  }) async {
    final session = await AuthenRepo.verify2FA(
      code: code,
      tempToken: tempToken,
    );
    return _requireSession(session);
  }

  @override
  Future<AuthSession> signup({required UserModel user}) async {
    final response = await AuthenRepo.register(body: user);
    final session = response?.data;
    if (session == null || session.accessToken.isEmpty) {
      throw ApiException();
    }

    ApiService.setToken(
      newToken: session.accessToken,
      newRefreshToken: session.refreshToken,
    );
    return session;
  }

  @override
  Future<void> activateSession(AuthSession session) async {
    await _persistSession(session);
  }

  @override
  Future<AuthSession> refreshSessionMetadata() async {
    final current = await _authStorage.loadSession();
    if (current == null) {
      throw ApiException();
    }

    final userResponse = await AuthenRepo.getCurrentUser();
    final user = userResponse?.data;
    if (user == null) {
      throw ApiException();
    }

    final updated = current.copyWith(
      profileStatus: user.profileStatus ?? current.profileStatus,
      isOnboardingCompleted:
          user.isOnboardingCompleted ?? current.isOnboardingCompleted,
    );
    await _persistSession(updated);
    return updated;
  }

  @override
  Future<String> forgotPassword({required String email}) async {
    final message = await AuthenRepo.forgetPassword(email: email);
    if (message != null && message.trim().isNotEmpty) {
      return message.trim();
    }
    return AppLocalizationsEn().forgotPasswordSuccessMessage;
  }

  @override
  Future<void> resetPassword({
    required String newPassword,
    required String token,
  }) async {
    final success = await AuthenRepo.resetPassword(
      newPassword: newPassword,
      token: token,
    );
    if (!success) {
      throw ApiException();
    }
  }

  @override
  Future<String> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    final resetToken = await AuthenRepo.verifyResetOtp(email: email, otp: otp);
    if (resetToken.trim().isEmpty) {
      throw ApiException();
    }
    return resetToken;
  }

  @override
  Future<void> sendVerificationEmail() async {
    final success = await AuthenRepo.sendVerificationEmail();
    if (!success) {
      throw ApiException();
    }
  }

  @override
  Future<AuthSession> verifyEmail({required String otp}) async {
    final session = await AuthenRepo.verifyEmail(otp: otp);

    final currentSession = await _authStorage.loadSession();
    if (currentSession != null) {
      final updated = currentSession.copyWith(
        emailVerified: true,
      );
      await _authStorage.saveSession(updated);
    }

    return session;
  }

  @override
  Future<AuthSession> signInWithGoogle() async {
    final session = await _googleAuthService.login();
    return _requireSession(session);
  }

  @override
  Future<AuthSession> passkeyLogin({required String email}) async {
    final session = await _passkeyService.login(email: email);
    return _requireSession(session);
  }

  @override
  Future<void> registerPasskey({String? deviceName}) async {
    await _passkeyService.register(deviceName: deviceName);
  }

  Future<AuthSession> _requireSession(AuthSession? session) async {
    if (session == null || session.accessToken.isEmpty) {
      throw ApiException();
    }

    await _persistSession(session);
    return session;
  }

  Future<void> _persistSession(AuthSession session) async {
    await _authStorage.saveSession(session);
    ApiService.setToken(
      newToken: session.accessToken,
      newRefreshToken: session.refreshToken,
    );
  }
}
