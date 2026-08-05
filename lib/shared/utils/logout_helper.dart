// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/authen/authen_repo.dart';

class LogoutHelper {
  static void handleLogout({BuildContext? context}) {
    if (!ApiService.hasToken()) return;
    InjectionHelper.authStorage.clear();
    ApiService.clearToken();
    InjectionHelper.profileCubit.clearReferralInfo();
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
  }) async {
    await AuthenRepo.logout().then((message) {
      if (showSuccessMessage) {
        InjectionHelper.snackBar.showSuccess(
          message ?? AppStrings.signOutSuccessMessage,
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
