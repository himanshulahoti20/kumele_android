import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/chat/presentation/chat_event_actions_page.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/profile/cubit/profile_cubit.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/event_card/widgets/category_tag.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';
import 'package:kuemele/shared/widgets/app_qr_code.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class ScanQrPage extends StatefulWidget implements BasePage {
  final ExploreEventDetail? eventDetail;

  /// Tablet-only: rendered as dialog content (matches iPad's ChatQrCodeView_iPad
  /// popup card) instead of a full pushed page. False keeps the existing
  /// mobile full-page layout unchanged.
  final bool isDialog;

  const ScanQrPage({
    super.key,
    this.eventDetail,
    this.isDialog = false,
  });

  @override
  String get screenName => 'ScanQrPage';

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  @override
  void initState() {
    super.initState();
    if (InjectionHelper.profileCubit.qrCodeInfo == null) {
      InjectionHelper.profileCubit.loadUserQrCode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventDetail = widget.eventDetail;
    final title = (eventDetail?.title.trim().isNotEmpty == true)
        ? eventDetail!.title
        : '--';
    final hostName = (eventDetail?.hostName.trim().isNotEmpty == true)
        ? eventDetail!.hostName
        : '--';
    final hostAvatar =
        (eventDetail?.hostProfile.avatarUrl?.trim().isNotEmpty == true)
            ? eventDetail!.hostProfile.avatarUrl!
            : '';
    final location = (eventDetail?.displayLocation.trim().isNotEmpty == true)
        ? eventDetail!.displayLocation
        : '--';
    final category = (eventDetail?.primaryHobby.trim().isNotEmpty == true)
        ? eventDetail!.primaryHobby
        : '--';

    if (widget.isDialog) {
      return _buildDialogContent(
          context, title, hostName, hostAvatar, location, category);
    }

    return Scaffold(
      backgroundColor: ColorSet.bg3Color,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              MobileHeader(label: AppLocalizations.of(context)!.scanQr),
              const Gap(22),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildFirstColumn(context, title, hostName, hostAvatar,
                          location, category),
                      const Gap(40),
                      BlocBuilder<ProfileCubit, ProfileState>(
                        bloc: InjectionHelper.profileCubit,
                        builder: (context, state) => _buildSecondColumn(
                          context,
                          InjectionHelper.profileCubit.qrCodeInfo?.qrCodeUrl ??
                              '',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tablet-only: based on ChatQrCodeView_iPad's rounded card layout — a
  /// "Scan QR" title with a close button (spacing 45 below), then the info
  /// and QR image side by side (66pt avatar, 24pt title, theme-inverted
  /// category pill, 212pt QR code) instead of the mobile page's single
  /// stacked column. Size cap enlarged from iOS's original 600x495 per
  /// request.
  Widget _buildDialogContent(
    BuildContext context,
    String title,
    String hostName,
    String hostAvatar,
    String location,
    String category,
  ) {
    final screenSize = MediaQuery.sizeOf(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: math.min(screenSize.width - 32, 750),
        maxHeight: math.min(screenSize.height - 32, 620),
      ),
      // iOS bgColor (card surface) is Android's bg3Color — the two ColorSet
      // names are swapped between the apps.
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 45),
        decoration: BoxDecoration(
          color: ColorSet.bg3Color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(width: 40),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.scanQr,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleLargeBold
                        .copyWith(fontSize: 20, color: ColorSet.textColor),
                  ),
                ),
                AppRoundedIconButton(
                  assetPath: IconSet.closeIcon,
                  iconSize: 20,
                  semanticLabel: 'Close',
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Gap(45),
            Flexible(
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTabletInfoColumn(
                        context,
                        title,
                        hostName,
                        hostAvatar,
                        location,
                        category,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: BlocBuilder<ProfileCubit, ProfileState>(
                        bloc: InjectionHelper.profileCubit,
                        builder: (context, state) => _buildTabletQrColumn(
                          context,
                          InjectionHelper.profileCubit.qrCodeInfo
                                  ?.qrCodeUrl ??
                              '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// iOS's authBgColor/authTextColor invert with theme (black-on-white
  /// becomes white-on-black in dark mode) — unlike this app's usual tokens.
  Widget _buildTabletInfoColumn(
    BuildContext context,
    String title,
    String hostName,
    String hostAvatar,
    String location,
    String category,
  ) {
    final isDark = ColorSet.isDarkMode;
    final authBg = isDark ? Colors.white : Colors.black;
    final authText = isDark ? Colors.black : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppAvatar(
          imageUrl: hostAvatar,
          name: hostName,
          size: 66,
        ),
        const Gap(15),
        Text(
          title,
          style: context.textTheme.titleLargeBold.copyWith(
            fontSize: 24,
            color: ColorSet.textColor,
          ),
        ),
        const Gap(15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: authBg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.sell, size: 24, color: authText),
              const Gap(12),
              Text(
                category,
                style: context.textTheme.bodyMedium
                    .copyWith(fontSize: 15, color: authText),
              ),
            ],
          ),
        ),
        const Gap(15),
        RichText(
          text: TextSpan(
            style: context.textTheme.bodyMedium
                .copyWith(fontSize: 17, color: ColorSet.textColor),
            children: [
              TextSpan(text: '${AppLocalizations.of(context)!.hostedBy} '),
              TextSpan(
                text: hostName,
                style: const TextStyle(color: Color(0xFF808080)),
              ),
            ],
          ),
        ),
        if (location.isNotEmpty && location != '--') ...[
          const Gap(8),
          Text(
            location,
            style: context.textTheme.bodyMedium
                .copyWith(fontSize: 15, color: ColorSet.textColor),
          ),
        ],
        const Gap(24),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: authBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.qr_code, size: 20, color: authText),
              const Gap(8),
              Text(
                AppLocalizations.of(context)!.scanQrCode,
                style: context.textTheme.bodyMedium.copyWith(
                  color: authText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletQrColumn(BuildContext context, String qrPayload) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (qrPayload.isNotEmpty)
          AppQrCode(
            data: qrPayload,
            size: 212,
            showBorder: false,
            padding: 0,
            backgroundColor: Colors.transparent,
          )
        else
          KumeleAssetWidget(
            assetPath: IconSet.isDarkMode
                ? Assets.icons.qrDark.path
                : Assets.icons.qrPng.path,
            fit: BoxFit.contain,
            width: 212,
            height: 212,
          ),
        Text(
          AppLocalizations.of(context)!.hostQr,
          style: context.textTheme.bodyMedium
              .copyWith(fontSize: 14, color: ColorSet.textColor),
        ),
      ],
    );
  }

  Widget _buildSecondColumn(BuildContext context, String qrPayload) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (qrPayload.isNotEmpty)
          AppQrCode(
            data: qrPayload,
            size: 180,
            showBorder: false,
            padding: 0,
            backgroundColor: Colors.transparent,
          )
        else
          KumeleAssetWidget(
            assetPath: IconSet.isDarkMode
                ? Assets.icons.qrDark.path
                : Assets.icons.qrPng.path,
            fit: BoxFit.contain,
            width: 180,
            height: 180,
          ),
        const Gap(8),
        Text(
          AppLocalizations.of(context)!.hostQr,
          style:
              context.textTheme.bodyLarge.copyWith(color: ColorSet.textColor),
        ),
        const Gap(20),
      ],
    );
  }

  Widget _buildFirstColumn(
    BuildContext context,
    String title,
    String hostName,
    String hostAvatar,
    String location,
    String category,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(10),
        AppAvatar(
          imageUrl: hostAvatar,
          name: hostName,
          size: 100,
          showShadow: false,
        ),
        const Gap(10),
        Text(
          title,
          style: context.textTheme.titleLargeBold.copyWith(fontSize: 30),
          textAlign: TextAlign.center,
        ),
        const Gap(16),
        CategoryTag(label: category),
        const Gap(16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.hostedBy,
              style: context.textTheme.bodyLargeSemiBold,
            ),
            const Gap(4),
            Flexible(
              child: Text(
                hostName,
                style: context.textTheme.bodyLargeSemiBold
                    .copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
        const Gap(8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.locationLabel,
              style: context.textTheme.bodyLargeSemiBold,
            ),
            const Gap(4),
            Flexible(
              child: Text(
                location,
                style: context.textTheme.bodyLargeSemiBold
                    .copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
        const Gap(40),
        AppButton.primary(
          label: AppLocalizations.of(context)!.scanQrCode,
          iconAsset: Assets.qr.path,
          iconColor: ColorSet.bg2Color,
          foregroundColor: ColorSet.bg2Color,
          onPressed: widget.eventDetail == null
              ? null
              : () => InjectionHelper.router.push(
                    AppRoutes.guestScan,
                    extra: ChatEventActionsRouteArgs(
                      initialTab: ChatEventActionTab.guestScan,
                      eventId: widget.eventDetail!.id,
                    ),
                  ),
        ),
      ],
    );
  }
}
