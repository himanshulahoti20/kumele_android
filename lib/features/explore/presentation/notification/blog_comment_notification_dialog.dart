import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/features/blog/presentation/post/blog_post_share.dart';

import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/flip.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/widgets/kumele_rich_text.dart';

class Comment {
  final String name;
  final String profile;
  final String comment;
  final String date;
  bool expanded;
  final List<Replay> replays;

  Comment({
    required this.name,
    required this.profile,
    required this.comment,
    required this.date,
    this.expanded = false,
    this.replays = const [],
  });
}

class Replay {
  final String name;
  final String profile;
  final String comment;
  final String date;
  final bool expanded;
  final List<String> tag;
  final String time;
  final List<Replay> replays;

  Replay({
    required this.name,
    required this.profile,
    required this.comment,
    required this.date,
    this.expanded = false,
    required this.tag,
    required this.time,
    this.replays = const [],
  });
}

class BlogCommentNotificationDialog extends StatefulWidget {
  const BlogCommentNotificationDialog({super.key});

  @override
  State<BlogCommentNotificationDialog> createState() =>
      _BlogCommentNotificationDialogState();
}

class _BlogCommentNotificationDialogState
    extends State<BlogCommentNotificationDialog> {
  TextEditingController commentCTR = TextEditingController();
  bool poped = false;
  bool isLiked = false;
  int likeCount = 0;

  // Predefined comments and replies
  final List<Comment> comments = [
    Comment(
      name: "Jakob Hoffman",
      profile: "assets/blog_image_1.png",
      comment:
          "This event looks amazing! I'd love to join and learn more about spirituality.",
      date: "2 hours ago",
      replays: [
        Replay(
          name: "Sarah Miller",
          profile: "assets/blog_image_2.png",
          comment: "It's truly transformative! You'll love it.",
          date: "1 hour ago",
          tag: ["@Jakob Hoffman"],
          time: "1:30 PM",
        ),
        Replay(
          name: "Michael Chen",
          profile: IconSet.create2,
          comment: "I attended last month's session. Highly recommended!",
          date: "45 minutes ago",
          tag: ["@Jakob Hoffman"],
          time: "2:15 PM",
        ),
      ],
    ),
    Comment(
      name: "Emma Watson",
      profile: "assets/blog_image_3.png",
      comment: "The meditation techniques shared here are life-changing!",
      date: "3 hours ago",
      replays: [
        Replay(
          name: "David Brooks",
          profile: IconSet.create4,
          comment: "Completely agree! The instructor is excellent.",
          date: "2 hours ago",
          tag: ["@Emma Watson"],
          time: "1:00 PM",
        ),
      ],
    ),
    Comment(
      name: "Alex Thompson",
      profile: IconSet.create5,
      comment:
          "Looking forward to the next session. The community here is amazing!",
      date: "4 hours ago",
      replays: [
        Replay(
          name: "Lisa Wang",
          profile: IconSet.create1,
          comment: "Yes! Such a supportive group.",
          date: "3 hours ago",
          tag: ["@Alex Thompson"],
          time: "12:30 PM",
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    commentCTR.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = FinalSize.width(context);
    double height = FinalSize.height(context);
    double defaultWidth = width * 0.7;

    return PopScope(
      canPop: poped,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || poped) return;
        goto(context, 'home', arguments: {'selectedindex': 1});
      },
      child: Scaffold(
        backgroundColor: ColorSet.bgColor,
        body: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: ColorSet.bgColor,
            ),
            child: Center(
              child: Container(
                width: width * 0.85,
                height: height * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width * 0.005),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header
                      Container(
                        height: height * 0.04,
                        margin: EdgeInsets.only(
                          top: 20.0,
                          right: 1000.0,
                          bottom: 10,
                        ),
                        child: Text(
                          'Blogs',
                          style: TextStyle(
                            fontSize: width * 0.017,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: height * 0.0016,
                        color: Colors.grey[200],
                      ),

                      // Comments section
                      SizedBox(height: size(10)),
                      Padding(
                        padding: EdgeInsets.only(right: sizeW(240)),
                        child: Text("Comments",
                            style: context.textTheme.headlineMedium
                                .copyWith(fontSize: 26)),
                      ),

                      // Comment input
                      SizedBox(height: size(20)),
                      KumeleTextArea(
                        controller: commentCTR,
                        maxLines: 3,
                        hintText: "Add your comment...",
                      ),
                      SizedBox(height: size(30)),

                      // Publish button
                      Padding(
                        padding: EdgeInsets.only(left: 690.0),
                        child: isDark()
                            ? AppButton.outline(
                                label: "Publish Comment",
                                onPressed: () {
                                  // Add new comment logic here
                                  if (commentCTR.text.isNotEmpty) {
                                    setState(() {
                                      comments.insert(
                                        0,
                                        Comment(
                                          name: "You",
                                          profile: IconSet.matchedBGImage,
                                          comment: commentCTR.text,
                                          date: "Just now",
                                        ),
                                      );
                                      commentCTR.clear();
                                    });
                                  }
                                },
                              )
                            : AppButton.primary(
                                label: "Publish Comment",
                                onPressed: () {
                                  // Add new comment logic here
                                  if (commentCTR.text.isNotEmpty) {
                                    setState(() {
                                      comments.insert(
                                        0,
                                        Comment(
                                          name: "You",
                                          profile: IconSet.matchedBGImage,
                                          comment: commentCTR.text,
                                          date: "Just now",
                                        ),
                                      );
                                      commentCTR.clear();
                                    });
                                  }
                                },
                              ),
                      ),
                      SizedBox(height: size(40)),

                      // Comments list
                      ...comments.map(
                          (comment) => blogCommentsTile(defaultWidth, comment)),

                      SizedBox(height: size(40)),

                      // Navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            IconSet.arrowBackIcon,
                            width: sizeW(25),
                            height: size(25),
                          ),
                          SizedBox(width: sizeW(0)),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (!poped) {
                                  context.pop();
                                  poped = true;
                                }
                              });
                            },
                            child: Text('Previous',
                                style: context.textTheme.titleMedium.copyWith(
                                    fontSize: 21, fontWeight: FontWeight.w500)),
                          ),
                          const Spacer(),
                          Text('Next',
                              style: context.textTheme.titleMedium.copyWith(
                                  color: const Color(0xFF004DFF),
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(width: sizeW(0)),
                          Image.asset(
                            IconSet.arrowRightIcon,
                            width: sizeW(25),
                            height: size(25),
                          ),
                        ],
                      ),
                      SizedBox(height: size(50)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget blogCommentsTile(double defaultWidth, Comment comment) {
    return Padding(
      padding: EdgeInsets.only(bottom: size(20), right: size(445)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: comment.expanded
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.start,
        children: [
          Container(
            width: sizeW(19),
            height: size(65),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(comment.profile),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: sizeW(5)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(comment.name,
                      style: context.textTheme.bodyLargeBold
                          .copyWith(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.visible),
                  SizedBox(width: sizeW(2)),
                  KumeleReplyTag(
                    label: comment.date,
                    action: 'Reply',
                    labelStyle: context.textTheme.bodyLargeLight.copyWith(
                      fontSize: size(17),
                    ),
                    actionStyle: context.textTheme.bodyLargeBold.copyWith(
                      color: const Color(0xFF004DFF),
                    ),
                    dotStyle: context.textTheme.bodyLarge.copyWith(
                      fontSize: size(6),
                    ),
                  ),
                  SizedBox(width: sizeW(3)),
                  // Condition to hide "3 Replies" container for Jakob Hoffman
                  if (comment.replays.isNotEmpty &&
                      comment.name != "Jakob Hoffman")
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          comment.expanded = !comment.expanded;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 5,
                          top: 5,
                          right: 5,
                          bottom: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC533),
                          borderRadius: BorderRadius.circular(size(9)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('3 Replies',
                                style: context.textTheme.bodySmall
                                    .copyWith(color: Colors.black),
                                overflow: TextOverflow.visible),
                            SizedBox(width: sizeW(0)),
                            Flip(
                              isFlipped: comment.expanded,
                              child: Image.asset(
                                'assets/icons/drop_down.png',
                                width: sizeW(6),
                                height: size(15),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(width: sizeW(10)),
                ],
              ),
              Text(comment.comment,
                  style: context.textTheme.bodyMedium.copyWith(fontSize: 15),
                  maxLines: 2),
              if (comment.expanded) SizedBox(height: size(0)),
              if (comment.expanded)
                for (var i = 0; i < comment.replays.length; i++)
                  blogCommentsReplayTile(defaultWidth, comment.replays[i]),
              SizedBox(height: size(10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget blogCommentsReplayTile(double defaultWidth, Replay replay) {
    return Padding(
      padding: EdgeInsets.only(bottom: size(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: sizeW(60),
            height: size(60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              replay.profile,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: sizeW(0)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(replay.name,
                    style: context.textTheme.bodyLargeBold
                        .copyWith(fontWeight: FontWeight.w700),
                    overflow: TextOverflow.visible),
                KumeleReplyTag(
                  label: replay.date,
                  action: 'Replay',
                  labelStyle: context.textTheme.bodyLarge,
                  actionStyle: context.textTheme.bodyLargeBold.copyWith(
                    color: const Color(0xFF004DFF),
                  ),
                  dotStyle: context.textTheme.bodyLarge.copyWith(
                    fontSize: size(10),
                  ),
                ),
                KumeleTextLink(
                  leading: replay.tag.join(' '),
                  trailing: ' ${replay.comment}',
                  leadingStyle: context.textTheme.bodyMediumBold.copyWith(
                    color: const Color(0xFF004DFF),
                  ),
                  trailingStyle: context.textTheme.bodyMediumBold,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Social Media Icons
  List<Widget> socialMediaIcons() {
    return [
      socialIcon(IconSet.youtubeIcon),
      socialIcon(IconSet.facebookIcon),
      socialIcon(IconSet.instagramIcon),
      socialIcon(IconSet.pinterestIcon),
      socialIcon(IconSet.twitterIcon),
      socialIcon(IconSet.shareIcon),
    ];
  }

  Widget socialIcon(String icon) {
    return Padding(
      padding: EdgeInsets.only(right: sizeW(3)),
      child: GestureDetector(
        onTap: () {
          if (icon == IconSet.shareIcon) {
            showDialog(
              barrierColor: ColorSet.bcColor, // Less dark background

              context: context,
              builder: (BuildContext context) {
                return BlogPostShare();
              },
            );
          }
        },
        child: SizedBox(
          height: size(25),
          width: sizeW(8),
          child: Image.asset(
            icon,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
