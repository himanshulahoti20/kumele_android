import 'package:equatable/equatable.dart';

enum DeleteAccountStatus {
  initial,
  submitting,
  success,
}

class DeleteAccountState extends Equatable {
  const DeleteAccountState({
    this.status = DeleteAccountStatus.initial,
    this.password = '',
    this.reason = '',
    this.confirmation = false,
    this.errorMessage,
    this.successMessage,
  });

  final DeleteAccountStatus status;
  final String password;
  final String reason;
  final bool confirmation;
  final String? errorMessage;
  final String? successMessage;

  bool get isSubmitting => status == DeleteAccountStatus.submitting;

  DeleteAccountState copyWith({
    DeleteAccountStatus? status,
    String? password,
    String? reason,
    bool? confirmation,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccessMessage = false,
  }) {
    return DeleteAccountState(
      status: status ?? this.status,
      password: password ?? this.password,
      reason: reason ?? this.reason,
      confirmation: confirmation ?? this.confirmation,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccessMessage ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        password,
        reason,
        confirmation,
        errorMessage,
        successMessage,
      ];
}
