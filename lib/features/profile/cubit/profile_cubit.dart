import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/features/profile/cubit/profile_state.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/entities/hobby_interest.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/entities/user_hobby_preference.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/models/event_category.dart';
import 'package:kuemele/shared/models/referral_info.dart';
import 'package:kuemele/shared/models/user_qr_code_info.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/localization/localization_repo.dart';
import 'package:kuemele/shared/services/api_service/profile/profile_repo.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';

export 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState.init);
  int count = 0;
  UserModel? userData;
  ReferralInfo? referralInfo;
  UserNotification? userNotification;
  UserQrCodeInfo? qrCodeInfo;
  List<EventCategory> eventCategories = [];
  AdaptiveThemeMode currentThemeMode = AdaptiveThemeMode.system;
  List<SubscriptionTier> subscriptionTiers = [];
  SubscriptionStatus? subscriptionStatus;

  /// The current user's effective subscription perks. Prefers matching
  /// [SubscriptionStatus.tierId]/[tierName] against the fetched
  /// [subscriptionTiers] list, since the status API's own embedded
  /// entitlements have been observed to be a partial subset (e.g. missing
  /// adFree). Falls back to that partial subset only if no tier matches,
  /// and to [SubscriptionEntitlements.none] for unsubscribed/unauthenticated
  /// users, so feature gates can read this unconditionally.
  SubscriptionEntitlements get entitlements {
    final status = subscriptionStatus;
    if (status == null || !status.isActive) return SubscriptionEntitlements.none;

    for (final tier in subscriptionTiers) {
      if (status.matchesTier(tier)) return tier.entitlements;
    }
    return status.entitlements ?? SubscriptionEntitlements.none;
  }

  bool get isDark {
    return switch (currentThemeMode) {
      AdaptiveThemeMode.dark => true,
      AdaptiveThemeMode.light => false,
      AdaptiveThemeMode.system =>
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark,
    };
  }

  List<String> languages = [
    'English',
    'French',
    'Spanish',
    'Chinese',
    'Arabic',
    'German',
  ];

  void switchTheme() {
    currentThemeMode =
        isDark ? AdaptiveThemeMode.light : AdaptiveThemeMode.dark;
    final context = InjectionHelper.navKey.currentContext!;
    if (currentThemeMode == AdaptiveThemeMode.dark) {
      AdaptiveTheme.of(context).setDark();
    } else if (currentThemeMode == AdaptiveThemeMode.light) {
      AdaptiveTheme.of(context).setLight();
    } else {
      AdaptiveTheme.of(context).setSystem();
    }
    safeEmit(ProfileState.loaded(count++));
  }

  void reload() => unawaited(refreshUserSession());

  Future<void> loadAuthenticatedSession() async {
    await Future.wait([
      loadUserData(),
      loadUserNotification(),
      loadEventCategories(),
      loadReferralInfo(),
      loadSubscriptionInfo(),
    ]);
    await loadUserQrCode();
  }

  Future<void> refreshUserSession() async {
    await Future.wait([
      loadUserData(),
      loadUserNotification(),
      loadReferralInfo(),
      loadSubscriptionInfo(),
    ]);
    await loadUserQrCode();
  }

  /// Ancillary to session load: failures are swallowed rather than surfaced
  /// as an error state, so a transient tiers/status fetch failure just falls
  /// back to [SubscriptionEntitlements.none] instead of blocking sign-in.
  Future<void> loadSubscriptionInfo() async {
    try {
      subscriptionTiers = await Web3Repo.getSubscriptionTiers();
    } catch (_) {}
    try {
      subscriptionStatus = await Web3Repo.getSubscriptionStatus();
    } catch (_) {}
    safeEmit(ProfileState.loaded(count++));
  }

  void clearReferralInfo() {
    referralInfo = null;
    qrCodeInfo = null;
  }

  Future<void> loadUserQrCode() async {
    final userId = userData?.id;
    if (userId == null) return;
    try {
      qrCodeInfo = await ProfileRepo.getUserQrCode(userId);
      safeEmit(ProfileState.loaded(count++));
    } on ApiException catch (e) {
      safeEmit(
        ProfileState.errorMessage(e.error ?? ApiErrorMessage.APP_BLOC_ERROR),
      );
    } on Exception {
      safeEmit(ProfileState.errorMessage(ApiErrorMessage.APP_UNKNOWN_ERROR));
    }
  }

  String? _hobbyContext;

  /// Comma-joined hobby names for the current user, used to target
  /// hobby-based ad/notification campaigns (`hobbyContext` query param).
  /// Cached for the session once resolved; empty string if unavailable.
  Future<String> loadHobbyContext() async {
    final cached = _hobbyContext;
    if (cached != null) return cached;

    final userId = userData?.id;
    if (userId == null || userId.isEmpty) return '';

    try {
      final hobbiesRepo = InjectionHelper.hobbiesRepository;
      final results = await Future.wait([
        hobbiesRepo.getUserHobbies(userId: userId),
        hobbiesRepo.getHobbyInterests(),
      ]);
      final preferences = results[0] as List<UserHobbyPreference>;
      final interests = results[1] as List<HobbyInterest>;
      final nameById = {for (final i in interests) i.id: i.name};
      // Matches iOS's User.hobbyContext: lowercased. The backend's
      // hobby-targeted ad campaigns match against this case-sensitively —
      // sending the names as-typed silently dropped every campaign
      // targeted by a hobby whose stored tag isn't already lowercase.
      final names = preferences
          .map((p) => nameById[p.hobbyId]?.toLowerCase())
          .whereType<String>()
          .toSet()
          .join(',');
      _hobbyContext = names;
      return names;
    } catch (_) {
      return '';
    }
  }

  void getUserData() => unawaited(loadUserData());

  Future<void> loadReferralInfo() async {
    try {
      referralInfo = await ProfileRepo.getMyReferralInfo();
      _syncReferralCodeToUserData();
      safeEmit(ProfileState.loaded(count++));
    } on ApiException catch (e) {
      safeEmit(
        ProfileState.errorMessage(e.error ?? ApiErrorMessage.APP_BLOC_ERROR),
      );
    } on Exception {
      safeEmit(ProfileState.errorMessage(ApiErrorMessage.APP_UNKNOWN_ERROR));
    }
  }

  void _syncReferralCodeToUserData() {
    final code = referralInfo?.referralCode;
    if (code != null && userData != null) {
      userData = userData!.copyWith(myReferralCode: code);
    }
  }

  Future<void> loadUserData() async {
    try {
      final value = await ProfileRepo.getUserData();
      userData = value?.data;
      _syncReferralCodeToUserData();
      safeEmit(ProfileState.loaded(count++));
    } on ApiException catch (e) {
      safeEmit(
        ProfileState.errorMessage(e.error ?? ApiErrorMessage.APP_BLOC_ERROR),
      );
    } on Exception {
      safeEmit(ProfileState.errorMessage(ApiErrorMessage.APP_UNKNOWN_ERROR));
    }
  }

  void getUserNotification() => unawaited(loadUserNotification());

  Future<void> loadUserNotification() async {
    try {
      final value = await ProfileRepo.getUserNotification();
      userNotification = value?.data ?? UserNotification();
      safeEmit(ProfileState.loaded(count++));
    } on ApiException catch (e) {
      safeEmit(
        ProfileState.errorMessage(e.error ?? ApiErrorMessage.APP_BLOC_ERROR),
      );
    } on Exception {
      safeEmit(ProfileState.errorMessage(ApiErrorMessage.APP_UNKNOWN_ERROR));
    }
  }

  void getEventCategories() => unawaited(loadEventCategories());

  Future<void> loadEventCategories() async {
    if (eventCategories.isNotEmpty) return;
    try {
      eventCategories = await ProfileRepo.getEventCategories();
      safeEmit(ProfileState.loaded(count++));
    } on ApiException catch (e) {
      safeEmit(
        ProfileState.errorMessage(e.error ?? ApiErrorMessage.APP_BLOC_ERROR),
      );
    } on Exception {
      safeEmit(ProfileState.errorMessage(ApiErrorMessage.APP_UNKNOWN_ERROR));
    }
  }

  Future<void> loadLanguages() async {
    await LocalizationRepo.getLanguageNames().then((value) {
      if (value.isNotEmpty) {
        languages = value;
        safeEmit(ProfileState.loaded(count++));
      }
    }).onError<ApiException>((e, s) {
      safeEmit(
          ProfileState.errorMessage(e.error ?? ApiErrorMessage.APP_BLOC_ERROR));
    }).onError<Exception>((e, s) {
      safeEmit(ProfileState.errorMessage(ApiErrorMessage.APP_UNKNOWN_ERROR));
    });
  }

  void updateUserNotification(
      {bool? soundNotifications, bool? emailNotifications}) {
    final updateSoundNotification =
        soundNotifications ?? userNotification?.soundNotifications ?? false;
    final updateEmailNotification =
        emailNotifications ?? userNotification?.emailNotifications ?? false;
    userNotification?.soundNotifications = updateSoundNotification;
    userNotification?.emailNotifications = updateEmailNotification;
    safeEmit(ProfileState.loaded(count++));
    ProfileRepo.updateUserNotification(
      soundNotifications: updateSoundNotification,
      emailNotifications: updateEmailNotification,
    )
        .then((value) => safeEmit(ProfileState.loaded(count++)))
        .onError<ApiException>((e, s) => safeEmit(
              ProfileState.errorMessage(
                  e.error ?? ApiErrorMessage.APP_BLOC_ERROR),
            ))
        .onError<Exception>((e, s) => safeEmit(
              ProfileState.errorMessage(ApiErrorMessage.APP_UNKNOWN_ERROR),
            ));
  }

  Future<void> updateAbout({required String about}) async {
    SmartDialog.showLoading();
    safeEmit(ProfileState.loaded(count++));
    ProfileRepo.updateUserAbout(about: about).then((value) {
      SmartDialog.dismiss();
      userData?.aboutMe = about;
      InjectionHelper.snackBar.showSuccess(value?.message ?? 'Success');
    }).onError<ApiException>((e, s) {
      SmartDialog.dismiss();
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_BLOC_ERROR);
    }).onError<Exception>((e, s) {
      SmartDialog.dismiss();
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    });
  }

  Future<void> updateProfile({required UserModel body}) async {
    SmartDialog.showLoading();
    safeEmit(ProfileState.loaded(count++));
    ProfileRepo.updateUserProfile(body: body).then((value) {
      SmartDialog.dismiss();
      userData = value?.data ?? userData;
      InjectionHelper.snackBar.showSuccess(value?.message ?? 'Success');
      safeEmit(ProfileState.loaded(count++));
    }).onError<ApiException>((e, s) {
      SmartDialog.dismiss();
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_BLOC_ERROR);
    }).onError<Exception>((e, s) {
      SmartDialog.dismiss();
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    });
  }
}
