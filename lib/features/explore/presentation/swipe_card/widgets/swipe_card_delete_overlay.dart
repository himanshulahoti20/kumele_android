import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class SwipeCardDeleteOverlay extends StatelessWidget {
  const SwipeCardDeleteOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      width: double.infinity,
      color: ColorSet.bcColor,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(
            right: responsive.w(6),
            bottom: responsive.h(8),
          ),
          child: KumeleAssetWidget.square(
            assetPath: Assets.icons.trash.path,
            size: responsive.w(20),
          ),
        ),
      ),
    );
  }
}
