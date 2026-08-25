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

    // Always route through AppAvatar so the real signed-in user's photo is
    // used whenever they have one, and a plain initials circle otherwise —
    // never a raw asset lookup that breaks (red "broken image" box) when
    // [chat.profile] is empty.
    final profile = chat.profile;
    return AppAvatar(
      name: chat.from,
      imageUrl: profile.startsWith('http') ? profile : null,
      size: size,
      showShadow: false,
    );
  }
}
