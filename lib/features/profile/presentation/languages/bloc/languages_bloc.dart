import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/profile_page_bloc.dart';
import 'package:kuemele/features/profile/presentation/languages/bloc/languages_event.dart';
import 'package:kuemele/features/profile/presentation/languages/bloc/languages_state.dart';
import 'package:kuemele/features/profile/presentation/languages/domain/entities/translation_language.dart';
import 'package:kuemele/features/profile/presentation/languages/domain/repositories/translation_repository.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/profile/profile_repo.dart';

export 'languages_event.dart';
export 'languages_state.dart';

class LanguagesBloc extends Bloc<LanguagesEvent, LanguagesState> {
  LanguagesBloc({required TranslationRepository translationRepository})
      : _translationRepository = translationRepository,
        super(const LanguagesState()) {
    on<LanguagesInit>(_onInit);
    on<LanguagesRetry>(_onRetry);
    on<LanguagesLanguageSelected>(_onLanguageSelected);
  }

  final TranslationRepository _translationRepository;

  Future<void> _onInit(
    LanguagesInit event,
    Emitter<LanguagesState> emit,
  ) async {
    await _loadLanguages(emit);
  }

  Future<void> _onRetry(
    LanguagesRetry event,
    Emitter<LanguagesState> emit,
  ) async {
    await _loadLanguages(emit);
  }

  Future<void> _loadLanguages(Emitter<LanguagesState> emit) async {
    emit(
      state.copyWith(
        status: LanguagesStatus.loading,
        languages: const [],
        clearErrorMessage: true,
      ),
    );

    try {
      final languages = await _translationRepository.getSupportedLanguages();
      final selectedLanguageCode = _resolveSelectedLanguageCode(
        languages,
        InjectionHelper.profileCubit.userData?.language,
      );

      emit(
        state.copyWith(
          status: LanguagesStatus.loaded,
          languages: languages,
          selectedLanguageCode: selectedLanguageCode,
        ),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: LanguagesStatus.failure,
          errorMessage: error.error ?? AppLocalizationsEn().languagesLoadFailed,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: LanguagesStatus.failure,
          errorMessage: AppLocalizationsEn().languagesLoadFailed,
        ),
      );
    }
  }

  Future<void> _onLanguageSelected(
    LanguagesLanguageSelected event,
    Emitter<LanguagesState> emit,
  ) async {
    if (state.isLoading || state.isUpdating) return;
    if (state.selectedLanguageCode == event.code) return;

    final previousCode = state.selectedLanguageCode;
    emit(
      state.copyWith(
        status: LanguagesStatus.updating,
        selectedLanguageCode: event.code,
        clearErrorMessage: true,
      ),
    );

    try {
      final response = await ProfileRepo.updateUserProfile(
        body: UserModel(language: event.code),
      );

      if (response?.data == null) {
        throw ApiException(error: 'Failed to update language.');
      }

      final profileCubit = InjectionHelper.profileCubit;
      profileCubit.userData = response!.data;
      InjectionHelper.profilePageBloc.add(const ProfilePageRefresh());

      InjectionHelper.snackBar.showSuccess(
        response.message ?? 'Language updated.',
      );
      emit(
        state.copyWith(status: LanguagesStatus.loaded),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: LanguagesStatus.loaded,
          selectedLanguageCode: previousCode,
          errorMessage: error.error ?? 'Failed to update language.',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: LanguagesStatus.loaded,
          selectedLanguageCode: previousCode,
          errorMessage: 'Failed to update language.',
        ),
      );
    }
  }

  String _resolveSelectedLanguageCode(
    List<TranslationLanguage> languages,
    String? currentLanguage,
  ) {
    if (currentLanguage == null || currentLanguage.trim().isEmpty) {
      return _defaultLanguageCode(languages);
    }

    final normalized = currentLanguage.trim().toLowerCase();
    for (final language in languages) {
      if (language.code.toLowerCase() == normalized) {
        return language.code;
      }
      if (language.name.toLowerCase() == normalized) {
        return language.code;
      }
      if (language.nativeName.toLowerCase() == normalized) {
        return language.code;
      }
    }

    return _defaultLanguageCode(languages);
  }

  String _defaultLanguageCode(List<TranslationLanguage> languages) {
    return languages
        .firstWhere(
          (language) => language.code == 'en',
          orElse: () => languages.first,
        )
        .code;
  }
}
