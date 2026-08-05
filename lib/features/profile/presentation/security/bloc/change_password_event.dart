import 'package:equatable/equatable.dart';

sealed class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object?> get props => [];
}

final class ChangePasswordCurrentChanged extends ChangePasswordEvent {
  const ChangePasswordCurrentChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class ChangePasswordNewChanged extends ChangePasswordEvent {
  const ChangePasswordNewChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class ChangePasswordConfirmChanged extends ChangePasswordEvent {
  const ChangePasswordConfirmChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class ChangePasswordOpened extends ChangePasswordEvent {
  const ChangePasswordOpened();
}

final class ChangePasswordSubmitted extends ChangePasswordEvent {
  const ChangePasswordSubmitted();
}
