import 'package:kuemele/shared/components/icons.dart';

class CommentModel {
  final String author;
  final String comment;
  final String timestamp;
  final String image;
  final List<CommentModel> replies;

  const CommentModel({
    required this.author,
    required this.comment,
    required this.timestamp,
    required this.image,
    this.replies = const [],
  });

  bool get hasReplies => replies.isNotEmpty;

  static List<CommentModel> fakeComments = [
    CommentModel(
      author: 'Alice',
      comment: 'Great post!',
      timestamp: '18 July 2025',
      image: testImage2,
      replies: [
        CommentModel(
          author: 'Bob',
          comment: 'Thanks, Alice!',
          timestamp: '18 July 2025',
          image: testImage3,
        ),
        CommentModel(
          author: 'Eve',
          comment: 'Nice insights!',
          timestamp: '18 July 2025',
          image: testImage4,
        ),
        CommentModel(
          author: 'Alice',
          comment: 'You\'re welcome!',
          timestamp: '18 July 2025',
          image: testImage3,
        ),
        CommentModel(
          author: 'Charlie',
          comment: 'I agree with Bob!',
          timestamp: '18 July 2025',
          image: testImage4,
        ),
      ],
    ),
    CommentModel(
      author: 'Charlie',
      comment: 'I totally agree with you.',
      timestamp: '19 July 2025',
      image: testImage3,
    ),
    CommentModel(
      author: 'Dave',
      comment: 'Can you share more details?',
      timestamp: '20 July 2025',
      image: testImage4,
      replies: [
        CommentModel(
          author: 'Eve',
          comment: 'Sure, I will update soon.',
          timestamp: '20 July 2025',
          image: testImage3,
          replies: [
            CommentModel(
              author: 'Dave',
              comment: 'Looking forward to it!',
              timestamp: '21 July 2025',
              image: testImage4,
            ),
            CommentModel(
              author: 'Frank',
              comment: 'I have the same question.',
              timestamp: '21 July 2025',
              image: testImage2,
            ),
            CommentModel(
              author: 'Grace',
              comment: 'Please keep us posted.',
              timestamp: '21 July 2025',
              image: testImage3,
            ),
          ],
        ),
        CommentModel(
          author: 'Dave',
          comment: 'Me too!',
          timestamp: '19 July 2025',
          image: testImage2,
        ),
        CommentModel(
          author: 'Frank',
          comment: 'Same here!',
          timestamp: '19 July 2025',
          image: testImage3,
        ),
      ],
    ),
  ];
}
