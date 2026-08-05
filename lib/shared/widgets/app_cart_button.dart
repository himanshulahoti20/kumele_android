import 'package:flutter/material.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class AppCartButton extends StatelessWidget {
  const AppCartButton({
    super.key,
    required this.onTap,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.iconSize = 18,
  });

  final VoidCallback onTap;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry padding;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: ColorSet.specialYellowColor,
          borderRadius: borderRadius ?? BorderRadius.circular(7),
        ),
        child: Center(
          child: KumeleAssetWidget.square(
            assetPath: Assets.icons.cart.path,
            size: iconSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
