import 'package:equatable/equatable.dart';
import 'package:kuemele/shared/models/authen_models.dart';

enum EditProfileStatus {
  initial,
  pickingImage,
  submitting,
  success,
}

class EditProfileState extends Equatable {
  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.isInitialized = false,
    this.username = '',
    this.originalUsername = '',
    this.firstName = '',
    this.lastName = '',
    this.bio = '',
    this.phone = '',
    this.avatarUrl,
    this.localImagePath,
    this.errorMessage,
    this.isUsernameAvailable,
    this.isCheckingUsername = false,
  });

  final EditProfileStatus status;
  final bool isInitialized;
  final String username;
  final String originalUsername;
  final String firstName;
  final String lastName;
  final String bio;
  final String phone;
  final String? avatarUrl;
  final String? localImagePath;
  final String? errorMessage;
  final bool? isUsernameAvailable;
  final bool isCheckingUsername;

  bool get hasLocalImage =>
      localImagePath != null && localImagePath!.isNotEmpty;

  bool get isPickingImage => status == EditProfileStatus.pickingImage;

  bool get isSubmitting => status == EditProfileStatus.submitting;

  String get displayName {
    return [firstName, lastName]
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .join(' ');
  }

  factory EditProfileState.fromUser(UserModel? user) {
    if (user == null) return const EditProfileState();

    final nameParts = _splitFullName(user.fullname);

    final username = user.username ?? '';

    return EditProfileState(
      isInitialized: true,
      username: username,
      originalUsername: username,
      firstName:
          user.firstName ?? (nameParts.isNotEmpty ? nameParts.first : ''),
      lastName: user.lastName ??
          (nameParts.length > 1 ? nameParts.skip(1).join(' ') : ''),
      bio: user.aboutMe ?? '',
      phone: user.phone ?? '',
      avatarUrl: user.profilePicture,
    );
  }

  EditProfileState copyWith({
    EditProfileStatus? status,
    bool? isInitialized,
    String? username,
    String? originalUsername,
    String? firstName,
    String? lastName,
    String? bio,
    String? phone,
    String? avatarUrl,
    String? localImagePath,
    String? errorMessage,
    bool? isUsernameAvailable,
    bool? isCheckingUsername,
    bool clearLocalImage = false,
    bool clearError = false,
    bool clearUsernameValidation = false,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      isInitialized: isInitialized ?? this.isInitialized,
      username: username ?? this.username,
      originalUsername: originalUsername ?? this.originalUsername,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      localImagePath:
          clearLocalImage ? null : (localImagePath ?? this.localImagePath),
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
        isInitialized,
        username,
        originalUsername,
        firstName,
        lastName,
        bio,
        phone,
        avatarUrl,
        localImagePath,
        errorMessage,
        isUsernameAvailable,
        isCheckingUsername,
      ];
}

List<String> _splitFullName(String? fullName) {
  return (fullName ?? '')
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
}
