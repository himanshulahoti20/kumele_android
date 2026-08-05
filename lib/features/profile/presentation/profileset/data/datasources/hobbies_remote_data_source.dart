import 'package:kuemele/features/profile/presentation/profileset/data/models/hobby_category_model.dart';
import 'package:kuemele/features/profile/presentation/profileset/data/models/user_hobby_preference_model.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/entities/user_hobby_preference.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';
import 'package:kuemele/shared/utils/utils.dart';

class HobbiesRemoteDataSource {
  Future<List<HobbyCategoryModel>> fetchCategories() async {
    final api = GeneratedApiOperations.getHobbyCategories;

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );

    return ApiService.handleResponse<List<HobbyCategoryModel>>(
          () =>
              Utils.jsonToList(
                ApiService.extractList(response),
                HobbyCategoryModel.fromJson,
              ) ??
              [],
        ) ??
        [];
  }

  Future<List<UserHobbyPreferenceModel>> fetchUserHobbies({
    required String userId,
  }) async {
    final api = GeneratedApiOperations.getUserHobbies;

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      GeneratedApiOperations.resolvePath(api, pathValues: {'id': userId}),
      api.operationId,
    );

    return ApiService.handleResponse<List<UserHobbyPreferenceModel>>(
          () =>
              Utils.jsonToList(
                _extractUserHobbiesList(response),
                UserHobbyPreferenceModel.fromJson,
              ) ??
              [],
        ) ??
        [];
  }

  /// The user hobbies list may arrive as a raw list, under `data`,
  /// or nested under a `hobbies` key.
  static List<dynamic> _extractUserHobbiesList(dynamic response) {
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is Map<String, dynamic> && data['hobbies'] is List) {
        return data['hobbies'] as List<dynamic>;
      }
      if (response['hobbies'] is List) {
        return response['hobbies'] as List<dynamic>;
      }
    }
    return ApiService.extractList(response);
  }

  Future<String> updateUserHobbies({
    required String userId,
    required List<UserHobbyPreference> hobbies,
  }) async {
    final api = GeneratedApiOperations.updateUserHobbies;

    final payload = hobbies
        .map(UserHobbyPreferenceModel.fromEntity)
        .map((hobby) => hobby.toJson())
        .toList();

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      GeneratedApiOperations.resolvePath(api, pathValues: {'id': userId}),
      api.operationId,
      body: {'hobbies': payload},
    );

    return ApiErrorExtractor.messageFrom(response) ??
        'Interests saved successfully.';
  }
}
