import 'package:equatable/equatable.dart';

enum TwoFactorDisableStatus {
  initial,
  submitting,
  success,
}

class TwoFactorDisableState extends Equatable {
  const TwoFactorDisableState({
    this.status = TwoFactorDisableStatus.initial,
    this.verificationCode = '',
  });

  final TwoFactorDisableStatus status;
  final String verificationCode;

  bool get isSubmitting => status == TwoFactorDisableStatus.submitting;

  bool get canSubmit =>
      status != TwoFactorDisableStatus.submitting &&
      verificationCode.length == 6;

  TwoFactorDisableState copyWith({
    TwoFactorDisableStatus? status,
    String? verificationCode,
  }) {
    return TwoFactorDisableState(
      status: status ?? this.status,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }

  @override
  List<Object?> get props => [status, verificationCode];
}
