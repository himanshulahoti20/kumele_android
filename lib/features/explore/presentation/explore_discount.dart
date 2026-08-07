import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_shadows.dart';
import 'package:kuemele/shared/components/flip.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/components/event_card/event_card_layout.dart';
import 'package:kuemele/features/discover/presentation/event_matched_flow.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/services/api_service/ads/ads_repo.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ExploreDiscount extends StatefulWidget {
  const ExploreDiscount({
    super.key,
  });

  @override
  State<ExploreDiscount> createState() => _ExploreDiscountState();
}

class _ExploreDiscountState extends State<ExploreDiscount> {
  final ScrollController _controller = ScrollController();
  AdItem? _ad;
  bool expanded = true;
  bool _isContainerVisible = false;
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
      final response = await AdsRepo.fetchAds(
        placement: 'FEED',
        locationKey: AdsRepo.locationKeyFrom(
          city: location?.city ?? profile?.city,
          country: location?.country ?? profile?.country,
        ),
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
          eventType: 'impression',
          placement: 'FEED',
        ));
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _toggleContainerVisibility() {
    setState(() {
      _isContainerVisible = !_isContainerVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollDialog(
      footer: Container(
        color: ColorSet.bgColor,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                InjectionHelper.snackBar
                    .showSuccess(AppLocalizations.of(context)!.exploreDiscountDeclineMessage);
              },
              child: Container(
                height: size(50),
                width: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorSet.revertBgColor),
                  color: ColorSet.bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(AppLocalizations.of(context)!.cancel,
                      style: context.textTheme.bodyLarge
                          .copyWith(color: ColorSet.revertBgColor)),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final ad = _ad;
                if (ad != null) {
                  await AdsRepo.trackAd(TrackAdRequest(
                    adId: ad.id,
                    eventType: 'click',
                    placement: 'FEED',
                  ));
                  final url = ad.destinationUrl;
                  final uri = url == null ? null : Uri.tryParse(url);
                  if (uri != null) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
                if (!context.mounted) return;
                context.pop();
                if (ad == null) EventMatchedFlow.show(context);
              },
              child: Container(
                height: size(50),
                width: 250,
                decoration: BoxDecoration(
                  color: ColorSet.revbg3Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                      _ad == null
                          ? AppLocalizations.of(context)!.continueLabel
                          : AppLocalizations.of(context)!.openLabel,
                      style: context.textTheme.bodyLarge
                          .copyWith(color: ColorSet.bg2Color)),
                ),
              ),
            ),
          ],
        ),
      ),
      child: mainView(),
    );
  }

  Widget mainView() {
    final ad = _ad;
    if (_isLoading) {
      return const SizedBox(
        height: 280,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ad?.mediaUrl != null)
          KumeleAssetWidget(
            assetPath: ad!.mediaUrl!,
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          )
        else
          Container(
            width: double.infinity,
            height: 220,
            color: ColorSet.bg2Color,
            alignment: Alignment.center,
            child: Image.asset('assets/logo/kumele_logo.png', height: 72),
          ),
        Gap(20),
        Row(
          children: [
            Expanded(
              child: Text(
                  ad?.title ??
                      AppLocalizations.of(context)!.exploreDiscountNoOfferTitle,
                  style: context.textTheme.headlineSmallBold
                      .copyWith(fontSize: 26, fontWeight: FontWeight.w700)),
            ),
            Spacer(),
            GestureDetector(
              onTap: _toggleContainerVisibility,
              child: Visibility(
                visible: !_isContainerVisible,
                child: Container(
                  height: size(40),
                  width: sizeW(40),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorSet.bgColor,
                    borderRadius: BorderRadius.circular(size(100)),
                  ),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: KumeleAssetWidget(
                        assetPath: SVGAsset.icon_arrow,
                        color: ColorSet.revbg3Color),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: size(3)),
        Visibility(
          visible: !_isContainerVisible, // Hide text when container is visible
          child: Text(
              ad?.body ??
                  AppLocalizations.of(context)!
                      .exploreDiscountCheckBackLaterMessage,
              style: context.textTheme.bodyMedium
                  .copyWith(color: ColorSet.textColor)),
        ),
        SizedBox(height: size(20)),
        Visibility(
          visible: _isContainerVisible,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  ad?.body ??
                      AppLocalizations.of(context)!
                          .exploreDiscountNoAdDetailsMessage,
                  style: context.textTheme.bodySmall.copyWith(fontSize: 13),
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.visible),
              SizedBox(height: size(12)),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorSet.homeMainCardColor,
                      borderRadius: BorderRadius.circular(size(10)),
                    ),
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.fromLTRB(15, 40, 15, 21),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "${ad?.title ?? AppLocalizations.of(context)!.exploreDiscountOfferFallback}: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorSet.textColor,
                              fontSize: size(12),
                            ),
                          ),
                          TextSpan(
                            text:
                                "\n\n${ad?.body ?? AppLocalizations.of(context)!.exploreDiscountNoAdDetailsMessage}",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: size(13),
                              color: ColorSet.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (ad?.mediaUrl != null)
                    KumeleAssetWidget(
                      assetPath: ad!.mediaUrl!,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget expandButton() {
    return Flip(
      isFlipped: expanded,
      child: GestureDetector(
        onTap: () {
          setState(() {
            expanded = !expanded;
            _controller.animateTo(
              _controller.position.maxScrollExtent,
              duration: const Duration(seconds: 1),
              curve: Curves.bounceOut,
            );
          });
        },
        child: Container(
          height: size(40),
          width: sizeW(40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size(40)),
            color: ColorSet.homeMainCardArrowBG,
          ),
          child: Image.asset(
            IconSet.expandArrowIcon,
            height: size(20),
            width: sizeW(20),
          ),
        ),
      ),
    );
  }
}

class ExploreFeedAdCard extends StatefulWidget {
  const ExploreFeedAdCard({
    super.key,
    required this.fallback,
  });

  final Widget fallback;

  @override
  State<ExploreFeedAdCard> createState() => _ExploreFeedAdCardState();
}

class _ExploreFeedAdCardState extends State<ExploreFeedAdCard> {
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
      final response = await AdsRepo.fetchAds(
        placement: 'FEED',
        locationKey: AdsRepo.locationKeyFrom(
          city: location?.city ?? profile?.city,
          country: location?.country ?? profile?.country,
        ),
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
          eventType: 'impression',
          placement: 'FEED',
        ));
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openAd() async {
    final ad = _ad;
    if (ad == null) return;

    await AdsRepo.trackAd(TrackAdRequest(
      adId: ad.id,
      eventType: 'click',
      placement: 'FEED',
    ));

    final url = ad.destinationUrl;
    final uri = url == null ? null : Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (_isLoading || ad == null || ad.mediaUrl == null) {
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
                  child: KumeleAssetWidget(
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
                      child: _ExploreFeedAdContent(ad: ad),
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
  });

  final AdItem ad;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final title = ad.title.trim();
    final body = ad.body?.trim() ?? '';

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
      ],
    );
  }
}
