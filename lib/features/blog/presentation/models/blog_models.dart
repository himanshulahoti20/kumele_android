class Replay {
  final String name;
  final List<String> tag;
  final String profile;
  final String comment;
  final String date;
  final String time;

  Replay({
    required this.name,
    required this.tag,
    required this.profile,
    required this.comment,
    required this.date,
    required this.time,
  });
}

class Comment {
  final String name;
  final String profile;
  final String comment;
  final String date;
  final String time;
  final List<Replay> replays;
  bool expanded;

  Comment({
    required this.name,
    required this.profile,
    required this.comment,
    required this.date,
    required this.time,
    required this.replays,
    required this.expanded,
  });
}

class BlogPost {
  final String image;
  final String content;
  final String videoUrl;

  BlogPost({
    required this.image,
    required this.content,
    required this.videoUrl,
  });
}

class BlogType {
  final String image;
  final String title;
  final String type;
  final String host;
  final String date;
  final List<BlogPost> blogPost;
  final List<Comment> comments;
  final String maincontent;

  BlogType({
    required this.image,
    required this.title,
    required this.type,
    required this.host,
    required this.date,
    required this.blogPost,
    required this.comments,
    required this.maincontent,
  });
}

class BlogCategory {
  final String label;
  final bool isSelected;

  const BlogCategory({
    required this.label,
    this.isSelected = false,
  });

  static List<BlogCategory> get placeholders => const [
        BlogCategory(label: 'All'),
        BlogCategory(label: 'Food'),
        BlogCategory(label: 'Travel'),
        BlogCategory(label: 'Sports'),
        BlogCategory(label: 'Music'),
      ];

  BlogCategory copyWith({
    String? label,
    bool? isSelected,
  }) {
    return BlogCategory(
      label: label ?? this.label,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class BlogAuthor {
  final String id;
  final String displayName;
  final String? avatar;

  const BlogAuthor({
    required this.id,
    required this.displayName,
    this.avatar,
  });

  factory BlogAuthor.fromJson(Map<String, dynamic> json) {
    return BlogAuthor(
      id: json['id'] as String? ?? '',
      displayName: json['display_name'] as String? ??
          json['displayName'] as String? ??
          'Unknown',
      avatar: json['avatar'] as String?,
    );
  }
}

class BlogHobbyCategory {
  final String id;
  final String name;
  final String slug;

  const BlogHobbyCategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory BlogHobbyCategory.fromJson(Map<String, dynamic> json) {
    return BlogHobbyCategory(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }
}

class BlogContentBlock {
  final String type;
  final String value;

  const BlogContentBlock({
    required this.type,
    required this.value,
  });

  factory BlogContentBlock.fromJson(Map<String, dynamic> json) {
    return BlogContentBlock(
      type: json['type'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }
}

class BlogTocItem {
  final String text;
  final int level;
  final String anchor;

  const BlogTocItem({
    required this.text,
    required this.level,
    required this.anchor,
  });

  factory BlogTocItem.fromJson(Map<String, dynamic> json) {
    return BlogTocItem(
      text: json['text'] as String? ?? '',
      level: json['level'] as int? ?? 1,
      anchor: json['anchor'] as String? ?? '',
    );
  }
}

class BlogPostModel {
  final String id;
  final String title;
  final String slug;
  final String excerpt;
  final String? coverImage;
  final int readingTimeMinutes;
  final int wordCount;
  final int likeCount;
  final int commentCount;
  final String createdAt;
  final String language;
  final String visibility;
  final BlogAuthor author;
  final BlogHobbyCategory? hobbyCategory;
  final String? contentHtml;
  final List<BlogContentBlock>? contentBlocks;
  final List<BlogTocItem>? toc;
  final bool? isLiked;
  final String? shareUrl;
  final String? youtubeLink;
  final String? facebookLink;
  final String? instagramLink;
  final String? pinterestLink;
  final String? twitterLink;

  const BlogPostModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    this.coverImage,
    required this.readingTimeMinutes,
    required this.wordCount,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.language,
    required this.visibility,
    required this.author,
    this.hobbyCategory,
    this.contentHtml,
    this.contentBlocks,
    this.toc,
    this.isLiked,
    this.shareUrl,
    this.youtubeLink,
    this.facebookLink,
    this.instagramLink,
    this.pinterestLink,
    this.twitterLink,
  });

  factory BlogPostModel.fromJson(Map<String, dynamic> json) {
    return BlogPostModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      excerpt: json['excerpt'] as String? ?? '',
      coverImage:
          json['cover_image'] as String? ?? json['coverImage'] as String?,
      readingTimeMinutes: json['reading_time_minutes'] as int? ??
          json['readingTimeMinutes'] as int? ??
          0,
      wordCount: json['word_count'] as int? ?? json['wordCount'] as int? ?? 0,
      likeCount: json['like_count'] as int? ?? json['likeCount'] as int? ?? 0,
      commentCount:
          json['comment_count'] as int? ?? json['commentCount'] as int? ?? 0,
      createdAt:
          json['created_at'] as String? ?? json['createdAt'] as String? ?? '',
      language: json['language'] as String? ?? 'en',
      visibility: json['visibility'] as String? ?? 'app_only',
      author:
          BlogAuthor.fromJson(json['author'] as Map<String, dynamic>? ?? {}),
      hobbyCategory: json['hobby_category'] != null
          ? BlogHobbyCategory.fromJson(
              json['hobby_category'] as Map<String, dynamic>)
          : null,
      contentHtml:
          json['content_html'] as String? ?? json['contentHtml'] as String?,
      contentBlocks: (json['content_blocks'] as List<dynamic>?)
          ?.map((e) => BlogContentBlock.fromJson(e as Map<String, dynamic>))
          .toList(),
      toc: (json['toc'] as List<dynamic>?)
          ?.map((e) => BlogTocItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLiked: json['is_liked'] as bool? ?? json['isLiked'] as bool?,
      shareUrl: json['share_url'] as String? ?? json['shareUrl'] as String?,
      youtubeLink:
          json['youtube_link'] as String? ?? json['youtubeLink'] as String?,
      facebookLink:
          json['facebook_link'] as String? ?? json['facebookLink'] as String?,
      instagramLink:
          json['instagram_link'] as String? ?? json['instagramLink'] as String?,
      pinterestLink:
          json['pinterest_link'] as String? ?? json['pinterestLink'] as String?,
      twitterLink:
          json['twitter_link'] as String? ?? json['twitterLink'] as String?,
    );
  }

  static List<BlogPostModel> get placeholders => List.generate(
        4,
        (index) => BlogPostModel(
          id: 'placeholder-$index',
          title: 'Placeholder title for blog post loading effect',
          slug: 'placeholder-slug',
          excerpt: 'Placeholder excerpt for skeleton loading.',
          readingTimeMinutes: 2,
          wordCount: 150,
          likeCount: 0,
          commentCount: 0,
          createdAt: '2026-06-13T07:53:38.134Z',
          language: 'en',
          visibility: 'app_only',
          author: const BlogAuthor(id: 'author', displayName: 'Loading Author'),
          hobbyCategory: const BlogHobbyCategory(
              id: 'cat', name: 'Category', slug: 'category'),
        ),
      );
}

class BlogCommentModel {
  final String id;
  final String postId;
  final String authorId;
  final String content;
  final String? parentId;
  final String moderation;
  final String createdAt;
  final String updatedAt;
  final BlogAuthor author;
  final List<BlogCommentModel> replies;

  const BlogCommentModel({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    this.parentId,
    required this.moderation,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
    this.replies = const [],
  });

  factory BlogCommentModel.fromJson(Map<String, dynamic> json) {
    return BlogCommentModel(
      id: json['id'] as String? ?? '',
      postId: json['postId'] as String? ?? json['post_id'] as String? ?? '',
      authorId:
          json['authorId'] as String? ?? json['author_id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      parentId: json['parentId'] as String? ?? json['parent_id'] as String?,
      moderation: json['moderation'] as String? ?? 'PENDING',
      createdAt:
          json['createdAt'] as String? ?? json['created_at'] as String? ?? '',
      updatedAt:
          json['updatedAt'] as String? ?? json['updated_at'] as String? ?? '',
      author:
          BlogAuthor.fromJson(json['author'] as Map<String, dynamic>? ?? {}),
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => BlogCommentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
