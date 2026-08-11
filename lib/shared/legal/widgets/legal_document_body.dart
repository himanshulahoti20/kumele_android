import 'package:flutter/material.dart';

import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';

import '../legal_block.dart';

/// Renders a list of [LegalBlock]s using the same typography as the native
/// iOS `LocalLegalDocuments.swift` views (header / section / sub-section /
/// body / bullet point).
class LegalDocumentBody extends StatelessWidget {
  const LegalDocumentBody({super.key, required this.blocks});

  final List<LegalBlock> blocks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < blocks.length; i++) ...[
            _buildBlock(context, blocks[i]),
            if (i != blocks.length - 1) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildBlock(BuildContext context, LegalBlock block) {
    final textTheme = context.textTheme;
    switch (block.type) {
      case LegalBlockType.header:
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            block.text,
            style: textTheme.headlineSmallBold.copyWith(
              color: ColorSet.textColor,
            ),
          ),
        );
      case LegalBlockType.section:
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            block.text,
            style: textTheme.titleLargeBold.copyWith(
              fontSize: 18,
              color: ColorSet.textColor,
            ),
          ),
        );
      case LegalBlockType.subSection:
        return Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            block.text,
            style: textTheme.titleMediumSemiBold.copyWith(
              color: ColorSet.textColor,
            ),
          ),
        );
      case LegalBlockType.body:
        return Text(
          block.text,
          style: textTheme.bodyMedium.copyWith(
            fontSize: 15,
            height: 1.4,
            color: ColorSet.textColor.withValues(alpha: 0.85),
          ),
        );
      case LegalBlockType.bullet:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '•',
              style: textTheme.bodyMedium.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: ColorSet.textColor,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                block.text,
                style: textTheme.bodyMedium.copyWith(
                  fontSize: 15,
                  height: 1.35,
                  color: ColorSet.textColor.withValues(alpha: 0.85),
                ),
              ),
            ),
          ],
        );
    }
  }
}
