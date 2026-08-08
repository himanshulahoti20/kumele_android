import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/shared/services/api_service/localization/localization_repo.dart';
import 'package:kuemele/shared/utils/storage_util.dart';

class LanguageModel {
  final String code;
  final String name;

  const LanguageModel({required this.code, required this.name});
}

class LocaleState {
  final Locale locale;
  final List<LanguageModel> languages;
  final bool isLoading;

  const LocaleState({
    required this.locale,
    this.languages = const [],
    this.isLoading = false,
  });

  LocaleState copyWith({
    Locale? locale,
    List<LanguageModel>? languages,
    bool? isLoading,
  }) {
    return LocaleState(
      locale: locale ?? this.locale,
      languages: languages ?? this.languages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LocaleCubit extends Cubit<LocaleState> {
  static const Map<String, String> _languageNames = {
    'en': 'English',
    'ar': 'العربية',
    'de': 'Deutsch',
    'es': 'Español',
    'fr': 'Français',
    'zh': '中文',
  };

  LocaleCubit()
      : super(LocaleState(
          locale: const Locale('en'),
          languages: _buildLanguagesFromSupported(),
        )) {
    _restoreLocale();
    _initializeLanguages();
  }

  static List<LanguageModel> _buildLanguagesFromSupported() {
    return AppLocalizations.supportedLocales
        .map((locale) => LanguageModel(
              code: locale.languageCode,
              name: _languageNames[locale.languageCode] ??
                  locale.languageCode.toUpperCase(),
            ))
        .toList();
  }

  Future<void> _initializeLanguages() async {
    safeEmit(state.copyWith(isLoading: true));
    try {
      final apiLanguages = await LocalizationRepo.getLanguages();
      final languages = apiLanguages.isNotEmpty
          ? apiLanguages
          : _buildLanguagesFromSupported();
      safeEmit(state.copyWith(languages: languages, isLoading: false));
    } catch (_) {
      safeEmit(
        state.copyWith(
          languages: _buildLanguagesFromSupported(),
          isLoading: false,
        ),
      );
    }
  }

  Future<void> _restoreLocale() async {
    try {
      final saved = await StorageUtil.retrieveItem(StorageKey.APP_LOCALE);
      if (saved is String && saved.isNotEmpty) {
        safeEmit(state.copyWith(locale: Locale(saved)));
      }
    } catch (_) {
      // Ignore storage errors and fall back to the default locale.
    }
  }

  void setLocale(String languageCode) {
    if (languageCode.isEmpty) return;
    final locale = Locale(languageCode);
    StorageUtil.storeItem(StorageKey.APP_LOCALE, languageCode);
    safeEmit(state.copyWith(locale: locale));
  }
}
