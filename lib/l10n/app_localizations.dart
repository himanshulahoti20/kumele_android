import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('zh')
  ];

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Self-check'**
  String get selfCheck;

  /// Feedback
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Feedback
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Feedback
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Feedback
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// Feedback
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// Feedback
  ///
  /// In en, this message translates to:
  /// **'Add your comment...'**
  String get addYourComment;

  /// Feedback
  ///
  /// In en, this message translates to:
  /// **'Publish comment'**
  String get publishComment;

  /// Feedback
  ///
  /// In en, this message translates to:
  /// **'Posted!'**
  String get posted;

  /// Validation
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// Validation
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// Empty states
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// Empty states
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// Empty states
  ///
  /// In en, this message translates to:
  /// **'No Chats'**
  String get noChats;

  /// Empty states
  ///
  /// In en, this message translates to:
  /// **'You have no chats right now. Start a conversation or check back later.'**
  String get noChatsDescription;

  /// Empty states
  ///
  /// In en, this message translates to:
  /// **'No Guests'**
  String get noGuests;

  /// Empty states
  ///
  /// In en, this message translates to:
  /// **'There are no guests checked in or registered for this event yet.'**
  String get noGuestsDescription;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Spirituality'**
  String get spirituality;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Hosted by'**
  String get hostedBy;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Rate event'**
  String get rateEvent;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Report event'**
  String get reportEvent;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Guest Scan'**
  String get guestScan;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Align the guest QR code within the frame'**
  String get alignQrInFrame;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Guest not found in this event'**
  String get guestNotFound;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Invalid QR code'**
  String get invalidQrCode;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Confirm check-in'**
  String get confirmCheckIn;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Check in this guest for the event?'**
  String get confirmGuestCheckInDescription;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Successfully checked in {name}!'**
  String checkedInSuccess(String name);

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Checked In'**
  String get checkedInLabel;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Not Checked In'**
  String get notCheckedInLabel;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmedLabel;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Follow Host'**
  String get followHost;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'-- days left to rate &\nreview'**
  String get daysLeftToRate;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Scanned list: --'**
  String get scannedList;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Event Canceled'**
  String get eventCanceled;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'No Messages'**
  String get noMessages;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'There are no messages here yet.'**
  String get noMessagesDescription;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Failed to join chat room'**
  String get joinChatFailed;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Successfully joined the chat room'**
  String get joinChatSuccess;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Failed to load chat messages'**
  String get loadMessagesFailed;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Failed to send message'**
  String get sendMessageFailed;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Chat is not available'**
  String get chatNotAvailable;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'You do not have access to this chat'**
  String get chatAccessDenied;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'This chat is closed'**
  String get chatClosed;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get typeAMessage;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownUser;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Active Event'**
  String get activeEvent;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Event Chat'**
  String get eventChat;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Event Address'**
  String get eventAddressLabel;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Cash on entry'**
  String get cashOnEntry;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'My Events'**
  String get myEvents;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Created Events'**
  String get createdEvents;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Joined Events'**
  String get joinedEvents;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'You haven\'t created any events yet.'**
  String get noEventsCreatedYet;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'You haven\'t joined any events yet.'**
  String get noEventsJoinedYet;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Blogs'**
  String get blogsTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get settingsTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Interested hobbies'**
  String get interestedHobbies;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Edit hobbies'**
  String get editHobbies;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'My QR Code'**
  String get myQrCode;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Gold status'**
  String get goldStatus;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Failed to load languages.'**
  String get languagesLoadFailed;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Failed to load followers and following.'**
  String get connectionsLoadFailed;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Card Payments, Subscriptions & Escrow '**
  String get cardPaymentsSubscriptions;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Tell us how we can help.'**
  String get contactPageSubtitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get contactSubjectLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Brief summary of your issue'**
  String get contactSubjectHint;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get contactDescriptionLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Describe your issue in detail'**
  String get contactDescriptionHint;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get contactCategoryLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get contactPriorityLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Attachment (optional)'**
  String get contactAttachmentLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Upload a screenshot'**
  String get contactAttachmentHint;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get contactSubmitLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Your message has been sent.'**
  String get contactSuccessMessage;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Failed to send message. Please try again.'**
  String get contactSubmitFailed;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Please enter at least 20 characters so support can help properly.'**
  String get contactDescriptionTooShort;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Please enter a subject.'**
  String get contactSubjectRequired;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Please enter a description.'**
  String get contactDescriptionRequired;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image.'**
  String get contactAttachmentPickFailed;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Guidelines'**
  String get guidelines;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Refer a Friend'**
  String get referAFriend;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Your referral code is not available right now. Please try again later.'**
  String get referralCodeUnavailable;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Join me on Kumele'**
  String get referralShareSubject;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Join me on Kumele — meet local hobby friends through shared interests!\n\nUse my referral code: {referralCode}\n\nSign up here: {referralLink}'**
  String referralShareMessage(String referralCode, String referralLink);

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Night Mode'**
  String get nightMode;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Signout'**
  String get signOut;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Are you sure? This action cannot\n be undone. Please retype \npassword.'**
  String get deleteAccountConfirmTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get deleteAccountPasswordHint;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'This action is permanent. Enter your password and tell us why you are leaving.'**
  String get deleteAccountPageSubtitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get deleteAccountPasswordLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get deleteAccountReasonLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Tell us why you are leaving'**
  String get deleteAccountReasonHint;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'I understand this action is permanent and cannot be undone'**
  String get deleteAccountConfirmationLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountSubmitLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Account successfully deleted.'**
  String get deleteAccountSuccessMessage;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get deleteAccountSubmitFailed;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get deleteAccountPasswordRequired;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Please tell us why you are leaving.'**
  String get deleteAccountReasonRequired;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Please confirm that you understand this action is permanent.'**
  String get deleteAccountConfirmationRequired;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to\n signout?'**
  String get signOutConfirmTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Signed out successfully.'**
  String get signOutSuccessMessage;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordPageTitle;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we will send you a reset token.'**
  String get forgotPasswordSubtitle;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'E-Mail'**
  String get forgotPasswordEmailLabel;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Enter E-Mail'**
  String get forgotPasswordHint;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Send Reset Email'**
  String get forgotPasswordSubmitLabel;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'If that email exists, a reset link has been sent.'**
  String get forgotPasswordSuccessMessage;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordPageTitle;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your email and choose a new password.'**
  String get resetPasswordSubtitle;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get resetPasswordTokenLabel;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get resetPasswordTokenHint;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get resetPasswordNewPasswordLabel;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get resetPasswordNewPasswordHint;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get resetPasswordConfirmPasswordLabel;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get resetPasswordConfirmPasswordHint;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordSubmitLabel;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get resetPasswordSuccessMessage;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLengthError;

  /// Forgot / Reset password
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatchError;

  /// Email verification
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get emailVerificationPageTitle;

  /// Email verification
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit verification code to your email. Enter it below to continue.'**
  String get emailVerificationSubtitle;

  /// Email verification
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get emailVerificationVerifyLabel;

  /// Email verification
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get emailVerificationResendLabel;

  /// Email verification
  ///
  /// In en, this message translates to:
  /// **'Resend code in'**
  String get emailVerificationResendInLabel;

  /// Email verification
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to your email.'**
  String get emailVerificationSentMessage;

  /// Email verification
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code. Please try again.'**
  String get emailVerificationFailedMessage;

  /// Email verification
  ///
  /// In en, this message translates to:
  /// **'Failed to send verification code. Please try again.'**
  String get emailVerificationSendFailedMessage;

  /// Email verification
  ///
  /// In en, this message translates to:
  /// **'Email verified successfully!'**
  String get emailVerificationSuccessMessage;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get changePasswordCurrentLabel;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get changePasswordCurrentHint;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get changePasswordNewLabel;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get changePasswordNewHint;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get changePasswordConfirmLabel;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get changePasswordConfirmHint;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get changePasswordSubmitLabel;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully. Please sign in with your new password.'**
  String get changePasswordSuccessMessage;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Failed to update password. Please try again.'**
  String get changePasswordSubmitFailed;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password.'**
  String get changePasswordCurrentRequired;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Register Passkey'**
  String get registerPasskey;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Two Factor Authentication'**
  String get twoFactorAuth;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Authenticator App Setup'**
  String get twoFactorSetupTitle;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'1. Open an authenticator app on your mobile device'**
  String get twoFactorSetupStep1;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'If you don\'t have one, download and install one of the recommended apps:'**
  String get twoFactorSetupStep1Hint;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'2. Scan this barcode with your '**
  String get twoFactorSetupStep2Lead;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'authenticator app'**
  String get twoFactorSetupStep2Bold;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Can\'t scan? Use this code instead'**
  String get twoFactorSetupCantScan;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'3. Enter the six-digit code from the '**
  String get twoFactorSetupStep3Lead;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'authenticator app'**
  String get twoFactorSetupStep3Bold;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code Here'**
  String get twoFactorVerificationHint;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Failed to load 2FA setup. Please try again.'**
  String get twoFactorSetupLoadFailed;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Failed to enable 2FA. Please check your code and try again.'**
  String get twoFactorEnableFailed;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Two factor authentication enabled successfully.'**
  String get twoFactorEnableSuccess;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Setup code copied to clipboard'**
  String get twoFactorManualCodeCopied;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setup;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Disable Two Factor Authentication'**
  String get twoFactorDisableTitle;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to turn off two factor authentication?'**
  String get twoFactorDisableSubtitle;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Your account will only be protected by your password. We recommend keeping 2FA enabled for better security.'**
  String get twoFactorDisableDescription;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Disable Two Factor'**
  String get twoFactorDisableConfirm;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Enter the six-digit code from your '**
  String get twoFactorDisableCodeLead;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Two factor authentication disabled successfully.'**
  String get twoFactorDisableSuccess;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Failed to disable 2FA. Please check your code and try again.'**
  String get twoFactorDisableFailed;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Two Factor Authentication'**
  String get twoFactorLoginTitle;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Enter the code from your authenticator app to continue'**
  String get twoFactorLoginSubtitle;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Your account is protected with two factor authentication.'**
  String get twoFactorLoginDescription;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Enter the six-digit code from your '**
  String get twoFactorLoginCodeLead;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'authenticator app'**
  String get twoFactorLoginCodeBold;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get twoFactorLoginVerify;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code. Please try again.'**
  String get twoFactorLoginFailed;

  /// Security
  ///
  /// In en, this message translates to:
  /// **'Passkey registered successfully'**
  String get passkeyRegisterSuccess;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Set up your profile'**
  String get onboardingPageTitle;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Add a photo and tell the community about yourself.'**
  String get onboardingPageSubtitle;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Tap to add photo'**
  String get onboardingAvatarHint;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Add profile photo'**
  String get onboardingImagePickerTitle;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Choose gallery or camera for your profile picture'**
  String get onboardingImagePickerSubtitle;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get onboardingUsernameLabel;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Choose a username (optional)'**
  String get onboardingUsernameHint;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Usernames can only be changed every 3 months'**
  String get onboardingUsernameHelper;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Checking username...'**
  String get onboardingUsernameChecking;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Username is available'**
  String get onboardingUsernameAvailable;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Username is already taken'**
  String get onboardingUsernameTaken;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get onboardingPhoneLabel;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number (optional)'**
  String get onboardingPhoneHint;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'About me'**
  String get onboardingAboutLabel;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Tell us about your interests, hobbies, and what you enjoy doing'**
  String get onboardingAboutHint;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully.'**
  String get onboardingSuccessMessage;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Please add a profile photo.'**
  String get onboardingImageRequired;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number.'**
  String get onboardingPhoneRequired;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number.'**
  String get onboardingPhoneInvalid;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'About me must be at least 200 characters.'**
  String get onboardingAboutTooShort;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'About me cannot exceed 500 characters.'**
  String get onboardingAboutTooLong;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Image upload is only available on Android.'**
  String get onboardingImagePlatformUnsupported;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image.'**
  String get onboardingImagePickFailed;

  /// Onboarding
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile. Please try again.'**
  String get onboardingSubmitFailed;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get editProfileFirstNameLabel;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get editProfileFirstNameHint;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get editProfileLastNameLabel;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get editProfileLastNameHint;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'About me'**
  String get editProfileAboutLabel;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'Tell us about your interests, hobbies, and what you enjoy doing'**
  String get editProfileAboutHint;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get editProfilePhoneLabel;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get editProfilePhoneHint;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get editProfileUpdateLabel;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get editProfileSuccessMessage;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile. Please try again.'**
  String get editProfileSubmitFailed;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name.'**
  String get editProfileFirstNameRequired;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'About me cannot exceed 500 characters.'**
  String get editProfileAboutTooLong;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number.'**
  String get editProfilePhoneInvalid;

  /// Edit profile
  ///
  /// In en, this message translates to:
  /// **'Unable to update profile. User not found.'**
  String get editProfileUserMissing;

  /// Map & Location Picker
  ///
  /// In en, this message translates to:
  /// **'Pick Event Location'**
  String get pickEventLocation;

  /// Map & Location Picker
  ///
  /// In en, this message translates to:
  /// **'Selected Location'**
  String get selectedLocation;

  /// Map & Location Picker
  ///
  /// In en, this message translates to:
  /// **'Fetching address…'**
  String get fetchingAddress;

  /// Map & Location Picker
  ///
  /// In en, this message translates to:
  /// **'Move the map to pick a location'**
  String get moveMapToPickLocation;

  /// Map & Location Picker
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// Map & Location Picker
  ///
  /// In en, this message translates to:
  /// **'Searching…'**
  String get searching;

  /// Map & Location Picker
  ///
  /// In en, this message translates to:
  /// **'Unknown location'**
  String get unknownLocation;

  /// Map & Location Picker
  ///
  /// In en, this message translates to:
  /// **'Could not fetch address'**
  String get couldNotFetchAddress;

  /// Map & Location Picker
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationServicesDisabled;

  /// Map & Location Picker
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get locationPermissionDenied;

  /// Map & Location Picker
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied.'**
  String get locationPermissionPermanentlyDenied;

  /// Map & Location Picker
  ///
  /// In en, this message translates to:
  /// **'Pick event location'**
  String get pickEventLocationPlaceholder;

  /// Map & Location Picker
  ///
  /// In en, this message translates to:
  /// **'Tap to open map and drop a pin'**
  String get tapToOpenMapPlaceholder;

  /// Share Event Bottom Sheet
  ///
  /// In en, this message translates to:
  /// **'Limited Invites'**
  String get limitedInvites;

  /// Share Event Bottom Sheet
  ///
  /// In en, this message translates to:
  /// **'How it works:'**
  String get howItWorks;

  /// Share Event Bottom Sheet
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Share Event Bottom Sheet
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// Share Event Bottom Sheet
  ///
  /// In en, this message translates to:
  /// **'Invite your friends and family'**
  String get inviteFriendsAndFamily;

  /// Share Event Bottom Sheet
  ///
  /// In en, this message translates to:
  /// **'Event code copied to clipboard!'**
  String get eventCodeCopied;

  /// Share Event Bottom Sheet
  ///
  /// In en, this message translates to:
  /// **'Copy to'**
  String get copyTo;

  /// Share Event Bottom Sheet
  ///
  /// In en, this message translates to:
  /// **'clipboard'**
  String get clipboard;

  /// Share Event Bottom Sheet
  ///
  /// In en, this message translates to:
  /// **'Event ID: '**
  String get eventIdLabel;

  /// Share Event Bottom Sheet
  ///
  /// In en, this message translates to:
  /// **'Location: '**
  String get locationLabel;

  /// Scan QR Page
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanQr;

  /// Scan QR Page
  ///
  /// In en, this message translates to:
  /// **'Host QR'**
  String get hostQr;

  /// Scan QR Page
  ///
  /// In en, this message translates to:
  /// **'Group meditation'**
  String get groupMeditation;

  /// Scan QR Page
  ///
  /// In en, this message translates to:
  /// **'Ankit Maheswari'**
  String get demoHostName;

  /// Scan QR Page
  ///
  /// In en, this message translates to:
  /// **'Bahawalpur, Pun Pakistan'**
  String get demoLocation;

  /// Auth - Signup / Signin
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Auth - Signin
  ///
  /// In en, this message translates to:
  /// **'Enter email | Nickname'**
  String get signInEmailHint;

  /// Auth - Signin
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get signInPasswordHint;

  /// Auth - Signin
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get signInRememberMeLabel;

  /// Auth - Signin
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get signInForgotPasswordLabel;

  /// Auth - Signin
  ///
  /// In en, this message translates to:
  /// **'I am not a robot'**
  String get signInCaptchaLabel;

  /// Auth - Signin
  ///
  /// In en, this message translates to:
  /// **'Not a member? '**
  String get signInNotAMemberPrefix;

  /// Auth - Signin
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? '**
  String get signInNoAccountPrefix;

  /// Auth - Signin
  ///
  /// In en, this message translates to:
  /// **'Or Sign in with Passkey'**
  String get signInPasskeyDividerLabel;

  /// Auth - Signin
  ///
  /// In en, this message translates to:
  /// **'We recommend Passkey to all users, if your device supports it for better security and a pleasant user experience.'**
  String get signInPasskeyDescription;

  /// Auth - Signin
  ///
  /// In en, this message translates to:
  /// **'Language choice:'**
  String get signInLanguageChoiceLabel;

  /// Auth - Signin
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get signInFillFieldsError;

  /// Auth - Signin
  ///
  /// In en, this message translates to:
  /// **'Please confirm you are not a robot'**
  String get signInCaptchaRequiredError;

  /// Auth - Signin
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully'**
  String get signInSuccessMessage;

  /// Auth - Signin
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogleLabel;

  /// Auth - Signup / Signin
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// Auth - Signup / Signin
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get signupFirstNameLabel;

  /// Auth - Signup / Signin
  ///
  /// In en, this message translates to:
  /// **'Enter first name'**
  String get signupFirstNameHint;

  /// Auth - Signup / Signin
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get signupLastNameLabel;

  /// Auth - Signup / Signin
  ///
  /// In en, this message translates to:
  /// **'Enter last name'**
  String get signupLastNameHint;

  /// Auth - Signup / Signin
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get signupEmailHint;

  /// Auth - Signup / Signin
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get signupPasswordHint;

  /// Auth - Signup / Signin
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signupConfirmPasswordHint;

  /// Auth - Signup / Signin
  ///
  /// In en, this message translates to:
  /// **'Referral code'**
  String get signupReferralCodeLabel;

  /// Auth - Signup / Signin
  ///
  /// In en, this message translates to:
  /// **'Beta code'**
  String get signupBetaCodeLabel;

  /// Auth - Signup / Signin
  ///
  /// In en, this message translates to:
  /// **' e.g. DF4R435'**
  String get signupCodeHint;

  /// Auth - Signup / Signin
  ///
  /// In en, this message translates to:
  /// **'Sign in with your Kumele passkey'**
  String get passkeySignInTitle;

  /// Earn Medals
  ///
  /// In en, this message translates to:
  /// **'Earn Medals'**
  String get earnMedals;

  /// Earn Medals
  ///
  /// In en, this message translates to:
  /// **'Bronze Status'**
  String get bronzeStatus;

  /// Earn Medals
  ///
  /// In en, this message translates to:
  /// **'Silver Status'**
  String get silverStatus;

  /// Earn Medals
  ///
  /// In en, this message translates to:
  /// **'Gold Status'**
  String get goldStatusMedal;

  /// Earn Medals
  ///
  /// In en, this message translates to:
  /// **'User created a minimum of 2 events or user attended a minimum of 2 events without fail in the \nlast 30 days. The user gets 2% discount of 1 in-app purchase of choice.'**
  String get bronzeStatusDescription;

  /// Earn Medals
  ///
  /// In en, this message translates to:
  /// **'User created a minimum of 3 events or user attended a minimum of 3 events without fail in the\n last 30 days. The user gets 4% discount of 1 in-app purchase of choice.'**
  String get silverStatusDescription;

  /// Earn Medals
  ///
  /// In en, this message translates to:
  /// **'User created a minimum of 4 events or user attended a minimum of 4 events without fail in the \nlast 30 days. The user gets 8% discount of 1 in-app purchase of choice.'**
  String get goldStatusMedalDescription;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTitle;

  /// Filter
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// Filter
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Filter
  ///
  /// In en, this message translates to:
  /// **'Distance range (in Kilometers)'**
  String get distanceRangeLabel;

  /// Filter
  ///
  /// In en, this message translates to:
  /// **'Age range'**
  String get ageRangeLabel;

  /// Filter
  ///
  /// In en, this message translates to:
  /// **'PaidEvent'**
  String get paidEvent;

  /// Filter
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get stateHint;

  /// Filter
  ///
  /// In en, this message translates to:
  /// **'Postal/Zip Code'**
  String get postalZipCodeHint;

  /// Filter
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryHint;

  /// Shop / NFT
  ///
  /// In en, this message translates to:
  /// **'Open Phantom Wallet'**
  String get openPhantomWallet;

  /// Shop / NFT
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get nftDescriptionLabel;

  /// Shop / NFT
  ///
  /// In en, this message translates to:
  /// **'NFT Details'**
  String get nftDetailsLabel;

  /// Shop
  ///
  /// In en, this message translates to:
  /// **'Number of guests valid only for this event'**
  String get guestCountValidForEventOnly;

  /// Shop / NFT
  ///
  /// In en, this message translates to:
  /// **'Token ID'**
  String get tokenIdLabel;

  /// Shop / NFT
  ///
  /// In en, this message translates to:
  /// **'Token Standard'**
  String get tokenStandardLabel;

  /// Shop / NFT
  ///
  /// In en, this message translates to:
  /// **'Blockchain'**
  String get blockchainLabel;

  /// Shop / NFT
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get creatorLabel;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Add Comments'**
  String get addCommentsHint;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Report Event'**
  String get reportEventPageTitle;

  /// Chat
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get ratingPageTitle;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Like post'**
  String get blogLikePostSemanticLabel;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get blogLikesLabel;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get blogShareLabel;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Reply to'**
  String get replyDialogTitlePrefix;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Write your reply...'**
  String get replyDialogHint;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'No blogs found'**
  String get blogEmptyStateTitle;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Try a different category filter.'**
  String get blogEmptyStateDescription;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get blogCategoryAll;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get blogCategoryFood;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get blogCategoryTravel;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get blogCategorySports;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get blogCategoryMusic;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Placeholder title for blog post loading effect'**
  String get blogPlaceholderTitle;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Placeholder excerpt for skeleton loading.'**
  String get blogPlaceholderExcerpt;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Loading Author'**
  String get blogPlaceholderAuthorName;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get blogPlaceholderCategoryName;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Singleton of Glen Ord 38-year old and the Singleton range.'**
  String get blogPostShareSampleTitle;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Sprituality'**
  String get blogPostShareCategoryLabel;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **' Author:'**
  String get blogPostShareAuthorLabel;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **' Publish Date:'**
  String get blogPostSharePublishDateLabel;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'How it Works'**
  String get blogPostShareHowItWorksTitle;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'1.Check Url to open blog'**
  String get blogPostShareStep1;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'2.Or Search blog when logged in -t to like'**
  String get blogPostShareStep2;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Invite your friends \n and family'**
  String get blogPostShareInviteTitle;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get blogPostCommentsTitle;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get blogPostPreviousLabel;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Replies'**
  String get blogRepliesCountLabel;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Get ready for an evening filled with laughter'**
  String get blogReplyPlaceholderText;

  /// Blog
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get blogSearchHint;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Event Name'**
  String get createEventNameLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Add a title'**
  String get createEventTitleHint;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get createEventSubtitleLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Add a subtitle'**
  String get createEventSubtitleHint;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get createEventDescriptionMaxLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get createEventDescriptionLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'More about the event'**
  String get createEventDescriptionHint;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get createEventDateLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Event Start time'**
  String get createEventStartTimeLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get createEventStartTimePlaceholder;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Event End time'**
  String get createEventEndTimeLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get createEventEndTimePlaceholder;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Check User Availability'**
  String get createEventCheckAvailabilityLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'To use this, please add your address and number of guest. Disclaimer: we cannot guarantee 100%\nmatches due to certain factors beyond our control.'**
  String get createEventAvailabilityDisclaimer;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Event starts in'**
  String get createEventStartsInLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Decrease time'**
  String get createEventDecreaseTimeSemanticLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Increase time'**
  String get createEventIncreaseTimeSemanticLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get createEventStreetLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Enter street'**
  String get createEventStreetHint;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Home Number'**
  String get createEventHomeNumberLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Enter home number'**
  String get createEventHomeNumberHint;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get createEventDistrictLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Enter district'**
  String get createEventDistrictHint;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Postal/zip code'**
  String get createEventPostalCodeLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Enter postal or zip code'**
  String get createEventPostalCodeHint;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get createEventStateLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Enter state'**
  String get createEventStateHint;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get createEventUploadImageTitle;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Choose a source for your event image'**
  String get createEventUploadImageSubtitle;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get createEventCategoryPlaceholder;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Event Category'**
  String get createEventCategoryLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Event Image'**
  String get createEventImageLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'(Recommended size 400 x 400px)'**
  String get createEventImageSizeHint;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Stripe Connected'**
  String get createEventStripeConnectedLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get createEventPreviewSubmitLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'guests'**
  String get createEventPreviewGuestsSuffix;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Event has already started'**
  String get createEventPreviewAlreadyStarted;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Starts in {days} days'**
  String createEventPreviewStartsInDays(Object days);

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Starts tomorrow'**
  String get createEventPreviewStartsTomorrow;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Starts in {hours} hour'**
  String createEventPreviewStartsInHour(Object hours);

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Starts in {hours} hours'**
  String createEventPreviewStartsInHours(Object hours);

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Starts in {minutes} minute'**
  String createEventPreviewStartsInMinute(Object minutes);

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Starts in {minutes} minutes'**
  String createEventPreviewStartsInMinutes(Object minutes);

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Starting now'**
  String get createEventPreviewStartingNow;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Spirituality'**
  String get createEventPreviewDefaultCategory;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get createEventPreviewDefaultHostName;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Expected {label}'**
  String createEventPreviewExpectedLabel(Object label);

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Pricing {label}'**
  String createEventPreviewPricingLabel(Object label);

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'No more matches currently, until then'**
  String get discoverNoMatchesMessage;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'guests'**
  String get discoverGuestsSuffix;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Go to chat'**
  String get discoverGoToChatLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Location:'**
  String get discoverLocationLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Indore, Madhya radesh, IN'**
  String get discoverMockLocationLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Starts in'**
  String get discoverStartsInLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'hrs'**
  String get discoverHoursSuffix;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get discoverShareLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'🌟 Invitation to a Transformative Yoga Experience: Kundalini Awakening Gathering'**
  String get discoverMockEventTitle;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Embark on a profound journey of self-discovery and inner transformation with our exclusive Kundalini Awakening Yoga event! We invite you to join us for a harmonious gathering where ten individuals will come together to explore the ancient practice of Kundalini yoga. This'**
  String get discoverMockEventDescription;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get discoverHostLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get discoverHostMedalGoldLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'About Alkesh:'**
  String get discoverMockAboutHostLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Engineering Marvel with a Passion for Beats and Serenity'**
  String get discoverMockAboutHostText;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Welcome to my world of innovation and\nrhythm! I’m Alkesh, an engineer by profession\nand a connoisseur of life’s eclectic\nexperiences.'**
  String get discoverMockHostBio;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **' followers'**
  String get discoverFollowersSuffix;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Overall Ratings'**
  String get discoverOverallRatingsSuffix;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'90’s Hip-Hop'**
  String get discoverMockCategoryLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'House Party'**
  String get discoverMockPartyTypeLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'3.6 out of 5'**
  String get discoverMockRatingSummaryLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'6 Guest ratings'**
  String get discoverMockGuestRatingsLabel;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Jakob Hoffman'**
  String get discoverMockReviewerName;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'⬤ 23 August 2023'**
  String get discoverMockReviewDate;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'What a display  dsn  cdn zxnc nzc njzcn nzcjcnzjncjcnzjcnzc ncnz cjkznkcnzc kcnznczn cznzxnc  czc znc zncznc z nzcxnjcc ncjcnz nc nzcnnz cc'**
  String get discoverMockReviewText;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Other Events from Alkesh'**
  String get discoverMockOtherEventsLabel;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get exploreSwipeCardToday;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Search Hobby Events'**
  String get exploreSearchHint;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Start in'**
  String get exploreSwipeCardStartInPrefix;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get exploreSwipeCardHostLabel;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'followers'**
  String get exploreSwipeCardFollowersSuffix;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Overall Ratings'**
  String get exploreSwipeCardOverallRatingsLabel;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Van Life'**
  String get exploreCategoryVanLife;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Pet Love'**
  String get exploreCategoryPetLove;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Sprituality'**
  String get exploreCategorySpirituality;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Board Games'**
  String get exploreCategoryBoardGames;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get exploreDiscountDeclineMessage;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openLabel;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'No offer available'**
  String get exploreDiscountNoOfferTitle;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Please check back later.'**
  String get exploreDiscountCheckBackLaterMessage;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'No ad details were provided.'**
  String get exploreDiscountNoAdDetailsMessage;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get exploreDiscountOfferFallback;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Failed to load events.'**
  String get exploreLoadEventsFailed;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Interested'**
  String get exploreInterestedLabel;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Failed to load event details.'**
  String get exploreEventDetailLoadFailed;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Wish you a Happy Birthday!'**
  String get birthdayNotificationTitle;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'“Happy birthday! I hope all your birthday wishes\n and dreams come true.”'**
  String get birthdayNotificationMessage;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Kuemele Team  '**
  String get birthdayNotificationSignature;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsTitle;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousLabel;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'3 Replies'**
  String get blogCommentRepliesCount;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get blogCommentReplayAction;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Welcome to Kuemele'**
  String get welcomeNotificationTitle;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'23November, 2022'**
  String get welcomeNotificationDate;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Maecenas quam nunc, sagittis non condimentum at, rutrum sit amet\n eros. Fusce rutrum,lectus\n \nin blandit sagittis, mi tortor ullamcorper mi, vitae vestibulum libero quam a nisi.\n\n In eu mauris et neque sodales porta eu eget dui. Nunc eu quam sit amet justo elementum mollis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.s quis lectus maximus fermentum.'**
  String get welcomeNotificationBody;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get createEventButtonLabel;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get notificationsEmptyTitle;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'You have no new notifications right now. Check back later.'**
  String get notificationsEmptyDescription;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'No more matches currently,'**
  String get exploreEmptyNoMoreMatches;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'until then'**
  String get exploreEmptyUntilThen;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Be awesome and create an event'**
  String get exploreEmptyCreateEventPromptSubtitle;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Here are some blogs you may like'**
  String get exploreEmptyReadBlogPromptSubtitle;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Read Blog'**
  String get exploreEmptyReadBlogButtonLabel;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Be awesome and invite your friends'**
  String get exploreEmptyInviteFriendsPromptSubtitle;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get exploreEmptyInviteFriendsButtonLabel;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Matched Event'**
  String get exploreMatchedEventsSectionTitle;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Created Event'**
  String get exploreCreatedEventsSectionTitle;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get exploreHostFallbackName;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Email or Mobile number'**
  String get addPaypalEmailOrMobileHint;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get orDividerLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Event Ads'**
  String get eventAdsLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Thank You!'**
  String get paymentThankYouTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Your payment is complete.'**
  String get paymentCompleteMessage;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'View Payment'**
  String get viewPaymentLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedStatusLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Order code'**
  String get orderCodeLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateTimeLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Exchange Rate'**
  String get exchangeRateLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Payment processed by'**
  String get paymentProcessedByLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Send Payment'**
  String get sendPaymentTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'To make a payment, send BTC to the address below'**
  String get sendPaymentInstructions;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Pay With wallet'**
  String get payWithWalletLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'BTC Address'**
  String get btcAddressLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Pay with Coinbase'**
  String get payWithCoinbaseLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Or select a cryptocurrency'**
  String get selectCryptocurrencyLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMoreLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'No subscription tier available yet.'**
  String get noSubscriptionTierAvailable;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Please sign in before starting a subscription.'**
  String get signInBeforeSubscription;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Subscription activated'**
  String get subscriptionActivatedMessage;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Purchase failed: {error}'**
  String purchaseFailedMessage(Object error);

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Could not create the subscription checkout session.'**
  String get subscriptionCheckoutSessionFailed;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribeLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Payment complete'**
  String get paymentCompleteShort;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Checkout started'**
  String get checkoutStartedMessage;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Subscription created'**
  String get subscriptionCreatedMessage;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Please sign in to manage a subscription.'**
  String get signInToManageSubscription;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Unable to cancel subscription right now.'**
  String get unableToCancelSubscription;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Subscription cancellation requested'**
  String get subscriptionCancellationRequested;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Unable to resume subscription right now.'**
  String get unableToResumeSubscription;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Subscription resumed'**
  String get subscriptionResumedMessage;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Crypto payments are still being wired to the live checkout flow.'**
  String get cryptoPaymentsComingSoon;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Amount to pay'**
  String get amountToPayLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Select a subscription'**
  String get selectSubscriptionLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlyLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearlyLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'{tierName} plan • {cycle} billing'**
  String tierPlanBillingSummary(Object cycle, Object tierName);

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Subscription plans'**
  String get subscriptionPlansTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'No subscription tiers are available right now.'**
  String get noSubscriptionTiersAvailable;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popularBadgeLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Price unavailable'**
  String get priceUnavailableLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Current subscription'**
  String get currentSubscriptionTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Sign in to check your active subscription status.'**
  String get signInCheckSubscriptionStatus;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'No active subscription found yet.'**
  String get noActiveSubscriptionFound;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get planLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Renews / ends'**
  String get renewsEndsLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Cancellation'**
  String get cancellationLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Scheduled for period end'**
  String get scheduledForPeriodEndLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Resume subscription'**
  String get resumeSubscriptionLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Cancel at period end'**
  String get cancelAtPeriodEndLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Recent payments'**
  String get recentPaymentsTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Payment history becomes available after sign in.'**
  String get paymentHistoryAfterSignIn;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'No payment history found yet.'**
  String get noPaymentHistoryFound;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Payment {id}'**
  String paymentIdFallback(Object id);

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Provider unknown'**
  String get providerUnknownLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Refresh details'**
  String get refreshDetailsLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Crypto payment options'**
  String get cryptoPaymentOptionsLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Sign in to subscribe'**
  String get signInToSubscribeLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Continue to checkout'**
  String get continueToCheckoutLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Enter discount code'**
  String get enterDiscountCodeHint;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Add a discount code first.'**
  String get addDiscountCodeFirstMessage;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Discount code will be validated when checkout starts.'**
  String get discountCodeValidatedAtCheckoutMessage;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'You can review subscription plans now, but you need to sign in before checkout, cancellation, or payment history will work.'**
  String get authBannerSubscriptionMessage;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Action not allowed'**
  String get actionNotAllowedTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Remove Card'**
  String get removeCardTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Connect your Escrow Account'**
  String get connectEscrowAccountLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptionsTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Buy now'**
  String get buyNowLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivateLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activateLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Confirm card deletion'**
  String get confirmCardDeletionTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetailsTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Event Not Found'**
  String get eventNotFoundTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'The requested event details could not be found.'**
  String get eventNotFoundDescription;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get eventLocationLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Capacity & Availability'**
  String get capacityAvailabilityLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'{attendeeCount} / {capacity} Attendees ({spotsRemaining} spots left)'**
  String capacityAvailabilitySummary(
      Object attendeeCount, Object capacity, Object spotsRemaining);

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Turn on Sound notification'**
  String get turnOnSoundNotificationLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'E-Mail notifications'**
  String get emailNotificationsLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Bronze Status'**
  String get medalBronzeTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'User created a minimum of 2 events or user attended a minimum of 2 events without fail in the last 30 days. The user gets 2% discount of 1 in-app purchase of choice.'**
  String get medalBronzeDescription;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Silver Status'**
  String get medalSilverTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'User created a minimum of 3 events or user attended a minimum of 3 events without fail in the last 30 days. The user gets 4% discount of 1 in-app purchase of choice.'**
  String get medalSilverDescription;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Gold Status'**
  String get medalGoldTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'User created a minimum of 4 events or user attended a minimum of 4 events without fail in the last 30 days. The user gets 8% discount of 1 in-app purchase of choice.'**
  String get medalGoldDescription;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Connect TV'**
  String get connectTvLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'TV connected successfully.'**
  String get tvConnectedSuccessMessage;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Could not connect this TV.'**
  String get couldNotConnectTvMessage;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get blogCommentAuthorYou;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get blogCommentJustNow;

  /// Discover
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get discoverGoldBadgeLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentDialogTitle;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Amount to pay'**
  String get paymentAmountToPayLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Select a subscription'**
  String get paymentSelectSubscriptionLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'plan •'**
  String get paymentPlanBulletSuffix;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'billing'**
  String get paymentBillingSuffix;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get paymentYearlyLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get paymentMonthlyLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Enter discount code'**
  String get paymentDiscountCodeHint;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Add a discount code first.'**
  String get paymentDiscountCodeEmptyMessage;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Discount code will be validated when checkout starts.'**
  String get paymentDiscountCodeValidationMessage;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get paymentApplyLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'You can review subscription plans now, but you need to sign in before checkout, cancellation, or payment history will work.'**
  String get paymentAuthBannerMessage;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Subscription plans'**
  String get paymentSubscriptionPlansTitle;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'No subscription tiers are available right now.'**
  String get paymentNoTiersMessage;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get paymentPopularBadgeLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Price unavailable'**
  String get paymentPriceUnavailableLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Current subscription'**
  String get paymentCurrentSubscriptionTitle;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Sign in to check your active subscription status.'**
  String get paymentSignInToCheckStatusMessage;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'No active subscription found yet.'**
  String get paymentNoActiveSubscriptionMessage;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get paymentStatusLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get paymentPlanLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get paymentUnknownPlanLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Renews / ends'**
  String get paymentRenewsEndsLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Cancellation'**
  String get paymentCancellationLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Scheduled for period end'**
  String get paymentScheduledForPeriodEndLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Resume subscription'**
  String get paymentResumeSubscriptionLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Cancel at period end'**
  String get paymentCancelAtPeriodEndLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Recent payments'**
  String get paymentRecentPaymentsTitle;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Payment history becomes available after sign in.'**
  String get paymentHistoryAfterSignInMessage;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'No payment history found yet.'**
  String get paymentNoHistoryMessage;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Payment {id}'**
  String paymentFallbackDescription(String id);

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Provider unknown'**
  String get paymentProviderUnknownLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Refresh details'**
  String get paymentRefreshDetailsLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Crypto payment options'**
  String get paymentCryptoOptionsLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Sign in to subscribe'**
  String get paymentSignInToSubscribeLabel;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Continue to checkout'**
  String get paymentContinueToCheckoutLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get interestMovies;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Pubs & Bars'**
  String get interestPubsAndBars;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Live show'**
  String get interestLiveShow;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Clubbing'**
  String get interestClubbing;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Festival'**
  String get interestFestival;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Outdoors'**
  String get interestOutdoors;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Volunteer'**
  String get interestVolunteer;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'DIY'**
  String get interestDiy;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Activism'**
  String get interestActivism;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Pet love'**
  String get interestPetLove;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Video Games'**
  String get interestVideoGames;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Family activities'**
  String get interestFamilyActivities;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Tech'**
  String get interestTech;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Costume'**
  String get interestCostume;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Foodie'**
  String get interestFoodie;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Camping'**
  String get interestCamping;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'User created a minimum of 2 events or user attended a minimum of 2 events without fail in the last 30 days. The user gets 2% discount of 1 in-app purchase of choice.'**
  String get medalBronzeSubtitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'User created a minimum of 3 events or user attended a minimum of 3 events without fail in the last 30 days. The user gets 4% discount of 1 in-app purchase of choice.'**
  String get medalSilverSubtitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'User created a minimum of 4 events or user attended a minimum of 4 events without fail in the last 30 days. The user gets 8% discount of 1 in-app purchase of choice.'**
  String get medalGoldSubtitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Action not allowed'**
  String get removeCardActionNotAllowedTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Connect your Escrow Account'**
  String get removeCardConnectEscrowLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get removeCardSubscriptionsLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Confirm card deletion'**
  String get removeCardConfirmDeletionTitle;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get myEventDetailsLabel;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Connect TV'**
  String get connectTvTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Advert'**
  String get advertDialogTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Event starts in 48 hrs'**
  String get advertEventStarts48hrs;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Event starts in 7 days'**
  String get advertEventStarts7days;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'User Around'**
  String get userAroundTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Potential matches matching your criteria found currently'**
  String get userAroundMessage;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Guest Invite'**
  String get guestInviteTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Invite your friends to Kumele'**
  String get inviteFriendsToKumeleTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Referral code'**
  String get inviteReferralCodeLabel;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Congratulations'**
  String get congratulationsTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'New Status: Bronze'**
  String get congratsNewStatusBronze;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Discount Code: KEMELE20'**
  String get congratsDiscountCode;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'You created a minimum of 3 events or user attended a minimum of 3 events without fail in the last 30 days. The user gets 4% discount of one in-app purchase of choice.'**
  String get congratsBronzeDescription;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Passkeys are easy to set up and let you securely sign in to your Kumele Account using the  security capabilities of your devices like Touch ID and Face ID.  Passkeys are way more secure and are easier to use than all current 2-factor authentication methods.'**
  String get passkeyIntroDescription;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Passkey'**
  String get passkeyTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Sign in using passkey'**
  String get signInUsingPasskeyLabel;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Enter your e-mail'**
  String get signupPasskeyEmailHint;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Start in'**
  String get eventStartInLabel;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Cancel event'**
  String get cancelEventTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Set Time'**
  String get setTimeTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Guest Prices'**
  String get guestPricesTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Guest prices are unavailable right now.'**
  String get guestPricesUnavailableMessage;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Reward Rings'**
  String get rewardRingsTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Money Earned'**
  String get moneyEarnedTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgainLabel;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Location Services Off'**
  String get locationServicesOffTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Location Access Required'**
  String get locationAccessRequiredTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Please enable location services on your device to discover events near you.'**
  String get locationServicesOffMessage;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Location permission was permanently denied. Please enable it in app settings.'**
  String get locationPermissionPermanentlyDeniedMessage;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Location access is needed to show events near you.'**
  String get locationAccessNeededMessage;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Join this event?'**
  String get joinEventConfirmTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get joinLabel;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Kumele Terms of use'**
  String get kumeleTermsOfUseLabel;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Event Cancelled'**
  String get eventCancelledDialogTitle;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'The host unfortunately cancelled the event. We apologize for the inconvenience. In case of prepayments please contact PayPal immediately for a refund.'**
  String get eventCancelledDialogMessage;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Premium In-app purchase include:'**
  String get premiumPurchaseIncludeLabel;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'Location Change'**
  String get premiumLocationChange;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'House party (Max guest 10)'**
  String get premiumHouseParty;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'No Ads'**
  String get premiumNoAds;

  /// Shared
  ///
  /// In en, this message translates to:
  /// **'7 days pre event Advertising'**
  String get premium7DaysAdvertising;

  /// Auth
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get signupDateOfBirthLabel;

  /// Auth
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get signupGenderLabel;

  /// Auth
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpButtonLabel;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String myEventJoinedLabel(String date);

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Organized by'**
  String get myEventOrganizedByLabel;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get myEventDateTimeLabel;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get myEventLocationLabel;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Capacity & Availability'**
  String get myEventCapacityAvailabilityLabel;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'About Event'**
  String get myEventAboutEventLabel;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Event Rules & Info'**
  String get eventRulesTitle;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Age: {minAge} - {maxAge}'**
  String eventRuleAgeLabel(String minAge, String maxAge);

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get eventRuleNoAgeLimitLabel;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Gender: {gender}'**
  String eventRuleGenderLabel(String gender);

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Language: {language}'**
  String eventRuleLanguageLabel(String language);

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Requires Host Approval'**
  String get eventRuleRequiresApprovalLabel;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Matched Event'**
  String get exploreMatchedEventLabel;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Created Event'**
  String get exploreCreatedEventLabel;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Join Now'**
  String get exploreJoinNowLabel;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'No more matches currently,'**
  String get exploreSwipeNoMoreMatchesLine1;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'until then'**
  String get exploreSwipeNoMoreMatchesLine2;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Be awesome and create an event'**
  String get exploreSwipeCreateEventCta;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Here are some blogs you may like'**
  String get exploreSwipeBlogsSuggestion;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Be awesome and invite your friends'**
  String get exploreSwipeInviteFriendsCta;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get exploreNotificationsTitle;

  /// Profile/Explore
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreTabletHeaderTitle;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Create event'**
  String get createEventTitle;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Preview Event'**
  String get previewEventLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Age range'**
  String get createEventAgeRangeLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Number of guests'**
  String get createEventNumberOfGuestsLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'RSVP Guest Payment'**
  String get createEventRsvpGuestPaymentLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Free Event'**
  String get createEventFreeEventLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Card Payment'**
  String get createEventCardPaymentLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Cash On Entry'**
  String get createEventCashOnEntryLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Report Event'**
  String get reportEventTitle;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Choose a reason'**
  String get reportEventChooseReasonLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratingsTitle;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Rate Event'**
  String get rateEventTitle;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Attendee Ratings (70%)'**
  String get attendeeRatingsLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'No comments yet. Be the first to comment!'**
  String get blogNoCommentsMessage;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'NFT Preview'**
  String get nftPreviewTitle;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Close Preview'**
  String get nftClosePreviewLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Wallet Signature Required'**
  String get walletSignatureRequiredTitle;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismissLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Turn on Sound notification'**
  String get soundNotificationTurnOnLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Sound notification'**
  String get soundNotificationLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Turn on 2 factor authentications'**
  String get turnOn2faLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Choose interests'**
  String get chooseInterestsTitle;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Choose up to {count} interests:'**
  String chooseUpToInterestsLabel(String count);

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Earn medals and rewards'**
  String get earnMedalsAndRewardsTitle;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Other events from {hostName}'**
  String otherEventsFromHostLabel(String hostName);

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Hobby Meetup'**
  String get hobbyMeetupTagline;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'We play. We overcome. We unite. We live.'**
  String get splashTagline;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Group Meditation'**
  String get guestTileGroupMeditationLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Hosted By Anki Maheshwari'**
  String get guestTileHostedByLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Bahawalpur, Punjab PK'**
  String get guestTileLocationLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'United Kingdom, 39495, kentucky'**
  String get filterMockLocationLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'History & Statistics'**
  String get historyStatisticsTitle;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Blog Details'**
  String get blogDetailsTitle;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Add card'**
  String get addCardTitle;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Card details are collected securely by Stripe.'**
  String get addCardStripeMessage;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get addCardSubmitLabel;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get noNotificationsTitle;

  /// Misc
  ///
  /// In en, this message translates to:
  /// **'You have no new notifications right now. Check back later.'**
  String get noNotificationsDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
