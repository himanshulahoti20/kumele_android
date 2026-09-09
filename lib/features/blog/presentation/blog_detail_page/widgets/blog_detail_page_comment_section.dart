import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';

class BlogDetailCommentSection extends StatelessWidget {
  const BlogDetailCommentSection({
    super.key,
    required this.controller,
    this.isLoading = false,
    this.onSubmit,
  });

  final TextEditingController controller;
  final bool isLoading;
  final ValueChanged<String>? onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlogDetailCommentComposer(
      controller: controller,
      isLoading: isLoading,
      onSubmit: onSubmit,
    );
  }
}

class BlogDetailCommentComposer extends StatelessWidget {
  const BlogDetailCommentComposer({
    super.key,
    required this.controller,
    this.isLoading = false,
    this.onSubmit,
  });

  final TextEditingController controller;
  final bool isLoading;
  final ValueChanged<String>? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KumeleTextArea(
          labelText: AppLocalizations.of(context)!.comment,
          controller: controller,
          hintText: AppLocalizations.of(context)!.addYourComment,
          fillColor: ColorSet.textBoxBgColor,
          borderRadius: 8,
          maxLines: 5,
          minLines: 5,
        ),
        Gap(14.h),
        Align(
          alignment: Alignment.centerRight,
          child: AppButton.primary(
            label: AppLocalizations.of(context)!.publishComment,
            isLoading: isLoading,
            onPressed: () {
              if (isLoading) return;
              final text = controller.text.trim();
              if (text.isEmpty) {
                return;
              }
              onSubmit?.call(text);
            },
            fullWidth: false,
          ),
        ),
      ],
    );
  }
}
