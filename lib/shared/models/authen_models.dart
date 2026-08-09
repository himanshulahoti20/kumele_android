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
  String? displayName;
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
  String? city;
  String? country;
  double? latitude;
  double? longitude;
  int? locationRadius;
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
  bool? emailVerified;
  String? paypalMerchantId;
  bool? paypalConnected;
  ProfileCompleteness? profileCompleteness;

  UserModel({
    this.id,
    this.username,
    this.fullname,
    this.displayName,
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
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.locationRadius,
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
    this.emailVerified,
    this.paypalMerchantId,
    this.paypalConnected,
    this.profileCompleteness,
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
    final displayName =
        (json['displayName'] ?? json['display_name'])?.toString().trim();
    final fullName =
        (json['fullname'] ?? json['fullName'] ?? displayName ?? combinedName)
            .toString()
            .trim();

    return UserModel(
      id: (json['id'] ?? json['_id'] ?? json['userId'] ?? json['user_id'])
          ?.toString(),
      username: json['username']?.toString(),
      fullname: fullName.isEmpty ? null : fullName,
      displayName: displayName?.isEmpty == true ? null : displayName,
      firstName: firstName,
      lastName: lastName?.isEmpty == true ? null : lastName,
      email: json['email']?.toString(),
      password: json['password']?.toString(),
      gender: _genderFromJson(json['gender']),
      language: (json['language'] ?? json['preferredLanguage'])?.toString(),
      dateOfBirth: (json['dateofbirth'] ?? json['dateOfBirth'])?.toString(),
      referralCode: (json['referralcode'] ?? json['referralCode'])?.toString(),
      betaCode: (json['betaCode'] ?? json['beta_code'])?.toString(),
      aboveLegalAge: _asBool(json['abovelegalage'] ?? json['aboveLegalAge']),
      termsAndConditionsAccepted: _asBool(
        json['termsandconditionsaccepted'] ??
            json['termsAndConditionsAccepted'],
      ),
      subscribedToNewsletter: _asBool(
        json['subscribedtonewsletter'] ?? json['subscribedToNewsletter'],
      ),
      profilePicture: (json['profilepicture'] ??
              json['profilePicture'] ??
              json['profile_picture'] ??
              json['avatar'] ??
              json['avatarUrl'])
          ?.toString(),
      aboutMe: (json['aboutMe'] ?? json['about_me'] ?? json['bio'])?.toString(),
      phone: json['phone']?.toString(),
      city: json['city']?.toString(),
      country: json['country']?.toString(),
      latitude: _asDouble(json['latitude']),
      longitude: _asDouble(json['longitude']),
      locationRadius: _asInt(json['locationRadius'] ?? json['location_radius']),
      toTpSecret: json['to_tp_secret']?.toString(),
      is2faEnabled: _asBool(
        json['twoFactorEnabled'] ??
            json['is_2fa_enabled'] ??
            json['is2faEnabled'],
      ),
      myReferralCode:
          (json['myReferralCode'] ?? json['my_referral_code'])?.toString(),
      qrCodeUrl: (json['qrCodeUrl'] ?? json['qr_code_url'])?.toString(),
      resetPasswordToken: json['reset_password_token']?.toString(),
      resetPasswordExpires: json['reset_password_expires']?.toString(),
      authProvider: (json['authProvider'] ?? json['auth_provider'])?.toString(),
      createdAt: (json['createdAt'] ?? json['created_at'])?.toString(),
      token: json['token']?.toString(),
      profileStatus:
          (json['profile_status'] ?? json['profileStatus'])?.toString(),
      isOnboardingCompleted: _asBool(
        json['isOnboardingCompleted'] ?? json['is_onboarding_completed'],
      ),
      emailVerified: _asBool(json['emailVerified'] ?? json['email_verified']),
      paypalMerchantId: (json['paypalMerchantId'] ??
              json['paypal_merchant_id'] ??
              json['paypalAccountId'] ??
              json['paypal_account_id'])
          ?.toString(),
      paypalConnected: _asBool(
        json['paypalConnected'] ??
            json['paypal_connected'] ??
            json['isPaypalConnected'] ??
            json['is_paypal_connected'],
      ),
      profileCompleteness: json['profileCompleteness'] is Map
          ? ProfileCompleteness.fromJson(
              (json['profileCompleteness'] as Map).cast<String, dynamic>(),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (fullname != null) 'fullName': fullname,
      if (displayName != null) 'displayName': displayName,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (gender != null) 'gender': gender?.value,
      if (language != null) 'language': language,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (referralCode != null) 'referralCode': referralCode ?? '',
      if (betaCode != null) 'betaCode': betaCode ?? '',
      if (aboveLegalAge != null) 'aboveLegalAge': aboveLegalAge,
      if (termsAndConditionsAccepted != null)
        'termsAndConditionsAccepted': termsAndConditionsAccepted,
      if (subscribedToNewsletter != null)
        'subscribedToNewsletter': subscribedToNewsletter,
      if (profilePicture != null) 'profilepicture': profilePicture,
      if (aboutMe != null) 'about_me': aboutMe,
      if (phone != null) 'phone': phone,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (locationRadius != null) 'locationRadius': locationRadius,
      if (toTpSecret != null) 'to_tp_secret': toTpSecret,
      if (is2faEnabled != null) 'twoFactorEnabled': is2faEnabled,
      if (emailVerified != null) 'emailVerified': emailVerified,
      if (paypalMerchantId != null) 'paypalMerchantId': paypalMerchantId,
      if (paypalConnected != null) 'paypalConnected': paypalConnected,
      if (profileCompleteness != null)
        'profileCompleteness': profileCompleteness!.toJson(),
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
    String? displayName,
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
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    int? locationRadius,
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
    bool? emailVerified,
    String? paypalMerchantId,
    bool? paypalConnected,
    ProfileCompleteness? profileCompleteness,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      displayName: displayName ?? this.displayName,
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
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationRadius: locationRadius ?? this.locationRadius,
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
      emailVerified: emailVerified ?? this.emailVerified,
      paypalMerchantId: paypalMerchantId ?? this.paypalMerchantId,
      paypalConnected: paypalConnected ?? this.paypalConnected,
      profileCompleteness: profileCompleteness ?? this.profileCompleteness,
    );
  }

  bool get isPayPalConnected {
    final merchantId = paypalMerchantId?.trim() ?? '';
    return paypalConnected == true || merchantId.isNotEmpty;
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
      if (displayName != null) 'displayName': displayName,
      if (username != null) 'username': username,
      if (profilePicture != null) 'avatar': profilePicture,
      if (aboutMe != null) 'bio': aboutMe,
      if (phone != null) 'phone': phone,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (locationRadius != null) 'locationRadius': locationRadius,
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

class ProfileCompleteness {
  const ProfileCompleteness({
    required this.percentage,
    this.missingFields = const [],
    this.completedFields = const [],
  });

  final int percentage;
  final List<String> missingFields;
  final List<String> completedFields;

  factory ProfileCompleteness.fromJson(Map<String, dynamic> json) {
    return ProfileCompleteness(
      percentage: _asInt(json['percentage']) ?? 0,
      missingFields:
          _asStringList(json['missingFields'] ?? json['missing_fields']),
      completedFields:
          _asStringList(json['completedFields'] ?? json['completed_fields']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'percentage': percentage,
      'missingFields': missingFields,
      'completedFields': completedFields,
    };
  }
}

bool? _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
  return null;
}

double? _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '');
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

List<String> _asStringList(dynamic value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList();
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
      isOnboardingCompleted: _asBool(
        json['isOnboardingCompleted'] ?? json['is_onboarding_completed'],
      ),
      emailVerified: _asBool(json['emailVerified'] ?? json['email_verified']),
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
