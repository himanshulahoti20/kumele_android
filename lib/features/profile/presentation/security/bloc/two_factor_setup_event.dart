import 'package:equatable/equatable.dart';

sealed class TwoFactorSetupEvent extends Equatable {
  const TwoFactorSetupEvent();

  @override
  List<Object?> get props => [];
}

class TwoFactorSetupOpened extends TwoFactorSetupEvent {
  const TwoFactorSetupOpened();
}

class TwoFactorSetupStarted extends TwoFactorSetupEvent {
  const TwoFactorSetupStarted();
}

class TwoFactorSetupRetried extends TwoFactorSetupEvent {
  const TwoFactorSetupRetried();
}

class TwoFactorSetupCodeChanged extends TwoFactorSetupEvent {
  const TwoFactorSetupCodeChanged(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}

class TwoFactorSetupSubmitted extends TwoFactorSetupEvent {
  const TwoFactorSetupSubmitted();
}
