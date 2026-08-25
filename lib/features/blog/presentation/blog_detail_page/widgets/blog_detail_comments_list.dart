import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/utils/conversion_utils.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';
import 'package:kuemele/l10n/app_localizations.dart';

enum LineType { vertical, thread }

class _DottedLinePainter extends CustomPainter {
  _DottedLinePainter({
    required this.color,
    this.type = LineType.vertical,
    this.isLast = false,
    this.xOffset,
    this.yOffset = 0,
  });

  final Color color;
  final LineType type;
  final bool isLast;
  final double? xOffset;
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
    } else {
      final x = xOffset ?? size.width / 2;
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
      oldDelegate.xOffset != xOffset ||
      oldDelegate.yOffset != yOffset;
}

class BlogDetailCommentsList extends StatefulWidget {
  const BlogDetailCommentsList({
    super.key,
    required this.comments,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.onReply,
  });

  final List<BlogCommentModel> comments;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final ValueChanged<BlogCommentModel>? onReply;

  @override
  State<BlogDetailCommentsList> createState() => _BlogDetailCommentsListState();
}

class _BlogDetailCommentsListState extends State<BlogDetailCommentsList> {
  final Set<String> _expandedCommentIds = {};

  void _toggleReplies(String commentId) {
    setState(() {
      if (!_expandedCommentIds.remove(commentId)) {
        _expandedCommentIds.add(commentId);
      }
    });
  }

  void _replyTo(BlogCommentModel comment, String threadId) {
    setState(() => _expandedCommentIds.add(threadId));
    widget.onReply?.call(comment);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.errorMessage != null) {
      return Column(
        children: [
          Text(
            widget.errorMessage!,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium.copyWith(
              color: ColorSet.subTextColor,
            ),
          ),
          if (widget.onRetry != null)
            TextButton(
              onPressed: widget.onRetry,
              child: const Text('Retry'),
            ),
        ],
      );
    }

    if (widget.comments.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Text(
            AppLocalizations.of(context)!.blogNoCommentsMessage,
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
      itemCount: widget.comments.length,
      separatorBuilder: (context, index) => Gap(20.h),
      itemBuilder: (context, index) {
        final comment = widget.comments[index];
        return _CommentItem(
          comment: comment,
          showReplies: _expandedCommentIds.contains(comment.id),
          onToggleReplies: () => _toggleReplies(comment.id),
          onReply: (replyTarget) => _replyTo(replyTarget, comment.id),
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
    this.showReplies = false,
    this.onToggleReplies,
    this.onReply,
    this.parentAuthorName,
  });

  final BlogCommentModel comment;
  final bool isReply;
  final bool isLast;
  final bool showReplies;
  final VoidCallback? onToggleReplies;
  final ValueChanged<BlogCommentModel>? onReply;
  final String? parentAuthorName;

  @override
  Widget build(BuildContext context) {
    final parsedDate = ConversionUtils.parseDateTime(comment.createdAt);
    final formattedDate = parsedDate != null
        ? ConversionUtils.formatDateTime(parsedDate, 'dd MMMM yyyy')
        : comment.createdAt;
    final avatarSize = 60.r;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isReply)
            SizedBox(
              width: 42.w,
              child: CustomPaint(
                painter: _DottedLinePainter(
                  color: ColorSet.textColor.withAlpha(76),
                  type: LineType.thread,
                  isLast: isLast,
                  xOffset: avatarSize / 2,
                  yOffset: avatarSize / 2,
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
                        width: avatarSize,
                        child: Column(
                          children: [
                            AppAvatar(
                              imageUrl: comment.author.avatar,
                              name: comment.author.displayName,
                              size: avatarSize,
                              showShadow: false,
                            ),
                            if (showReplies && comment.replies.isNotEmpty)
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
                      Gap(8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    comment.author.displayName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        context.textTheme.titleMedium.copyWith(
                                      color: ColorSet.textColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18.sp,
                                      height: 1.1,
                                    ),
                                  ),
                                ),
                                if (!isReply && comment.replies.isNotEmpty)
                                  _RepliesPill(
                                    count: comment.replies.length,
                                    isExpanded: showReplies,
                                    onTap: onToggleReplies,
                                  ),
                              ],
                            ),
                            Gap(5.h),
                            _CommentMetaRow(
                              date: formattedDate,
                              onReply: () => onReply?.call(comment),
                            ),
                            Gap(6.h),
                            _buildContent(
                                context, comment.content, parentAuthorName),
                            Gap(10.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (showReplies && comment.replies.isNotEmpty)
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
          color: ColorSet.specialBlueColor,
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
          fontSize: 15.sp,
          height: 1.2,
        ),
        children: spans,
      ),
    );
  }
}

class _CommentMetaRow extends StatelessWidget {
  const _CommentMetaRow({
    required this.date,
    required this.onReply,
  });

  final String date;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    final mutedStyle = context.textTheme.bodyMedium.copyWith(
      color: ColorSet.textColor.withAlpha(153),
      fontSize: 16.sp,
      height: 1.0,
    );

    return Row(
      children: [
        Text('• $date • ', style: mutedStyle),
        GestureDetector(
          onTap: onReply,
          behavior: HitTestBehavior.opaque,
          child: Text(
            AppLocalizations.of(context)!.reply,
            style: mutedStyle.copyWith(color: ColorSet.specialBlueColor),
          ),
        ),
      ],
    );
  }
}

class _RepliesPill extends StatelessWidget {
  const _RepliesPill({
    required this.count,
    required this.isExpanded,
    this.onTap,
  });

  final int count;
  final bool isExpanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 8.w),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: ColorSet.specialYellowColor,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$count ${AppLocalizations.of(context)!.blogRepliesCountLabel}',
              style: context.textTheme.bodySmall.copyWith(
                color: Colors.black,
                fontSize: 12.sp,
                height: 1.0,
              ),
            ),
            Gap(4.w),
            Image.asset(
              isExpanded
                  ? 'assets/icons/blogs/dropdown_expand.png'
                  : 'assets/icons/blogs/dropdown_unexpanded.png',
              width: 16.r,
              height: 16.r,
              excludeFromSemantics: true,
            ),
          ],
        ),
      ),
    );
  }
}
