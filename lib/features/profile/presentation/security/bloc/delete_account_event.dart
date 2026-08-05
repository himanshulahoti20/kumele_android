import 'package:equatable/equatable.dart';

sealed class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object?> get props => [];
}

final class DeleteAccountOpened extends DeleteAccountEvent {
  const DeleteAccountOpened();
}

final class DeleteAccountPasswordChanged extends DeleteAccountEvent {
  const DeleteAccountPasswordChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class DeleteAccountReasonChanged extends DeleteAccountEvent {
  const DeleteAccountReasonChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class DeleteAccountConfirmationChanged extends DeleteAccountEvent {
  const DeleteAccountConfirmationChanged(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

final class DeleteAccountSubmitted extends DeleteAccountEvent {
  const DeleteAccountSubmitted();
}
