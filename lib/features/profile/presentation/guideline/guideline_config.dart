import 'package:kuemele/features/chat/models/chat_config.dart';

enum GuidelineTab {
  communityGuidelines('Community Guidelines'),
  howTo('How to'),
  popular('Popular'),
  knowledgeBase('Knowledge Base');

  const GuidelineTab(this.label);

  final String label;

  static GuidelineTab fromLabel(String? label) {
    return GuidelineTab.values.firstWhere(
      (tab) => tab.label == label,
      orElse: () => GuidelineTab.communityGuidelines,
    );
  }
}

abstract final class GuidelineConfig {
  GuidelineConfig._();

  static const guidelinesEmptyMessage = 'No community guidelines available.';
  static const guidelinesErrorMessage = 'Unable to load community guidelines.';
  static const howToPlaceholder = 'How to content coming soon.';
  static const popularPlaceholder = 'Popular content coming soon.';
  static const chatInputHint = 'Type a message';
  static const defaultMention = 'Alkesh kumar';
  static const aiAssistantName = 'AI Assistant';

  static const double chatAvatarSize = 50;
  static const double chatBubbleIconSize = 40;
  static const double chatActionIconSize = 20;
  static const double dateHeaderWidth = 165;

  static final List<ChatMessage> demoKnowledgeBaseChats = [
    ChatMessage.fakeOther('Mon 8th Oct 2025', 'Welcome to my event'),
    ChatMessage.fakeMe(
      'Mon 8th Oct 2025',
      "Absolutely! Can't wait to hit the road.",
    ),
    ChatMessage.fakeOther('Yesterday', 'Welcome to my event'),
    ChatMessage.fakeMe('Today', "Absolutely! Can't wait to hit the road."),
  ];
}
