import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_shadows.dart';
import 'package:kuemele/shared/components/event_card/widgets/category_tag.dart';
import 'package:kuemele/shared/components/event_card/widgets/event_card_info_item.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/gen/assets.gen.dart';

class EventCard2 extends StatelessWidget {
  const EventCard2({
    super.key,
    required this.title,
    required this.imagePath,
    required this.category,
    required this.time,
    required this.price,
    required this.guests,
    required this.startTime,
    this.bgColor,
  });

  final String title;
  final String imagePath;
  final String category;
  final String time;
  final String price;
  final String guests;
  final String startTime;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final isTablet = responsive.isTablet;
    final titleFontSize = responsive.sp(isTablet ? 16 : 18);
    final infoFontSize = responsive.sp(isTablet ? 11 : 13);
    final infoIconSize = responsive.w(isTablet ? 16 : 18);

    return Container(
      width: responsive.w(240),
      decoration: BoxDecoration(
        color: bgColor ?? ColorSet.bg3Color,
        borderRadius: BorderRadius.circular(responsive.w(10)),
        boxShadow: AppShadows.card,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(responsive.w(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  KumeleAssetWidget(
                    assetPath: imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    top: responsive.h(7),
                    right: responsive.w(2),
                    child: CategoryTag(label: category),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                responsive.w(16),
                responsive.h(12),
                responsive.w(16),
                responsive.h(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.bodySmallSemiBold.copyWith(
                      fontSize: titleFontSize,
                      color: ColorSet.textColor,
                    ),
                  ),
                  Gap(responsive.h(8)),
                  EventCardInfoItem(
                    assetPath: Assets.icons.groupCard.path,
                    label: guests,
                    iconSize: infoIconSize,
                    fontSize: infoFontSize,
                  ),
                  Gap(responsive.h(8)),
                  Row(
                    children: [
                      EventCardInfoItem(
                        assetPath: Assets.icons.dollarCircled.path,
                        label: price,
                        iconSize: infoIconSize,
                        fontSize: infoFontSize,
                      ),
                      Gap(responsive.w(5)),
                      EventCardInfoItem(
                        assetPath: Assets.icons.clock.path,
                        label: time,
                        iconSize: infoIconSize,
                        fontSize: infoFontSize,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
