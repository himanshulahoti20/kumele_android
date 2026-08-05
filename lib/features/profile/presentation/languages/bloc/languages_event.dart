sealed class LanguagesEvent {
  const LanguagesEvent();
}

class LanguagesInit extends LanguagesEvent {
  const LanguagesInit();
}

class LanguagesRetry extends LanguagesEvent {
  const LanguagesRetry();
}

class LanguagesLanguageSelected extends LanguagesEvent {
  const LanguagesLanguageSelected(this.code);

  final String code;
}
