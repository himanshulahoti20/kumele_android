enum GuidelineTab {
  communityGuidelines('Community\nGuidelines'),
  faq('How To'),
  popular('Popular'),
  knowledgeBase('Knowledge\nBase');

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

  static const chatInputHint = 'Type a message';
  static const aiAssistantName = 'Kumele AI';

  static const double chatAvatarSize = 50;
  static const double chatBubbleIconSize = 40;
  static const double chatActionIconSize = 20;
}
