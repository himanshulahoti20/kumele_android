// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/authen/authen_repo.dart';
import 'package:kuemele/shared/services/notification_service.dart';
import 'package:kuemele/shared/utils/storage_util.dart';

class LogoutHelper {
  static void handleLogout({BuildContext? context}) {
    if (!ApiService.hasToken()) return;
    InjectionHelper.authStorage.clear();
    ApiService.clearToken();
    InjectionHelper.profileCubit.clearReferralInfo();
    NotificationService.clearTokenRegistration();
    // Once-per-login popups — the next login should see them again.
    StorageUtil.deleteItem(StorageKey.WHAT_WOULD_YOU_LIKE_SHOWN);
    BuildContext? usingContext =
        context ?? InjectionHelper.navKey.currentContext;
    if (usingContext != null) {
      InjectionHelper.homePageCubit.onTapTab(usingContext, HomeTabType.home);
      usingContext.go(AppRoutes.signin);
    }
  }

  static Future<void> doLogout(
    BuildContext? context, {
    bool showSuccessMessage = true,
    bool allDevices = false,
  }) async {
    final logoutCall =
        allDevices ? AuthenRepo.logoutAll() : AuthenRepo.logout();
    await logoutCall.then((message) {
      if (showSuccessMessage) {
        InjectionHelper.snackBar.showSuccess(
          message ?? AppLocalizationsEn().signOutSuccessMessage,
        );
      }
      handleLogout(context: context);
    }).onError<ApiException>((e, s) {
      if (e.statusCode == ApiStatusCode.Unauthorized ||
          e.statusCode == ApiStatusCode.InternalServerError ||
          e.statusCode == ApiStatusCode.NotFound) {
        handleLogout(context: context);
      } else {
        InjectionHelper.snackBar
            .show(e.error ?? ApiErrorMessage.APP_BLOC_ERROR);
      }
    }).onError<Exception>((e, s) {
      InjectionHelper.snackBar.show(ApiErrorMessage.APP_UNKNOWN_ERROR);
    });
  }
}
