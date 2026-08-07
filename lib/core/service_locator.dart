import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/app/cubit/locale_cubit.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/auth/signin/bloc/signin_bloc.dart';
import 'package:kuemele/features/auth/signin/data/storage/signin_preferences_storage.dart';
import 'package:kuemele/features/auth/onboarding/bloc/onboarding_bloc.dart';
import 'package:kuemele/features/auth/signup/bloc/signup_bloc.dart';
import 'package:kuemele/features/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:kuemele/features/auth/reset_password/bloc/reset_password_bloc.dart';
import 'package:kuemele/features/auth/email_verification/bloc/email_verification_bloc.dart';
import 'package:kuemele/app/cubit/app_cubit.dart';
import 'package:kuemele/features/chat/data/datasources/chat_socket_data_source.dart';
import 'package:kuemele/features/chat/data/repositories/chat_room_repository_impl.dart';
import 'package:kuemele/features/chat/domain/repositories/chat_room_repository.dart';
import 'package:kuemele/features/chat/presentation/bloc/chat_room_bloc.dart';
import 'package:kuemele/features/chat/presentation/bloc/guest_scan/guest_scan_bloc.dart';
import 'package:kuemele/features/profile/presentation/connections/bloc/connections_bloc.dart';
import 'package:kuemele/features/profile/presentation/connections/data/repositories/connections_repository_impl.dart';
import 'package:kuemele/features/profile/presentation/connections/domain/repositories/connections_repository.dart';
import 'package:kuemele/features/profile/presentation/languages/bloc/languages_bloc.dart';
import 'package:kuemele/features/profile/presentation/languages/data/repositories/translation_repository_impl.dart';
import 'package:kuemele/features/profile/presentation/languages/domain/repositories/translation_repository.dart';
import 'package:kuemele/features/profile/presentation/contact/bloc/contact_bloc.dart';
import 'package:kuemele/features/profile/presentation/contact/data/repositories/contact_support_repository_impl.dart';
import 'package:kuemele/features/profile/presentation/contact/domain/repositories/contact_support_repository.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/change_password_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/delete_account_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/two_factor_disable_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/two_factor_setup_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/data/repositories/change_password_repository_impl.dart';
import 'package:kuemele/features/profile/presentation/security/data/repositories/delete_account_repository_impl.dart';
import 'package:kuemele/features/profile/presentation/security/data/repositories/two_factor_setup_repository_impl.dart';
import 'package:kuemele/features/profile/presentation/security/domain/repositories/change_password_repository.dart';
import 'package:kuemele/features/profile/presentation/security/domain/repositories/delete_account_repository.dart';
import 'package:kuemele/features/profile/presentation/security/domain/repositories/two_factor_setup_repository.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/edit_profile_bloc.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/interested_hobbies_bloc.dart';
import 'package:kuemele/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:kuemele/features/profile/presentation/profileset/data/repositories/edit_profile_repository_impl.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/repositories/edit_profile_repository.dart';
import 'package:kuemele/features/profile/presentation/my_events/cubit/my_events_cubit.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/profile_page_bloc.dart';
import 'package:kuemele/features/profile/presentation/profileset/data/repositories/hobbies_repository_impl.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/repositories/hobbies_repository.dart';
import 'package:kuemele/features/blog/domain/repositories/blog_repository.dart';
import 'package:kuemele/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:kuemele/features/discover/cubit/create_event_cubit.dart';
import 'package:kuemele/features/discover/cubit/event_matched_bloc.dart';
import 'package:kuemele/features/discover/data/repositories/create_event_repository_impl.dart';
import 'package:kuemele/features/discover/domain/repositories/create_event_repository.dart';
import 'package:kuemele/features/explore/cubit/event_detail_cubit.dart';
import 'package:kuemele/features/explore/cubit/explore_cubit.dart';
import 'package:kuemele/features/explore/data/repositories/explore_repository_impl.dart';
import 'package:kuemele/features/explore/domain/repositories/explore_repository.dart';
import 'package:kuemele/features/explore/data/repositories/notification_repository_impl.dart';
import 'package:kuemele/features/explore/domain/repositories/notification_repository.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_bloc.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/cubit/swipe_card_bloc.dart';
import 'package:kuemele/features/home/cubit/home_page_cubit.dart';
import 'package:kuemele/features/profile/cubit/profile_cubit.dart';
import 'package:kuemele/core/app_initialization/app_initialization_service.dart';
import 'package:kuemele/core/get_it.dart';
import 'package:kuemele/core/responsive/responsive_service.dart';
import 'package:kuemele/core/snackbar/snackbar_service.dart';
import 'package:kuemele/navigation/app_router.dart';
import 'package:kuemele/shared/services/google_auth/google_auth_service.dart';
import 'package:kuemele/shared/services/passkey/passkey_service.dart';
import 'package:kuemele/shared/services/recaptcha/recaptcha_service.dart';
import 'package:kuemele/shared/services/recaptcha/app_recaptcha_service.dart';
import 'package:kuemele/shared/services/image_picker/image_picker_service.dart';
import 'package:kuemele/shared/services/share/share_service.dart';
import 'package:kuemele/shared/services/clipboard_service.dart';
import 'package:kuemele/shared/services/video_player_service.dart';
import 'package:kuemele/shared/services/location_service.dart';
import 'package:kuemele/shared/cubit/location_cubit.dart';
import 'package:kuemele/shared/widgets/location_picker/location_picker_cubit.dart';

export 'package:kuemele/core/get_it.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void setupServiceLocator() {
  // Global Keys
  getIt.registerLazySingleton<GlobalKey<NavigatorState>>(() => navigatorKey);

  // Router
  getIt.registerLazySingleton<GoRouter>(createAppRouter);

  // Services
  getIt.registerLazySingleton<LocationService>(() => LocationService());
  getIt.registerLazySingleton<LocationCubit>(
    () => LocationCubit(locationService: getIt<LocationService>()),
  );
  getIt.registerLazySingleton<LocationPickerCubit>(
    () => LocationPickerCubit(locationService: getIt<LocationService>()),
  );
  getIt.registerLazySingleton<PasskeyService>(() => PasskeyService());
  getIt.registerLazySingleton<GoogleAuthService>(() => GoogleAuthService());
  getIt.registerLazySingleton<RecaptchaService>(() => RecaptchaService());
  getIt.registerLazySingleton<AppRecaptchaService>(() => AppRecaptchaService());
  getIt.registerLazySingleton<VideoPlayerService>(() => VideoPlayerService());
  getIt.registerLazySingleton<ResponsiveService>(
      () => const ResponsiveService());
  getIt.registerLazySingleton<SnackBarService>(() => SnackBarService());
  getIt.registerLazySingleton<AuthStorage>(() => const AuthStorage());
  getIt.registerLazySingleton<SigninPreferencesStorage>(
    () => const SigninPreferencesStorage(),
  );

  //Cubit
  getIt.registerLazySingleton<AppCubit>(() => AppCubit());
  getIt.registerLazySingleton<LocaleCubit>(() => LocaleCubit());
  getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit());
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authStorage: getIt<AuthStorage>(),
      passkeyService: getIt<PasskeyService>(),
      googleAuthService: getIt<GoogleAuthService>(),
    ),
  );
  getIt.registerLazySingleton<ConnectionsRepository>(
    () => ConnectionsRepositoryImpl(),
  );
  getIt.registerLazySingleton<ProfilePageBloc>(
    () => ProfilePageBloc(
      profileCubit: getIt<ProfileCubit>(),
      authRepository: getIt<AuthRepository>(),
      connectionsRepository: getIt<ConnectionsRepository>(),
    ),
  );
  getIt.registerLazySingleton<AppInitializationService>(
    () => AppInitializationService(
      profileCubit: getIt<ProfileCubit>(),
      profilePageBloc: getIt<ProfilePageBloc>(),
      blogBloc: getIt<BlogBloc>(),
    ),
  );
  getIt.registerLazySingleton<HomePageCubit>(() => HomePageCubit());
  getIt.registerLazySingleton<SigninBloc>(
    () => SigninBloc(
      preferencesStorage: getIt<SigninPreferencesStorage>(),
    ),
  );
  getIt.registerLazySingleton<SignupBloc>(() => SignupBloc());
  getIt.registerLazySingleton<ForgotPasswordBloc>(
    () => ForgotPasswordBloc(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<ResetPasswordBloc>(
    () => ResetPasswordBloc(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<EmailVerificationBloc>(
    () => EmailVerificationBloc(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<HobbiesRepository>(
    () => HobbiesRepositoryImpl(),
  );
  getIt.registerLazySingleton<BlogRepository>(
    () => BlogRepositoryImpl(),
  );
  getIt.registerLazySingleton<ExploreRepository>(
    () => ExploreRepositoryImpl(),
  );
  getIt.registerLazySingleton<ExploreCubit>(
    () => ExploreCubit(repository: getIt<ExploreRepository>()),
  );
  getIt.registerLazySingleton<MyEventsCubit>(
    () => MyEventsCubit(
      repository: getIt<ExploreRepository>(),
      profileCubit: getIt<ProfileCubit>(),
    ),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(),
  );
  getIt.registerLazySingleton<NotificationBloc>(
    () => NotificationBloc(repository: getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<SwipeCardBloc>(() => SwipeCardBloc());
  getIt.registerLazySingleton<EventDetailCubit>(
    () => EventDetailCubit(repository: getIt<ExploreRepository>()),
  );
  getIt.registerLazySingleton<EventMatchedBloc>(
    () => EventMatchedBloc(
      chatRoomRepository: getIt<ChatRoomRepository>(),
    ),
  );
  getIt.registerLazySingleton<ImagePickerService>(() => ImagePickerService());
  getIt.registerLazySingleton<ShareService>(() => ShareService());
  getIt.registerLazySingleton<ClipboardService>(() => ClipboardService());
  getIt.registerLazySingleton<CreateEventRepository>(
    () => CreateEventRepositoryImpl(),
  );
  getIt.registerLazySingleton<CreateEventCubit>(
    () => CreateEventCubit(
      imagePickerService: getIt<ImagePickerService>(),
      repository: getIt<CreateEventRepository>(),
    ),
  );
  getIt.registerLazySingleton<TranslationRepository>(
    () => TranslationRepositoryImpl(),
  );
  getIt.registerLazySingleton<EditProfileRepository>(
    () => EditProfileRepositoryImpl(),
  );
  getIt.registerLazySingleton<EditProfileBloc>(
    () => EditProfileBloc(
      editProfileRepository: getIt<EditProfileRepository>(),
      imagePickerService: getIt<ImagePickerService>(),
    ),
  );
  getIt.registerLazySingleton<ContactSupportRepository>(
    () => ContactSupportRepositoryImpl(),
  );
  getIt.registerLazySingleton<ContactBloc>(
    () => ContactBloc(
      contactSupportRepository: getIt<ContactSupportRepository>(),
      imagePickerService: getIt<ImagePickerService>(),
    ),
  );
  getIt.registerLazySingleton<ChangePasswordRepository>(
    () => ChangePasswordRepositoryImpl(),
  );
  getIt.registerLazySingleton<ChangePasswordBloc>(
    () => ChangePasswordBloc(
      changePasswordRepository: getIt<ChangePasswordRepository>(),
    ),
  );
  getIt.registerLazySingleton<DeleteAccountRepository>(
    () => DeleteAccountRepositoryImpl(),
  );
  getIt.registerLazySingleton<DeleteAccountBloc>(
    () => DeleteAccountBloc(
      deleteAccountRepository: getIt<DeleteAccountRepository>(),
    ),
  );
  getIt.registerLazySingleton<TwoFactorSetupRepository>(
    () => TwoFactorSetupRepositoryImpl(),
  );
  getIt.registerLazySingleton<TwoFactorSetupBloc>(
    () => TwoFactorSetupBloc(
      repository: getIt<TwoFactorSetupRepository>(),
    ),
  );
  getIt.registerLazySingleton<TwoFactorDisableBloc>(
    () => TwoFactorDisableBloc(
      repository: getIt<TwoFactorSetupRepository>(),
    ),
  );
  getIt.registerLazySingleton<LanguagesBloc>(
    () => LanguagesBloc(translationRepository: getIt<TranslationRepository>()),
  );
  getIt.registerLazySingleton<ConnectionsBloc>(
    () => ConnectionsBloc(
      connectionsRepository: getIt<ConnectionsRepository>(),
    ),
  );
  getIt.registerLazySingleton<InterestedHobbiesBloc>(
    () => InterestedHobbiesBloc(hobbiesRepository: getIt<HobbiesRepository>()),
  );
  getIt.registerLazySingleton<BlogBloc>(
    () => BlogBloc(
      hobbiesRepository: getIt<HobbiesRepository>(),
      blogRepository: getIt<BlogRepository>(),
    ),
  );
  getIt.registerLazySingleton<OnboardingBloc>(
    () => OnboardingBloc(imagePickerService: getIt<ImagePickerService>()),
  );
  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      authRepository: getIt<AuthRepository>(),
      appInitializationService: getIt<AppInitializationService>(),
    ),
  );
  getIt.registerLazySingleton<ChatRoomRepository>(
    () => ChatRoomRepositoryImpl(),
  );
  getIt.registerLazySingleton<ChatSocketDataSource>(
    () => ChatSocketDataSource(),
  );
  getIt.registerLazySingleton<ChatRoomBloc>(
    () => ChatRoomBloc(
      repository: getIt<ChatRoomRepository>(),
      socket: getIt<ChatSocketDataSource>(),
    ),
  );
  getIt.registerLazySingleton<GuestScanBloc>(
    () => GuestScanBloc(exploreRepository: getIt<ExploreRepository>()),
  );
}

List<BlocProvider> get appBlocProviders => [
      BlocProvider<AppCubit>.value(value: getIt<AppCubit>()),
      BlocProvider<LocaleCubit>.value(value: getIt<LocaleCubit>()),
      BlocProvider<LocationCubit>.value(value: getIt<LocationCubit>()),
      BlocProvider<LocationPickerCubit>.value(
          value: getIt<LocationPickerCubit>()),
      BlocProvider<SigninBloc>.value(value: getIt<SigninBloc>()),
      BlocProvider<SignupBloc>.value(value: getIt<SignupBloc>()),
      BlocProvider<ForgotPasswordBloc>.value(
          value: getIt<ForgotPasswordBloc>()),
      BlocProvider<ResetPasswordBloc>.value(value: getIt<ResetPasswordBloc>()),
      BlocProvider<EmailVerificationBloc>.value(
        value: getIt<EmailVerificationBloc>(),
      ),
      BlocProvider<AuthBloc>.value(value: getIt<AuthBloc>()),
      BlocProvider<LanguagesBloc>.value(value: getIt<LanguagesBloc>()),
      BlocProvider<InterestedHobbiesBloc>.value(
        value: getIt<InterestedHobbiesBloc>(),
      ),
      BlocProvider<BlogBloc>.value(
        value: getIt<BlogBloc>(),
      ),
      BlocProvider<OnboardingBloc>.value(value: getIt<OnboardingBloc>()),
      BlocProvider<ProfilePageBloc>.value(value: getIt<ProfilePageBloc>()),
      BlocProvider<ExploreCubit>.value(value: getIt<ExploreCubit>()),
      BlocProvider<MyEventsCubit>.value(value: getIt<MyEventsCubit>()),
      BlocProvider<NotificationBloc>.value(value: getIt<NotificationBloc>()),
      BlocProvider<SwipeCardBloc>.value(value: getIt<SwipeCardBloc>()),
      BlocProvider<EventDetailCubit>.value(value: getIt<EventDetailCubit>()),
      BlocProvider<EventMatchedBloc>.value(value: getIt<EventMatchedBloc>()),
      BlocProvider<CreateEventCubit>.value(value: getIt<CreateEventCubit>()),
      BlocProvider<EditProfileBloc>.value(value: getIt<EditProfileBloc>()),
      BlocProvider<ChangePasswordBloc>.value(
          value: getIt<ChangePasswordBloc>()),
      BlocProvider<ContactBloc>.value(value: getIt<ContactBloc>()),
      BlocProvider<DeleteAccountBloc>.value(value: getIt<DeleteAccountBloc>()),
      BlocProvider<TwoFactorSetupBloc>.value(
          value: getIt<TwoFactorSetupBloc>()),
      BlocProvider<TwoFactorDisableBloc>.value(
          value: getIt<TwoFactorDisableBloc>()),
      BlocProvider<ConnectionsBloc>.value(value: getIt<ConnectionsBloc>()),
      BlocProvider<ChatRoomBloc>.value(value: getIt<ChatRoomBloc>()),
      BlocProvider<GuestScanBloc>.value(value: getIt<GuestScanBloc>()),
    ];

class InjectionHelper {
  static GlobalKey<NavigatorState> get navKey =>
      getIt<GlobalKey<NavigatorState>>();

  static GoRouter get router => getIt<GoRouter>();

  static PasskeyService get passkeyService => getIt<PasskeyService>();

  static GoogleAuthService get googleAuthService => getIt<GoogleAuthService>();

  static RecaptchaService get recaptchaService => getIt<RecaptchaService>();

  static AppRecaptchaService get appRecaptchaService =>
      getIt<AppRecaptchaService>();

  static VideoPlayerService get videoPlayerService =>
      getIt<VideoPlayerService>();

  static AppCubit get appCubit => getIt<AppCubit>();

  static ProfileCubit get profileCubit => getIt<ProfileCubit>();

  static HomePageCubit get homePageCubit => getIt<HomePageCubit>();

  static SigninBloc get signinBloc => getIt<SigninBloc>();

  static SignupBloc get signupBloc => getIt<SignupBloc>();

  static InterestedHobbiesBloc get interestedHobbiesBloc =>
      getIt<InterestedHobbiesBloc>();

  static BlogBloc get blogBloc => getIt<BlogBloc>();

  static BlogRepository get blogRepository => getIt<BlogRepository>();

  static OnboardingBloc get onboardingBloc => getIt<OnboardingBloc>();

  static ProfilePageBloc get profilePageBloc => getIt<ProfilePageBloc>();

  static ExploreRepository get exploreRepository => getIt<ExploreRepository>();

  static ExploreCubit get exploreCubit => getIt<ExploreCubit>();

  static MyEventsCubit get myEventsCubit => getIt<MyEventsCubit>();

  static NotificationBloc get notificationBloc => getIt<NotificationBloc>();

  static SwipeCardBloc get swipeCardBloc => getIt<SwipeCardBloc>();

  static EventDetailCubit get eventDetailCubit => getIt<EventDetailCubit>();

  static EventMatchedBloc get eventMatchedBloc => getIt<EventMatchedBloc>();

  static CreateEventCubit get createEventCubit => getIt<CreateEventCubit>();

  static CreateEventRepository get createEventRepository =>
      getIt<CreateEventRepository>();

  static ImagePickerService get imagePickerService =>
      getIt<ImagePickerService>();

  static ShareService get shareService => getIt<ShareService>();

  static ClipboardService get clipboardService => getIt<ClipboardService>();

  static AuthBloc get authBloc => getIt<AuthBloc>();

  static AuthStorage get authStorage => getIt<AuthStorage>();

  static SigninPreferencesStorage get signinPreferencesStorage =>
      getIt<SigninPreferencesStorage>();

  static ResponsiveService get responsiveService => getIt<ResponsiveService>();

  static SnackBarService get snackBar => getIt<SnackBarService>();

  static AppInitializationService get appInitializationService =>
      getIt<AppInitializationService>();

  static EditProfileBloc get editProfileBloc => getIt<EditProfileBloc>();

  static ChangePasswordBloc get changePasswordBloc =>
      getIt<ChangePasswordBloc>();

  static ContactBloc get contactBloc => getIt<ContactBloc>();

  static DeleteAccountBloc get deleteAccountBloc => getIt<DeleteAccountBloc>();

  static TwoFactorSetupRepository get twoFactorSetupRepository =>
      getIt<TwoFactorSetupRepository>();

  static TwoFactorSetupBloc get twoFactorSetupBloc =>
      getIt<TwoFactorSetupBloc>();

  static TwoFactorDisableBloc get twoFactorDisableBloc =>
      getIt<TwoFactorDisableBloc>();

  static ConnectionsBloc get connectionsBloc => getIt<ConnectionsBloc>();

  static LocationService get locationService => getIt<LocationService>();

  static LocationCubit get locationCubit => getIt<LocationCubit>();

  static LocationPickerCubit get locationPickerCubit =>
      getIt<LocationPickerCubit>();

  static ChatRoomBloc get chatRoomBloc => getIt<ChatRoomBloc>();

  static GuestScanBloc get guestScanBloc => getIt<GuestScanBloc>();
}
