import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/entities/hobby_interest.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class HobbyIconWidget extends StatelessWidget {
  final HobbyInterest hobby;
  final double size;
  final Color color;

  const HobbyIconWidget({
    super.key,
    required this.hobby,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconUrl = hobby.icon;

    if (iconUrl == null || iconUrl.isEmpty) {
      return SizedBox(width: size, height: size);
    }

    final isEmoji = !iconUrl.contains('/') && !iconUrl.contains('.');

    if (isEmoji) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            iconUrl,
            style: context.textTheme.bodyMedium.copyWith(
              fontSize: size * 0.7,
              height: 1.0,
            ),
          ),
        ),
      );
    }

    return KumeleAssetWidget(
      assetPath: iconUrl,
      width: size,
      height: size,
      color: color,
    );
  }
}
