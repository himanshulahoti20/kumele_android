import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class EventCardTodayBadge extends StatelessWidget {
  const EventCardTodayBadge({
    super.key,
    this.label = 'Today',
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Stack(
      alignment: Alignment.center,
      children: [
        KumeleAssetWidget(
          assetPath: Assets.svg.rectangle.path,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            responsive.w(6),
            responsive.h(3),
            responsive.w(16),
            responsive.h(3),
          ),
          child: Text(
            label,
            style: context.textTheme.bodySmallBold.copyWith(
              fontSize: responsive.sp(13),
              color: ColorSet.textColor,
            ),
          ),
        ),
      ],
    );
  }
}
