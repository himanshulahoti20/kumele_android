import 'package:flutter_test/flutter_test.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';

void main() {
  test('new replies are inserted immediately using the requested parent', () {
    final parent = _comment('parent');
    final replyWithoutEchoedParent = _comment('reply');

    final comments = insertCommentReply(
      [parent],
      replyWithoutEchoedParent,
      parentId: parent.id,
    );

    expect(comments.single.replies.single.id, replyWithoutEchoedParent.id);
  });
}

BlogCommentModel _comment(String id) => BlogCommentModel(
      id: id,
      postId: 'post',
      authorId: 'author',
      content: id,
      moderation: 'APPROVED',
      createdAt: '2026-08-24T00:00:00Z',
      updatedAt: '2026-08-24T00:00:00Z',
      author: const BlogAuthor(id: 'author', displayName: 'Author'),
    );
