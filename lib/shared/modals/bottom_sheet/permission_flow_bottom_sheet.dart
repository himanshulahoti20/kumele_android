import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/services/notification_service.dart';

/// Sequential Notification -> Photo -> Location permission primer sheets,
/// shown once per app session right after a successful login.
class PermissionFlowSheet {
  PermissionFlowSheet._();

  static bool _shownThisSession = false;

  static Future<void> showIfNeeded() async {
    if (_shownThisSession) return;
    _shownThisSession = true;

    await _step(
      icon: IconSet.notificationsIcon,
      title: '"Kumele" Would Like to Send You Push Notifications',
      message: 'Notifications may include alerts, sounds and icon badges. '
          'These can be configured in Settings.',
      buttons: {
        "Don't Allow": null,
        'Allow': NotificationService.requestPermission,
      },
    );

    await _step(
      icon: IconSet.photographyIcon,
      title: '"Kumele" Would to Access Your Photos',
      message:
          'Allow "Kumele" to access your photos to send images or videos',
      buttons: {
        'Select Photos...': _requestPhotoAccess,
        'Allow Access to All Photos': _requestPhotoAccess,
        "Don't Allow": null,
      },
    );

    await _step(
      icon: IconSet.location,
      title: 'Allow "Kumele" to access your location?',
      message:
          'Allow "Kumele" to access your photos to send images or videos',
      buttons: {
        'Allow While Using App': _requestLocationAccess,
        'Allow Once': _requestLocationAccess,
        "Don't Allow": null,
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
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final action = await AppBottomSheet.show<Future<void> Function()?>(
      context: context,
      isDismissible: false,
      dragToClose: false,
      showDragHandle: false,
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
