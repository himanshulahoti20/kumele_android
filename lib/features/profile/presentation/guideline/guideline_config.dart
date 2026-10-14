enum GuidelineTab {
  communityGuidelines('Community\nGuidelines'),
  faq('FAQ'),
  knowledgeBase('Knowledge\nBase');

  const GuidelineTab(this.label);

  final String label;

  /// Tabs currently shown (Knowledge Base is hidden, see
  /// [GuidelineConfig.showKnowledgeBase]).
  static List<GuidelineTab> get visible => values
      .where((tab) =>
          tab != knowledgeBase || GuidelineConfig.showKnowledgeBase)
      .toList();

  static GuidelineTab fromLabel(String? label) {
    return visible.firstWhere(
      (tab) => tab.label == label,
      orElse: () => GuidelineTab.communityGuidelines,
    );
  }
}

abstract final class GuidelineConfig {
  GuidelineConfig._();

  /// The Knowledge Base (AI chat) tab is hidden for now; flip to bring it back.
  static const showKnowledgeBase = false;

  static const chatInputHint = 'Type a message';
  static const aiAssistantName = 'Kumele AI';

  static const double chatAvatarSize = 50;
  static const double chatBubbleIconSize = 40;
  static const double chatActionIconSize = 20;
}
