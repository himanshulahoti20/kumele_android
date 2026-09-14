import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/features/chat/presentation/chat_event_actions_page.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';

class ChatMoreDialog extends StatelessWidget {
  final String eventId;
  final String hostId;

  /// Tablet-only: rendered as a centered popup card matching iPad's
  /// MenuChatView (420x326, larger rows, close button) instead of the
  /// phone's small anchored dropdown menu.
  final bool isTabletPopup;

  const ChatMoreDialog({
    super.key,
    required this.eventId,
    required this.hostId,
    this.isTabletPopup = false,
  });

  void close(BuildContext context) {
    if (isTabletPopup) {
      Navigator.of(context).pop();
      return;
    }
    SmartDialog.dismiss();
  }

  void openRatingPage(BuildContext context) {
    InjectionHelper.router.push(
      AppRoutes.rating,
      extra: ChatEventActionsRouteArgs(eventId: eventId),
    );
  }

  void openReportPage(BuildContext context) {
    InjectionHelper.router.push(
      AppRoutes.report,
      extra: ChatEventActionsRouteArgs(
        initialTab: ChatEventActionTab.report,
        eventId: eventId,
      ),
    );
  }

  void openGuestScanPage(BuildContext context) {
    InjectionHelper.router.push(
      AppRoutes.guestScan,
      extra: ChatEventActionsRouteArgs(
        initialTab: ChatEventActionTab.guestScan,
        eventId: eventId,
      ),
    );
  }

  Future<void> _confirmFollowHost(BuildContext context) async {
    await AppDialog.confirm<void>(
      context: context,
      width: AppDialogSize.widthFor(context),
      title: AppLocalizations.of(context)!.followHost,
      svgIcon: Assets.follow.path,
      content: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          AppLocalizations.of(context)!.followHostConfirmMessage,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium,
        ),
      ),
      cancelText: AppLocalizations.of(context)!.no,
      confirmText: AppLocalizations.of(context)!.followHostConfirmButton,
      onConfirmAsync: () => _followHost(context),
    );
  }

  Future<void> _followHost(BuildContext context) async {
    try {
      await InjectionHelper.connectionsRepository.follow(userId: hostId);
      InjectionHelper.snackBar
          .showSuccess(AppLocalizations.of(context)!.followHostSuccessMessage);
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isTabletPopup) {
      return SizedBox(
        width: 420,
        height: 326,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              // iOS MenuChatView's card is "bgColor", which is Android's
              // bg3Color (the two ColorSet names are swapped between apps).
              decoration: BoxDecoration(
                color: ColorSet.bg3Color,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              alignment: Alignment.center,
              child: buildContent(context),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: InkWell(
                onTap: () => close(context),
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.close),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: ColorSet.bg3Color,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: buildContent(context),
    );
  }

  Column buildContent(BuildContext context) {
    final iconSize = isTabletPopup ? 38.0 : 24.0;
    const spacing = 10.0;
    final textStyle = isTabletPopup
        ? context.textTheme.bodyLarge.copyWith(fontSize: 25)
        : context.textTheme.bodyLarge;

    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMenuItem(
          context,
          Assets.star.path,
          AppLocalizations.of(context)!.rateEvent,
          () {
            close(context);
            openRatingPage(context);
          },
          iconSize: isTabletPopup ? iconSize : 20,
          spacing: isTabletPopup ? spacing : 14,
          textStyle: textStyle,
        ),
        _buildMenuItem(
          context,
          Assets.report.path,
          AppLocalizations.of(context)!.reportEvent,
          () {
            close(context);
            openReportPage(context);
          },
          iconSize: iconSize,
          spacing: spacing,
          textStyle: textStyle,
        ),
        _buildMenuItem(
          context,
          Assets.qr.path,
          AppLocalizations.of(context)!.guestScan,
          () {
            close(context);
            openGuestScanPage(context);
          },
          iconSize: iconSize,
          spacing: spacing,
          textStyle: textStyle,
        ),
        _buildMenuItem(
          context,
          Assets.follow.path,
          AppLocalizations.of(context)!.followHost,
          () {
            close(context);
            _confirmFollowHost(context);
          },
          iconSize: iconSize,
          spacing: spacing,
          textStyle: textStyle,
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String iconPath,
    String text,
    VoidCallback onTap, {
    double iconSize = 24,
    double spacing = 10,
    TextStyle? textStyle,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            KumeleAssetWidget(
              assetPath: iconPath,
              color: ColorSet.revbg3Color,
              width: iconSize,
              height: iconSize,
            ),
            Gap(spacing),
            Text(
              text,
              style: textStyle ?? context.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
