import 'package:equatable/equatable.dart';

sealed class TwoFactorDisableEvent extends Equatable {
  const TwoFactorDisableEvent();

  @override
  List<Object?> get props => [];
}

class TwoFactorDisableOpened extends TwoFactorDisableEvent {
  const TwoFactorDisableOpened();
}

class TwoFactorDisableCodeChanged extends TwoFactorDisableEvent {
  const TwoFactorDisableCodeChanged(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}

class TwoFactorDisableSubmitted extends TwoFactorDisableEvent {
  const TwoFactorDisableSubmitted();
}
