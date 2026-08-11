import 'legal_block.dart';

/// Static content for the native Terms of Use document, mirroring the
/// `TermsOfUseNativeView` from the iOS app.
abstract final class TermsOfUseData {
  TermsOfUseData._();

  static const List<LegalBlock> _intro = [
    LegalBlock.header('TERMS OF USE'),
    LegalBlock.body('For a summary of our Terms of Use, go to Summary of Terms.'),
    LegalBlock.body('Welcome to Kumele.'),
    LegalBlock.body(
        'These Terms of Use are between you and Baku. Baku offers services '
        'related to Kumele. References to “we,” “us,” “our,” and “Kumele” are to '
        'Baku and its Affiliates. “Affiliates” means any entity that directly or '
        'indirectly controls, is controlled by, or is under common control with Baku.'),
    LegalBlock.body('The term (“Host” or “Event Organiser”) refers to the event organiser.'),
    LegalBlock.body('The term (“Consumer or Guest”) refers to the customer.'),
    LegalBlock.body(
        'The terms (“hobbies” or “activities”) refer to:\n'
        '“Hobbies/Activities” = categories of interest (football, yoga, coding)\n'
        '“Events” = scheduled meetups created by Hosts'),
  ];

  static const List<LegalBlock> _s0 = [
    LegalBlock.section('APPLICABLE LEGAL DOCUMENTS'),
    LegalBlock.body(
        'If you are an Organiser/Host or Guest/Consumer, the following '
        'agreements apply to your use of the Kumele platform:\n'
        '– Terms of Use\n'
        '– Privacy Policy\n'
        '– Community Guidelines\n'
        'These agreements constitute the entire agreement between you and Kumele.'),
    LegalBlock.section('KUMELE’S ROLE AND SERVICES'),
    LegalBlock.body(
        'Our Role: Hosts create Events and publish them on the Kumele platform '
        'for Guests to join. Guests can search for Events, register, pay online '
        'and attend. Kumele supports payments, event management, communication '
        'and community guidelines.'),
    LegalBlock.body(
        'Service: We generate revenue by charging commissions for ticket sales '
        'and other services (see Section 11 – Purchases).'),
  ];

  static const List<LegalBlock> _s1 = [
    LegalBlock.section('1. ACCEPTANCE OF THE TERMS OF USE AGREEMENT'),
    LegalBlock.body(
        '1.1 By downloading, accessing, registering, or using the Kumele '
        'application or platform, you confirm that you have read, understood '
        'and accepted these Terms of Use and you agree to be bound by them.'),
    LegalBlock.body(
        '1.2 If you do not agree with these Terms of Use, you must not download, '
        'access, register, or use the Kumele platform.'),
    LegalBlock.body(
        '1.3 Platform Role & Disclaimer\n'
        'Kumele is not an event organiser.\n'
        'Hosts independently create and manage events.\n'
        'Guests choose whether to join, attend, or pay for events.\n'
        'Kumele provides only matching, payment facilitation, communication '
        'tools, and verification systems. Kumele does not supervise, control, '
        'or assume responsibility for events, venues, or Host conduct.\n'
        'Kumele does not guarantee:\n'
        'Event quality\n'
        'Attendance by hosts or guests\n'
        'Safety, legality, or suitability of events\n'
        'All users participate at their own risk, subject to mandatory consumer '
        'protection laws.'),
    LegalBlock.body(
        'Prohibited Events (Summary)\n'
        'For clarity, the following types of events are not permitted on Kumele, '
        'among others described in Section 9 (Community Rules):\n'
        'Erotic or sexual events\n'
        'Drug-related events (including cannabis) are not permitted on Kumele.\n'
        'Parties in private properties (including Airbnbs) without the owner\'s '
        'prior permission\n'
        'Events that disturb neighbours or violate local laws'),
  ];

  static const List<LegalBlock> _s2a = [
    LegalBlock.section('2. ELIGIBILITY AND CORE PLATFORM RULES'),
    LegalBlock.body(
        'You must be at least 18 years old, or the legal age of majority in '
        'your country, to create an account, attend events, and use Kumele '
        'services. By creating an account, you confirm that you are at least 18 '
        'years old. Kumele may request age verification documents at any time. '
        'If you fail to provide them, your account may be restricted or closed.'),
    LegalBlock.bullet('Do not create fake profiles or create multiple accounts.'),
    LegalBlock.bullet(
        'Do not send spam, unsolicited messages, or commercial promotions to other members.'),
    LegalBlock.bullet(
        'Do not post private information or content that violates the rights of others.'),
    LegalBlock.bullet(
        'Do not attempt to circumvent Kumele payments, fees, or commissions.'),
    LegalBlock.subSection('2.a Events, Matching & Temporary Chats'),
    LegalBlock.body(
        'Guests join Events directly through the platform. Kumele does not '
        'recommend matches or pair members. Temporary chats are created for each '
        'Event and may be deleted at the end of the Event. Inappropriate content '
        'in chats may lead to account restriction or termination.'),
    LegalBlock.body(
        'Hosts are responsible for organising their Events and must have the '
        'necessary permissions and licences.'),
    LegalBlock.subSection('2.b Ratings, Reputation & Rewards'),
    LegalBlock.body(
        'Guests can rate Events and Hosts after attending. Ratings are shown on '
        'Host profiles. Kumele may reward active users with discounts, benefits '
        'or Kumele Coins.'),
    LegalBlock.body(
        'Kumele Coins are virtual points earned for activity. Coins can be used '
        'to unlock discounts or benefits, but have no monetary value and cannot '
        'be exchanged for money.'),
  ];

  static const List<LegalBlock> _s2b = [
    LegalBlock.subSection('2.c Digital Assets & NFTs'),
    LegalBlock.body(
        'Kumele may issue digital assets (e.g., NFTs) as rewards or '
        'collectibles. Digital assets are personal, non-transferable and have '
        'no monetary value. Kumele does not guarantee the value, duration or '
        'availability of digital assets.'),
    LegalBlock.subSection('2.d AI, Automation & Moderation'),
    LegalBlock.body(
        'Kumele may use AI tools to moderate content, detect fraud, and improve '
        'user experience. Kumele may automate some decisions (e.g., content '
        'moderation, fraud detection). If you disagree with an automated '
        'decision, you can contact us to request a manual review.'),
    LegalBlock.subSection('2.e Suspension & Termination'),
    LegalBlock.body(
        'Kumele may suspend or terminate your account if you violate these Terms '
        'of Use, Community Guidelines, or applicable laws. You will be notified '
        'of the reason unless it is unlawful or unsafe to do so.'),
  ];

  static const List<LegalBlock> _s3 = [
    LegalBlock.section('3. PRIVACY AND CONSUMER INFORMATION'),
    LegalBlock.body(
        '3.1 We process your personal data in accordance with the Privacy '
        'Policy. You consent to the collection, processing and storage of your '
        'data as described in the Privacy Policy.'),
    LegalBlock.body(
        '3.2 In certain countries, you are entitled to request a copy, '
        'correction or deletion of your personal data, or to object to specific '
        'processing.'),
    LegalBlock.body(
        '3.3 We may share your data with service providers, payment processors '
        'or public authorities if required by law.'),
  ];

  static const List<LegalBlock> _s4 = [
    LegalBlock.section('4. Accounts, Authentication & Security'),
    LegalBlock.body(
        '4.1 You are responsible for keeping your account credentials '
        'confidential. You must not share your password with anyone. You must '
        'notify us immediately if you suspect unauthorised access to your '
        'account.'),
  ];

  static const List<LegalBlock> _s5 = [
    LegalBlock.section('5. MODIFYING THE SERVICE AND TERMINATION'),
    LegalBlock.body(
        '5.1 We may modify, suspend, or terminate the Kumele service, in whole '
        'or in part, at any time and for any reason, with or without notice.'),
    LegalBlock.body(
        '5.2 You may stop using Kumele at any time. You can delete your account '
        'by contacting support.'),
    LegalBlock.body(
        '5.3 After termination, your right to use the Kumele platform ends '
        'immediately. Terms that by their nature should survive termination will '
        'survive, including but not limited to ownership provisions, warranty '
        'disclaimers, and limitations of liability.'),
    LegalBlock.body(
        '5.4 We are not liable to you or any third party for any modification, '
        'suspension, or termination of the service.'),
  ];

  static const List<LegalBlock> _s6 = [
    LegalBlock.section('6. SAFETY; YOUR INTERACTIONS WITH OTHER MEMBERS'),
    LegalBlock.body(
        '6.1 You are solely responsible for your interactions with other '
        'members. You acknowledge that Kumele does not conduct criminal '
        'background checks on its members.'),
    LegalBlock.body(
        '6.2 You agree to exercise caution and to apply common sense when '
        'interacting with other members. You should not share financial '
        'information or private details.'),
    LegalBlock.body(
        '6.3 If you encounter inappropriate behaviour, you may report the user. '
        'We may review reports and take action as described in the Community '
        'Guidelines.'),
  ];

  static const List<LegalBlock> _s7 = [
    LegalBlock.section('7. RIGHTS KUMELE GRANTS YOU'),
    LegalBlock.body(
        '7.1 On the condition that you comply with these Terms of Use, Kumele '
        'grants you a limited, non-exclusive, non-transferable, revocable '
        'licence to use the Kumele platform and its content for personal, '
        'non-commercial purposes. You agree not to:'),
    LegalBlock.bullet(
        'Use the platform for any commercial purpose without prior written consent.'),
    LegalBlock.bullet(
        'Copy, modify, distribute, sell, or lease any part of the platform.'),
    LegalBlock.bullet(
        'Reverse engineer, decompile, or attempt to derive the source code of the platform.'),
    LegalBlock.bullet(
        'Remove or alter any copyright, trademark, or other proprietary notices.'),
    LegalBlock.bullet('Interfere with, disrupt, or overload the platform or its servers.'),
    LegalBlock.bullet('Access the platform using automated means (e.g., scraping, bots).'),
    LegalBlock.bullet('Create derivative works from the platform content.'),
    LegalBlock.bullet(
        'Upload malicious code or content that may harm the platform or other users.'),
    LegalBlock.bullet('Use the platform to violate any applicable law or regulation.'),
    LegalBlock.bullet(
        'Impersonate any person or entity or misrepresent your affiliation.'),
    LegalBlock.bullet('Collect or harvest information about other users without consent.'),
    LegalBlock.bullet(
        'Attempt to gain unauthorised access to any part of the platform.'),
    LegalBlock.bullet('Encourage or assist any third party in doing any of the above.'),
    LegalBlock.body('7.2 Kumele reserves all rights not expressly granted to you.'),
    LegalBlock.body('7.3 Your licence terminates automatically if you breach these Terms of Use.'),
  ];

  static const List<LegalBlock> _s8 = [
    LegalBlock.section('8. RIGHTS YOU GRANT KUMELE'),
    LegalBlock.body(
        '8.1 By posting, uploading, or sharing content on the platform, you '
        'grant Kumele a worldwide, non-exclusive, royalty-free, sublicensable '
        'licence to use, copy, reproduce, process, adapt, modify, publish, '
        'transmit, and display such content in connection with the operation of '
        'the platform.'),
    LegalBlock.body(
        '8.2 You represent and warrant that you own or have the necessary rights '
        'to the content you post.'),
    LegalBlock.body(
        '8.3 You agree that the content you post will not infringe the rights of '
        'any third party.'),
    LegalBlock.body(
        '8.4 You grant Kumele the right to use your name and profile picture in '
        'connection with content you post.'),
    LegalBlock.body('8.5 You understand that content you post may be viewed by other users.'),
    LegalBlock.body(
        '8.6 You may delete your content at any time, but Kumele may retain '
        'copies for legal or compliance reasons.'),
    LegalBlock.body(
        '8.7 You are responsible for the content you post and the consequences '
        'of posting it.'),
    LegalBlock.body(
        '8.8 We may remove content that violates these Terms of Use or '
        'applicable laws.'),
  ];

  static const List<LegalBlock> _s9 = [
    LegalBlock.section('9. COMMUNITY RULES'),
    LegalBlock.body(
        '9.1 You agree to comply with the Community Guidelines and these '
        'Community Rules when using the Kumele platform. You must not:'),
    LegalBlock.bullet('Post nude, sexual, or erotic content.'),
    LegalBlock.bullet('Promote, facilitate, or organise illegal activities.'),
    LegalBlock.bullet('Harass, bully, threaten, or intimidate other members.'),
    LegalBlock.bullet(
        'Post hateful content based on race, ethnicity, religion, gender, '
        'sexual orientation, or disability.'),
    LegalBlock.bullet(
        'Organise or promote events involving drugs or other illegal substances.'),
    LegalBlock.bullet(
        'Organise or promote events in private properties without the owner\'s permission.'),
    LegalBlock.bullet(
        'Use the platform to solicit or facilitate prostitution or sexual services.'),
    LegalBlock.bullet('Post content that promotes violence or self-harm.'),
    LegalBlock.bullet(
        'Share content that violates the intellectual property rights of others.'),
    LegalBlock.bullet('Impersonate other members, public figures, or brands.'),
    LegalBlock.bullet('Post misleading or fraudulent content.'),
    LegalBlock.bullet('Attempt to defraud other members or Kumele.'),
    LegalBlock.bullet('Use the platform to send unsolicited advertising or spam.'),
    LegalBlock.bullet(
        'Create events that disturb neighbours or violate local laws.'),
    LegalBlock.bullet('Sell tickets outside the official Kumele platform.'),
    LegalBlock.bullet('Post personal contact details for commercial purposes.'),
    LegalBlock.bullet('Evade Kumele fees, commissions, or payment systems.'),
    LegalBlock.bullet('Share content that contains malware or harmful code.'),
    LegalBlock.bullet('Violate any applicable local, national, or international law.'),
    LegalBlock.body(
        '9.2 Kumele may remove any content or event that violates these rules, '
        'and may suspend or terminate your account.'),
    LegalBlock.body('9.3 If you see a violation, please report it to support.'),
  ];

  static const List<LegalBlock> _s10 = [
    LegalBlock.section('10. OTHER MEMBERS\' CONTENT'),
    LegalBlock.body(
        'Although we reserve the right to review or remove all content, such '
        'content does not necessarily reflect our opinions or policies. We are '
        'not responsible for the content posted by other members.'),
    LegalBlock.subSection('10.a No Responsibility'),
    LegalBlock.body(
        'We do not guarantee the accuracy, integrity, quality, or '
        'appropriateness of any content posted by members. You may be exposed '
        'to content that is inaccurate, offensive, or objectionable.'),
    LegalBlock.subSection('10.b Use of Other Members\' Content'),
    LegalBlock.body(
        'You may not use other members\' content without their permission. You '
        'may not copy, modify, or distribute other members\' content.'),
  ];

  static const List<LegalBlock> _s11a = [
    LegalBlock.section('11. PURCHASES'),
    LegalBlock.subSection('11.1 General Terms'),
    LegalBlock.body(
        '11.1 General Terms\n'
        'All ticket sales are final. Event tickets may be non-refundable unless '
        'required by law. By purchasing a ticket, you agree to the event '
        'organiser\'s terms and conditions.'),
    LegalBlock.subSection('11.2 Payment Processing'),
    LegalBlock.body(
        '11.2 Payment Processing\n'
        'Payments are processed by our payment providers. By making a purchase, '
        'you agree to the applicable payment provider\'s terms.'),
    LegalBlock.subSection('11.3 Transaction Confirmation'),
    LegalBlock.body(
        '11.3 Transaction Confirmation\n'
        'You will receive a confirmation email and/or push notification after a '
        'successful purchase. Keep this confirmation for your records.'),
    LegalBlock.subSection('11.4 Refund Policy'),
    LegalBlock.body(
        '11.4 Refund Policy\n'
        'Refunds are subject to the event organiser\'s refund policy. If an '
        'event is cancelled, you may be entitled to a refund as required by law.'),
    LegalBlock.subSection('11.5 Ticket Cancellation'),
    LegalBlock.body(
        '11.5 Ticket Cancellation\n'
        'You may cancel your ticket as described in the event organiser\'s '
        'policy. Kumele is not responsible for cancellations made by the event '
        'organiser.'),
  ];

  static const List<LegalBlock> _s11b = [
    LegalBlock.subSection('11.6 Event Postponement'),
    LegalBlock.body(
        '11.6 Event Postponement\n'
        'If an event is postponed, your ticket remains valid for the new date '
        'unless otherwise stated. You may request a refund if you cannot attend '
        'the new date.'),
    LegalBlock.subSection('11.7 Price and Fees'),
    LegalBlock.body(
        '11.7 Price and Fees\n'
        'All prices are displayed in the applicable currency and may include '
        'taxes and fees. Kumele may charge a service fee.'),
    LegalBlock.subSection('11.8 Tickets and Attendance'),
    LegalBlock.body(
        '11.8 Tickets and Attendance\n'
        'You may be required to present your ticket or QR code for entry. '
        'Tickets are personal and non-transferable unless stated otherwise.'),
    LegalBlock.subSection('11.9 Chargebacks'),
    LegalBlock.body(
        '11.9 Chargebacks\n'
        'Unjustified chargebacks may result in account suspension or termination.'),
  ];

  static const List<LegalBlock> _s12 = [
    LegalBlock.section('12. NOTICE AND PROCEDURE FOR MAKING CLAIMS OF COPYRIGHT INFRINGEMENT'),
    LegalBlock.body(
        '12.1 We respect the intellectual property rights of others and expect '
        'you to do the same.'),
    LegalBlock.body(
        '12.2 If you believe that your work has been copied in a way that '
        'constitutes copyright infringement, please notify us with the '
        'following information:'),
    LegalBlock.bullet('A description of the copyrighted work that you claim has been infringed.'),
    LegalBlock.bullet('A description of where the infringing material is located on the platform.'),
    LegalBlock.bullet('Your contact information, including your email address.'),
    LegalBlock.bullet('A statement that you believe in good faith that the use is not authorised.'),
    LegalBlock.body(
        '12.3 We may remove content that we believe infringes the rights of '
        'others.'),
  ];

  static const List<LegalBlock> _s13 = [
    LegalBlock.section('13. DISCLAIMERS'),
    LegalBlock.body(
        '13.1 The Kumele platform and its content are provided on an "as is" '
        'and "as available" basis. We make no representations or warranties of '
        'any kind, express or implied, regarding the platform, its content, or '
        'the events listed on it.'),
    LegalBlock.body(
        '13.2 We do not warrant that the platform will be uninterrupted, '
        'error-free, or secure.'),
    LegalBlock.body(
        '13.3 We are not responsible for the conduct of any user, Host, or '
        'Guest. To the maximum extent permitted by law, we disclaim all '
        'liability arising from your use of the platform.'),
  ];

  static const List<LegalBlock> _s14 = [
    LegalBlock.section('14. THIRD-PARTY SERVICES'),
    LegalBlock.body(
        'The platform may contain links to third-party websites or services. We '
        'are not responsible for the content, policies, or practices of any '
        'third-party websites or services.'),
  ];

  static const List<LegalBlock> _s15 = [
    LegalBlock.section('15. LIMITATION OF LIABILITY'),
    LegalBlock.body(
        '15.1 To the maximum extent permitted by law, Kumele, its affiliates, '
        'and their officers, directors, employees, and agents shall not be '
        'liable for any indirect, incidental, special, consequential, or '
        'punitive damages, including but not limited to loss of profits, data, '
        'or goodwill.'),
    LegalBlock.body(
        '15.2 Our total liability to you shall not exceed the amount you paid '
        'to Kumele in the twelve (12) months preceding the claim, or one '
        'hundred euros (€100), whichever is greater.'),
  ];

  static const List<LegalBlock> _s16 = [
    LegalBlock.section('16. ARBITRATION, CLASS-ACTION WAIVER, AND JURY WAIVER'),
    LegalBlock.body(
        '16.1 You and Kumele agree that any dispute arising out of or relating '
        'to these Terms of Use or the platform will be resolved by binding '
        'arbitration, except where prohibited by law.'),
    LegalBlock.body(
        '16.2 You agree that any arbitration will take place on an individual '
        'basis. Class actions and class arbitrations are waived.'),
    LegalBlock.body(
        '16.3 You and Kumele waive the right to a jury trial, to the extent '
        'permitted by law.'),
  ];

  static const List<LegalBlock> _s17 = [
    LegalBlock.section('17. GOVERNING LAW'),
    LegalBlock.body(
        'These Terms of Use are governed by the laws of the jurisdiction where '
        'Kumele operates, without regard to its conflict of law provisions.'),
  ];

  static const List<LegalBlock> _s18 = [
    LegalBlock.section('18. INDEMNITY BY YOU'),
    LegalBlock.body(
        'You agree to indemnify and hold harmless Kumele, its affiliates, and '
        'their officers, directors, employees, and agents from and against any '
        'claims, liabilities, damages, losses, and expenses arising out of or '
        'in connection with:'),
    LegalBlock.bullet('Your use of the platform.'),
    LegalBlock.bullet('Your violation of these Terms of Use.'),
    LegalBlock.bullet('Your violation of any rights of a third party.'),
    LegalBlock.bullet('Your events, activities, or interactions with other members.'),
  ];

  static const List<LegalBlock> _s19 = [
    LegalBlock.section('19. ENTIRE AGREEMENT; OTHER'),
    LegalBlock.body(
        'These Terms of Use constitute the entire agreement between you and '
        'Kumele regarding your use of the platform and supersede all prior '
        'agreements. If any provision is held invalid, the remaining provisions '
        'remain in effect.'),
  ];

  static const List<LegalBlock> _summary = [
    LegalBlock.section('SUMMARY OF TERMS'),
    LegalBlock.body(
        'This summary highlights some of the key points of our Terms of Use. '
        'For full details, please read the entire Terms of Use.'),
    LegalBlock.subSection('1. What is Kumele?'),
    LegalBlock.body(
        'Kumele is a platform that connects Hosts (Event Organisers) with '
        'Guests (Consumers) for hobbies, activities, and events.'),
    LegalBlock.subSection('2. Do I need to be 18+?'),
    LegalBlock.body(
        'Yes. You must be at least 18 years old, or the legal age of majority '
        'in your country, to create an account and use Kumele.'),
    LegalBlock.subSection('3. Are there prohibited events?'),
    LegalBlock.body(
        'Yes. Erotic events, drug-related events, parties in private properties '
        'without permission, and events that disturb neighbours or violate '
        'local laws are not allowed.'),
    LegalBlock.subSection('4. Can I get a refund?'),
    LegalBlock.body(
        'Refunds are subject to the event organiser\'s refund policy. If an '
        'event is cancelled, you may be entitled to a refund as required by law.'),
    LegalBlock.subSection('5. Are tickets transferable?'),
    LegalBlock.body(
        'Tickets are personal and non-transferable unless stated otherwise by '
        'the event organiser.'),
    LegalBlock.subSection('6. What happens if I break the rules?'),
    LegalBlock.body(
        'We may remove content, suspend, or terminate your account if you '
        'violate the Community Rules or Community Guidelines.'),
    LegalBlock.subSection('7. How are disputes resolved?'),
    LegalBlock.body(
        'Disputes are resolved by binding arbitration on an individual basis, '
        'except where prohibited by law.'),
  ];

  static const List<LegalBlock> blocks = [
    ..._intro,
    ..._s0,
    ..._s1,
    ..._s2a,
    ..._s2b,
    ..._s3,
    ..._s4,
    ..._s5,
    ..._s6,
    ..._s7,
    ..._s8,
    ..._s9,
    ..._s10,
    ..._s11a,
    ..._s11b,
    ..._s12,
    ..._s13,
    ..._s14,
    ..._s15,
    ..._s16,
    ..._s17,
    ..._s18,
    ..._s19,
    ..._summary,
  ];
}
