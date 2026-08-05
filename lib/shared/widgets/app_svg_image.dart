import 'package:flutter/material.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class AppSvgImage extends StatelessWidget {
  final String assetName;
  final Color? color;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppSvgImage({
    super.key,
    required this.assetName,
    this.color,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return KumeleAssetWidget(
      assetPath: assetName,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }
}
