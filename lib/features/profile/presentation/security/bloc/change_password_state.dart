import 'package:equatable/equatable.dart';

enum ChangePasswordStatus {
  initial,
  submitting,
  success,
}

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.errorMessage,
  });

  final ChangePasswordStatus status;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final String? errorMessage;

  bool get isSubmitting => status == ChangePasswordStatus.submitting;

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentPassword,
        newPassword,
        confirmPassword,
        errorMessage,
      ];
}
