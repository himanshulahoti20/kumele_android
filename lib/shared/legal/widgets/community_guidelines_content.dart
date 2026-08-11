import 'package:flutter/material.dart';

import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';

import '../community_guidelines_data.dart';

/// Renders the native Community Guidelines content, mirroring the
/// `CommunityGuidelinesNativeView` from the iOS app (header, intros, policy
/// cards, sub-sections, bullets and emphasised notes).
class CommunityGuidelinesContent extends StatelessWidget {
  const CommunityGuidelinesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < CommunityGuidelinesData.blocks.length; i++) ...[
            _buildBlock(context, CommunityGuidelinesData.blocks[i]),
            if (i != CommunityGuidelinesData.blocks.length - 1)
              const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }

  Widget _buildBlock(BuildContext context, GuidelineBlock block) {
    final textTheme = context.textTheme;
    switch (block.type) {
      case GuidelineBlockType.header:
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            block.text,
            style: textTheme.headlineSmallBold.copyWith(
              color: ColorSet.textColor,
            ),
          ),
        );
      case GuidelineBlockType.intro:
        return Text(
          block.text,
          style: textTheme.bodyMedium.copyWith(
            fontSize: 15,
            height: 1.4,
            color: ColorSet.textColor.withValues(alpha: 0.85),
          ),
        );
      case GuidelineBlockType.section:
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            block.text,
            style: textTheme.titleLargeBold.copyWith(
              fontSize: 18,
              color: ColorSet.textColor,
            ),
          ),
        );
      case GuidelineBlockType.policy:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              block.text,
              style: textTheme.titleMediumSemiBold.copyWith(
                fontSize: 15,
                color: ColorSet.textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              block.description ?? '',
              style: textTheme.bodyMedium.copyWith(
                fontSize: 14,
                height: 1.35,
                color: ColorSet.textColor.withValues(alpha: 0.8),
              ),
            ),
          ],
        );
      case GuidelineBlockType.subSection:
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            block.text,
            style: textTheme.titleMediumSemiBold.copyWith(
              color: ColorSet.textColor,
            ),
          ),
        );
      case GuidelineBlockType.bullet:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '•',
              style: textTheme.bodyMedium.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: ColorSet.textColor,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                block.text,
                style: textTheme.bodyMedium.copyWith(
                  fontSize: 14,
                  height: 1.35,
                  color: ColorSet.textColor.withValues(alpha: 0.85),
                ),
              ),
            ),
          ],
        );
      case GuidelineBlockType.note:
        return Text(
          block.text,
          style: textTheme.bodyMedium.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: ColorSet.textColor,
          ),
        );
    }
  }
}
