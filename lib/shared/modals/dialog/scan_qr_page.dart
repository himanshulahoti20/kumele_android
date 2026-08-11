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
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class ScanQrPage extends StatefulWidget implements BasePage {
  final ExploreEventDetail? eventDetail;

  const ScanQrPage({
    super.key,
    this.eventDetail,
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
