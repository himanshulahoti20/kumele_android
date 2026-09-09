import 'package:kuemele/features/profile/cubit/profile_state.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/features/profile/presentation/security/security_config.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/models/user_qr_code_info.dart';

class ProfilePageState {
  const ProfilePageState({
    this.profileStatus = ProfileStatus.init,
    this.userData,
    this.qrCodeInfo,
    this.primarySettings = const [],
    this.secondarySettings = const [],
    this.securitySettings = const [],
    this.followingCount = 0,
    this.followersCount = 0,
    this.goldStatus = '0',
    this.topMedalTier = 'Gold',
    this.topMedalCount = '0',
    this.isDarkMode = false,
    this.isPasskeyRegistering = false,
    this.successMessage,
    this.errorMessage,
  });

  final ProfileStatus profileStatus;
  final UserModel? userData;
  final UserQrCodeInfo? qrCodeInfo;
  final List<ProfileSettingItem> primarySettings;
  final List<ProfileSettingItem> secondarySettings;
  final List<SecuritySettingItem> securitySettings;
  final int followingCount;
  final int followersCount;
  final String goldStatus;

  /// The highest reward tier actually held (gold beats silver beats
  /// bronze) — distinct from [goldStatus], which is always the gold count
  /// specifically for the "Gold status" settings row.
  final String topMedalTier;
  final String topMedalCount;
  final bool isDarkMode;
  final bool isPasskeyRegistering;
  final String? successMessage;
  final String? errorMessage;

  bool get twoFactorEnabled => userData?.twoFactorEnabled ?? false;

  List<ProfileStatItem> get profileStats => ProfileConfig.profileStats(
        followingCount: followingCount,
        followersCount: followersCount,
        goldStatus: goldStatus,
      );

  ProfilePageState copyWith({
    ProfileStatus? profileStatus,
    UserModel? userData,
    UserQrCodeInfo? qrCodeInfo,
    List<ProfileSettingItem>? primarySettings,
    List<ProfileSettingItem>? secondarySettings,
    List<SecuritySettingItem>? securitySettings,
    int? followingCount,
    int? followersCount,
    String? goldStatus,
    String? topMedalTier,
    String? topMedalCount,
    bool? isDarkMode,
    bool? isPasskeyRegistering,
    String? successMessage,
    String? errorMessage,
    bool clearSuccessMessage = false,
    bool clearErrorMessage = false,
  }) {
    return ProfilePageState(
      profileStatus: profileStatus ?? this.profileStatus,
      userData: userData ?? this.userData,
      qrCodeInfo: qrCodeInfo ?? this.qrCodeInfo,
      primarySettings: primarySettings ?? this.primarySettings,
      secondarySettings: secondarySettings ?? this.secondarySettings,
      securitySettings: securitySettings ?? this.securitySettings,
      followingCount: followingCount ?? this.followingCount,
      followersCount: followersCount ?? this.followersCount,
      goldStatus: goldStatus ?? this.goldStatus,
      topMedalTier: topMedalTier ?? this.topMedalTier,
      topMedalCount: topMedalCount ?? this.topMedalCount,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isPasskeyRegistering: isPasskeyRegistering ?? this.isPasskeyRegistering,
      successMessage:
          clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
