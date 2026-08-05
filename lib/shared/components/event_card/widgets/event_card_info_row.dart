import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/event_card/event_card_layout.dart';
import 'package:kuemele/shared/components/event_card/widgets/event_card_info_item.dart';

class EventCardInfoRow extends StatelessWidget {
  const EventCardInfoRow({
    super.key,
    required this.price,
    required this.time,
    required this.guests,
  });

  final String price;
  final String time;
  final String guests;

  @override
  Widget build(BuildContext context) {
    final layout = EventCardLayout(context.responsive);

    return Wrap(
      spacing: layout.infoRowSpacing,
      runSpacing: layout.infoRowRunSpacing,
      children: [
        EventCardInfoItem(
          assetPath: Assets.svg.iconTicket.path,
          label: price,
          iconSize: layout.infoIconSize,
        ),
        EventCardInfoItem(
          assetPath: Assets.icons.clock.path,
          label: time,
          iconSize: layout.infoIconSize,
        ),
        EventCardInfoItem(
          assetPath: Assets.icons.groupCard.path,
          label: guests,
          iconSize: layout.infoIconSize,
        ),
      ],
    );
  }
}
