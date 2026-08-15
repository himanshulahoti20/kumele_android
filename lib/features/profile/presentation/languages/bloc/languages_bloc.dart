import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/app/cubit/locale_cubit.dart';
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

      // The highlighted chip and the language the app actually renders in must
      // never disagree: a stale profile language would otherwise leave the
      // wanted language already "selected", so tapping it did nothing.
      if (selectedLanguageCode !=
          getIt<LocaleCubit>().state.locale.languageCode) {
        getIt<LocaleCubit>().setLocale(selectedLanguageCode);
      }

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
    if (state.selectedLanguageCode == event.code) {
      // Already the selected chip — re-apply instead of no-oping, so a tap is
      // never swallowed when the rendered locale has drifted from the profile.
      getIt<LocaleCubit>().setLocale(event.code);
      return;
    }

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

      // Apply the new language to the whole app immediately.
      getIt<LocaleCubit>().setLocale(event.code);

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

  /// Profile language wins; otherwise fall back to the locale the app is
  /// already rendering in, so a locally picked language survives a reload.
  String _resolveSelectedLanguageCode(
    List<TranslationLanguage> languages,
    String? currentLanguage,
  ) {
    return _matchLanguageCode(languages, currentLanguage) ??
        _matchLanguageCode(
          languages,
          getIt<LocaleCubit>().state.locale.languageCode,
        ) ??
        _defaultLanguageCode(languages);
  }

  String? _matchLanguageCode(
    List<TranslationLanguage> languages,
    String? value,
  ) {
    if (value == null || value.trim().isEmpty) return null;

    final normalized = value.trim().toLowerCase();
    for (final language in languages) {
      if (language.code.toLowerCase() == normalized ||
          language.name.toLowerCase() == normalized ||
          language.nativeName.toLowerCase() == normalized) {
        return language.code;
      }
    }
    return null;
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
