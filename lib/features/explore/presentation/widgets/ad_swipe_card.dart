import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/modals/dialog/ad_tap_through_dialog.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/services/api_service/ads/ads_repo.dart';
import 'package:kuemele/shared/widgets/ad_media_carousel.dart';

/// An advert card inside the event swipe deck — mirrors iOS's `AdSwipeCardView`:
/// media with a "Sponsored" pill, title + outlined CTA, one-line body and an
/// expand chevron. Swiping right/left is tracked by the deck as positive/negative.
class AdSwipeCard extends StatefulWidget {
  const AdSwipeCard({
    super.key,
    required this.ad,
    required this.isExpanded,
    required this.onToggleExpand,
    this.bgColor,
  });

  final AdItem ad;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final Color? bgColor;

  @override
  State<AdSwipeCard> createState() => _AdSwipeCardState();
}

class _AdSwipeCardState extends State<AdSwipeCard> {
  @override
  void initState() {
    super.initState();
    // Counted once the card is on screen; AdsRepo dedupes per impression.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      AdsRepo.trackAd(TrackAdRequest(
        adId: widget.ad.id,
        campaignId: widget.ad.campaignId,
        impressionId: widget.ad.impressionId,
        eventType: 'view',
        placement: 'HOME',
      ));
    });
  }

  Future<void> _openAd() async {
    final ad = widget.ad;
    try {
      await AdsRepo.trackAd(TrackAdRequest(
        adId: ad.id,
        campaignId: ad.campaignId,
        impressionId: ad.impressionId,
        eventType: 'click',
        placement: 'HOME',
      ));
    } catch (_) {}
    if (!mounted) return;
    await AppDialog.show(
      context: context,
      width: AppDialogSize.notificationModalWidthFor(context),
      dialog: AdTapThroughDialog(ad: ad),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ad = widget.ad;
    final body = ad.body?.trim() ?? '';
    final ctaLabel = ad.resolvedCtaLabel(
      (type) => switch (type.toLowerCase()) {
        'event' => 'View event',
        'blog' => 'Read more',
        _ => 'Learn more',
      },
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: ColoredBox(
        color: widget.bgColor ?? ColorSet.bg2Color,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AdMediaCarousel(ad: ad),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1F1F1F),
                          borderRadius: BorderRadius.all(Radius.circular(999)),
                        ),
                        child: Text(
                          'Sponsored',
                          style: context.textTheme.bodyMediumBold.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            ad.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyLargeBold.copyWith(
                              color: ColorSet.textColor,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _openAd,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: ColorSet.textColor),
                            ),
                            child: Text(
                              ctaLabel,
                              maxLines: 1,
                              style: context.textTheme.bodyMediumBold.copyWith(
                                color: ColorSet.textColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            body,
                            maxLines: widget.isExpanded ? 6 : 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium.copyWith(
                              color: ColorSet.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onToggleExpand,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              widget.isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: ColorSet.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.isExpanded) ...[
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _openAd,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: ColorSet.textColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ctaLabel,
                            style: context.textTheme.bodyMediumBold.copyWith(
                              color: ColorSet.bgColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
