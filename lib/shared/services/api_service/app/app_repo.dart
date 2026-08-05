import 'package:kuemele/shared/models/app_config.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class AppRepo extends ApiService {
  static Future<AppConfig?> getAppConfig() async {
    final api = GeneratedApiOperations.getAppConfig;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      useAuthenHeader: false,
    );
    return ApiService.handleResponse<AppConfig?>(() => AppConfig.fromJson(ApiService.extractMap(response)));
  }
}
