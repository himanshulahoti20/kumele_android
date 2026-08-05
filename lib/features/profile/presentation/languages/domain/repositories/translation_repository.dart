import 'package:kuemele/features/profile/presentation/languages/domain/entities/translation_language.dart';

abstract class TranslationRepository {
  Future<List<TranslationLanguage>> getSupportedLanguages();
}
