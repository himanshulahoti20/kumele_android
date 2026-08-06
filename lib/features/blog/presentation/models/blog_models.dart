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
      id: json['id']?.toString() ?? '',
      displayName: (json['display_name'] ?? json['displayName'] ?? json['name'])
              ?.toString() ??
          'Unknown',
      avatar: (json['avatar'] ?? json['avatarUrl'])?.toString(),
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
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
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
      type: json['type']?.toString() ?? '',
      value: (json['value'] ?? json['content'] ?? '').toString(),
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
      text: json['text']?.toString() ?? '',
      level: _asInt(json['level'], fallback: 1),
      anchor: json['anchor']?.toString() ?? '',
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
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      excerpt: json['excerpt']?.toString() ?? '',
      coverImage:
          (json['cover_image'] ?? json['coverImage'] ?? json['coverImageUrl'])
              ?.toString(),
      readingTimeMinutes: _asInt(
        json['reading_time_minutes'] ?? json['readingTimeMinutes'],
      ),
      wordCount: _asInt(json['word_count'] ?? json['wordCount']),
      likeCount: _asInt(json['like_count'] ?? json['likeCount']),
      commentCount: _asInt(json['comment_count'] ?? json['commentCount']),
      createdAt: (json['created_at'] ?? json['createdAt'])?.toString() ?? '',
      language: json['language']?.toString() ?? 'en',
      visibility: json['visibility']?.toString() ?? 'app_only',
      author: BlogAuthor.fromJson(_asMap(json['author'])),
      hobbyCategory:
          json['hobby_category'] != null || json['hobbyCategory'] != null
              ? BlogHobbyCategory.fromJson(
                  _asMap(json['hobby_category'] ?? json['hobbyCategory']),
                )
              : null,
      contentHtml: (json['content_html'] ?? json['contentHtml'])?.toString(),
      contentBlocks:
          ((json['content_blocks'] ?? json['contentBlocks']) as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => BlogContentBlock.fromJson(e.cast<String, dynamic>()))
              .toList(),
      toc: (json['toc'] as List<dynamic>?)
          ?.whereType<Map>()
          .map((e) => BlogTocItem.fromJson(e.cast<String, dynamic>()))
          .toList(),
      isLiked: json['is_liked'] as bool? ?? json['isLiked'] as bool?,
      shareUrl: (json['share_url'] ?? json['shareUrl'])?.toString(),
      youtubeLink: (json['youtube_link'] ?? json['youtubeLink'])?.toString(),
      facebookLink: (json['facebook_link'] ?? json['facebookLink'])?.toString(),
      instagramLink:
          (json['instagram_link'] ?? json['instagramLink'])?.toString(),
      pinterestLink:
          (json['pinterest_link'] ?? json['pinterestLink'])?.toString(),
      twitterLink: (json['twitter_link'] ?? json['twitterLink'])?.toString(),
    );
  }

  BlogPostModel copyWithLike({bool? isLiked, int? likeCount}) {
    return BlogPostModel(
      id: id,
      title: title,
      slug: slug,
      excerpt: excerpt,
      coverImage: coverImage,
      readingTimeMinutes: readingTimeMinutes,
      wordCount: wordCount,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount,
      createdAt: createdAt,
      language: language,
      visibility: visibility,
      author: author,
      hobbyCategory: hobbyCategory,
      contentHtml: contentHtml,
      contentBlocks: contentBlocks,
      toc: toc,
      isLiked: isLiked ?? this.isLiked,
      shareUrl: shareUrl,
      youtubeLink: youtubeLink,
      facebookLink: facebookLink,
      instagramLink: instagramLink,
      pinterestLink: pinterestLink,
      twitterLink: twitterLink,
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
      id: json['id']?.toString() ?? '',
      postId: (json['postId'] ?? json['post_id'])?.toString() ?? '',
      authorId: (json['authorId'] ?? json['author_id'])?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      parentId: (json['parentId'] ?? json['parent_id'])?.toString(),
      moderation: json['moderation']?.toString() ?? 'PENDING',
      createdAt: (json['createdAt'] ?? json['created_at'])?.toString() ?? '',
      updatedAt: (json['updatedAt'] ?? json['updated_at'])?.toString() ?? '',
      author: BlogAuthor.fromJson(_asMap(json['author'])),
      replies: (json['replies'] as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => BlogCommentModel.fromJson(e.cast<String, dynamic>()))
              .toList() ??
          const [],
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const {};
}
