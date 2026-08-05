import 'package:kuemele/features/profile/presentation/languages/domain/entities/translation_language.dart';
import 'package:kuemele/features/profile/presentation/languages/domain/repositories/translation_repository.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  @override
  Future<List<TranslationLanguage>> getSupportedLanguages() async {
    final api = GeneratedApiOperations.getTranslationLanguages;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      useAuthenHeader: false,
    );

    return ApiService.handleResponse<List<TranslationLanguage>>(() {
          final data = ApiService.extractMap(response);
          final supported = data['supported'] as List? ?? const [];
          final languages = supported
              .whereType<Map>()
              .map(
                (item) => TranslationLanguage.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .where((language) => language.code.isNotEmpty)
              .toList();

          if (languages.isEmpty) {
            throw ApiException(error: 'No languages available.');
          }

          return languages;
        }) ??
        [];
  }
}
