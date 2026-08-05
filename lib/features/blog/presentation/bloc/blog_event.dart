abstract class BlogEvent {
  const BlogEvent();
}

class BlogInit extends BlogEvent {
  const BlogInit();
}

class BlogRefresh extends BlogEvent {
  const BlogRefresh();
}

class BlogSearchChanged extends BlogEvent {
  final String query;
  const BlogSearchChanged(this.query);
}

class BlogSelectCategory extends BlogEvent {
  final int index;
  const BlogSelectCategory(this.index);
}

class BlogFetchDetails extends BlogEvent {
  final String blogId;
  const BlogFetchDetails(this.blogId);
}

class BlogPostComment extends BlogEvent {
  final String blogId;
  final String content;
  final String? parentId;
  const BlogPostComment(this.blogId, this.content, {this.parentId});
}

class BlogFetchComments extends BlogEvent {
  final String blogId;
  const BlogFetchComments(this.blogId);
}
