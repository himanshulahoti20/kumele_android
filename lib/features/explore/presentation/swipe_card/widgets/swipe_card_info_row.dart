import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/swipe_card_layout.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_info_chip.dart';
import 'package:kuemele/gen/assets.gen.dart';

class SwipeCardInfoRow extends StatelessWidget {
  const SwipeCardInfoRow({
    super.key,
    required this.layout,
    required this.price,
    required this.time,
    required this.guests,
    this.compact = false,
  });

  final SwipeCardLayout layout;
  final String price;
  final String time;
  final String guests;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SwipeCardInfoChip(
                assetPath: Assets.svg.iconTicket.path,
                label: price,
                alignment: Alignment.centerLeft,
                compact: compact,
              ),
            ),
            Expanded(
              child: SwipeCardInfoChip(
                assetPath: Assets.icons.clock.path,
                label: time,
                alignment: Alignment.center,
                compact: compact,
              ),
            ),
          ],
        ),
        Gap(8.h),
        SwipeCardInfoChip(
          assetPath: Assets.icons.guests.path,
          label: guests,
          alignment: Alignment.centerLeft,
          compact: compact,
        ),
      ],
    );
  }
}
