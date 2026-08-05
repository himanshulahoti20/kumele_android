import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/authen/authen_repo.dart';

class GoogleAuthService {
  GoogleAuthService({
    GoogleSignIn? googleSignIn,
    FirebaseAuth? firebaseAuth,
  })  : _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _explicitFirebaseAuth = firebaseAuth;

  final GoogleSignIn _googleSignIn;
  final FirebaseAuth? _explicitFirebaseAuth;
  bool _initialized = false;

  FirebaseAuth get _firebaseAuth =>
      _explicitFirebaseAuth ?? FirebaseAuth.instance;

  static bool get hasExplicitServerClientId =>
      AuthConfig.googleServerClientId.isNotEmpty &&
      !AuthConfig.googleServerClientId.startsWith('REPLACE_WITH_');

  Future<AuthSession> login() async {
    try {
      final token = await _signInAndGetFirebaseToken();
      final response = await AuthenRepo.firebaseLogin(token: token);
      final session = response?.data;
      if (session == null || session.accessToken.isEmpty) {
        throw ApiException(error: 'Google sign-in returned empty session');
      }
      return session;
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(error: ExceptionMessages.from(error));
    }
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) {
      return;
    }

    await _googleSignIn.initialize(
      serverClientId:
          hasExplicitServerClientId ? AuthConfig.googleServerClientId : null,
    );
    _initialized = true;
  }

  Future<String> _signInAndGetFirebaseToken() async {
    await _ensureInitialized();

    try {
      final account = await _googleSignIn.authenticate();
      final googleAuth = account.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw ApiException(error: 'Google sign-in returned no ID token');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw ApiException(error: 'Firebase sign-in failed: No user found');
      }

      final firebaseToken = await firebaseUser.getIdToken(true);
      if (firebaseToken == null || firebaseToken.isEmpty) {
        throw ApiException(
            error: 'Failed to retrieve Firebase token after Google sign-in');
      }

      return firebaseToken;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw ApiException(error: AuthConfig.googleSignInCanceled);
      }
      if (error.code == GoogleSignInExceptionCode.clientConfigurationError ||
          (error.description?.toLowerCase().contains('serverclientid') ??
              false)) {
        throw ApiException(error: AuthConfig.googleSignInNotConfigured);
      }
      throw ApiException(error: error.description ?? 'Google sign-in failed');
    } on FirebaseAuthException catch (error) {
      throw ApiException(
          error: error.message ?? 'Firebase authentication failed');
    } catch (error) {
      throw ApiException(error: ExceptionMessages.from(error));
    }
  }
}
