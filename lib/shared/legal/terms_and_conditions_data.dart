class TermsSection {
  const TermsSection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

abstract final class TermsAndConditionsData {
  TermsAndConditionsData._();

  static const String documentTitle = 'Kumele Terms of Use';
  static const String lastUpdated = 'Last updated: July 7, 2026';

  static const String introduction =
      'Welcome to Kumele. These Terms and Conditions govern your access to and use of our platform, including events, community features, messaging, and account services. By creating an account, you agree to the terms below.';

  static const List<TermsSection> sections = [
    TermsSection(
      title: '1. Account eligibility',
      body:
          'You must be a legal adult in your jurisdiction to create an account. You are responsible for keeping your login credentials secure and for all activity that occurs under your account.',
    ),
    TermsSection(
      title: '2. Acceptable use',
      body:
          'You agree not to harass other members, post unlawful content, attempt to disrupt the service, or use Kumele for spam, fraud, or unauthorized commercial activity. We may suspend accounts that violate these rules.',
    ),
    TermsSection(
      title: '3. Events and community content',
      body:
          'Event listings, photos, messages, and profile information you share may be visible to other users according to your privacy settings. You retain ownership of your content, but grant Kumele a license to display and distribute it within the platform.',
    ),
    TermsSection(
      title: '4. Payments and subscriptions',
      body:
          'Paid features, subscriptions, and escrow services may be subject to additional billing terms. Prices, renewal dates, and refund eligibility will be shown before you confirm a purchase.',
    ),
    TermsSection(
      title: '5. Privacy and communications',
      body:
          'We process personal data as described in our Privacy Policy. By using Kumele, you consent to service-related emails and notifications. Marketing messages can be managed from your account settings.',
    ),
    TermsSection(
      title: '6. Termination',
      body:
          'You may delete your account at any time. Kumele may suspend or terminate access if these terms are breached, if required by law, or to protect the safety of the community.',
    ),
    TermsSection(
      title: '7. Changes to these terms',
      body:
          'We may update these terms from time to time. Material changes will be communicated through the app or by email. Continued use of Kumele after updates means you accept the revised terms.',
    ),
  ];
}
