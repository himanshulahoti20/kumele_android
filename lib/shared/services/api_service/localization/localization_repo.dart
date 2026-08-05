import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class LocalizationRepo extends ApiService {
  static Future<List<String>> getLanguageNames() async {
    final api = GeneratedApiOperations.getLocalizationLanguages;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      useAuthenHeader: false,
    );
    return ApiService.handleResponse<List<String>>(() {
          final data = ApiService.extractMap(response);
          final supported = (data['supported'] as List? ?? const []);
          return supported
              .whereType<Map>()
              .map((item) => item['name']?.toString())
              .whereType<String>()
              .toList();
        }) ??
        [];
  }
}
