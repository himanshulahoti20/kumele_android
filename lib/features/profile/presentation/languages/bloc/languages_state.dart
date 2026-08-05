import 'package:kuemele/features/profile/presentation/languages/domain/entities/translation_language.dart';

enum LanguagesStatus {
  initial,
  loading,
  loaded,
  updating,
  failure,
}

class LanguagesState {
  const LanguagesState({
    this.status = LanguagesStatus.initial,
    this.languages = const [],
    this.selectedLanguageCode,
    this.errorMessage,
  });

  final LanguagesStatus status;
  final List<TranslationLanguage> languages;
  final String? selectedLanguageCode;
  final String? errorMessage;

  bool get isLoading => status == LanguagesStatus.loading && languages.isEmpty;

  bool get isUpdating => status == LanguagesStatus.updating;

  LanguagesState copyWith({
    LanguagesStatus? status,
    List<TranslationLanguage>? languages,
    String? selectedLanguageCode,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return LanguagesState(
      status: status ?? this.status,
      languages: languages ?? this.languages,
      selectedLanguageCode: selectedLanguageCode ?? this.selectedLanguageCode,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
