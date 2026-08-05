import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/event_card/event_card_layout.dart';
import 'package:lottie/lottie.dart';

class EventCardStartTimeRow extends StatelessWidget {
  const EventCardStartTimeRow({
    super.key,
    required this.startTime,
  });

  final String startTime;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final layout = EventCardLayout(responsive);

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Start in',
            style: context.textTheme.bodySmall.copyWith(
              color: ColorSet.textColor,
            ),
          ),
          Gap(responsive.w(4)),
          Lottie.asset(
            Assets.iconsJson.clock.path,
            height: layout.startTimeClockSize,
            width: layout.startTimeClockSize,
            fit: BoxFit.contain,
          ),
          Gap(responsive.w(4)),
          Text(
            startTime,
            style: context.textTheme.bodySmallBold.copyWith(
              color: ColorSet.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
