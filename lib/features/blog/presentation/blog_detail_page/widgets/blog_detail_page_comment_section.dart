import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/shared/components/app_button.dart';
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
          labelText: AppStrings.comment,
          controller: controller,
          hintText: AppStrings.addYourComment,
          maxLines: 6,
          minLines: 6,
        ),
        Gap(18.h),
        Align(
          alignment: Alignment.centerRight,
          child: AppButton.primary(
            label: AppStrings.publishComment,
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
