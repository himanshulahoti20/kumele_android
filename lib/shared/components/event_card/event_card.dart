import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/presentation/explore_discount.dart';
import 'package:kuemele/features/explore/presentation/explorepreview.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_shadows.dart';
import 'package:kuemele/shared/components/event_card/event_card_layout.dart';
import 'package:kuemele/shared/components/event_card/widgets/category_tag.dart';
import 'package:kuemele/shared/components/event_card/widgets/event_card_cancel_button.dart';
import 'package:kuemele/shared/components/event_card/widgets/event_card_delete_overlay.dart';
import 'package:kuemele/shared/components/event_card/widgets/event_card_info_row.dart';
import 'package:kuemele/shared/components/event_card/widgets/event_card_start_time_row.dart';
import 'package:kuemele/shared/components/event_card/widgets/event_card_today_badge.dart';
import 'package:kuemele/shared/utils/image_provider_utils.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.category,
    required this.hostName,
    required this.time,
    required this.price,
    required this.guests,
    required this.startTime,
    required this.index,
    this.eventId,
    this.showBottomLeftContainer = false,
    this.showDeleteIcon = false,
    this.cancelButton = false,
    this.bgColor,
  });

  final String title;
  final String imagePath;
  final String category;
  final String hostName;
  final String time;
  final String price;
  final String guests;
  final String startTime;
  final int index;
  final String? eventId;
  final bool showBottomLeftContainer;
  final bool showDeleteIcon;
  final bool cancelButton;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final layout = EventCardLayout(responsive);

    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        decoration: BoxDecoration(boxShadow: AppShadows.card),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(layout.borderRadius),
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final imageHeight = constraints.maxHeight * 0.5;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _EventCardImage(
                        imagePath: imagePath,
                        height: imageHeight,
                        showTodayBadge: showBottomLeftContainer,
                      ),
                      Expanded(
                        child: _EventCardContent(
                          title: title,
                          hostName: hostName,
                          time: time,
                          price: price,
                          guests: guests,
                          startTime: startTime,
                          cancelButton: cancelButton,
                          bgColor: bgColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (showDeleteIcon) const EventCardDeleteOverlay(),
              if (category.isNotEmpty)
                Positioned(
                  top: layout.categoryTagTop,
                  right: layout.categoryTagRight,
                  child: CategoryTag(label: category),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    final id = eventId?.trim() ?? '';
    if (id.isEmpty) {
      if (index == 2) {
        showDialog(
          context: context,
          barrierColor: ColorSet.bcColor,
          builder: (context) => const ExploreDiscount(),
        );
      }
      return;
    }

    AppDialog.show(
      context: context,
      width: AppDialogSize.widthFor(context),
      dialog: ExplorePreview(eventId: id),
    );
  }
}

class _EventCardImage extends StatelessWidget {
  const _EventCardImage({
    required this.imagePath,
    required this.height,
    required this.showTodayBadge,
  });

  final String imagePath;
  final double height;
  final bool showTodayBadge;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageProviderFromPath(imagePath),
          ),
        ),
        child: showTodayBadge
            ? Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: responsive.h(4)),
                  child: const EventCardTodayBadge(),
                ),
              )
            : null,
      ),
    );
  }
}

class _EventCardContent extends StatelessWidget {
  const _EventCardContent({
    required this.title,
    required this.hostName,
    required this.time,
    required this.price,
    required this.guests,
    required this.startTime,
    required this.cancelButton,
    this.bgColor,
  });

  final String title;
  final String hostName;
  final String time;
  final String price;
  final String guests;
  final String startTime;
  final bool cancelButton;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final layout = EventCardLayout(responsive);

    return ColoredBox(
      color: bgColor ?? ColorSet.bg2Color,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: layout.contentPaddingV,
          horizontal: layout.contentPaddingH,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyLargeBold.copyWith(
                      color: ColorSet.textColor,
                    ),
                  ),
                ),
                if (cancelButton) ...[
                  Gap(responsive.w(8)),
                  const EventCardCancelButton(),
                ],
              ],
            ),
            Gap(responsive.h(8)),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(bottom: responsive.h(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EventCardInfoRow(
                      price: price,
                      hostName: hostName,
                      time: time,
                      guests: guests,
                    ),
                    Gap(responsive.h(6)),
                    EventCardStartTimeRow(startTime: startTime),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
