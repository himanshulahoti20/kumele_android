import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/features/debug_tools/debug_model.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const splash2 = '/splash2';
  static const signin = '/signin';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const signupTerms = '/signup/terms';
  static const emailVerification = '/email-verification';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const blogDetail = '/blog-detail';
  static const createEvent = '/create-event';
  static const statistic = '/statistic';
  static const filter = '/filter';
  static const notification = '/notification';
  static const chatList = '/chat-list';
  static const chatRoom = '/chat-room';
  static const paymentSubscriptions = '/payment-subscriptions';
  static const addCard = '/add-card';
  static const interestedHobbies = '/interested-hobbies';
  static const earnMedals = '/earn-medals';
  static const followers = '/followers';
  static const termsAndConditions = '/terms-and-conditions';
  static const communityGuidelines = '/community-guidelines';
  static const faq = '/faq';
  static const soundNotification = '/sound-notification';
  static const languages = '/languages';
  static const removeCard = '/remove-card';
  static const security = '/security';
  static const contact = '/contact';
  static const changePassword = '/change-password';
  static const deleteAccount = '/delete-account';
  static const editProfile = '/edit-profile';
  static const myEvents = '/my-events';
  static const myEventDetail = '/my-event-detail';
  static const rating = '/rating';
  static const report = '/report';
  static const guestScan = '/guest-scan';
  static const scanQr = '/scan-qr';
  static const mainDebug = '/debug';
  static const apiDebug = '/debug/api';
}

class AuthRouteArgs {
  final String? entryLabel;
  final String? entryDescription;

  const AuthRouteArgs({this.entryLabel, this.entryDescription});
}

class ForgotPasswordRouteArgs {
  final String? email;

  const ForgotPasswordRouteArgs({this.email});
}

class ResetPasswordRouteArgs {
  final String email;

  const ResetPasswordRouteArgs({required this.email});
}

class EmailVerificationRouteArgs {
  final String email;
  final bool isFromSignup;

  const EmailVerificationRouteArgs({
    required this.email,
    this.isFromSignup = false,
  });
}

class OnboardingRouteArgs {
  final bool isFromSignUp;

  const OnboardingRouteArgs({required this.isFromSignUp});
}

class InterestedHobbiesRouteArgs {
  final bool isFromSignUp;

  const InterestedHobbiesRouteArgs({required this.isFromSignUp});
}

class EarnMedalsRouteArgs {
  final bool isFromSignUp;

  const EarnMedalsRouteArgs({required this.isFromSignUp});
}

class HomeRouteArgs {
  final bool showWelcomeMessage;

  const HomeRouteArgs({this.showWelcomeMessage = false});
}

class BlogDetailRouteArgs {
  final BlogPostModel blog;

  const BlogDetailRouteArgs({required this.blog});
}

class FollowersRouteArgs {
  final String? selectedTab;

  const FollowersRouteArgs({this.selectedTab});
}

class ContactRouteArgs {
  final String? relatedEntityId;
  final String? relatedEntityType;

  const ContactRouteArgs({
    this.relatedEntityId,
    this.relatedEntityType,
  });
}

class ApiDebugRouteArgs {
  final RequestLogType type;

  const ApiDebugRouteArgs({required this.type});
}
