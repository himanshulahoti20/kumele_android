import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';

class ChatMoreDialog extends StatelessWidget {
  final String eventId;

  const ChatMoreDialog({
    super.key,
    required this.eventId,
  });

  void close(BuildContext context) {
    SmartDialog.dismiss();
  }

  void openRatingPage(BuildContext context) {
    InjectionHelper.router.push(
      AppRoutes.rating,
    );
  }

  void openReportPage(BuildContext context) {
    InjectionHelper.router.push(
      AppRoutes.report,
    );
  }

  void openGuestScanPage(BuildContext context) {
    InjectionHelper.router.push(
      AppRoutes.guestScan,
      extra: eventId,
    );
  }

  @override
  Widget build(BuildContext context) {
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
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMenuItem(
          context,
          Assets.star.path,
          AppStrings.rateEvent,
          () {
            close(context);
            openRatingPage(context);
          },
          iconSize: 20,
          spacing: 14,
        ),
        _buildMenuItem(
          context,
          Assets.report.path,
          AppStrings.reportEvent,
          () {
            close(context);
            openReportPage(context);
          },
        ),
        _buildMenuItem(
          context,
          Assets.qr.path,
          AppStrings.guestScan,
          () {
            close(context);
            openGuestScanPage(context);
          },
        ),
        _buildMenuItem(
          context,
          Assets.follow.path,
          AppStrings.followHost,
          () {
            close(context);
            // BottomAlertDialog.confirm(
            //   context,
            //   DialogStyle(
            //     showData: false,
            //     height: isPortrait ? 400 : 360,
            //     width: isPortrait ? 150 : 125,
            //     topSpacer: isPortrait ? 20 : 24,
            //     iconPath: IconSet.person,
            //     title: 'Follow Host',
            //     subTitle: "Do you want to follow host?",
            //     titleWidth: isPortrait ? 200 : 250,
            //     titleFontSize: isPortrait ? 17 : 19,
            //     titleFontWeight: FontWeight.w700,
            //     afterTextFieldSpacer: isPortrait ? 40 : 44,
            //     onCancelPressed: () => context.pop(),
            //     confirmButtonText: 'Follow',
            //     confirmButtonWidth: size(52),
            //     onConfirmPressed: () => context.pop(),
            //     cancelButtonText: 'No',
            //     cancelButtonHeight: size(50),
            //     cancelButtonWidth: size(52),
            //   ),
            // );
          },
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
              style: context.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
