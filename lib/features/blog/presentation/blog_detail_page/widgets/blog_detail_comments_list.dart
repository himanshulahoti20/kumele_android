import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/utils/conversion_utils.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';

enum LineType { vertical, horizontal, thread }

class _DottedLinePainter extends CustomPainter {
  _DottedLinePainter({
    required this.color,
    this.type = LineType.vertical,
    this.isLast = false,
    this.yOffset = 0,
  });

  final Color color;
  final LineType type;
  final bool isLast;
  final double yOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    void drawDottedLine(Offset p1, Offset p2) {
      final distance = (p2 - p1).distance;
      if (distance == 0) return;
      final direction = (p2 - p1) / distance;
      double currentDistance = 0;
      while (currentDistance < distance) {
        final start = p1 + direction * currentDistance;
        final end =
            p1 + direction * (currentDistance + 4.0).clamp(0.0, distance);
        canvas.drawLine(start, end, paint);
        currentDistance += 8.0;
      }
    }

    if (type == LineType.vertical) {
      drawDottedLine(
          Offset(size.width / 2, 0), Offset(size.width / 2, size.height));
    } else if (type == LineType.horizontal) {
      drawDottedLine(Offset(0, yOffset), Offset(size.width, yOffset));
    } else if (type == LineType.thread) {
      final double x = size.width / 2;
      drawDottedLine(Offset(x, 0), Offset(x, yOffset));
      drawDottedLine(Offset(x, yOffset), Offset(size.width, yOffset));
      if (!isLast) {
        drawDottedLine(Offset(x, yOffset), Offset(x, size.height));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.type != type ||
      oldDelegate.isLast != isLast ||
      oldDelegate.yOffset != yOffset;
}

class BlogDetailCommentsList extends StatelessWidget {
  const BlogDetailCommentsList({
    super.key,
    required this.comments,
    this.isLoading = false,
    this.onReply,
  });

  final List<BlogCommentModel> comments;
  final bool isLoading;
  final ValueChanged<BlogCommentModel>? onReply;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (comments.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Text(
            'No comments yet. Be the first to comment!',
            style: context.textTheme.bodyMedium.copyWith(
              color: ColorSet.textColor.withAlpha(153),
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      separatorBuilder: (context, index) => Gap(16.h),
      itemBuilder: (context, index) {
        final comment = comments[index];
        return _CommentItem(
          comment: comment,
          onReply: onReply,
        );
      },
    );
  }
}

class _CommentItem extends StatelessWidget {
  const _CommentItem({
    required this.comment,
    this.isReply = false,
    this.isLast = false,
    this.onReply,
    this.parentAuthorName,
  });

  final BlogCommentModel comment;
  final bool isReply;
  final bool isLast;
  final ValueChanged<BlogCommentModel>? onReply;
  final String? parentAuthorName;

  @override
  Widget build(BuildContext context) {
    final parsedDate = ConversionUtils.parseDateTime(comment.createdAt);
    final formattedDate = parsedDate != null
        ? ConversionUtils.formatDateTime(parsedDate, 'dd MMM, yyyy')
        : comment.createdAt;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isReply)
            SizedBox(
              width: 32.w,
              child: CustomPaint(
                painter: _DottedLinePainter(
                  color: ColorSet.textColor.withAlpha(76),
                  type: LineType.thread,
                  isLast: isLast,
                  yOffset: 16.w,
                ),
              ),
            ),
          if (isReply)
            SizedBox(
              width: 12.w,
              child: CustomPaint(
                painter: _DottedLinePainter(
                  color: ColorSet.textColor.withAlpha(76),
                  type: LineType.horizontal,
                  yOffset: 16.w,
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: 32.w,
                        child: Column(
                          children: [
                            AppAvatar(
                              imageUrl: comment.author.avatar,
                              name: comment.author.displayName,
                              size: 32.r,
                              showShadow: false,
                            ),
                            if (comment.replies.isNotEmpty)
                              Expanded(
                                child: CustomPaint(
                                  painter: _DottedLinePainter(
                                    color: ColorSet.textColor.withAlpha(76),
                                    type: LineType.vertical,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  comment.author.displayName,
                                  style:
                                      context.textTheme.bodyMediumBold.copyWith(
                                    color: ColorSet.textColor,
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: context.textTheme.bodySmall.copyWith(
                                    color: ColorSet.textColor.withAlpha(153),
                                  ),
                                ),
                              ],
                            ),
                            Gap(4.h),
                            _buildContent(
                                context, comment.content, parentAuthorName),
                            Gap(8.h),
                            AppButton.text(
                              label: 'Reply',
                              onPressed: () => onReply?.call(comment),
                              fontSize: 12.sp,
                              foregroundColor: ColorSet.lightBlueColor,
                            ),
                            Gap(12.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (comment.replies.isNotEmpty)
                  ...comment.replies.asMap().entries.map((entry) {
                    return _CommentItem(
                      comment: entry.value,
                      isReply: true,
                      isLast: entry.key == comment.replies.length - 1,
                      onReply: onReply,
                      parentAuthorName: comment.author.displayName,
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, String content, String? parentAuthorName) {
    String pattern = r'(@\w+)';
    if (parentAuthorName != null && parentAuthorName.isNotEmpty) {
      final escapedName = RegExp.escape('@$parentAuthorName');
      pattern = '$escapedName|(@\\w+)';
    }

    final RegExp regex = RegExp(pattern);
    final matches = regex.allMatches(content);

    if (matches.isEmpty) {
      return Text(
        content,
        style: context.textTheme.bodyMedium.copyWith(
          color: ColorSet.textColor.withAlpha(230),
        ),
      );
    }

    final spans = <TextSpan>[];
    int currentPosition = 0;

    for (final match in matches) {
      if (match.start > currentPosition) {
        spans.add(TextSpan(
          text: content.substring(currentPosition, match.start),
        ));
      }
      spans.add(TextSpan(
        text: match.group(0),
        style: context.textTheme.bodyMediumBold.copyWith(
          color: ColorSet.textColor,
        ),
      ));
      currentPosition = match.end;
    }

    if (currentPosition < content.length) {
      spans.add(TextSpan(
        text: content.substring(currentPosition),
      ));
    }

    return RichText(
      text: TextSpan(
        style: context.textTheme.bodyMedium.copyWith(
          color: ColorSet.textColor.withAlpha(230),
        ),
        children: spans,
      ),
    );
  }
}
