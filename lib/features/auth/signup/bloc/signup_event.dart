import 'package:kuemele/shared/models/authen_models.dart';

sealed class SignupEvent {}

class SignupGenderChanged extends SignupEvent {
  SignupGenderChanged(this.gender);
  final Gender gender;
}

class SignupDateOfBirthChanged extends SignupEvent {
  SignupDateOfBirthChanged({this.day, this.month, this.year});
  final int? day;
  final int? month;
  final int? year;
}

class SignupLegalAdultChanged extends SignupEvent {
  SignupLegalAdultChanged(this.value);
  final bool value;
}

class SignupSubscribeChanged extends SignupEvent {
  SignupSubscribeChanged(this.value);
  final bool value;
}

class SignupTermsChanged extends SignupEvent {
  SignupTermsChanged(this.value);
  final bool value;
}

class SignupCaptchaChanged extends SignupEvent {
  SignupCaptchaChanged(this.value);
  final bool value;
}

class SignupReset extends SignupEvent {}

class SignupSubmitted extends SignupEvent {
  SignupSubmitted({
    required this.firstName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.lastName = '',
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
}
