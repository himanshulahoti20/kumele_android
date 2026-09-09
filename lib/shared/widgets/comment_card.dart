import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/models/comment_model.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/size_reporting_widget.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class VerticalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorSet.textColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashHeight = 4.0;
    const dashSpace = 2.0;
    double startY = 0;
    final x = size.width / 2;

    while (startY < size.height) {
      canvas.drawLine(Offset(x, startY), Offset(x, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorSet.textColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 2.0;
    double startX = 0;
    final y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CommentCard extends StatefulWidget {
  final CommentModel comment;
  final bool showHorizontalLine;
  final VoidCallback? onToggleShowReply;
  final bool showReply;
  final bool? showDateSameRow;

  const CommentCard({
    super.key,
    required this.comment,
    this.showHorizontalLine = false,
    this.onToggleShowReply,
    this.showReply = true,
    this.showDateSameRow,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool _showReplies = false;
  double commentHeight = 20;

  CommentModel get comment => widget.comment;

  @override
  Widget build(BuildContext context) {
    final double paddingLeft = 29.5;
    final double horizontalLineLength = 45;
    final bool showDateSameRow = widget.showDateSameRow ?? FormFactor.isTablet;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dash line for replies
            if (widget.showHorizontalLine)
              Container(
                margin: EdgeInsets.only(top: 30),
                width: horizontalLineLength,
                child: CustomPaint(
                  painter: DashLinePainter(),
                  child: Container(height: 1),
                ),
              ),
            // Main comment card
            Expanded(
              child: Row(
                spacing: 10,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Opacity(
                        opacity: _showReplies ? 1 : 0,
                        child: SizedBox(
                          width: 1,
                          height: commentHeight,
                          child: CustomPaint(painter: VerticalLinePainter()),
                        ),
                      ),
                      Image.asset(comment.image, width: 60, height: 60),
                    ],
                  ),
                  Expanded(
                    child: SizeReportingWidget(
                      onSizeChange: (Size value) => setState(() => commentHeight = value.height),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 5,
                            children: [
                              Text(
                                comment.author,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  color: ColorSet.textColor,
                                ),
                              ),
                              if (showDateSameRow) buildRowDate(),
                              if (comment.hasReplies)
                                GestureDetector(
                                  onTap: () {
                                    widget.onToggleShowReply?.call();
                                    setState(() {
                                      _showReplies = !_showReplies;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: ColorSet.specialYellowColor,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${comment.replies.length} Replies",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: FormFactor.isTablet ? 17 : 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Image.asset(
                                          IconSet.dropDownIcon,
                                          color: Colors.black,
                                          fit: BoxFit.cover,
                                          width: FormFactor.isTablet ? 28 : 20,
                                          height: FormFactor.isTablet ? 28 : 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (!showDateSameRow) buildRowDate(),
                          Text(
                            comment.comment + comment.comment + comment.comment + comment.comment,
                            style: TextStyle(fontSize: FormFactor.isTablet ? 19 : 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Replies section with vertical line
        // if (_showReplies && widget.comment.hasReplies)
        Visibility(
          visible: _showReplies && widget.comment.hasReplies,
          child: widget.showHorizontalLine
              ? Column(
                  children: widget.comment.replies.mapIndexed((index, reply) {
                    final isLastReply = index == widget.comment.replies.length - 1;
                    return Padding(
                      padding: EdgeInsets.only(left: horizontalLineLength),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            bottom: 0,
                            child: Opacity(
                              opacity: isLastReply ? 0 : 1,
                              child: Padding(
                                padding: EdgeInsets.only(left: 29.5),
                                child: SizedBox(
                                  width: 1,
                                  // height: commentHeight,
                                  child: CustomPaint(painter: VerticalLinePainter()),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 20 : 0,
                              bottom: isLastReply ? 0 : 20,
                            ),
                            child: CommentCard(comment: reply, showHorizontalLine: false),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              : Column(
                  children: widget.comment.replies.mapIndexed((index, reply) {
                    final isLastReply = index == widget.comment.replies.length - 1;
                    return ReplyCard(
                      reply: reply,
                      isFirst: index == 0,
                      isLastReply: isLastReply,
                      paddingLeft: paddingLeft,
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Row buildRowDate() {
    final fontSize = FormFactor.isTablet ? 18.0 : 16.0;
    return Row(
      spacing: 5,
      children: [
        Text(
          "•",
          style: TextStyle(
            color: ColorSet.textColor,
            fontSize: fontSize + 9,
          ),
        ),
        Text(
          comment.timestamp,
          style: TextStyle(
            color: ColorSet.textColor,
            fontSize: fontSize,
          ),
        ),
        if (widget.showReply) ...[
          Text(
            "•",
            style: TextStyle(
              color: ColorSet.textColor,
              fontSize: fontSize + 9,
            ),
          ),
          ClickWidget(
            onPressed: () {},
            child: Text(
              AppLocalizations.of(context)!.reply,
              style: TextStyle(
                color: ColorSet.lightBlueColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ]
      ],
    );
  }
}

class ReplyCard extends StatefulWidget {
  const ReplyCard({
    super.key,
    required this.reply,
    required this.isFirst,
    required this.isLastReply,
    required this.paddingLeft,
  });

  final CommentModel reply;
  final bool isFirst;
  final bool isLastReply;
  final double paddingLeft;

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  double replyHeight = 20;
  final replyKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vertical line segment for this reply
        Gap(widget.paddingLeft),
        SizedBox(
          width: 1,
          height: widget.isLastReply ? 30 : replyHeight,
          child: CustomPaint(painter: VerticalLinePainter()),
        ),
        // Reply comment
        Expanded(
          child: SizeReportingWidget(
            onSizeChange: (Size value) => setState(() => replyHeight = value.height),
            child: Padding(
              key: replyKey,
              padding: EdgeInsets.only(
                top: widget.isFirst ? 20 : 0,
                bottom: widget.isLastReply ? 0 : 20,
              ),
              child: CommentCard(
                comment: widget.reply,
                showHorizontalLine: true,
                onToggleShowReply: () {
                  try {
                    final RenderBox renderBox = replyKey.currentContext?.findRenderObject() as RenderBox;
                    setState(() => replyHeight = renderBox.size.height);
                  } catch (e) {
                    log(e.toString());
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
