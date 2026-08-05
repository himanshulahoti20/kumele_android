import 'package:kuemele/shared/utils/utils.dart';

enum Gender {
  male,
  female,
  nonBinary;

  String get value => switch (this) {
        male => 'male',
        female => 'female',
        nonBinary => 'non-binary',
      };

  String get label => switch (this) {
        male => 'Male',
        female => 'Female',
        nonBinary => 'Non-Binary',
      };
}

class UserModel {
  String? id;
  String? username;
  String? fullname;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  Gender? gender;
  String? language;
  String? dateOfBirth;
  String? referralCode;
  String? betaCode;
  bool? aboveLegalAge;
  bool? termsAndConditionsAccepted;
  bool? subscribedToNewsletter;
  String? profilePicture;
  String? aboutMe;
  String? phone;
  String? toTpSecret;
  bool? is2faEnabled;
  String? myReferralCode;
  String? qrCodeUrl;
  String? resetPasswordToken;
  String? resetPasswordExpires;
  String? authProvider;
  String? createdAt;
  String? token;
  String? profileStatus;
  bool? isOnboardingCompleted;

  UserModel({
    this.id,
    this.username,
    this.fullname,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.gender,
    this.language,
    this.dateOfBirth,
    this.referralCode,
    this.betaCode,
    this.aboveLegalAge,
    this.termsAndConditionsAccepted,
    this.subscribedToNewsletter,
    this.profilePicture,
    this.aboutMe,
    this.phone,
    this.toTpSecret,
    this.is2faEnabled,
    this.myReferralCode,
    this.qrCodeUrl,
    this.resetPasswordToken,
    this.resetPasswordExpires,
    this.authProvider,
    this.createdAt,
    this.token,
    this.profileStatus,
    this.isOnboardingCompleted,
  });

  bool get twoFactorEnabled => is2faEnabled ?? false;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final firstName =
        (json['firstName'] ?? json['first_name'])?.toString().trim();
    final lastName = (json['lastName'] ?? json['last_name'])?.toString().trim();
    final combinedName = [firstName, lastName]
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .join(' ')
        .trim();

    return UserModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      fullname: (json['fullname'] ?? combinedName).toString().trim().isEmpty
          ? null
          : (json['fullname'] ?? combinedName).toString().trim(),
      firstName: firstName,
      lastName: lastName?.isEmpty == true ? null : lastName,
      email: json['email'] as String?,
      password: json['password'] as String?,
      gender: _genderFromJson(json['gender']),
      language: (json['language'] ?? json['preferredLanguage']) as String?,
      dateOfBirth: (json['dateofbirth'] ?? json['dateOfBirth']) as String?,
      referralCode: (json['referralcode'] ?? json['referralCode']) as String?,
      betaCode: json['beta_code'] as String?,
      aboveLegalAge: (json['abovelegalage'] ?? json['aboveLegalAge']) as bool?,
      termsAndConditionsAccepted: (json['termsandconditionsaccepted'] ??
          json['termsAndConditionsAccepted']) as bool?,
      subscribedToNewsletter: (json['subscribedtonewsletter'] ??
          json['subscribedToNewsletter']) as bool?,
      profilePicture: (json['profilepicture'] ?? json['avatar']) as String?,
      aboutMe: (json['about_me'] ?? json['bio']) as String?,
      phone: json['phone'] as String?,
      toTpSecret: json['to_tp_secret'] as String?,
      is2faEnabled: (json['twoFactorEnabled'] ??
          json['is_2fa_enabled'] ??
          json['is2faEnabled']) as bool?,
      myReferralCode: json['my_referral_code'] as String?,
      qrCodeUrl: json['qr_code_url'] as String?,
      resetPasswordToken: json['reset_password_token'] as String?,
      resetPasswordExpires: json['reset_password_expires'] as String?,
      authProvider: json['auth_provider'] as String?,
      createdAt: json['created_at'] as String?,
      token: json['token'] as String?,
      profileStatus:
          (json['profile_status'] ?? json['profileStatus'])?.toString(),
      isOnboardingCompleted: (json['isOnboardingCompleted'] ??
          json['is_onboarding_completed']) as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (fullname != null) 'fullName': fullname,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (gender != null) 'gender': gender?.value,
      if (language != null) 'language': language,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (referralCode != null) 'referralCode': referralCode ?? '',
      if (betaCode != null) 'beta_code': betaCode ?? '',
      if (aboveLegalAge != null) 'aboveLegalAge': aboveLegalAge,
      if (termsAndConditionsAccepted != null)
        'termsAndConditionsAccepted': termsAndConditionsAccepted,
      if (subscribedToNewsletter != null)
        'subscribedToNewsletter': subscribedToNewsletter,
      if (profilePicture != null) 'profilepicture': profilePicture,
      if (aboutMe != null) 'about_me': aboutMe,
      if (toTpSecret != null) 'to_tp_secret': toTpSecret,
      if (is2faEnabled != null) 'twoFactorEnabled': is2faEnabled,
      if (myReferralCode != null) 'my_referral_code': myReferralCode,
      if (qrCodeUrl != null) 'qr_code_url': qrCodeUrl,
      if (resetPasswordToken != null)
        'reset_password_token': resetPasswordToken,
      if (resetPasswordExpires != null)
        'reset_password_expires': resetPasswordExpires,
      if (authProvider != null) 'auth_provider': authProvider,
      if (createdAt != null) 'created_at': createdAt,
      if (token != null) 'token': token,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? fullname,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    Gender? gender,
    String? language,
    String? dateOfBirth,
    String? referralCode,
    String? betaCode,
    bool? aboveLegalAge,
    bool? termsAndConditionsAccepted,
    bool? subscribedToNewsletter,
    String? profilePicture,
    String? aboutMe,
    String? phone,
    String? toTpSecret,
    bool? is2faEnabled,
    String? myReferralCode,
    String? qrCodeUrl,
    String? resetPasswordToken,
    String? resetPasswordExpires,
    String? authProvider,
    String? createdAt,
    String? token,
    String? profileStatus,
    bool? isOnboardingCompleted,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      language: language ?? this.language,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      referralCode: referralCode ?? this.referralCode,
      betaCode: betaCode ?? this.betaCode,
      aboveLegalAge: aboveLegalAge ?? this.aboveLegalAge,
      termsAndConditionsAccepted:
          termsAndConditionsAccepted ?? this.termsAndConditionsAccepted,
      subscribedToNewsletter:
          subscribedToNewsletter ?? this.subscribedToNewsletter,
      profilePicture: profilePicture ?? this.profilePicture,
      aboutMe: aboutMe ?? this.aboutMe,
      phone: phone ?? this.phone,
      toTpSecret: toTpSecret ?? this.toTpSecret,
      is2faEnabled: is2faEnabled ?? this.is2faEnabled,
      myReferralCode: myReferralCode ?? this.myReferralCode,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
      resetPasswordToken: resetPasswordToken ?? this.resetPasswordToken,
      resetPasswordExpires: resetPasswordExpires ?? this.resetPasswordExpires,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt ?? this.createdAt,
      token: token ?? this.token,
      profileStatus: profileStatus ?? this.profileStatus,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
    );
  }

  Map<String, dynamic> toProfileUpdateJson() {
    final explicitFirstName = firstName?.trim();
    final explicitLastName = lastName?.trim();
    final names = (fullname ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((value) => value.isNotEmpty)
        .toList();
    final firstNameValue = explicitFirstName?.isNotEmpty == true
        ? explicitFirstName
        : (names.isNotEmpty ? names.first : null);
    final lastNameValue = explicitLastName?.isNotEmpty == true
        ? explicitLastName
        : (names.length > 1 ? names.skip(1).join(' ') : null);

    return {
      if (firstNameValue != null) 'firstName': firstNameValue,
      if (lastNameValue != null) 'lastName': lastNameValue,
      if (username != null) 'username': username,
      if (profilePicture != null) 'avatar': profilePicture,
      if (aboutMe != null) 'bio': aboutMe,
      if (phone != null) 'phone': phone,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (gender != null)
        'gender': switch (gender!) {
          Gender.male => 'MALE',
          Gender.female => 'FEMALE',
          Gender.nonBinary => 'OTHER',
        },
      if (language != null) 'preferredLanguage': language,
    };
  }
}

Gender? _genderFromJson(dynamic value) {
  final normalized = value?.toString().trim().toLowerCase();
  switch (normalized) {
    case 'male':
      return Gender.male;
    case 'female':
      return Gender.female;
    case 'non-binary':
    case 'nonbinary':
    case 'other':
    case 'prefer_not_to_say':
    case 'prefer not to say':
      return Gender.nonBinary;
    default:
      return Utils.stringToEnum(value, Gender.values);
  }
}

class UserNotification {
  bool? soundNotifications;
  bool? emailNotifications;

  UserNotification({
    this.soundNotifications,
    this.emailNotifications,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      soundNotifications: json['sound_notifications'] as bool?,
      emailNotifications: json['email_notifications'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (soundNotifications != null) 'sound_notifications': soundNotifications,
      if (emailNotifications != null) 'email_notifications': emailNotifications,
    };
  }
}

class AuthSession {
  final String accessToken;
  final String? refreshToken;
  final String? userId;
  final String? email;
  final String? role;
  final String? profileStatus;
  final bool? isOnboardingCompleted;
  final bool? emailVerified;

  const AuthSession({
    required this.accessToken,
    this.refreshToken,
    this.userId,
    this.email,
    this.role,
    this.profileStatus,
    this.isOnboardingCompleted,
    this.emailVerified,
  });

  bool get needsOnboarding {
    return isOnboardingCompleted == false;
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken:
          (json['access_token'] ?? json['accessToken'] ?? json['token'] ?? '')
              .toString(),
      refreshToken: (json['refresh_token'] ?? json['refreshToken'])?.toString(),
      userId: (json['user_id'] ?? json['userId'])?.toString(),
      email: json['email']?.toString(),
      role: json['role']?.toString(),
      profileStatus:
          (json['profile_status'] ?? json['profileStatus'])?.toString(),
      isOnboardingCompleted: (json['isOnboardingCompleted'] ??
          json['is_onboarding_completed']) as bool?,
      emailVerified: (json['emailVerified'] ??
          json['email_verified'] ??
          json['emailVerified']) as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (userId != null) 'user_id': userId,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (profileStatus != null) 'profile_status': profileStatus,
      if (isOnboardingCompleted != null)
        'isOnboardingCompleted': isOnboardingCompleted,
      if (emailVerified != null) 'emailVerified': emailVerified,
    };
  }

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    String? userId,
    String? email,
    String? role,
    String? profileStatus,
    bool? isOnboardingCompleted,
    bool? emailVerified,
  }) {
    return AuthSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      role: role ?? this.role,
      profileStatus: profileStatus ?? this.profileStatus,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
}

sealed class LoginResult {
  const LoginResult();
}

class LoginSessionResult extends LoginResult {
  const LoginSessionResult(this.session);

  final AuthSession session;
}

class LoginTwoFactorChallengeResult extends LoginResult {
  const LoginTwoFactorChallengeResult({required this.tempToken});

  final String tempToken;
}
