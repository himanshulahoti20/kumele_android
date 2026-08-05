import 'package:kuemele/shared/models/authen_models.dart';

enum SignupUIStatus {
  initial,
  validationError,
  validationSuccess,
}

class SignupState {
  const SignupState({
    this.selectedGender = Gender.male,
    this.selectedDay = 1,
    this.selectedMonth = 1,
    this.selectedYear = 2000,
    this.legalAdult = false,
    this.subscribe = false,
    this.terms = false,
    this.imNotARobot = false,
    this.status = SignupUIStatus.initial,
    this.errorMessage,
  });

  final Gender selectedGender;
  final int selectedDay;
  final int selectedMonth;
  final int selectedYear;
  final bool legalAdult;
  final bool subscribe;
  final bool terms;
  final bool imNotARobot;
  final SignupUIStatus status;
  final String? errorMessage;

  SignupState copyWith({
    Gender? selectedGender,
    int? selectedDay,
    int? selectedMonth,
    int? selectedYear,
    bool? legalAdult,
    bool? subscribe,
    bool? terms,
    bool? imNotARobot,
    SignupUIStatus? status,
    String? errorMessage,
  }) {
    return SignupState(
      selectedGender: selectedGender ?? this.selectedGender,
      selectedDay: selectedDay ?? this.selectedDay,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      legalAdult: legalAdult ?? this.legalAdult,
      subscribe: subscribe ?? this.subscribe,
      terms: terms ?? this.terms,
      imNotARobot: imNotARobot ?? this.imNotARobot,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
