import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/features/profile/cubit/profile_state.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/models/event_category.dart';
import 'package:kuemele/shared/models/referral_info.dart';
import 'package:kuemele/shared/models/user_qr_code_info.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/localization/localization_repo.dart';
import 'package:kuemele/shared/services/api_service/profile/profile_repo.dart';

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
    ]);
    await loadUserQrCode();
  }

  Future<void> refreshUserSession() async {
    await Future.wait([
      loadUserData(),
      loadUserNotification(),
      loadReferralInfo(),
    ]);
    await loadUserQrCode();
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
