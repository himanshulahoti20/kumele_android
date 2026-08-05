import 'package:equatable/equatable.dart';

enum OnboardingStatus {
  initial,
  pickingImage,
  submitting,
  success,
}

class OnboardingState extends Equatable {
  const OnboardingState({
    this.status = OnboardingStatus.initial,
    this.profileImagePath,
    this.errorMessage,
    this.isUsernameAvailable,
    this.isCheckingUsername = false,
  });

  final OnboardingStatus status;
  final String? profileImagePath;
  final String? errorMessage;
  final bool? isUsernameAvailable;
  final bool isCheckingUsername;

  bool get hasProfileImage =>
      profileImagePath != null && profileImagePath!.isNotEmpty;

  bool get isPickingImage => status == OnboardingStatus.pickingImage;

  bool get isSubmitting => status == OnboardingStatus.submitting;

  OnboardingState copyWith({
    OnboardingStatus? status,
    String? profileImagePath,
    String? errorMessage,
    bool? isUsernameAvailable,
    bool? isCheckingUsername,
    bool clearProfileImage = false,
    bool clearError = false,
    bool clearUsernameValidation = false,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      profileImagePath: clearProfileImage
          ? null
          : (profileImagePath ?? this.profileImagePath),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isUsernameAvailable: clearUsernameValidation
          ? null
          : (isUsernameAvailable ?? this.isUsernameAvailable),
      isCheckingUsername: isCheckingUsername ?? this.isCheckingUsername,
    );
  }

  @override
  List<Object?> get props => [
        status,
        profileImagePath,
        errorMessage,
        isUsernameAvailable,
        isCheckingUsername
      ];
}
