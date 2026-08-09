import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/models/common.dart';
import 'package:kuemele/shared/models/two_factor_setup_data.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';
import 'package:kuemele/shared/services/passkey/passkey_options_parser.dart';
import 'package:kuemele/shared/utils/utils.dart';

class AuthenRepo extends ApiService {
  static Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    final api = GeneratedApiOperations.login;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'email': email, 'password': password},
    );
    final result = ApiService.handleResponse<LoginResult>(() {
      final payload = ApiService.extractMap(response);
      final requires2FA = payload['requires2FA'] == true;
      final tempToken =
          (payload['tempToken'] ?? payload['temp_token'])?.toString();

      if (requires2FA && tempToken != null && tempToken.isNotEmpty) {
        return LoginTwoFactorChallengeResult(tempToken: tempToken);
      }

      return LoginSessionResult(AuthSession.fromJson(payload));
    });
    if (result == null) {
      throw ApiException();
    }
    return result;
  }

  static Future<AuthSession?> verify2FA({
    required String code,
    required String tempToken,
  }) async {
    final api = GeneratedApiOperations.verify2FA;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {
        'code': code,
        'tempToken': tempToken,
      },
    );
    return ApiService.handleResponse<AuthSession?>(
      () => AuthSession.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<String?> logout() async {
    final api = GeneratedApiOperations.logout;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<String?>(() {
      final payload = ApiService.extractMap(response);
      return ApiResponse.fromJson(payload).message;
    });
  }

  static Future<String?> logoutAll() async {
    final api = GeneratedApiOperations.logoutAll;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<String?>(() {
      final payload = ApiService.extractMap(response);
      return ApiResponse.fromJson(payload).message;
    });
  }

  static Future<ApiResponse<AuthSession>?> register(
      {required UserModel body}) async {
    final api = GeneratedApiOperations.signup;
    final requestBody = {
      'email': body.email,
      'password': body.password,
      'firstName': _resolveSignupFirstName(body) ?? '',
      'lastName': _resolveSignupLastName(body) ?? '',
      if (Utils.isNotNullOrEmpty(body.referralCode))
        'referralCode': body.referralCode,
      if (Utils.isNotNullOrEmpty(body.betaCode)) 'betaCode': body.betaCode,
    };
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: requestBody,
    );
    return ApiService.handleResponse<ApiResponse<AuthSession>>(
      () => ApiResponse<AuthSession>(
        success: true,
        data: AuthSession.fromJson(ApiService.extractMap(response)),
      ),
    );
  }

  static String? _resolveSignupFirstName(UserModel body) {
    final firstName = body.firstName?.trim();
    if (firstName != null && firstName.isNotEmpty) return firstName;
    return body.fullname?.trim().split(' ').first;
  }

  static String? _resolveSignupLastName(UserModel body) {
    final lastName = body.lastName?.trim();
    if (lastName != null && lastName.isNotEmpty) return lastName;

    final parts = body.fullname?.trim().split(RegExp(r'\s+')) ?? [];
    if (parts.length <= 1) return null;
    return parts.skip(1).join(' ');
  }

  static Future<ApiResponse<AuthSession>?> firebaseLogin(
      {required String token}) async {
    final api = GeneratedApiOperations.firebaseLogin;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'firebase_token': token},
      useAuthenHeader: false,
    );
    return ApiService.handleResponse<ApiResponse<AuthSession>>(
      () => ApiResponse<AuthSession>(
        success: true,
        data: AuthSession.fromJson(ApiService.extractMap(response)),
      ),
    );
  }

  static Future<String?> forgetPassword({required String email}) async {
    final api = GeneratedApiOperations.forgotPassword;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'email': email},
    );
    return ApiService.handleResponse<String?>(() {
      final payload = ApiService.extractMap(response);
      return ApiResponse.fromJson(payload).message;
    });
  }

  static Future<bool> resetPassword(
      {required String newPassword, required String token}) async {
    final api = GeneratedApiOperations.resetPassword;
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'newPassword': newPassword, 'token': token},
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<String> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    final api = GeneratedApiOperations.verifyResetOtp;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'email': email, 'otp': otp},
    );
    return ApiService.handleResponse<String>(() {
          final payload = ApiService.extractMap(response);
          return (payload['resetToken'] ?? payload['reset_token'] ?? '')
              .toString();
        }) ??
        (throw ApiException());
  }

  static Future<bool> sendVerificationEmail() async {
    final api = GeneratedApiOperations.sendVerificationEmail;
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<bool> resendVerificationEmail() async {
    final api = GeneratedApiOperations.resendVerification;
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<AuthSession> verifyEmail({required String otp}) async {
    final api = GeneratedApiOperations.verifyEmail;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'otp': otp},
    );
    return ApiService.handleResponse<AuthSession>(
          () => AuthSession.fromJson(ApiService.extractMap(response)),
        ) ??
        (throw ApiException());
  }

  static Future<ApiResponse<AuthSession>?> refreshSession(
      {required String refreshToken}) async {
    final api = GeneratedApiOperations.refreshToken;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'refreshToken': refreshToken},
      useAuthenHeader: false,
    );
    return ApiService.handleResponse<ApiResponse<AuthSession>>(
      () => ApiResponse<AuthSession>(
        success: true,
        data: AuthSession.fromJson(ApiService.extractMap(response)),
      ),
    );
  }

  static Future<ApiResponse<UserModel>?> getCurrentUser() async {
    final api = GeneratedApiOperations.getCurrentUser;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<ApiResponse<UserModel>>(
      () => ApiResponse<UserModel>(
        success: true,
        data: UserModel.fromJson(ApiService.extractMap(response)),
      ),
    );
  }

  static Future<String> passkeyLoginStart({required String email}) async {
    final api = GeneratedApiOperations.passkeyLoginStart;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'email': email},
      useAuthenHeader: false,
    );
    return PasskeyOptionsParser.toJsonString(response);
  }

  static Future<AuthSession?> passkeyLoginFinish({
    required String email,
    required Map<String, dynamic> response,
  }) async {
    final api = GeneratedApiOperations.passkeyLoginFinish;
    final apiResponse = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'email': email, 'response': response},
      useAuthenHeader: false,
    );
    return ApiService.handleResponse<AuthSession>(
      () => AuthSession.fromJson(ApiService.extractMap(apiResponse)),
    );
  }

  static Future<String> passkeyRegisterStart(
      {required String deviceName}) async {
    final api = GeneratedApiOperations.passkeyRegisterStart;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'deviceName': deviceName},
    );
    return PasskeyOptionsParser.toJsonString(response);
  }

  static Future<void> passkeyRegisterFinish({
    required Map<String, dynamic> response,
  }) async {
    final api = GeneratedApiOperations.passkeyRegisterFinish;
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'response': response},
    );
  }

  static Future<void> claimDevice(String code) async {
    await ApiService.callRequest(
      RequestMethod.POST,
      '/auth/device/claim',
      'AuthController_claimDevice_v1',
      body: {
        'code': code,
        'claimCode': code,
        'qrCode': code,
      },
    );
  }

  static Future<TwoFactorSetupData?> setup2FA() async {
    final api = GeneratedApiOperations.setup2FA;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<TwoFactorSetupData?>(() {
      final data = TwoFactorSetupData.fromJson(ApiService.extractMap(response));
      return data.isValid ? data : null;
    });
  }

  static Future<void> enable2FA({
    required String code,
  }) async {
    final api = GeneratedApiOperations.enable2FA;
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {
        'code': code,
      },
    );
  }

  static Future<void> disable2FA({required String code}) async {
    final api = GeneratedApiOperations.disable2FA;
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'code': code},
    );
  }
}
