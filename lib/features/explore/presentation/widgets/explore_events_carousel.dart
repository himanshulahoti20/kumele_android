import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/features/explore/presentation/explore_discount.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_event_card_builder.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_section_header.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/services/ads/ad_units.dart';
import 'package:kuemele/shared/services/ads/kumele_native_ad_widget.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class ExploreEventsCarousel extends StatelessWidget {
  const ExploreEventsCarousel({
    super.key,
    required this.events,
    required this.scrollController,
    this.feedAd,
    this.title = 'Hobby events in your location',
  });

  final List<ExploreEventItem> events;
  final ScrollController scrollController;
  final AdItem? feedAd;
  final String title;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    // Empty state reuses ExploreEventGridSection's exact structure (header
    // padding, ExploreSectionSpacer gap, same fromLTRB(20,4,20,20) text
    // padding, same default container padding) so this section, Matched
    // Event and Created Event all come out to the same height when empty —
    // they'd otherwise drift out of sync since this section's loaded state
    // uses its own compact title + no-bottom-padding layout for the cards.
    return ExploreSectionContainer(
      padding: events.isEmpty
          ? const EdgeInsets.only(top: 15, bottom: 35)
          : const EdgeInsets.only(top: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExploreSectionTitle(title: title),
          if (events.isEmpty) ...[
            const ExploreSectionSpacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Text(
                'No events found in your location.',
                style: TextStyle(
                  color: ColorSet.subTextColor,
                  fontSize: 14,
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final itemToShow = responsive.gridColumns;
                final cardWidth =
                    (width - (ExploreConfig.cardSpacing * (itemToShow - 1))) /
                        itemToShow;
                final sectionHeight = cardWidth / 0.72;

                if (events.isEmpty) {
                  return const SizedBox.shrink();
                }

                return ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                    height: sectionHeight,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ListView.separated(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        separatorBuilder: (_, __) =>
                            Gap(ExploreConfig.cardSpacing),
                        itemBuilder: (context, index) {
                          final event = events[index];
                          final eventCard =
                              ExploreEventCardBuilder.fromItem(event, index);
                          return Padding(
                            padding: const EdgeInsets.only(top: 28, bottom: 32),
                            child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                width: cardWidth,
                              ),
                              child: index == 2 && feedAd != null
                                  ? KumeleNativeAdWidget(
                                      adUnitId: KumeleAdUnits.localEvents,
                                      factoryId:
                                          KumeleAdUnits.localEventsAdFactoryId,
                                      fallback: ExploreFeedAdCard(
                                        ad: feedAd,
                                        fallback: eventCard,
                                      ),
                                    )
                                  : eventCard,
                            ),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _CarouselArrow(
                            isPrevious: true,
                            cardWidth: cardWidth,
                            scrollController: scrollController,
                          ),
                          _CarouselArrow(
                            isPrevious: false,
                            cardWidth: cardWidth,
                            scrollController: scrollController,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselArrow extends StatelessWidget {
  const _CarouselArrow({
    required this.isPrevious,
    required this.cardWidth,
    required this.scrollController,
  });

  final bool isPrevious;
  final double cardWidth;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final space = cardWidth + ExploreConfig.cardSpacing;
        scrollController.animateTo(
          scrollController.offset + (isPrevious ? -space : space),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: ColorSet.bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ColorSet.revertBgColor.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: KumeleAssetWidget.square(
          assetPath: isPrevious
              ? Assets.icons.arrowleft.path
              : Assets.icons.arrowRight.path,
          size: 20,
        ),
      ),
    );
  }
}
