import 'package:flutter/material.dart';

import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';

import '../faq_data.dart';

/// Renders the native FAQ content (title + question/answer cards), mirroring
/// the `FAQNativeView` from the iOS app.
class FaqContent extends StatelessWidget {
  const FaqContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              'FAQ',
              style: textTheme.headlineSmallBold.copyWith(
                color: ColorSet.textColor,
              ),
            ),
          ),
          for (final item in FaqData.items) ...[
            _FaqCard(item: item),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.item});

  final FaqItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.question,
            style: textTheme.titleMediumSemiBold.copyWith(
              color: ColorSet.textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.answer,
            style: textTheme.bodyMedium.copyWith(
              fontSize: 14,
              height: 1.35,
              color: ColorSet.textColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
