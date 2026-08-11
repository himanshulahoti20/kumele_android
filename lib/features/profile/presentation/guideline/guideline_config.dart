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
  static const chatInputHint = 'Type a message';
  static const aiAssistantName = 'Kumele AI';

  static const double chatAvatarSize = 50;
  static const double chatBubbleIconSize = 40;
  static const double chatActionIconSize = 20;
  static const double dateHeaderWidth = 165;
}
