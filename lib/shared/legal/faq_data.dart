/// A single FAQ entry rendered as a card (question + answer).
class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

/// Static FAQ content, mirroring the `FAQNativeView` from the iOS app.
abstract final class FaqData {
  FaqData._();

  static const List<FaqItem> items = [
    FaqItem(
      question: 'How do I create an account?',
      answer:
          'You can create an account using your email address, phone number, or '
          'Apple ID. Follow the on-screen instructions to complete the '
          'registration.',
    ),
    FaqItem(
      question: 'How do I find events?',
      answer:
          'Use the search function in the app to browse events by category, '
          'location, or date. You can also filter results by your interests.',
    ),
    FaqItem(
      question: 'How do I book a ticket?',
      answer:
          'Select an event, choose the number of tickets, and complete the '
          'payment. You will receive a confirmation email and a QR code for '
          'entry.',
    ),
    FaqItem(
      question: 'Can I cancel my ticket?',
      answer:
          'You can cancel your ticket as described in the event organiser\'s '
          'policy. Some tickets may be non-refundable.',
    ),
    FaqItem(
      question: 'How do I create an event?',
      answer:
          'Go to the Events tab, tap "Create Event", and fill in the event '
          'details. Your event will be reviewed before it is published.',
    ),
    FaqItem(
      question: 'How do I get a refund?',
      answer:
          'Refunds are subject to the event organiser\'s refund policy. If an '
          'event is cancelled, you may be entitled to a refund as required by '
          'law.',
    ),
    FaqItem(
      question: 'Is there a support team?',
      answer:
          'Yes, our support team is available 24/7. You can contact us through '
          'the app or by email at support@kumele.com.',
    ),
    FaqItem(
      question: 'How do I report a problem?',
      answer:
          'You can report a problem by going to the relevant event or profile '
          'and using the "Report" option.',
    ),
    FaqItem(
      question: 'How do I delete my account?',
      answer:
          'You can delete your account by going to Settings > Delete Account. '
          'This action is irreversible.',
    ),
    FaqItem(
      question: 'What happens to my data?',
      answer:
          'Your data is processed in accordance with our Privacy Policy. You '
          'can request a copy or deletion of your data at any time.',
    ),
    FaqItem(
      question: 'Can I use Kumele on multiple devices?',
      answer:
          'Yes, your Kumele account can be used on multiple devices. Your data '
          'will be synced across devices.',
    ),
    FaqItem(
      question: 'How do I earn Kumele Coins?',
      answer:
          'Kumele Coins are earned by attending events, leaving ratings, and '
          'inviting friends. Coins have no monetary value.',
    ),
    FaqItem(
      question: 'What are the payment options?',
      answer:
          'We accept major credit cards, debit cards, iDEAL, and other payment '
          'methods depending on your location.',
    ),
    FaqItem(
      question: 'What is Kumele?',
      answer:
          'Kumele is a platform that connects people through hobbies, '
          'activities, and events.',
    ),
  ];
}
