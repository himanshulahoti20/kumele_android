import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/models/legal_document.dart';
import 'package:kuemele/shared/widgets/app_loading_indicator.dart';

class GuidelineLegalContent extends StatelessWidget {
  const GuidelineLegalContent({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.document,
    this.emptyMessage = 'No content available.',
  });

  final bool isLoading;
  final String? errorMessage;
  final LegalDocument? document;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: AppLoadingIndicator.circle());
    }

    if (errorMessage != null) {
      return _MessageText(message: errorMessage!);
    }

    final content = document?.content;
    if (content == null || content.isEmpty) {
      return _MessageText(message: emptyMessage);
    }

    final bodyStyle = context.textTheme.bodySmall.copyWith(fontSize: 13);

    return ListView(
      children: [
        if (document?.title?.isNotEmpty ?? false) ...[
          Text(document!.title!, style: context.textTheme.bodyLarge),
          SizedBox(height: size(20)),
        ],
        Text(
          content,
          style: bodyStyle,
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}

class _MessageText extends StatelessWidget {
  const _MessageText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: context.textTheme.bodySmall.copyWith(fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }
}
