import 'package:equatable/equatable.dart';
import 'package:kuemele/shared/models/two_factor_setup_data.dart';

enum TwoFactorSetupStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  loadFailed,
}

class TwoFactorSetupState extends Equatable {
  const TwoFactorSetupState({
    this.status = TwoFactorSetupStatus.initial,
    this.setupData,
    this.verificationCode = '',
    this.errorMessage,
  });

  final TwoFactorSetupStatus status;
  final TwoFactorSetupData? setupData;
  final String verificationCode;
  final String? errorMessage;

  bool get isLoadingSetup => status == TwoFactorSetupStatus.loading;
  bool get isSubmitting => status == TwoFactorSetupStatus.submitting;
  bool get isLoadFailed => status == TwoFactorSetupStatus.loadFailed;

  bool get canSubmit =>
      status == TwoFactorSetupStatus.loaded && verificationCode.length == 6;

  TwoFactorSetupState copyWith({
    TwoFactorSetupStatus? status,
    TwoFactorSetupData? setupData,
    String? verificationCode,
    String? errorMessage,
    bool clearError = false,
    bool clearSetupData = false,
  }) {
    return TwoFactorSetupState(
      status: status ?? this.status,
      setupData: clearSetupData ? null : (setupData ?? this.setupData),
      verificationCode: verificationCode ?? this.verificationCode,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        setupData,
        verificationCode,
        errorMessage,
      ];
}
