import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/modals/dialog/notification_popups.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/services/notification_service.dart';
import 'package:kuemele/shared/utils/storage_util.dart';
import 'package:kuemele/l10n/app_localizations.dart';

/// Sequential Notification -> Photo -> Location permission primer sheets,
/// shown once per install, the first time the user lands on the login
/// (Signin) screen. This is the only place these three permissions are
/// requested — see signin_page.dart's initState.
class PermissionFlowSheet {
  PermissionFlowSheet._();

  static bool _shownThisSession = false;

  static Future<void> showIfNeeded() async {
    if (_shownThisSession) return;
    _shownThisSession = true;

    final alreadyShown =
        await StorageUtil.retrieveItem(StorageKey.PERMISSION_PRIMER_SHOWN);
    if (alreadyShown == true) return;

    // ignore: use_build_context_synchronously
    final context = navigatorKey.currentContext;
    // ignore: use_build_context_synchronously
    final l10n = context == null ? null : AppLocalizations.of(context);
    if (l10n == null) {
      _shownThisSession = false;
      return;
    }
    await StorageUtil.storeItem(StorageKey.PERMISSION_PRIMER_SHOWN, true);

    await _step(
      icon: IconSet.notificationsIcon,
      title: l10n.permissionNotificationPrimerTitle,
      message: l10n.permissionNotificationPrimerMessage,
      buttons: {
        l10n.permissionDontAllow: null,
        l10n.permissionAllow: NotificationService.requestPermission,
      },
    );

    await _step(
      icon: IconSet.photographyIcon,
      title: l10n.permissionPhotosPrimerTitle,
      message: l10n.permissionPhotosPrimerMessage,
      buttons: {
        l10n.permissionSelectPhotos: _requestPhotoAccess,
        l10n.permissionAllowAllPhotos: _requestPhotoAccess,
        l10n.permissionDontAllow: null,
      },
    );

    await _step(
      icon: IconSet.location,
      title: l10n.permissionLocationPrimerTitle,
      message: l10n.permissionLocationPrimerMessage,
      buttons: {
        l10n.permissionAllowWhileUsingApp: _requestLocationAccess,
        l10n.permissionAllowOnce: _requestLocationAccess,
        l10n.permissionDontAllow: null,
      },
    );
  }

  static Future<void> _requestPhotoAccess() async {
    await [ph.Permission.photos, ph.Permission.storage].request();
  }

  static Future<void> _requestLocationAccess() {
    return InjectionHelper.locationCubit.requestLocation();
  }

  static Future<void> _step({
    required String icon,
    required String title,
    required String message,
    required Map<String, Future<void> Function()?> buttons,
  }) async {
    // ignore: use_build_context_synchronously
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // iPad (PermissionAlert.swift): centered card over a flat scrim, not a
    // bottom sheet.
    if (FormFactor.isTablet) {
      final action = await AppDialog.show<Future<void> Function()?>(
        context: context,
        width: AppDialogSize.notificationModalWidthFor(context),
        barrierColor: ColorSet.scrimFlat,
        barrierDismissible: false,
        dialog: ModalSheetCard(
          padding: 26,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(icon, width: 22, height: 22),
                  const Gap(16),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyLarge.copyWith(
                        color: ColorSet.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Gap(16),
                  GestureDetector(
                    onTap: () => Navigator.of(context, rootNavigator: true).pop(),
                    child: Image.asset(IconSet.closeIcon, width: 24, height: 24),
                  ),
                ],
              ),
              const Gap(8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge.copyWith(
                  color: ColorSet.textColor,
                  fontSize: 14,
                ),
              ),
              const Gap(40),
              for (final (i, entry) in buttons.entries.indexed) ...[
                if (i > 0) const Gap(5),
                GestureDetector(
                  onTap: () => Navigator.of(context, rootNavigator: true)
                      .pop(entry.value),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 38,
                      vertical: 15,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ColorSet.textColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      entry.key,
                      style: context.textTheme.bodyLarge.copyWith(
                        color: ColorSet.bg2Color,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
      await action?.call();
      return;
    }

    final action = await AppBottomSheet.show<Future<void> Function()?>(
      context: context,
      isDismissible: false,
      dragToClose: false,
      showDragHandle: false,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      titleWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon, width: 22, height: 22),
          const Gap(10),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMediumSemiBold.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      subtitle: message,
      children: [
        for (final entry in buttons.entries) ...[
          AppButton.primary(
            label: entry.key,
            backgroundColor: ColorSet.revertBgColor,
            foregroundColor: ColorSet.bg3Color,
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(entry.value),
          ),
          const Gap(5),
        ],
      ],
    );

    await action?.call();
  }
}
