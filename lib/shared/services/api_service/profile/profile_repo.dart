import 'package:dio/dio.dart';
import 'package:kuemele/features/discover/data/models/upload_banner_response_model.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/models/common.dart';
import 'package:kuemele/shared/models/event_category.dart';
import 'package:kuemele/shared/models/privacy_preferences.dart';
import 'package:kuemele/shared/models/referral_info.dart';
import 'package:kuemele/shared/models/user_qr_code_info.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';
import 'package:kuemele/shared/utils/storage_util.dart';
import 'package:kuemele/shared/utils/utils.dart';

class ProfileRepo extends ApiService {
  static Future<UserQrCodeInfo?> getUserQrCode(String userId) async {
    final api = GeneratedApiOperations.generateQRCode;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': userId},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<UserQrCodeInfo?>(
      () => UserQrCodeInfo.fromJson(ApiService.extractMap(response)),
    );
  }

  /// `PUT /users/me/featured-nft` — sets which owned NFT the user shows on
  /// their public-facing profile/host card. Returns the full updated user
  /// (with `featuredNft` now populated to match).
  static Future<ApiResponse<UserModel>?> setFeaturedNft(String nftId) async {
    final response = await ApiService.callRequest(
      RequestMethod.PUT,
      '/users/me/featured-nft',
      'ProfileRepo_setFeaturedNft',
      body: {'nftId': nftId},
    );
    return ApiService.handleResponse<ApiResponse<UserModel>>(
      () => ApiResponse<UserModel>(
        success: true,
        data: UserModel.fromJson(ApiService.extractMap(response)),
      ),
    );
  }

  static Future<ApiResponse<UserModel>?> getUserData() async {
    final api = GeneratedApiOperations.getUserProfile;
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

  static Future<ApiResponse<UserNotification>?> getUserNotification() async {
    final soundNotifications =
        await StorageUtil.retrieveItem(StorageKey.USER_SOUND_NOTIFICATIONS)
            as bool?;
    final emailNotifications =
        await StorageUtil.retrieveItem(StorageKey.USER_EMAIL_NOTIFICATIONS)
            as bool?;

    return ApiService.handleResponse<ApiResponse<UserNotification>>(
      () => ApiResponse<UserNotification>(
        success: true,
        message: 'Notification preferences loaded locally.',
        data: UserNotification(
          soundNotifications: soundNotifications ?? false,
          emailNotifications: emailNotifications ?? false,
        ),
      ),
    );
  }

  static Future<bool> updateUserNotification({
    required bool soundNotifications,
    required bool emailNotifications,
  }) async {
    await StorageUtil.storeItem(
        StorageKey.USER_SOUND_NOTIFICATIONS, soundNotifications);
    await StorageUtil.storeItem(
        StorageKey.USER_EMAIL_NOTIFICATIONS, emailNotifications);
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<ApiResponse?> updateUserAbout({required String about}) async {
    final api = GeneratedApiOperations.updateUserProfile;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'bio': about},
    );
    return ApiService.handleResponse<ApiResponse>(() =>
        ApiResponse(success: true, data: ApiService.extractMap(response)));
  }

  static Future<String?> createSupportTicket({
    required Map<String, dynamic> body,
  }) async {
    final api = GeneratedApiOperations.createSupportTicket;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: body,
    );
    return ApiService.handleResponse<String?>(() {
      final payload = response is Map<String, dynamic> ? response : null;
      if (payload == null) return null;
      return ApiResponse.fromJson(payload).message;
    });
  }

  static Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final api = GeneratedApiOperations.changePassword;
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'currentPassword': oldPassword, 'newPassword': newPassword},
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<String?> deleteAccount({
    required String password,
    required String reason,
    required bool confirmation,
  }) async {
    final api = GeneratedApiOperations.deleteAccount;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {
        'password': password,
        'reason': reason,
        'confirmation': confirmation,
      },
    );
    return ApiService.handleResponse<String?>(() {
      final payload = ApiService.extractMap(response);
      return ApiResponse.fromJson(payload).message;
    });
  }

  static Future<PrivacyPreferences?> getPrivacyPreferences() async {
    final api = GeneratedApiOperations.getPrivacyPreferences;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<PrivacyPreferences?>(
      () => PrivacyPreferences.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<PrivacyPreferences?> updateConsent(
      PrivacyPreferences preferences) async {
    final api = GeneratedApiOperations.updateConsent;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: preferences.toConsentJson(),
    );
    return ApiService.handleResponse<PrivacyPreferences?>(
      () => PrivacyPreferences.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<List<EventCategory>> getEventCategories() async {
    final api = GeneratedApiOperations.getHobbyCategories;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<List<EventCategory>?>(() =>
            Utils.jsonToList(
                ApiService.extractList(response), EventCategory.fromJson)) ??
        [];
  }

  static Future<bool?> checkUsernameAvailability(String username) async {
    final api = GeneratedApiOperations.checkUsername;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      params: {'username': username},
      useAuthenHeader: false,
    );
    return ApiService.handleResponse<bool?>(() {
      final data = ApiService.extractMap(response);
      return data['available'] as bool?;
    });
  }

  static Future<bool> validateReferralCode(String code) async {
    final api = GeneratedApiOperations.validateReferralCode;
    final url = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'code': code},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      url,
      api.operationId,
    );
    return ApiService.handleResponse<bool>(() {
          final data = ApiService.extractMap(response);
          return (data['valid'] as bool?) ??
              (response is Map<String, dynamic>
                  ? response['valid'] as bool?
                  : null) ??
              true;
        }) ??
        false;
  }

  static Future<ReferralInfo?> getMyReferralInfo() async {
    final api = GeneratedApiOperations.getReferralCode;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<ReferralInfo?>(() {
      final info = ReferralInfo.fromJson(ApiService.extractMap(response));
      return info.isValid ? info : null;
    });
  }

  static Future<String> uploadProfileImage(String filePath) async {
    final api = GeneratedApiOperations.uploadProfileImage;

    final formData = FormData.fromMap(<String, dynamic>{
      'file': await MultipartFile.fromFile(filePath),
    });

    final response = await ApiService.uploadMultipart(
      api.path,
      api.operationId,
      formData,
    );

    return ApiService.handleResponse<String>(() {
      final data = ApiService.extractMap(response);
      return UploadBannerResponseModel.fromJson(data).url;
    })!;
  }

  static Future<ApiResponse<UserModel>?> updateUserProfile(
      {required UserModel body}) async {
    final api = GeneratedApiOperations.updateUserProfile;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: body.toProfileUpdateJson(),
    );
    return ApiService.handleResponse<ApiResponse<UserModel>>(
      () => ApiResponse<UserModel>(
        success: true,
        data: UserModel.fromJson(ApiService.extractMap(response)),
      ),
    );
  }

  static Future<ApiResponse<UserModel>?> updateUserProfileById({
    required String userId,
    required UserModel body,
  }) async {
    final api = GeneratedApiOperations.updateUserProfileById;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': userId},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      body: body.toProfileUpdateJson(),
    );
    return ApiService.handleResponse<ApiResponse<UserModel>>(
      () => ApiResponse<UserModel>(
        success: true,
        data: UserModel.fromJson(ApiService.extractMap(response)),
      ),
    );
  }
}
