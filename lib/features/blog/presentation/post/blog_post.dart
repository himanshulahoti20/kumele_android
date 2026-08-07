import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/event_card/widgets/category_tag.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/blog/presentation/post/blog_post_share.dart';
import 'package:kuemele/shared/models/comment_model.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/comment_card.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class BlogPosts extends StatefulWidget {
  final BlogType? blogType;
  final bool scrollToComment;
  const BlogPosts({super.key, this.blogType, required this.scrollToComment});

  @override
  State<BlogPosts> createState() => _BlogPostsState();
}

class _BlogPostsState extends State<BlogPosts> {
  TextEditingController commentCTR = TextEditingController();
  List<bool> opened = [];
  bool poped = false;
  bool isLiked = false; // Track like state
  int likeCount = 0; // Track like count
  Map<String, bool> expandedComments = {};
  final scrollCtrl = AutoScrollController();

  @override
  void initState() {
    // final args = ModalRoute.of(context)?.settings.arguments;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollToComment) {
        scrollCtrl.scrollToIndex(1, preferPosition: AutoScrollPosition.begin);
      }
    });
  }

  @override
  void didUpdateWidget(covariant BlogPosts oldWidget) {
    if (widget.scrollToComment) {
      scrollCtrl.scrollToIndex(1, preferPosition: AutoScrollPosition.begin);
    }
    super.didUpdateWidget(oldWidget);
  }

  BlogType getBlog() {
    BlogType demoBlog = BlogType(
      image: IconSet.blogDefaultImage,
      title: "Singleton of Glen Ord 38-year old and the Singleton range.",
      type: "Van Life",
      host: "Adventure Explorer",
      date: "23 August, 2022",
      maincontent:
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.',
      blogPost: [
        BlogPost(
          image: "",
          videoUrl:
              "https://youtu.be/7I3VAWGvOEw?si=gxmjg7JrF2SdXhgs", // YouTube video URL
          content:
              "Aliqua id fugiat nostrud irure ex duis ea quis id quis ad et. Sunt qui esse pariatur duis deserunt mollit dolore cillum minim tempor enim. Elit aute irure tempor cupidatat incididunt sint deserunt ut voluptate aute id deserunt nisi.\n \n Nulla Lorem mollit cupidatat irure. Laborum magna nulla duis ullamco cillum dolor. Voluptate exercitation incididunt aliquip deserunt reprehenderit elit laborum. ",
        ),
      ],
      comments: [
        Comment(
          name: 'Josh Durrant',
          profile: testImage2,
          comment:
              "Great post! d fd vdfgfgfgd v   dfsf   dfsdf  fsc dsfdsfsdff ferfer ref sdfsdff sdf f efr d fsd f sf ef sd fs fsd f",
          date: "23 August, 2023",
          time: "10:30 AM",
          expanded: false,
          replays: [
            Replay(
              name: 'koffman',
              tag: ['Josh Durrant'],
              profile: testImage3,
              comment: "Thanks!",
              date: "23 August, 2023",
              time: "11:00 AM",
            ),
            Replay(
              name: 'Lurrant',
              tag: ['Josh Durrant'],
              profile: testImage5,
              comment: "Love it!",
              date: "23 August, 2023",
              time: "11:30 AM",
            ),
            Replay(
              name: 'Sarah Wilson',
              tag: ['Josh Durrant'],
              profile: testImage2,
              comment: "This is really interesting!",
              date: "23 August, 2023",
              time: "12:00 PM",
            ),
            Replay(
              name: 'Michael Chen',
              tag: ['Josh Durrant'],
              profile: testImage3,
              comment: "Great insights, thanks for sharing.",
              date: "23 August, 2023",
              time: "12:30 PM",
            ),
          ],
        ),
        Comment(
          name: 'Jakob Hoffman',
          profile: testImage4,
          comment: "Awesome!",
          date: "23 August, 2023",
          time: "11:15 AM",
          expanded: false,
          replays: [
            Replay(
              name: 'Lurrant',
              tag: ['Jakob Hoffman'],
              profile: testImage5,
              comment: "Love it!",
              date: "23 August, 2023",
              time: "11:30 AM",
            ),
          ],
        ),
      ],
    );
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final BlogType blogType =
        widget.blogType ?? args?['blogType'] as BlogType? ?? demoBlog;

    return blogType;
  }

  @override
  void dispose() {
    commentCTR.dispose();
    super.dispose();
  }

  double getPortraitSize(BuildContext context, double factor) {
    double width = MediaQuery.of(context).size.width;
    return width * factor; // Adjust factor as needed for portrait
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        InjectionHelper.homePageCubit.goBack(context);
      },
      child: Scaffold(
        backgroundColor: ColorSet.bgColor,
        body: WidgetByDevice(
          tablet: _buildTablet(),
          phone: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SingleChildScrollView(
                  controller: scrollCtrl,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorSet.bg2Color,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage(getBlog().image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: size(14),
                                    right: 14,
                                    child: CategoryTag(
                                      label: getBlog().type,
                                      iconPNG: IconSet.spritualityIcon,
                                      size: 20,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(24),
                              Text(getBlog().title,
                                  style: context.textTheme.bodyLargeBold
                                      .copyWith(fontWeight: FontWeight.w700)),
                              Gap(12),
                              Row(
                                children: [
                                  Text("Steve Austin",
                                      style: context.textTheme.bodySmall
                                          .copyWith(fontSize: 13),
                                      overflow: TextOverflow.ellipsis),
                                  Gap(8),
                                  Container(
                                    height: 3,
                                    width: 3,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorSet.revertBgColor),
                                  ),
                                  Gap(8),
                                  Text("23 August, 2022",
                                      style: context.textTheme.bodySmall
                                          .copyWith(fontSize: 13)),
                                ],
                              ),
                              Gap(12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isLiked = !isLiked;
                                            likeCount = isLiked ? 1 : 0;
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(bottom: size(5)),
                                          child: SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: isLiked
                                                ? Icon(
                                                    Icons.favorite,
                                                    color: ColorSet.bg2Color
                                                        .withValues(
                                                            alpha: 0.35),
                                                    size: size(30),
                                                  )
                                                : Icon(
                                                    Icons.favorite,
                                                    color: ColorSet.textColor
                                                        .withValues(
                                                            alpha: 0.35),
                                                    size: size(30),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                          '$likeCount ${AppLocalizations.of(context)!.blogLikesLabel}',
                                          style: context
                                              .textTheme.bodySmallSemiBold
                                              .copyWith(
                                                  fontWeight: FontWeight.w600)),
                                      SizedBox(width: 9),
                                      Row(
                                          spacing: 6,
                                          children: socialMediaIcons()),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: size(30)),
                              Text(getBlog().maincontent,
                                  style: context.textTheme.bodyLarge,
                                  overflow: TextOverflow.visible),
                              Gap(16),
                              for (var i = 0;
                                  i < getBlog().blogPost.length;
                                  i++)
                                _buildLandscapeBlogPostTile(
                                    getBlog().blogPost[i]),
                              Text(AppLocalizations.of(context)!.blogPostCommentsTitle,
                                  style: context.textTheme.bodyMedium),
                              Gap(10),
                              Container(
                                height: size(126),
                                padding: EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                  color: ColorSet.textBoxBgColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                  controller: commentCTR,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: AppLocalizations.of(context)!
                                        .addYourComment,
                                    hintStyle: TextStyle(
                                        color: Colors.grey[500], fontSize: 14),
                                    labelStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              Gap(14),
                              Align(
                                alignment: Alignment.centerRight,
                                child: isDark()
                                    ? AppButton.outline(
                                        label: AppLocalizations.of(context)!.publishComment,
                                        onPressed: () {},
                                      )
                                    : AppButton.primary(
                                        label: AppLocalizations.of(context)!.publishComment,
                                        onPressed: () {},
                                      ),
                              ),
                              Gap(32),
                              AutoScrollTag(
                                key: ValueKey('comment'),
                                controller: scrollCtrl,
                                index: 1,
                                child: ListView.separated(
                                  padding: EdgeInsets.all(10),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: CommentModel.fakeComments.length,
                                  separatorBuilder: (context, index) => Gap(30),
                                  itemBuilder: (context, index) {
                                    final comment =
                                        CommentModel.fakeComments[index];
                                    return CommentCard(comment: comment);
                                  },
                                ),
                              ),
                              SizedBox(height: size(300)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(IconSet.arrowBackIcon,
                                      width: 25, height: 25),
                                  GestureDetector(
                                    onTap: () => InjectionHelper.homePageCubit
                                        .goBack(context),
                                    child: Text(AppLocalizations.of(context)!.blogPostPreviousLabel,
                                        style: context.textTheme.titleMedium
                                            .copyWith(
                                                fontSize: 21,
                                                fontWeight: FontWeight.w500)),
                                  ),
                                  const Spacer(),
                                  Text(AppLocalizations.of(context)!.next,
                                      style: context.textTheme.titleMedium
                                          .copyWith(
                                              color: ColorSet.lightBlueColor,
                                              fontSize: 21,
                                              fontWeight: FontWeight.w500)),
                                  Image.asset(IconSet.arrowRightIcon,
                                      width: 25, height: 25),
                                ],
                              ),
                              SizedBox(height: size(50)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTablet() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
        child: Container(
          decoration: BoxDecoration(
            color: ColorSet.bg2Color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.blogsTitle,
                  style: TextStyle(
                    fontSize: size(22),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(thickness: 0.5, color: Colors.grey[200]),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: size(300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: AssetImage(getBlog().image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: size(14),
                          right: 14,
                          child: CategoryTag(
                            label: getBlog().type,
                            iconPNG: IconSet.spritualityIcon,
                            size: 20,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size(20)),
                    Text(getBlog().title,
                        style: context.textTheme.headlineLargeBold
                            .copyWith(fontWeight: FontWeight.w700),
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.visible),
                    SizedBox(height: size(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLiked = !isLiked;
                                  likeCount = isLiked ? 1 : 0;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(bottom: size(5)),
                                child: SizedBox(
                                  height: size(25),
                                  width: 25,
                                  child: isLiked
                                      ? Icon(
                                          Icons.favorite,
                                          color: ColorSet.bg2Color
                                              .withValues(alpha: 0.35),
                                          size: size(30),
                                        )
                                      : Icon(
                                          Icons.favorite,
                                          color: ColorSet.textColor
                                              .withValues(alpha: 0.35),
                                          size: size(30),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                                          '$likeCount ${AppLocalizations.of(context)!.blogLikesLabel}',
                                style: context.textTheme.heading3.copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            SizedBox(width: sizeW(10)),
                            Text("Steve Austin",
                                style: context.textTheme.bodyLarge
                                    .copyWith(fontSize: 18),
                                overflow: TextOverflow.ellipsis),
                            Gap(8),
                            Container(
                              height: size(5),
                              width: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size(5)),
                                color: ColorSet.revertBgColor,
                              ),
                            ),
                            Gap(8),
                            Text("23 August, 2022",
                                style: context.textTheme.bodyLarge
                                    .copyWith(fontSize: 18)),
                            SizedBox(width: sizeW(8)),
                            Row(spacing: 6, children: socialMediaIcons()),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: size(30)),
                    Text(getBlog().maincontent,
                        style:
                            context.textTheme.bodyLarge.copyWith(fontSize: 19),
                        overflow: TextOverflow.visible),
                    SizedBox(height: size(20)),
                    for (var i = 0; i < getBlog().blogPost.length; i++)
                      _buildLandscapeBlogPostTile(getBlog().blogPost[i]),
                    SizedBox(height: size(10)),
                    Text(AppLocalizations.of(context)!.blogPostCommentsTitle,
                        style: context.textTheme.titleLarge
                            .copyWith(fontSize: 23)),
                    SizedBox(height: size(20)),
                    Container(
                      height: size(126),
                      padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: ColorSet.textBoxBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: commentCTR,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Add your comment....",
                          hintStyle:
                              TextStyle(color: Colors.grey[500], fontSize: 19),
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: size(30)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: isDark()
                          ? AppButton.outline(
                              label: AppLocalizations.of(context)!.publishComment,
                              onPressed: () {},
                            )
                          : AppButton.primary(
                              label: AppLocalizations.of(context)!.publishComment,
                              onPressed: () {},
                            ),
                    ),
                    SizedBox(height: size(40)),
                    AutoScrollTag(
                      key: ValueKey('comment'),
                      controller: scrollCtrl,
                      index: 1,
                      child: ListView.separated(
                        padding: EdgeInsets.all(10),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: CommentModel.fakeComments.length,
                        separatorBuilder: (context, index) => Gap(30),
                        itemBuilder: (context, index) {
                          final comment = CommentModel.fakeComments[index];
                          return CommentCard(comment: comment);
                        },
                      ),
                    ),
                    // ListView(
                    //   padding: EdgeInsets.all(10),
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   children: getBlog().comments.map((comment) => buildComment(comment, 0)).toList(),
                    // ),
                    SizedBox(height: size(300)),
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
                          onTap: () =>
                              InjectionHelper.homePageCubit.goBack(context),
                          child: Text(AppLocalizations.of(context)!.blogPostPreviousLabel,
                              style: context.textTheme.titleMedium.copyWith(
                                  fontSize: 21, fontWeight: FontWeight.w500)),
                        ),
                        const Spacer(),
                        Text(AppLocalizations.of(context)!.next,
                            style: context.textTheme.titleMedium.copyWith(
                                color: ColorSet.lightBlueColor,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeBlogPostTile(BlogPost blogPost) {
    String? videoId = YoutubePlayerController.convertUrlToId(blogPost.videoUrl);
    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId!,
      autoPlay: false,
      params: const YoutubePlayerParams(
        mute: false,
        enableCaption: true,
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          child: YoutubePlayer(
            controller: controller,
          ),
        ),
        SizedBox(height: size(10)),
        Text(blogPost.content,
            style: context.textTheme.labelSmall
                .copyWith(fontSize: FormFactor.isTablet ? 19 : 16),
            textAlign: TextAlign.start,
            overflow: TextOverflow.visible),
        SizedBox(height: size(30)),
      ],
    );
  }

  Widget buildComment(Comment comment, int level) {
    if (!expandedComments.containsKey(comment.name)) {
      expandedComments[comment.name] = false;
    }

    bool isExpanded = expandedComments[comment.name] ?? false;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Row(
                  children: [
                    Text(
                      comment.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: ColorSet.textColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "•",
                      style: TextStyle(
                        color: ColorSet.textColor,
                        fontSize: 27,
                      ),
                    ),
                    Text(
                      comment.date,
                      style: TextStyle(
                        color: ColorSet.textColor,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "•",
                      style: TextStyle(
                        color: ColorSet.textColor,
                        fontSize: 27,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            AppLocalizations.of(context)!.reply,
                            style: TextStyle(
                              color: ColorSet.lightBlueColor,
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        if (comment.replays.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              toggleReplies(comment.name);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFC533),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${comment.replays.length} ${AppLocalizations.of(context)!.blogRepliesCountLabel}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: Image.asset(
                                      IconSet.dropDownIcon,
                                      color: Colors.black,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Text(
                  comment.comment,
                  style: TextStyle(fontSize: 19),
                ),
              ),
              SizedBox(height: 20),
              if (comment.replays.isNotEmpty && isExpanded)
                Column(
                  children: List.generate(comment.replays.length, (index) {
                    final reply = comment.replays[index];
                    return buildReply(reply, index, comment.replays.length);
                  }),
                ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(comment.profile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (comment.replays.isNotEmpty && isExpanded)
              Dash(
                direction: Axis.vertical,
                length: comment.replays.length * 101.0,
                dashColor: ColorSet.textColor,
              ),
          ],
        ),
      ],
    );
  }

  Widget buildReply(Replay reply, int index, int totalReplies) {
    bool isFirst = index == 0;
    bool isLast = index == totalReplies - 1;
    bool isMiddle = !isFirst && !isLast;
    bool stepNext = index == 1;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (isMiddle) ...[
              if (stepNext) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: SizedBox(
                    width: 2,
                    height: 40,
                    child: Dash(
                      direction: Axis.vertical,
                      length: 40.0,
                      dashColor: ColorSet.textColor,
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(height: 0)
              ],
              Padding(
                padding: EdgeInsets.only(
                    left: 40.0,
                    top: stepNext
                        ? 0
                        : isLast
                            ? 50
                            : 17),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(reply.profile),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: SizedBox(
                  width: 2,
                  height: 50,
                  child: Dash(
                    direction: Axis.vertical,
                    length: 40.0,
                    dashColor: ColorSet.textColor,
                  ),
                ),
              ),
            ] else ...[
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Row(
                    children: [
                      Dash(
                        direction: Axis.horizontal,
                        dashColor: ColorSet.textColor,
                        length: 40,
                      ),
                      Container(
                        width: 50,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(reply.profile),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
        SizedBox(width: 15),
        Padding(
          padding: EdgeInsets.only(
              top: isFirst
                  ? 0
                  : stepNext
                      ? 20
                      : 0,
              bottom: isLast ? 20 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    reply.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "•",
                    style: TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 27,
                    ),
                  ),
                  Text(
                    reply.date,
                    style: TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "•",
                    style: TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 27,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      AppLocalizations.of(context)!.reply,
                      style: TextStyle(
                        color: ColorSet.lightBlueColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${reply.tag.join(', ')} ",
                      style: TextStyle(
                        color: ColorSet.lightBlueColor,
                        fontSize: 17,
                      ),
                    ),
                    TextSpan(
                      text:
                          "${AppLocalizations.of(context)!.blogReplyPlaceholderText} ",
                      style: TextStyle(
                        color: ColorSet.textColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void toggleReplies(String commentName) {
    setState(() {
      expandedComments[commentName] = !(expandedComments[commentName] ?? false);
    });
  }

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
    final size = FormFactor.isTablet ? 32.0 : 26.0;
    return GestureDetector(
      onTap: () {
        if (icon == IconSet.shareIcon) {
          showDialog(
            barrierColor: ColorSet.bcColor,
            context: context,
            builder: (BuildContext context) {
              return BlogPostShare();
            },
          );
        }
      },
      child: SizedBox(
          height: size,
          width: size,
          child: Image.asset(icon, fit: BoxFit.cover)),
    );
  }
}

// Custom Painter to Draw Lines
class ReplyLinePainter extends CustomPainter {
  final double avatarSize; // Size of the avatar container

  ReplyLinePainter({required this.avatarSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw a vertical dotted line from the parent comment's avatar to the first reply
    double dashWidth = 5, dashSpace = 5;
    double startY =
        avatarSize / 2; // Start from the middle of the parent avatar
    double endY = size.height; // End at the bottom of the replies section

    while (startY < endY) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Draw a horizontal dotted line connecting the parent comment's avatar to the replies' avatars
    double startX = 0;
    double endX = size.width *
        0.1; // Adjust this value to align with the replies' avatars
    double horizontalLineY =
        avatarSize / 2; // Align with the middle of the avatars

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, horizontalLineY),
        Offset(startX + dashWidth, horizontalLineY),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Dash extends StatelessWidget {
  final double length;
  final Axis direction;
  final Color dashColor;

  const Dash({
    super.key,
    required this.length,
    required this.direction,
    this.dashColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        direction == Axis.horizontal ? length : 1,
        direction == Axis.vertical ? length : 1,
      ),
      painter: _DashPainter(
        direction: direction,
        dashColor: dashColor,
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  final Axis direction;
  final Color dashColor;

  _DashPainter({
    required this.direction,
    required this.dashColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dashColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 3.0;
    double start = 0.0;
    final path = Path();

    if (direction == Axis.horizontal) {
      while (start < size.width) {
        path.moveTo(start, 0);
        path.lineTo(start + dashWidth, 0);
        start += dashWidth + dashSpace;
      }
    } else {
      while (start < size.height) {
        path.moveTo(0, start);
        path.lineTo(0, start + dashWidth);
        start += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
