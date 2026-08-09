import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog.dart';

extension GeneratedApiMethodMapper on GeneratedApiMethod {
  RequestMethod toRequestMethod() {
    return switch (this) {
      GeneratedApiMethod.get => RequestMethod.GET,
      GeneratedApiMethod.post => RequestMethod.POST,
      GeneratedApiMethod.put => RequestMethod.PUT,
      GeneratedApiMethod.patch => RequestMethod.PATCH,
      GeneratedApiMethod.delete => RequestMethod.DELETE,
      GeneratedApiMethod.head => RequestMethod.GET,
      GeneratedApiMethod.options => RequestMethod.GET,
    };
  }
}

class GeneratedApiOperations {
  GeneratedApiOperations._();

  static GeneratedApiDescriptor require(String operationId) {
    for (final descriptor in GeneratedApiCatalog.all) {
      if (descriptor.operationId == operationId) return descriptor;
    }
    throw StateError('Unknown API operation: $operationId');
  }

  static String resolvePath(
    GeneratedApiDescriptor descriptor, {
    Map<String, String> pathValues = const {},
  }) {
    var path = descriptor.path;
    for (final name in descriptor.pathParameters) {
      final value = pathValues[name];
      if (value == null) {
        throw ArgumentError.value(pathValues, 'pathValues', 'Missing $name');
      }
      path = path.replaceAll('{$name}', value);
    }
    return path;
  }

  static GeneratedApiDescriptor get uploadProfileImage =>
      require('UploadController_uploadProfileImage_v1');

  static GeneratedApiDescriptor get uploadEventBanner =>
      require('UploadController_uploadEventBanner_v1');

  static GeneratedApiDescriptor get getUserProfile =>
      require('UsersController_getProfile_v1');

  static GeneratedApiDescriptor get updateUserProfile =>
      require('UsersController_updateProfile_v1');

  static GeneratedApiDescriptor get updateUserProfileById =>
      require('UsersController_updateProfileById_v1');

  static GeneratedApiDescriptor get getReferralCode =>
      require('UsersController_getReferralCode_v1');

  static GeneratedApiDescriptor get generateQRCode =>
      require('UsersController_generateQRCode_v1');

  static GeneratedApiDescriptor get validateReferralCode =>
      require('UsersController_validateReferralCode_v1');

  static GeneratedApiDescriptor get changePassword =>
      require('AuthController_changePassword_v1');

  static GeneratedApiDescriptor get deleteAccount =>
      require('PrivacyController_deleteAccount_v1');

  static GeneratedApiDescriptor get getPrivacyPreferences =>
      require('PrivacyController_getPrivacyPreferences_v1');

  static GeneratedApiDescriptor get updateConsent =>
      require('PrivacyController_updateConsent_v1');

  static GeneratedApiDescriptor get getHobbyCategories =>
      require('HobbiesController_getCategories_v1');

  static GeneratedApiDescriptor get getUserHobbies =>
      require('HobbiesController_getUserHobbies_v1');

  static GeneratedApiDescriptor get updateUserHobbies =>
      require('HobbiesController_updateUserHobbies_v1');

  static GeneratedApiDescriptor get createSupportTicket =>
      require('SupportController_createTicket_v1');

  static GeneratedApiDescriptor get setup2FA =>
      require('AuthController_setup2FA_v1');

  static GeneratedApiDescriptor get enable2FA =>
      require('AuthController_enable2FA_v1');

  static GeneratedApiDescriptor get disable2FA =>
      require('AuthController_disable2FA_v1');

  static GeneratedApiDescriptor get verify2FA =>
      require('AuthController_verify2FA_v1');

  static GeneratedApiDescriptor get getLegalDocumentByType =>
      require('LegalController_findByType_v1');

  static GeneratedApiDescriptor get createEvent =>
      require('EventsController_createEvent_v1');

  static GeneratedApiDescriptor get listEvents =>
      require('EventsController_listEvents_v1');

  static GeneratedApiDescriptor get getEventDetails =>
      require('EventsController_getEventDetails_v1');

  static GeneratedApiDescriptor get joinEvent =>
      require('EventsController_joinEvent_v1');

  static GeneratedApiDescriptor get cancelEvent =>
      require('EventsController_cancelEvent_v1');

  static GeneratedApiDescriptor get selfCheckin =>
      require('EventsController_selfCheckin_v1');

  static GeneratedApiDescriptor get rateEvent =>
      require('EventsController_rateEvent_v1');

  static GeneratedApiDescriptor get getEventRatings =>
      require('EventsController_getEventRatings_v1');

  static GeneratedApiDescriptor get getEventRatingsSummary =>
      require('EventsController_getEventRatingsSummary_v1');

  static GeneratedApiDescriptor get getMyEventRating =>
      require('EventsController_getMyRating_v1');

  static GeneratedApiDescriptor get updateEventRating =>
      require('EventsController_updateEventRating_v1');

  static GeneratedApiDescriptor get deleteEventRating =>
      require('EventsController_deleteEventRating_v1');

  static GeneratedApiDescriptor get reportEvent =>
      require('EventsController_reportEvent_v1');

  static GeneratedApiDescriptor get createEventTicket =>
      require('TicketsController_createTicket_v1');

  static GeneratedApiDescriptor get getTicket =>
      require('TicketsController_getTicket_v1');

  static GeneratedApiDescriptor get cancelTicket =>
      require('TicketsController_cancelTicket_v1');

  static GeneratedApiDescriptor get validateTicket =>
      require('TicketsController_validateTicket_v1');

  static GeneratedApiDescriptor get getFollowers =>
      require('UsersController_getFollowers_v1');

  static GeneratedApiDescriptor get getFollowing =>
      require('UsersController_getFollowing_v1');

  static GeneratedApiDescriptor get getFollowStats =>
      require('UsersController_getFollowStats_v1');

  static GeneratedApiDescriptor get followUser =>
      require('UsersController_followUser_v1');

  static GeneratedApiDescriptor get unfollowUser =>
      require('UsersController_unfollowUser_v1');

  static GeneratedApiDescriptor get getNotifications =>
      require('NotificationsController_getNotifications_v1');

  static GeneratedApiDescriptor get markNotificationAsRead =>
      require('NotificationsController_markAsRead_v1');

  static GeneratedApiDescriptor get markAllNotificationsAsRead =>
      require('NotificationsController_markAllAsRead_v1');

  static GeneratedApiDescriptor get registerPushToken =>
      require('NotificationsController_registerPushToken_v1');

  static GeneratedApiDescriptor get getBlogFeed =>
      require('BlogsController_getBlogFeed_v1');

  static GeneratedApiDescriptor get getBlogDetails =>
      require('BlogsController_getBlogPost_v1');

  static GeneratedApiDescriptor get postBlogComment =>
      require('BlogsController_createComment_v1');

  static GeneratedApiDescriptor get getChatMessages =>
      require('ChatController_getChatMessages_v1');

  static GeneratedApiDescriptor get postChatMessage =>
      require('ChatController_sendMessage_v1');

  static GeneratedApiDescriptor get getChatStatus =>
      require('ChatController_getChatStatus_v1');

  static GeneratedApiDescriptor get joinChat =>
      require('ChatController_joinChat_v1');

  static GeneratedApiDescriptor get getEventGuestList =>
      require('EventsController_getGuestList_v1');

  static GeneratedApiDescriptor get hostCheckInGuest =>
      require('EventsController_hostCheckin_v1');

  static GeneratedApiDescriptor get login => require('AuthController_login_v1');

  static GeneratedApiDescriptor get logout =>
      require('AuthController_logout_v1');

  static GeneratedApiDescriptor get logoutAll =>
      require('AuthController_logoutAll_v1');

  static GeneratedApiDescriptor get resendVerification =>
      require('AuthController_resendVerification_v1');

  static GeneratedApiDescriptor get signup =>
      require('AuthController_signup_v1');

  static GeneratedApiDescriptor get firebaseLogin =>
      require('AuthController_firebaseLogin_v1');

  static GeneratedApiDescriptor get forgotPassword =>
      require('AuthController_forgotPassword_v1');

  static GeneratedApiDescriptor get resetPassword =>
      require('AuthController_resetPassword_v1');

  static GeneratedApiDescriptor get fetchAds =>
      require('AdsController_fetchAds_v1');

  static GeneratedApiDescriptor get trackAd =>
      require('AdsController_trackAd_v1');

  static GeneratedApiDescriptor get verifyResetOtp =>
      require('AuthController_verifyResetOtp_v1');

  static GeneratedApiDescriptor get sendVerificationEmail =>
      require('AuthController_sendVerificationEmail_v1');

  static GeneratedApiDescriptor get verifyEmail =>
      require('AuthController_verifyEmail_v1');

  static GeneratedApiDescriptor get refreshToken =>
      require('AuthController_refresh_v1');

  static GeneratedApiDescriptor get getCurrentUser =>
      require('AuthController_me_v1');

  static GeneratedApiDescriptor get passkeyLoginStart =>
      require('AuthController_passkeyLoginStart_v1');

  static GeneratedApiDescriptor get passkeyLoginFinish =>
      require('AuthController_passkeyLoginFinish_v1');

  static GeneratedApiDescriptor get passkeyRegisterStart =>
      require('AuthController_passkeyRegistrationStart_v1');

  static GeneratedApiDescriptor get passkeyRegisterFinish =>
      require('AuthController_passkeyRegistrationFinish_v1');

  static GeneratedApiDescriptor get getAppConfig =>
      require('AppConfigController_getConfig_v1');

  static GeneratedApiDescriptor get getLocalizationLanguages =>
      require('LocalizationController_getLanguages_v1');

  static GeneratedApiDescriptor get checkUsername =>
      require('UsersController_checkUsername_v1');

  static GeneratedApiDescriptor get getSubscriptionTiers =>
      require('SubscriptionsController_getSubscriptionTiers_v1');

  static GeneratedApiDescriptor get getSubscriptionStatus =>
      require('SubscriptionsController_getSubscriptionStatus_v1');

  static GeneratedApiDescriptor get createSubscription =>
      require('SubscriptionsController_createSubscription_v1');

  static GeneratedApiDescriptor get cancelSubscription =>
      require('SubscriptionsController_cancelSubscription_v1');

  static GeneratedApiDescriptor get resumeSubscription =>
      require('SubscriptionsController_resumeSubscription_v1');

  static GeneratedApiDescriptor get getPaymentHistory =>
      require('PaymentsController_getPaymentHistory_v1');

  static GeneratedApiDescriptor get createCardSetupIntent =>
      require('PaymentsController_createSetupIntent_v1');

  static GeneratedApiDescriptor get getMyTickets =>
      require('TicketsController_getMyTickets_v1');

  static GeneratedApiDescriptor get createEventPayment =>
      require('PaymentsController_createEventPayment_v1');

  static GeneratedApiDescriptor get createEventCreationPayment =>
      require('PaymentsController_createEventCreationPayment_v1');

  static GeneratedApiDescriptor get confirmPayment =>
      require('PaymentsController_confirmPayment_v1');

  static GeneratedApiDescriptor get createPayPalOrder =>
      require('PaymentsController_createPayPalOrder_v1');

  static GeneratedApiDescriptor get createPayPalEventCreationOrder =>
      require('PaymentsController_createPayPalEventCreationOrder_v1');

  static GeneratedApiDescriptor get capturePayPalOrder =>
      require('PaymentsController_capturePayPalOrder_v1');

  static GeneratedApiDescriptor get createPayPalVaultSetupToken =>
      require('PaymentsController_createPayPalVaultSetupToken_v1');

  static GeneratedApiDescriptor get getMyNftScreen =>
      require('NftsController_getMyScreen_v1');

  static GeneratedApiDescriptor get getMyNfts =>
      require('NftsController_getMyNfts_v1');

  static GeneratedApiDescriptor get getRewardNfts =>
      require('NftsController_getRewardsPage_v1');

  static GeneratedApiDescriptor get getMarketplaceNfts =>
      require('NftsController_getMarketplace_v1');

  static GeneratedApiDescriptor get claimNft =>
      require('NftsController_claimNft_v1');

  static GeneratedApiDescriptor get purchaseNft =>
      require('NftsController_purchaseNft_v1');

  static GeneratedApiDescriptor get getChatRooms =>
      require('ChatRoomsController_getChatRooms_v1');

  static GeneratedApiDescriptor get getEventRecommendations =>
      require('EventsController_getRecommendationsEvents_v1');

  static GeneratedApiDescriptor get getRecommendationsHobbies =>
      require('HobbiesController_getRecommendationsHobbies_v1');

  static GeneratedApiDescriptor get getTranslationLanguages =>
      require('TranslationController_getLanguages_v1');

  static GeneratedApiDescriptor get getCart =>
      require('CartController_getCart_v1');

  static GeneratedApiDescriptor get addToCart =>
      require('CartController_addToCart_v1');

  static GeneratedApiDescriptor get updateCartItem =>
      require('CartController_updateCartItem_v1');

  static GeneratedApiDescriptor get removeFromCart =>
      require('CartController_removeFromCart_v1');

  static GeneratedApiDescriptor get clearCart =>
      require('CartController_clearCart_v1');

  static GeneratedApiDescriptor get getProducts =>
      require('ProductsController_findAll_v1');

  static GeneratedApiDescriptor get getProduct =>
      require('ProductsController_findOne_v1');

  static GeneratedApiDescriptor get getRewardDiscounts =>
      require('DiscountsController_getUserRewardDiscounts_v1');

  static GeneratedApiDescriptor get validateDiscount =>
      require('DiscountsController_validateDiscount_v1');

  static GeneratedApiDescriptor get getEscrowStatus =>
      require('PaymentsController_getEscrowStatus_v1');

  static GeneratedApiDescriptor get listSavedCards =>
      require('PaymentsController_listSavedCards_v1');

  static GeneratedApiDescriptor get saveCard =>
      require('PaymentsController_saveCard_v1');

  static GeneratedApiDescriptor get deleteCard =>
      require('PaymentsController_deleteCard_v1');

  static GeneratedApiDescriptor get setDefaultCard =>
      require('PaymentsController_setDefaultCard_v1');

  static GeneratedApiDescriptor get getPayPalOrderStatus =>
      require('PaymentsController_getPayPalOrderStatus_v1');
}
