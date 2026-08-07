import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/shared/services/api_service/localization/localization_repo.dart';

class LanguageModel {
  final String code;
  final String name;

  LanguageModel({required this.code, required this.name});
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
  LocaleCubit()
      : super(LocaleState(
          locale: const Locale('en'),
          languages: _buildLanguagesFromSupported(),
        )) {
    _initializeLanguages();
  }

  static List<LanguageModel> _buildLanguagesFromSupported() {
    return AppLocalizations.supportedLocales
        .map((locale) => LanguageModel(
              code: locale.languageCode,
              name: locale.languageCode,
            ))
        .toList();
  }

  Future<void> _initializeLanguages() async {
    safeEmit(state.copyWith(isLoading: true));
    try {
      final languages = await LocalizationRepo.getLanguages();
      safeEmit(state.copyWith(languages: languages, isLoading: false));
    } catch (_) {
      safeEmit(state.copyWith(isLoading: false));
    }
  }

  void setLocale(String languageCode) {
    final locale = Locale(languageCode);
    safeEmit(state.copyWith(locale: locale));
  }
}
