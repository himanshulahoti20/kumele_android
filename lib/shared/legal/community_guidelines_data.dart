/// Types of content blocks inside the Community Guidelines document.
enum GuidelineBlockType {
  /// Main document title (24 bold)
  header,

  /// Intro paragraph (15 regular)
  intro,

  /// Section header (18 bold)
  section,

  /// Policy item with a title (15 semibold) and description (14 regular)
  policy,

  /// Sub-section header (16 semibold)
  subSection,

  /// Bullet point (14 regular, prefixed with "•")
  bullet,

  /// Emphasised note (15 bold)
  note,
}

/// A single content block inside the Community Guidelines document.
class GuidelineBlock {
  const GuidelineBlock.header(this.text)
      : type = GuidelineBlockType.header,
        description = null;

  const GuidelineBlock.intro(this.text)
      : type = GuidelineBlockType.intro,
        description = null;

  const GuidelineBlock.section(this.text)
      : type = GuidelineBlockType.section,
        description = null;

  const GuidelineBlock.policy(this.text, this.description)
      : type = GuidelineBlockType.policy;

  const GuidelineBlock.subSection(this.text)
      : type = GuidelineBlockType.subSection,
        description = null;

  const GuidelineBlock.bullet(this.text)
      : type = GuidelineBlockType.bullet,
        description = null;

  const GuidelineBlock.note(this.text)
      : type = GuidelineBlockType.note,
        description = null;

  final GuidelineBlockType type;
  final String text;
  final String? description;
}

/// Static content for the native Community Guidelines document, mirroring the
/// `CommunityGuidelinesNativeView` from the iOS app.
abstract final class CommunityGuidelinesData {
  CommunityGuidelinesData._();

  static const List<GuidelineBlock> blocks = [
    GuidelineBlock.header('Community Guidelines'),
    GuidelineBlock.intro(
        'Welcome to the Kumele community. To keep everyone safe, we have '
        'established a set of community policies and safety guidelines. As a '
        'member of the Kumele community, you must follow these policies and '
        'guidelines.'),
    GuidelineBlock.intro(
        'Your offline actions may result in the termination of your Kumele '
        'account. This includes actions taken outside the app, including at '
        'events, that are reported and verified.'),
    GuidelineBlock.intro(
        'Below is a list of our community policies and meet-up safety tips. We '
        'may update them from time to time, so please check this page '
        'regularly.'),
    GuidelineBlock.section('Community Policies'),
    GuidelineBlock.policy('Respect',
        'Treat all members with respect and kindness. Harassment, bullying, and '
        'hate speech are not tolerated.'),
    GuidelineBlock.policy('Professional Conduct',
        'Behave professionally and appropriately at all events and in all '
        'interactions.'),
    GuidelineBlock.policy('Safe Events',
        'Hosts must ensure their events are safe, lawful, and inclusive.'),
    GuidelineBlock.policy('Confidentiality',
        'Do not share private information or photos of other members without '
        'their consent.'),
    GuidelineBlock.section('Meet-up Safety Tips'),
    GuidelineBlock.intro(
        'To reduce risks and keep the community safe, please follow these tips:'),
    GuidelineBlock.subSection('Online Safety'),
    GuidelineBlock.bullet('Do not share your phone number or address publicly.'),
    GuidelineBlock.bullet('Report suspicious messages or profiles.'),
    GuidelineBlock.bullet('Never send money to people you have not met in person.'),
    GuidelineBlock.subSection('Meeting in Person'),
    GuidelineBlock.bullet('Meet in public places whenever possible.'),
    GuidelineBlock.bullet('Tell a friend or family member where you are going.'),
    GuidelineBlock.bullet('Arrive and leave events on your own terms.'),
    GuidelineBlock.section('LGBTQ+'),
    GuidelineBlock.intro(
        'Kumele welcomes members of the LGBTQ+ community. We do not tolerate '
        'discrimination based on sexual orientation, gender identity, or gender '
        'expression.'),
    GuidelineBlock.section('Sex & Consent'),
    GuidelineBlock.bullet('Sexual contact requires clear and enthusiastic consent.'),
    GuidelineBlock.bullet('Do not post sexual content or organise sexual events.'),
    GuidelineBlock.bullet('Respect boundaries. If someone says no, stop.'),
    GuidelineBlock.section('Resources for Help'),
    GuidelineBlock.note(
        'If you are in immediate danger, contact local emergency services first.'),
    GuidelineBlock.subSection('Emergency Numbers (Immediate Danger)'),
    GuidelineBlock.bullet('🏥 Emergency (Ambulance/Fire/Police): 112'),
    GuidelineBlock.bullet('🚔 Police: 101'),
    GuidelineBlock.subSection('Mental Health Support'),
    GuidelineBlock.bullet(
        '🧠 Suicide & Crisis Helplines: available locally.'),
    GuidelineBlock.bullet(
        '🤝 Community Support: talk to trusted friends or family.'),
    GuidelineBlock.subSection('National Hotlines'),
    GuidelineBlock.bullet('🇳🇱 Netherlands: 113 Suicide Prevention – 113'),
    GuidelineBlock.bullet('🇧🇪 Belgium: 1813 Suicide Prevention – 1813'),
    GuidelineBlock.bullet('🇬🇧 UK: Samaritans – 116 123'),
    GuidelineBlock.bullet('🇺🇸 USA: 988 Suicide & Crisis Lifeline – 988'),
    GuidelineBlock.bullet('🇩🇪 Germany: Telefonseelsorge – 0800 111 0 111'),
    GuidelineBlock.bullet('🇫🇷 France: 3114 Suicide Prevention – 3114'),
    GuidelineBlock.bullet('🇪🇸 Spain: 024 Suicide Prevention – 024'),
    GuidelineBlock.subSection('Global Directories'),
    GuidelineBlock.bullet('🌍 Find a Helpline: findahelpline.com'),
    GuidelineBlock.bullet('📞 International Helplines: available in multiple languages'),
  ];
}
