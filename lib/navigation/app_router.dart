import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/features/splash/splash_screen.dart';
import 'package:kuemele/features/splash/splash_screen_2.dart';
import 'package:kuemele/features/auth/signin/signin.dart';
import 'package:kuemele/features/auth/onboarding/onboarding.dart';
import 'package:kuemele/features/auth/signup/signup.dart';
import 'package:kuemele/features/auth/forgot_password/presentation/forgot_password_page.dart';
import 'package:kuemele/features/auth/reset_password/presentation/reset_password_page.dart';
import 'package:kuemele/features/auth/email_verification/presentation/email_verification_page.dart';
import 'package:kuemele/features/auth/signup/presentation/signup_terms_page.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_entity.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/features/statistics/history_statistics.dart';
import 'package:kuemele/features/chat/presentation/chat_page.dart';
import 'package:kuemele/features/chat/presentation/chat_room.dart';
import 'package:kuemele/features/chat/presentation/rating_page.dart';
import 'package:kuemele/features/chat/presentation/report_event_page.dart';
import 'package:kuemele/features/chat/presentation/guest_scan_page.dart';
import 'package:kuemele/features/discover/presentation/create_event_page.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_page.dart';
import 'package:kuemele/features/filter/presentation/filter.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/profile/presentation/card/add_card.dart';
import 'package:kuemele/features/profile/presentation/card/payment_subscriptions.dart';
import 'package:kuemele/features/profile/presentation/card/removeCard.dart';
import 'package:kuemele/features/profile/presentation/connections/followers.dart';
import 'package:kuemele/features/profile/presentation/guideline/community_guidelines.dart';
import 'package:kuemele/features/profile/presentation/languages/languages_page.dart';
import 'package:kuemele/features/profile/presentation/notification/sound_notification.dart';
import 'package:kuemele/features/profile/presentation/my_events/my_events_page.dart';
import 'package:kuemele/features/profile/presentation/my_events/pages/my_event_detail_page.dart';
import 'package:kuemele/features/profile/presentation/profileset/interested_hobbies.dart';
import 'package:kuemele/features/profile/presentation/profileset/earn_medals_page.dart';
import 'package:kuemele/features/profile/presentation/profileset/edit_profile.dart';
import 'package:kuemele/features/profile/presentation/contact/contact_page.dart';
import 'package:kuemele/features/profile/presentation/security/change_password.dart';
import 'package:kuemele/features/profile/presentation/security/delete_account_page.dart';
import 'package:kuemele/features/profile/presentation/security/security.dart';
import 'package:kuemele/features/profile/presentation/terms_and_conditions/terms_and_conditions.dart';
import 'package:kuemele/shared/modals/dialog/scan_qr_page.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/features/debug_tools/api_debug_page.dart';
import 'package:kuemele/features/debug_tools/debug_model.dart';
import 'package:kuemele/features/debug_tools/main_debug_page.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';

Page<T> _cupertinoPage<T extends Object?>({
  required GoRouterState state,
  required Widget child,
}) {
  return CupertinoPage<T>(
    key: state.pageKey,
    name: state.name,
    child: child,
  );
}

AuthRouteArgs _authArgs(GoRouterState state) {
  final extra = state.extra;
  if (extra is AuthRouteArgs) return extra;
  return const AuthRouteArgs();
}

ForgotPasswordRouteArgs _forgotPasswordArgs(GoRouterState state) {
  final extra = state.extra;
  if (extra is ForgotPasswordRouteArgs) return extra;
  return const ForgotPasswordRouteArgs();
}

EmailVerificationRouteArgs _emailVerificationArgs(GoRouterState state) {
  final extra = state.extra;
  if (extra is EmailVerificationRouteArgs) return extra;
  return const EmailVerificationRouteArgs(email: '');
}

ResetPasswordRouteArgs _resetPasswordArgs(GoRouterState state) {
  final extra = state.extra;
  if (extra is ResetPasswordRouteArgs) {
    return extra;
  }
  return const ResetPasswordRouteArgs(email: '');
}

BlogDetailRouteArgs _blogDetailArgs(GoRouterState state) {
  final extra = state.extra;
  if (extra is BlogDetailRouteArgs) return extra;
  if (extra is BlogPostModel) {
    return BlogDetailRouteArgs(blog: extra);
  }
  return BlogDetailRouteArgs(blog: BlogPostModel.placeholders.first);
}

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    observers: [FlutterSmartDialog.observer],
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.splash2,
        name: 'splash2',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: const SplashScreen2(),
        ),
      ),
      GoRoute(
        path: AppRoutes.signin,
        name: 'signin',
        pageBuilder: (context, state) {
          final args = _authArgs(state);
          return _cupertinoPage(
            state: state,
            child: Signin(
              entryLabel: args.entryLabel,
              entryDescription: args.entryDescription,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        pageBuilder: (context, state) {
          final args = _authArgs(state);
          return _cupertinoPage(
            state: state,
            child: Signup(
              entryLabel: args.entryLabel,
              entryDescription: args.entryDescription,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        pageBuilder: (context, state) {
          final args = _forgotPasswordArgs(state);
          return _cupertinoPage(
            state: state,
            child: ForgotPasswordPage(initialEmail: args.email),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'resetPassword',
        pageBuilder: (context, state) {
          final args = _resetPasswordArgs(state);
          return _cupertinoPage(
            state: state,
            child: ResetPasswordPage(email: args.email),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.emailVerification,
        name: 'emailVerification',
        pageBuilder: (context, state) {
          final args = _emailVerificationArgs(state);
          return _cupertinoPage(
            state: state,
            child: EmailVerificationPage(
              email: args.email,
              isFromSignup: args.isFromSignup,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.signupTerms,
        name: 'signupTerms',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: const SignupTermsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) {
          final extra = state.extra;
          final showWelcomeMessage = extra is HomeRouteArgs
              ? extra.showWelcomeMessage
              : state.uri.queryParameters['welcome'] == 'true';

          return _cupertinoPage(
            state: state,
            child: MainNavigationPage(
              showWelcomeMessage: showWelcomeMessage,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.blogDetail,
        name: 'blogDetail',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: BlogDetailPage(blog: _blogDetailArgs(state).blog),
        ),
      ),
      GoRoute(
        path: AppRoutes.createEvent,
        name: 'createEvent',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: CreateEvent(),
        ),
      ),
      GoRoute(
        path: AppRoutes.statistic,
        name: 'statistic',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: HistoryAndStatistics(),
        ),
      ),
      GoRoute(
        path: AppRoutes.filter,
        name: 'filter',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: Filter(),
        ),
      ),
      GoRoute(
        path: AppRoutes.notification,
        name: 'notification',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: const NotificationPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.chatList,
        name: 'chatList',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: const ChatPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.chatRoom,
        name: 'chatRoom',
        pageBuilder: (context, state) {
          final extra = state.extra;
          final chat = extra is ChatRoomEntity ? extra : null;
          return _cupertinoPage(
            state: state,
            child: ChatRoom(chat: chat),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.paymentSubscriptions,
        name: 'paymentSubscriptions',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: PaymentSubscriptionsDialog(),
        ),
      ),
      GoRoute(
        path: AppRoutes.addCard,
        name: 'addCard',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: AddCardDialog(),
        ),
      ),
      GoRoute(
        path: AppRoutes.interestedHobbies,
        name: 'interestedHobbies',
        pageBuilder: (context, state) {
          return _cupertinoPage(
            state: state,
            child: const InterestedHobbies(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.earnMedals,
        name: 'earnMedals',
        pageBuilder: (context, state) {
          return _cupertinoPage(
            state: state,
            child: const EarnMedalsPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.followers,
        name: 'followers',
        pageBuilder: (context, state) {
          final extra = state.extra;
          final selectedTab =
              extra is FollowersRouteArgs ? extra.selectedTab : null;

          return _cupertinoPage(
            state: state,
            child: FollowersPage(selectedTab: selectedTab),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.termsAndConditions,
        name: 'termsAndConditions',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: TermsAndConditions(),
        ),
      ),
      GoRoute(
        path: AppRoutes.communityGuidelines,
        name: 'communityGuidelines',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: CommunityGuideLines(),
        ),
      ),
      GoRoute(
        path: AppRoutes.soundNotification,
        name: 'soundNotification',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: SoundNotification(),
        ),
      ),
      GoRoute(
        path: AppRoutes.languages,
        name: 'languages',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: const LanguagesPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.removeCard,
        name: 'removeCard',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: RemovecardDialog(),
        ),
      ),
      GoRoute(
        path: AppRoutes.security,
        name: 'security',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: Security(),
        ),
      ),
      GoRoute(
        path: AppRoutes.contact,
        name: 'contact',
        pageBuilder: (context, state) {
          final extra = state.extra;
          final args = extra is ContactRouteArgs ? extra : null;
          return _cupertinoPage(
            state: state,
            child: ContactPage(routeArgs: args),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        name: 'changePassword',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: ChangePasswordPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.deleteAccount,
        name: 'deleteAccount',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: const DeleteAccountPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'editProfile',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: EditProfilePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.myEvents,
        name: 'myEvents',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: const MyEventsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.myEventDetail,
        name: 'myEventDetail',
        pageBuilder: (context, state) {
          final eventId = state.extra as String? ?? '';
          return _cupertinoPage(
            state: state,
            child: MyEventDetailPage(eventId: eventId),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.rating,
        name: 'rating',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: const RatingPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.report,
        name: 'report',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: const ReportEventPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.guestScan,
        name: 'guestScan',
        pageBuilder: (context, state) {
          final eventId = state.extra as String? ?? '';
          return _cupertinoPage(
            state: state,
            child: GuestScanPage(eventId: eventId),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.scanQr,
        name: 'scanQr',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: ScanQrPage(
            eventDetail: state.extra as ExploreEventDetail?,
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.mainDebug,
        name: 'mainDebug',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: MainDebugPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.apiDebug,
        name: 'apiDebug',
        pageBuilder: (context, state) {
          final extra = state.extra;
          final type =
              extra is ApiDebugRouteArgs ? extra.type : RequestLogType.api;
          return _cupertinoPage(
            state: state,
            child: APIDebugPage(type: type),
          );
        },
      ),
    ],
  );
}
