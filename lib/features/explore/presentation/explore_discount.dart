import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_shadows.dart';
import 'package:kuemele/shared/components/event_card/event_card_layout.dart';
import 'package:kuemele/features/discover/presentation/event_matched_flow.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/services/api_service/ads/ads_repo.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/kumele_video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class ExploreDiscount extends StatefulWidget {
  const ExploreDiscount({
    super.key,
  });

  @override
  State<ExploreDiscount> createState() => _ExploreDiscountState();
}

class _ExploreDiscountState extends State<ExploreDiscount> {
  AdItem? _ad;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    try {
      final location = InjectionHelper.locationCubit.state.coordinates;
      final profile = InjectionHelper.profileCubit.userData;
      final hobbyContext = await InjectionHelper.profileCubit.loadHobbyContext();
      final response = await AdsRepo.fetchAds(
        placement: 'FEED',
        locationKey: AdsRepo.locationKeyFrom(
          city: location?.city ?? profile?.city,
          country: location?.country ?? profile?.country,
        ),
        hobbyContext: hobbyContext,
      );
      final ad = response?.ads.firstOrNull;
      if (!mounted) return;
      setState(() {
        _ad = ad;
        _isLoading = false;
      });
      if (ad != null) {
        await AdsRepo.trackAd(TrackAdRequest(
          adId: ad.id,
          campaignId: ad.campaignId,
          impressionId: ad.impressionId,
          eventType: 'impression',
          placement: 'FEED',
        ));
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handlePrimaryTap() async {
    final ad = _ad;
    if (ad != null) {
      await AdsRepo.trackAd(TrackAdRequest(
        adId: ad.id,
        campaignId: ad.campaignId,
        impressionId: ad.impressionId,
        eventType: 'click',
        placement: 'FEED',
      ));
      final url = ad.resolvedDestinationUrl;
      final uri = url == null ? null : Uri.tryParse(url);
      if (uri != null) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
    if (!mounted) return;
    context.pop();
    if (ad == null) EventMatchedFlow.show(context);
  }

  void _handleClose() {
    InjectionHelper.snackBar
        .showSuccess(AppLocalizations.of(context)!.exploreDiscountDeclineMessage);
    context.pop();
  }

  String _fallbackCtaLabel(String destinationType) {
    switch (destinationType.toLowerCase()) {
      case 'app_install':
      case 'appinstall':
        return 'Install now';
      default:
        return AppLocalizations.of(context)!.openLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          constraints:
              BoxConstraints(maxHeight: AppDialogSize.maxHeightFor(context)),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 280,
                  child: Center(child: CircularProgressIndicator()),
                )
              : SingleChildScrollView(child: mainView()),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: _handleClose,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget mainView() {
    final ad = _ad;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ad?.mediaUrl != null)
          SizedBox(
            width: double.infinity,
            height: 220,
            child: ad!.mediaType.toLowerCase() == 'video'
                ? KumeleVideoPlayer(
                    videoPath: ad.mediaUrl!,
                    isNetwork: true,
                    fit: BoxFit.cover,
                  )
                : KumeleAssetWidget(
                    assetPath: ad.mediaUrl!,
                    fit: BoxFit.cover,
                  ),
          )
        else
          Container(
            width: double.infinity,
            height: 220,
            color: const Color(0xFFF2F2F2),
            alignment: Alignment.center,
            child: Image.asset('assets/logo/kumele_logo.png', height: 72),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      ad?.title ??
                          AppLocalizations.of(context)!
                              .exploreDiscountNoOfferTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  const Gap(12),
                  GestureDetector(
                    onTap: _handlePrimaryTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        ad == null
                            ? AppLocalizations.of(context)!.continueLabel
                            : ad.resolvedCtaLabel(_fallbackCtaLabel),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                ad?.body ??
                    AppLocalizations.of(context)!
                        .exploreDiscountCheckBackLaterMessage,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A4A4A),
                  height: 1.4,
                ),
              ),
              if (ad?.secondaryLinkUrl != null) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    final uri = Uri.tryParse(ad!.secondaryLinkUrl!);
                    if (uri != null) {
                      launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Text(
                    ad!.secondaryLinkUrl!,
                    style: TextStyle(
                      fontSize: 13,
                      color: ColorSet.specialBlueColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class ExploreFeedAdCard extends StatefulWidget {
  const ExploreFeedAdCard({
    super.key,
    required this.ad,
    required this.fallback,
  });

  final AdItem? ad;
  final Widget fallback;

  @override
  State<ExploreFeedAdCard> createState() => _ExploreFeedAdCardState();
}

class _ExploreFeedAdCardState extends State<ExploreFeedAdCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ExploreFeedAdCard oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _openAd() async {
    final ad = widget.ad;
    if (ad == null) return;

    await AdsRepo.trackAd(TrackAdRequest(
      adId: ad.id,
      campaignId: ad.campaignId,
      impressionId: ad.impressionId,
      eventType: 'click',
      placement: 'HOME',
    ));

    final url = ad.resolvedDestinationUrl;
    final uri = url == null ? null : Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openSecondaryLink() async {
    final url = widget.ad?.secondaryLinkUrl;
    final uri = url == null ? null : Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ad = widget.ad;
    if (ad == null || ad.mediaUrl == null) {
      return widget.fallback;
    }

    final responsive = context.responsive;
    final layout = EventCardLayout(responsive);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(layout.borderRadius),
        onTap: _openAd,
        child: Container(
          decoration: BoxDecoration(boxShadow: AppShadows.card),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(layout.borderRadius),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ad.mediaType.toLowerCase() == 'video'
                      ? KumeleVideoPlayer(
                          videoPath: ad.mediaUrl!,
                          isNetwork: true,
                          fit: BoxFit.cover,
                          muted: true,
                          loop: true,
                        )
                      : KumeleAssetWidget(
                          assetPath: ad.mediaUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Expanded(
                  flex: 1,
                  child: ColoredBox(
                    color: ColorSet.bg2Color,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: layout.contentPaddingV,
                        horizontal: layout.contentPaddingH,
                      ),
                      child: _ExploreFeedAdContent(
                        ad: ad,
                        onSecondaryLinkTap: _openSecondaryLink,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExploreFeedAdContent extends StatelessWidget {
  const _ExploreFeedAdContent({
    required this.ad,
    required this.onSecondaryLinkTap,
  });

  final AdItem ad;
  final VoidCallback onSecondaryLinkTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final title = ad.title.trim();
    final body = ad.body?.trim() ?? '';
    final secondaryLink = ad.secondaryLinkUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyLargeBold.copyWith(
            color: ColorSet.textColor,
          ),
        ),
        if (body.isNotEmpty) ...[
          Gap(responsive.h(8)),
          Expanded(
            child: Text(
              body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall.copyWith(
                color: ColorSet.textColor,
              ),
            ),
          ),
        ],
        if (secondaryLink != null) ...[
          Gap(responsive.h(4)),
          GestureDetector(
            onTap: onSecondaryLinkTap,
            child: Text(
              secondaryLink,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall.copyWith(
                color: ColorSet.textColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
