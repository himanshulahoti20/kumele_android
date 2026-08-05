import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class BlogDetailContent extends StatelessWidget {
  const BlogDetailContent({
    super.key,
    required this.blog,
    required this.isLoading,
  });

  final BlogPostModel blog;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final blocks = blog.contentBlocks;
    if (blocks != null && blocks.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: blocks.map((block) {
          final value = block.value.trim();
          if (value.isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Html(
              data: value,
              style: _contentStyles(),
            ),
          );
        }).toList(),
      );
    }

    final contentHtml = blog.contentHtml;
    if (contentHtml != null && contentHtml.isNotEmpty) {
      return Html(
        data: contentHtml,
        style: _contentStyles(),
      );
    }

    return Text(
      blog.excerpt,
      style: context.textTheme.bodyLarge.copyWith(
        color: ColorSet.textColor,
        height: 1.6,
      ),
    );
  }

  Map<String, Style> _contentStyles() {
    return {
      "body": Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
        color: ColorSet.textColor,
        fontSize: FontSize(16.sp),
        lineHeight: LineHeight(1.6),
      ),
      "h1": Style(
        color: ColorSet.textColor,
        margin: Margins.only(top: 16, bottom: 8),
      ),
      "h2": Style(
        color: ColorSet.textColor,
        margin: Margins.only(top: 16, bottom: 8),
      ),
      "h3": Style(
        color: ColorSet.textColor,
        margin: Margins.only(top: 16, bottom: 8),
      ),
      "h4": Style(
        color: ColorSet.textColor,
        margin: Margins.only(top: 14, bottom: 6),
      ),
      "h5": Style(
        color: ColorSet.textColor,
        margin: Margins.only(top: 12, bottom: 6),
      ),
      "h6": Style(
        color: ColorSet.textColor,
        margin: Margins.only(top: 12, bottom: 6),
      ),
      "p": Style(
        color: ColorSet.textColor,
        margin: Margins.only(bottom: 12),
      ),
      "ul": Style(
        color: ColorSet.textColor,
        margin: Margins.only(left: 18, bottom: 12),
        padding: HtmlPaddings.zero,
      ),
      "ol": Style(
        color: ColorSet.textColor,
        margin: Margins.only(left: 18, bottom: 12),
        padding: HtmlPaddings.zero,
      ),
      "li": Style(
        color: ColorSet.textColor,
        margin: Margins.only(bottom: 4),
      ),
      "a": Style(
        color: ColorSet.specialColor,
        textDecoration: TextDecoration.underline,
      ),
      "strong": Style(
        color: ColorSet.textColor,
        fontWeight: FontWeight.w700,
      ),
      "b": Style(
        color: ColorSet.textColor,
        fontWeight: FontWeight.w700,
      ),
      "em": Style(
        color: ColorSet.textColor,
        fontStyle: FontStyle.italic,
      ),
      "blockquote": Style(
        color: ColorSet.textColor.withValues(alpha: 0.85),
        margin: Margins.only(left: 8, top: 12, bottom: 12),
        padding: HtmlPaddings.only(left: 12),
        border: Border(
          left: BorderSide(
            color: ColorSet.specialColor.withValues(alpha: 0.35),
            width: 3,
          ),
        ),
      ),
      "code": Style(
        color: ColorSet.textColor,
        backgroundColor: ColorSet.bg2Color,
        padding: HtmlPaddings.symmetric(horizontal: 6, vertical: 4),
        fontFamily: 'monospace',
      ),
      "pre": Style(
        color: ColorSet.textColor,
        backgroundColor: ColorSet.bg2Color,
        padding: HtmlPaddings.all(12),
        margin: Margins.only(bottom: 12),
      ),
      "table": Style(
        color: ColorSet.textColor,
        margin: Margins.only(bottom: 12),
      ),
      "th": Style(
        color: ColorSet.textColor,
        padding: HtmlPaddings.all(8),
      ),
      "td": Style(
        color: ColorSet.textColor,
        padding: HtmlPaddings.all(8),
      ),
      "img": Style(
        margin: Margins.only(bottom: 12),
        width: Width.auto(),
        height: Height.auto(),
      ),
      "hr": Style(
        margin: Margins.only(top: 12, bottom: 12),
      ),
    };
  }
}
