import 'package:kuemele/shared/models/legal_document.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class LegalRepo extends ApiService {
  static Future<LegalDocument?> getLegalDocumentByType(
    LegalDocumentType type,
  ) async {
    final api = GeneratedApiOperations.getLegalDocumentByType;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'type': type.apiValue},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      useAuthenHeader: false,
    );
    return ApiService.handleResponse<LegalDocument?>(() {
      final data = ApiService.extractMap(response);
      if (data.isEmpty) return null;
      return LegalDocument.fromJson(data);
    });
  }
}
