import 'package:flutter/material.dart';
import 'package:kuemele/features/chat/models/chat_config.dart';
import 'package:kuemele/features/profile/presentation/guideline/guideline_config.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class GuidelineChatAvatar extends StatelessWidget {
  const GuidelineChatAvatar({
    super.key,
    required this.chat,
    this.size = GuidelineConfig.chatAvatarSize,
  });

  final ChatMessage chat;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (!chat.itsME) {
      return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorSet.subTextColor,
        ),
        child: KumeleAssetWidget.square(
          assetPath: SVGAsset.icon_ai,
          size: size - 4,
          color: ColorSet.textColor,
        ),
      );
    }

    final profile = chat.profile;
    if (profile.startsWith('http')) {
      return AppAvatar(
        name: chat.from,
        imageUrl: profile,
        size: size,
        showShadow: false,
      );
    }

    return KumeleAssetWidget.circular(
      assetPath: profile,
      size: size,
    );
  }
}
