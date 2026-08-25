// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Save';

  @override
  String get continueLabel => 'Continue';

  @override
  String get submit => 'Submit';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get done => 'Done';

  @override
  String get retry => 'Retry';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get selfCheck => 'Self-check';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Loading...';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get comment => 'Comment';

  @override
  String get addYourComment => 'Add your comment...';

  @override
  String get publishComment => 'Publish comment';

  @override
  String get posted => 'Posted!';

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get noResults => 'No results found';

  @override
  String get noData => 'No data available';

  @override
  String get noChats => 'No Chats';

  @override
  String get noChatsDescription =>
      'You have no chats right now. Start a conversation or check back later.';

  @override
  String get noGuests => 'No Guests';

  @override
  String get noGuestsDescription =>
      'There are no guests checked in or registered for this event yet.';

  @override
  String get chat => 'Chat';

  @override
  String get spirituality => 'Spirituality';

  @override
  String get hostedBy => 'Hosted by';

  @override
  String get rateEvent => 'Rate event';

  @override
  String get reportEvent => 'Report event';

  @override
  String get guestScan => 'Guest Scan';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get alignQrInFrame => 'Align the guest QR code within the frame';

  @override
  String get guestNotFound => 'Guest not found in this event';

  @override
  String get invalidQrCode => 'Invalid QR code';

  @override
  String get confirmCheckIn => 'Confirm check-in';

  @override
  String get confirmGuestCheckInDescription =>
      'Check in this guest for the event?';

  @override
  String checkedInSuccess(String name) {
    return 'Successfully checked in $name!';
  }

  @override
  String get checkedInLabel => 'Checked In';

  @override
  String get notCheckedInLabel => 'Not Checked In';

  @override
  String get confirmedLabel => 'Confirmed';

  @override
  String get followHost => 'Follow Host';

  @override
  String get followHostConfirmMessage => 'Do you want to follow host?';

  @override
  String get followHostConfirmButton => 'Follow host';

  @override
  String get followHostSuccessMessage => 'You are now following this host.';

  @override
  String get no => 'No';

  @override
  String get unfollowConfirmTitle => 'Are you sure you want to unfollow?';

  @override
  String get unfollowConfirmButton => 'Unfollow';

  @override
  String get selectAllLabel => 'Select All';

  @override
  String get removeLabel => 'Remove';

  @override
  String daysLeftToRate(int days) {
    return '$days days left to rate &\nreview';
  }

  @override
  String scannedList(int count) {
    return 'Scanned list: $count';
  }

  @override
  String get chatToday => 'Today';

  @override
  String get chatYesterday => 'Yesterday';

  @override
  String get eventCanceled => 'Event Canceled';

  @override
  String get noMessages => 'No Messages';

  @override
  String get noMessagesDescription => 'There are no messages here yet.';

  @override
  String get joinChatFailed => 'Failed to join chat room';

  @override
  String get joinChatSuccess => 'Successfully joined the chat room';

  @override
  String get loadMessagesFailed => 'Failed to load chat messages';

  @override
  String get sendMessageFailed => 'Failed to send message';

  @override
  String get chatNotAvailable => 'Chat is not available';

  @override
  String get chatAccessDenied => 'You do not have access to this chat';

  @override
  String get chatClosed => 'This chat is closed';

  @override
  String get typeAMessage => 'Type a message';

  @override
  String get reply => 'Reply';

  @override
  String get unknownUser => 'Unknown';

  @override
  String get activeEvent => 'Active Event';

  @override
  String get active => 'Active';

  @override
  String get eventChat => 'Event Chat';

  @override
  String get guests => 'Guests';

  @override
  String get guest => 'Guest';

  @override
  String get priceLabel => 'Price';

  @override
  String get eventAddressLabel => 'Event Address';

  @override
  String get cashOnEntry => 'Cash on entry';

  @override
  String get free => 'Free';

  @override
  String get profileTitle => 'Profile';

  @override
  String get myEvents => 'My Events';

  @override
  String get createdEvents => 'Created Events';

  @override
  String get joinedEvents => 'Joined Events';

  @override
  String get noEventsCreatedYet => 'You haven\'t created any events yet.';

  @override
  String get noEventsJoinedYet => 'You haven\'t joined any events yet.';

  @override
  String get blogsTitle => 'Blogs';

  @override
  String get settingsTitle => 'Setting';

  @override
  String get interestedHobbies => 'Interested hobbies';

  @override
  String get editHobbies => 'Edit hobbies';

  @override
  String get showMore => 'Show more';

  @override
  String get showLess => 'Show less';

  @override
  String get myQrCode => 'My QR Code';

  @override
  String get following => 'Following';

  @override
  String get followers => 'Followers';

  @override
  String get goldStatus => 'Gold status';

  @override
  String get notifications => 'Notifications';

  @override
  String get languages => 'Languages';

  @override
  String get languagesLoadFailed => 'Failed to load languages.';

  @override
  String get connectionsLoadFailed => 'Failed to load followers and following.';

  @override
  String get unfollowFailedMessage =>
      'Couldn\'t remove everyone selected. Please try again.';

  @override
  String get cardPaymentsSubscriptions =>
      'Card Payments, Subscriptions & Escrow ';

  @override
  String get security => 'Security';

  @override
  String get contact => 'Contact';

  @override
  String get faq => 'FAQ';

  @override
  String get contactPageSubtitle => 'Tell us how we can help.';

  @override
  String get contactSubjectLabel => 'Subject';

  @override
  String get contactSubjectHint => 'Brief summary of your issue';

  @override
  String get contactDescriptionLabel => 'Description';

  @override
  String get contactDescriptionHint => 'Describe your issue in detail';

  @override
  String get contactCategoryLabel => 'Category';

  @override
  String get contactPriorityLabel => 'Priority';

  @override
  String get contactAttachmentLabel => 'Attachment (optional)';

  @override
  String get contactAttachmentHint => 'Upload a screenshot';

  @override
  String get contactSubmitLabel => 'Submit';

  @override
  String get contactSuccessMessage => 'Your message has been sent.';

  @override
  String get contactSubmitFailed => 'Failed to send message. Please try again.';

  @override
  String get contactDescriptionTooShort =>
      'Please enter at least 20 characters so support can help properly.';

  @override
  String get contactSubjectRequired => 'Please enter a subject.';

  @override
  String get contactDescriptionRequired => 'Please enter a description.';

  @override
  String get contactAttachmentPickFailed => 'Failed to pick image.';

  @override
  String get guidelines => 'Guidelines';

  @override
  String get referAFriend => 'Refer a Friend';

  @override
  String get referralCodeUnavailable =>
      'Your referral code is not available right now. Please try again later.';

  @override
  String get referralShareSubject => 'Join me on Kumele';

  @override
  String referralShareMessage(String referralCode, String referralLink) {
    return 'Join me on Kumele — meet local hobby friends through shared interests!\n\nUse my referral code: $referralCode\n\nSign up here: $referralLink';
  }

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get nightMode => 'Night Mode';

  @override
  String get adPrivacyChoices => 'Ad Privacy Choices';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get signOut => 'Signout';

  @override
  String get deleteAccountConfirmTitle =>
      'Are you sure? This action cannot\n be undone. Please retype \npassword.';

  @override
  String get deleteAccountPasswordHint => 'Enter current password';

  @override
  String get deleteAccountPageSubtitle =>
      'This action is permanent. Enter your password and tell us why you are leaving.';

  @override
  String get deleteAccountPasswordLabel => 'Password';

  @override
  String get deleteAccountReasonLabel => 'Reason';

  @override
  String get deleteAccountReasonHint => 'Tell us why you are leaving';

  @override
  String get deleteAccountConfirmationLabel =>
      'I understand this action is permanent and cannot be undone';

  @override
  String get deleteAccountSubmitLabel => 'Delete Account';

  @override
  String get deleteAccountSuccessMessage => 'Account successfully deleted.';

  @override
  String get deleteAccountSubmitFailed =>
      'Failed to delete account. Please try again.';

  @override
  String get deleteAccountPasswordRequired => 'Please enter your password.';

  @override
  String get deleteAccountReasonRequired =>
      'Please tell us why you are leaving.';

  @override
  String get deleteAccountConfirmationRequired =>
      'Please confirm that you understand this action is permanent.';

  @override
  String get signOutConfirmTitle => 'Are you sure you want to\n signout?';

  @override
  String get signOutSuccessMessage => 'Signed out successfully.';

  @override
  String get forgotPasswordPageTitle => 'Forgot Password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email address and we will send you a reset token.';

  @override
  String get forgotPasswordEmailLabel => 'E-Mail';

  @override
  String get forgotPasswordHint => 'Enter E-Mail';

  @override
  String get forgotPasswordSubmitLabel => 'Send Reset Email';

  @override
  String get forgotPasswordSuccessMessage =>
      'If that email exists, a reset link has been sent.';

  @override
  String get resetPasswordPageTitle => 'Reset Password';

  @override
  String get resetPasswordSubtitle =>
      'Enter the code sent to your email and choose a new password.';

  @override
  String get resetPasswordTokenLabel => 'Verification Code';

  @override
  String get resetPasswordTokenHint => 'Enter code';

  @override
  String get resetPasswordNewPasswordLabel => 'New Password';

  @override
  String get resetPasswordNewPasswordHint => 'Enter new password';

  @override
  String get resetPasswordConfirmPasswordLabel => 'Confirm Password';

  @override
  String get resetPasswordConfirmPasswordHint => 'Re-enter new password';

  @override
  String get resetPasswordSubmitLabel => 'Reset Password';

  @override
  String get resetPasswordSuccessMessage => 'Password reset successfully';

  @override
  String get passwordMinLengthError => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatchError => 'Passwords do not match';

  @override
  String get emailVerificationPageTitle => 'Verify Your Email';

  @override
  String get emailVerificationSubtitle =>
      'We sent a 6-digit verification code to your email. Enter it below to continue.';

  @override
  String get emailVerificationVerifyLabel => 'Verify Email';

  @override
  String get emailVerificationResendLabel => 'Resend Code';

  @override
  String get emailVerificationResendInLabel => 'Resend code in';

  @override
  String get emailVerificationSentMessage =>
      'Verification code sent to your email.';

  @override
  String get emailVerificationFailedMessage =>
      'Invalid verification code. Please try again.';

  @override
  String get emailVerificationSendFailedMessage =>
      'Failed to send verification code. Please try again.';

  @override
  String get emailVerificationSuccessMessage => 'Email verified successfully!';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePasswordCurrentLabel => 'Current Password';

  @override
  String get changePasswordCurrentHint => 'Enter current password';

  @override
  String get changePasswordNewLabel => 'New Password';

  @override
  String get changePasswordNewHint => 'Enter new password';

  @override
  String get changePasswordConfirmLabel => 'Confirm New Password';

  @override
  String get changePasswordConfirmHint => 'Re-enter new password';

  @override
  String get changePasswordSubmitLabel => 'Update Password';

  @override
  String get changePasswordSuccessMessage =>
      'Password updated successfully. Please sign in with your new password.';

  @override
  String get changePasswordSubmitFailed =>
      'Failed to update password. Please try again.';

  @override
  String get changePasswordCurrentRequired =>
      'Please enter your current password.';

  @override
  String get registerPasskey => 'Register Passkey';

  @override
  String get twoFactorAuth => 'Two Factor Authentication';

  @override
  String get twoFactorSetupTitle => 'Authenticator App Setup';

  @override
  String get twoFactorSetupStep1 =>
      '1. Open an authenticator app on your mobile device';

  @override
  String get twoFactorSetupStep1Hint =>
      'If you don\'t have one, download and install one of the recommended apps:';

  @override
  String get twoFactorSetupStep2Lead => '2. Scan this barcode with your ';

  @override
  String get twoFactorSetupStep2Bold => 'authenticator app';

  @override
  String get twoFactorSetupCantScan => 'Can\'t scan? Use this code instead';

  @override
  String get twoFactorSetupStep3Lead => '3. Enter the six-digit code from the ';

  @override
  String get twoFactorSetupStep3Bold => 'authenticator app';

  @override
  String get twoFactorVerificationHint => 'Enter Verification Code Here';

  @override
  String get twoFactorSetupLoadFailed =>
      'Failed to load 2FA setup. Please try again.';

  @override
  String get twoFactorEnableFailed =>
      'Failed to enable 2FA. Please check your code and try again.';

  @override
  String get twoFactorEnableSuccess =>
      'Two factor authentication enabled successfully.';

  @override
  String get twoFactorManualCodeCopied => 'Setup code copied to clipboard';

  @override
  String get setup => 'Setup';

  @override
  String get twoFactorDisableTitle => 'Disable Two Factor Authentication';

  @override
  String get twoFactorDisableSubtitle =>
      'Are you sure you want to turn off two factor authentication?';

  @override
  String get twoFactorDisableDescription =>
      'Your account will only be protected by your password. We recommend keeping 2FA enabled for better security.';

  @override
  String get twoFactorDisableConfirm => 'Disable Two Factor';

  @override
  String get twoFactorDisableCodeLead => 'Enter the six-digit code from your ';

  @override
  String get twoFactorDisableSuccess =>
      'Two factor authentication disabled successfully.';

  @override
  String get twoFactorDisableFailed =>
      'Failed to disable 2FA. Please check your code and try again.';

  @override
  String get twoFactorLoginTitle => 'Two Factor Authentication';

  @override
  String get twoFactorLoginSubtitle =>
      'Enter the code from your authenticator app to continue';

  @override
  String get twoFactorLoginDescription =>
      'Your account is protected with two factor authentication.';

  @override
  String get twoFactorLoginCodeLead => 'Enter the six-digit code from your ';

  @override
  String get twoFactorLoginCodeBold => 'authenticator app';

  @override
  String get twoFactorLoginVerify => 'Verify';

  @override
  String get twoFactorLoginFailed =>
      'Invalid verification code. Please try again.';

  @override
  String get passkeyRegisterSuccess => 'Passkey registered successfully';

  @override
  String get onboardingPageTitle => 'Set up your profile';

  @override
  String get onboardingPageSubtitle =>
      'Add a photo and tell the community about yourself.';

  @override
  String get onboardingAvatarHint => 'Tap to add photo';

  @override
  String get onboardingImagePickerTitle => 'Add profile photo';

  @override
  String get onboardingImagePickerSubtitle =>
      'Choose gallery or camera for your profile picture';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get onboardingUsernameLabel => 'Username';

  @override
  String get onboardingUsernameHint => 'Choose a username (optional)';

  @override
  String get onboardingUsernameHelper =>
      'Usernames can only be changed every 3 months';

  @override
  String get onboardingUsernameChecking => 'Checking username...';

  @override
  String get onboardingUsernameAvailable => 'Username is available';

  @override
  String get onboardingUsernameTaken => 'Username is already taken';

  @override
  String get onboardingPhoneLabel => 'Phone number';

  @override
  String get onboardingPhoneHint => 'Enter your phone number (optional)';

  @override
  String get onboardingAboutLabel => 'About me';

  @override
  String get onboardingAboutHint =>
      'Tell us about your interests, hobbies, and what you enjoy doing';

  @override
  String get onboardingSuccessMessage => 'Profile saved successfully.';

  @override
  String get onboardingImageRequired => 'Please add a profile photo.';

  @override
  String get onboardingPhoneRequired => 'Please enter your phone number.';

  @override
  String get onboardingPhoneInvalid => 'Please enter a valid phone number.';

  @override
  String get onboardingAboutTooShort =>
      'About me must be at least 200 characters.';

  @override
  String get onboardingAboutTooLong => 'About me cannot exceed 500 characters.';

  @override
  String get onboardingImagePlatformUnsupported =>
      'Image upload is only available on Android.';

  @override
  String get onboardingImagePickFailed => 'Failed to pick image.';

  @override
  String get onboardingSubmitFailed =>
      'Failed to save profile. Please try again.';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileFirstNameLabel => 'First name';

  @override
  String get editProfileFirstNameHint => 'Enter your first name';

  @override
  String get editProfileLastNameLabel => 'Last name';

  @override
  String get editProfileLastNameHint => 'Enter your last name';

  @override
  String get editProfileAboutLabel => 'About me';

  @override
  String get editProfileAboutHint =>
      'Tell us about your interests, hobbies, and what you enjoy doing';

  @override
  String get editProfilePhoneLabel => 'Phone number';

  @override
  String get editProfilePhoneHint => 'Enter your phone number';

  @override
  String get editProfileUpdateLabel => 'Update';

  @override
  String get editProfileSuccessMessage => 'Profile updated successfully.';

  @override
  String get editProfileSubmitFailed =>
      'Failed to update profile. Please try again.';

  @override
  String get editProfileFirstNameRequired => 'Please enter your first name.';

  @override
  String get editProfileAboutTooLong =>
      'About me cannot exceed 500 characters.';

  @override
  String get editProfilePhoneInvalid => 'Please enter a valid phone number.';

  @override
  String get editProfileUserMissing =>
      'Unable to update profile. User not found.';

  @override
  String get pickEventLocation => 'Pick Event Location';

  @override
  String get selectedLocation => 'Selected Location';

  @override
  String get fetchingAddress => 'Fetching address…';

  @override
  String get moveMapToPickLocation => 'Move the map to pick a location';

  @override
  String get confirmLocation => 'Confirm Location';

  @override
  String get searching => 'Searching…';

  @override
  String get unknownLocation => 'Unknown location';

  @override
  String get couldNotFetchAddress => 'Could not fetch address';

  @override
  String get locationServicesDisabled => 'Location services are disabled.';

  @override
  String get locationPermissionDenied => 'Location permission denied.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Location permission permanently denied.';

  @override
  String get pickEventLocationPlaceholder => 'Pick event location';

  @override
  String get tapToOpenMapPlaceholder => 'Tap to open map and drop a pin';

  @override
  String get limitedInvites => 'Limited Invites';

  @override
  String get howItWorks => 'How it works:';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Signup';

  @override
  String get inviteFriendsAndFamily => 'Invite your friends and family';

  @override
  String get eventCodeCopied => 'Event code copied to clipboard!';

  @override
  String get copyTo => 'Copy to';

  @override
  String get clipboard => 'clipboard';

  @override
  String get eventIdLabel => 'Event ID: ';

  @override
  String get locationLabel => 'Location: ';

  @override
  String get scanQr => 'Scan QR';

  @override
  String get hostQr => 'Host QR';

  @override
  String get demoHostName => 'Ankit Maheswari';

  @override
  String get demoLocation => 'Bahawalpur, Pun Pakistan';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInEmailHint => 'Enter email | Nickname';

  @override
  String get signInPasswordHint => 'Enter Password';

  @override
  String get signInRememberMeLabel => 'Remember me';

  @override
  String get signInForgotPasswordLabel => 'Forgot Password?';

  @override
  String get signInCaptchaLabel => 'I am not a robot';

  @override
  String get signInNotAMemberPrefix => 'Not a member? ';

  @override
  String get signInNoAccountPrefix => 'Don’t have an account? ';

  @override
  String get signInPasskeyDividerLabel => 'Or Sign in with Passkey';

  @override
  String get signInPasskeyDescription =>
      'We recommend Passkey to all users, if your device supports it for better security and a pleasant user experience.';

  @override
  String get signInLanguageChoiceLabel => 'Language Choice';

  @override
  String get signInFillFieldsError => 'Please fill all required fields';

  @override
  String get signInCaptchaRequiredError => 'Please confirm you are not a robot';

  @override
  String get signInSuccessMessage => 'Signed in successfully';

  @override
  String get signInWithGoogleLabel => 'Sign in with Google';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get signupFirstNameLabel => 'First name';

  @override
  String get signupFirstNameHint => 'Enter first name';

  @override
  String get signupLastNameLabel => 'Last name';

  @override
  String get signupLastNameHint => 'Enter last name';

  @override
  String get signupEmailHint => 'Enter email';

  @override
  String get signupPasswordHint => 'Enter Password';

  @override
  String get signupConfirmPasswordHint => 'Confirm Password';

  @override
  String get signupReferralCodeLabel => 'Referral code';

  @override
  String get signupBetaCodeLabel => 'Beta code';

  @override
  String get signupCodeHint => ' e.g. DF4R435';

  @override
  String get passkeySignInTitle => 'Sign in with your Kumele passkey';

  @override
  String get earnMedals => 'Earn Medals';

  @override
  String get bronzeStatus => 'Bronze Status';

  @override
  String get silverStatus => 'Silver Status';

  @override
  String get goldStatusMedal => 'Gold Status';

  @override
  String get bronzeStatusDescription =>
      'User created a minimum of 2 events or user attended a minimum of 2 events without fail in the \nlast 30 days. The user gets 2% discount of 1 in-app purchase of choice.';

  @override
  String get silverStatusDescription =>
      'User created a minimum of 3 events or user attended a minimum of 3 events without fail in the\n last 30 days. The user gets 4% discount of 1 in-app purchase of choice.';

  @override
  String get goldStatusMedalDescription =>
      'User created a minimum of 4 events or user attended a minimum of 4 events without fail in the \nlast 30 days. The user gets 8% discount of 1 in-app purchase of choice.';

  @override
  String get filterTitle => 'Filter';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get change => 'Change';

  @override
  String get distanceRangeLabel => 'Distance range (in Kilometers)';

  @override
  String get ageRangeLabel => 'Age range';

  @override
  String get paidEvent => 'PaidEvent';

  @override
  String get stateHint => 'State';

  @override
  String get postalZipCodeHint => 'Postal/Zip Code';

  @override
  String get countryHint => 'Country';

  @override
  String get openPhantomWallet => 'Open Phantom Wallet';

  @override
  String get nftDescriptionLabel => 'Description';

  @override
  String get nftDetailsLabel => 'NFT Details';

  @override
  String get guestCountValidForEventOnly =>
      'Number of guests valid only for this event';

  @override
  String get tokenIdLabel => 'Token ID';

  @override
  String get tokenStandardLabel => 'Token Standard';

  @override
  String get blockchainLabel => 'Blockchain';

  @override
  String get creatorLabel => 'Creator';

  @override
  String get addCommentsHint => 'Add Comments';

  @override
  String get reportEventPageTitle => 'Report Event';

  @override
  String get ratingPageTitle => 'Rating';

  @override
  String get send => 'Send';

  @override
  String get blogLikePostSemanticLabel => 'Like post';

  @override
  String get blogLikesLabel => 'Likes';

  @override
  String get blogShareLabel => 'Share';

  @override
  String get replyDialogTitlePrefix => 'Reply to';

  @override
  String get replyDialogHint => 'Write your reply...';

  @override
  String get blogEmptyStateTitle => 'No blogs found';

  @override
  String get blogEmptyStateDescription => 'Try a different category filter.';

  @override
  String get blogCategoryAll => 'All';

  @override
  String get blogCategoryFood => 'Food';

  @override
  String get blogCategoryTravel => 'Travel';

  @override
  String get blogCategorySports => 'Sports';

  @override
  String get blogCategoryMusic => 'Music';

  @override
  String get blogPlaceholderTitle =>
      'Placeholder title for blog post loading effect';

  @override
  String get blogPlaceholderExcerpt =>
      'Placeholder excerpt for skeleton loading.';

  @override
  String get blogPlaceholderAuthorName => 'Loading Author';

  @override
  String get blogPlaceholderCategoryName => 'Category';

  @override
  String get blogPostShareSampleTitle =>
      'Singleton of Glen Ord 38-year old and the Singleton range.';

  @override
  String get blogPostShareCategoryLabel => 'Sprituality';

  @override
  String get blogPostShareAuthorLabel => ' Author:';

  @override
  String get blogPostSharePublishDateLabel => ' Publish Date:';

  @override
  String get blogPostShareHowItWorksTitle => 'How it Works';

  @override
  String get blogPostShareStep1 => '1.Check Url to open blog';

  @override
  String get blogPostShareStep2 => '2.Or Search blog when logged in -t to like';

  @override
  String get blogPostShareInviteTitle => 'Invite your friends \n and family';

  @override
  String get blogPostCommentsTitle => 'Comments';

  @override
  String get blogPostPreviousLabel => 'Previous';

  @override
  String get blogRepliesCountLabel => 'Replies';

  @override
  String get blogReplyPlaceholderText =>
      'Get ready for an evening filled with laughter';

  @override
  String get blogSearchHint => 'Search';

  @override
  String get createEventNameLabel => 'Event Name';

  @override
  String get createEventTitleHint => 'Add a title';

  @override
  String get createEventSubtitleLabel => 'Subtitle';

  @override
  String get createEventSubtitleHint => 'Add a subtitle';

  @override
  String get createEventDescriptionMaxLabel => 'Max';

  @override
  String get createEventDescriptionLabel => 'Description';

  @override
  String get createEventDescriptionHint => 'More about the event';

  @override
  String get createEventDateLabel => 'Date';

  @override
  String get createEventStartTimeLabel => 'Event Start time';

  @override
  String get createEventStartTimePlaceholder => 'Start time';

  @override
  String get createEventEndTimeLabel => 'Event End time';

  @override
  String get createEventEndTimePlaceholder => 'End time';

  @override
  String get createEventCheckAvailabilityLabel => 'Check User Availability';

  @override
  String get createEventAvailabilityDisclaimer =>
      'To use this, please add your address and number of guest. Disclaimer: we cannot guarantee 100%\nmatches due to certain factors beyond our control.';

  @override
  String get createEventStartsInLabel => 'Event starts in';

  @override
  String get createEventDecreaseTimeSemanticLabel => 'Decrease time';

  @override
  String get createEventIncreaseTimeSemanticLabel => 'Increase time';

  @override
  String get createEventStreetLabel => 'Street';

  @override
  String get createEventStreetHint => 'Enter street';

  @override
  String get createEventHomeNumberLabel => 'Home Number';

  @override
  String get createEventHomeNumberHint => 'Enter home number';

  @override
  String get createEventDistrictLabel => 'District';

  @override
  String get createEventDistrictHint => 'Enter district';

  @override
  String get createEventPostalCodeLabel => 'Postal/zip code';

  @override
  String get createEventPostalCodeHint => 'Enter postal or zip code';

  @override
  String get createEventStateLabel => 'State';

  @override
  String get createEventStateHint => 'Enter state';

  @override
  String get createEventUploadImageTitle => 'Upload Image';

  @override
  String get createEventUploadImageSubtitle =>
      'Choose a source for your event image';

  @override
  String get createEventCategoryPlaceholder => 'Category';

  @override
  String get createEventCategoryLabel => 'Event Category';

  @override
  String get createEventImageLabel => 'Event Image';

  @override
  String get createEventImageSizeHint => '(Recommended size 400 x 400px)';

  @override
  String get createEventStripeConnectedLabel => 'Stripe Connected';

  @override
  String get createEventPreviewSubmitLabel => 'Create Event';

  @override
  String get createEventPreviewGuestsSuffix => 'guests';

  @override
  String get createEventPreviewAlreadyStarted => 'Event has already started';

  @override
  String createEventPreviewStartsInDays(Object days) {
    return 'Starts in $days days';
  }

  @override
  String get createEventPreviewStartsTomorrow => 'Starts tomorrow';

  @override
  String createEventPreviewStartsInHour(Object hours) {
    return 'Starts in $hours hour';
  }

  @override
  String createEventPreviewStartsInHours(Object hours) {
    return 'Starts in $hours hours';
  }

  @override
  String createEventPreviewStartsInMinute(Object minutes) {
    return 'Starts in $minutes minute';
  }

  @override
  String createEventPreviewStartsInMinutes(Object minutes) {
    return 'Starts in $minutes minutes';
  }

  @override
  String get createEventPreviewStartingNow => 'Starting now';

  @override
  String get createEventPreviewDefaultCategory => 'Spirituality';

  @override
  String get createEventPreviewDefaultHostName => 'Me';

  @override
  String createEventPreviewExpectedLabel(Object label) {
    return 'Expected $label';
  }

  @override
  String createEventPreviewPricingLabel(Object label) {
    return 'Pricing $label';
  }

  @override
  String get discoverNoMatchesMessage =>
      'No more matches currently, until then';

  @override
  String get discoverGuestsSuffix => 'guests';

  @override
  String get discoverGoToChatLabel => 'Go to chat';

  @override
  String get discoverLocationLabel => 'Location:';

  @override
  String get discoverStartsInLabel => 'Starts in';

  @override
  String get discoverHoursSuffix => 'hrs';

  @override
  String get discoverShareLabel => 'Share';

  @override
  String get discoverHostLabel => 'Host';

  @override
  String get discoverHostMedalGoldLabel => 'Gold';

  @override
  String get discoverFollowersSuffix => ' followers';

  @override
  String get discoverOverallRatingsSuffix => 'Overall Ratings';

  @override
  String get exploreSwipeCardToday => 'Today';

  @override
  String get exploreSearchHint => 'Search Hobby Events';

  @override
  String get exploreSwipeCardStartInPrefix => 'Start in';

  @override
  String get exploreSwipeCardHostLabel => 'Host';

  @override
  String get exploreSwipeCardFollowersSuffix => 'followers';

  @override
  String get exploreSwipeCardOverallRatingsLabel => 'Overall Ratings';

  @override
  String get exploreCategoryVanLife => 'Van Life';

  @override
  String get exploreCategoryPetLove => 'Pet Love';

  @override
  String get exploreCategorySpirituality => 'Sprituality';

  @override
  String get exploreCategoryBoardGames => 'Board Games';

  @override
  String get exploreDiscountDeclineMessage => 'Decline';

  @override
  String get openLabel => 'Open';

  @override
  String get exploreDiscountNoOfferTitle => 'No offer available';

  @override
  String get exploreDiscountCheckBackLaterMessage => 'Please check back later.';

  @override
  String get exploreDiscountNoAdDetailsMessage =>
      'No ad details were provided.';

  @override
  String get exploreDiscountOfferFallback => 'Offer';

  @override
  String get exploreLoadEventsFailed => 'Failed to load events.';

  @override
  String get exploreInterestedLabel => 'Interested';

  @override
  String get exploreEventDetailLoadFailed => 'Failed to load event details.';

  @override
  String get birthdayNotificationTitle => 'Wish you a Happy Birthday!';

  @override
  String get birthdayNotificationMessage =>
      '“Happy birthday! I hope all your birthday wishes\n and dreams come true.”';

  @override
  String get birthdayNotificationSignature => 'Kuemele Team  ';

  @override
  String get commentsTitle => 'Comments';

  @override
  String get previousLabel => 'Previous';

  @override
  String get blogCommentRepliesCount => '3 Replies';

  @override
  String get blogCommentReplayAction => 'Replay';

  @override
  String get welcomeNotificationTitle => 'Welcome to Kuemele';

  @override
  String get welcomeNotificationDate => '23November, 2022';

  @override
  String get welcomeNotificationBody =>
      'Maecenas quam nunc, sagittis non condimentum at, rutrum sit amet\n eros. Fusce rutrum,lectus\n \nin blandit sagittis, mi tortor ullamcorper mi, vitae vestibulum libero quam a nisi.\n\n In eu mauris et neque sodales porta eu eget dui. Nunc eu quam sit amet justo elementum mollis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.s quis lectus maximus fermentum.';

  @override
  String get createEventButtonLabel => 'Create Event';

  @override
  String get notificationsEmptyTitle => 'No Notifications';

  @override
  String get notificationsEmptyDescription =>
      'You have no new notifications right now. Check back later.';

  @override
  String get exploreEmptyNoMoreMatches => 'No more matches currently,';

  @override
  String get exploreEmptyUntilThen => 'until then';

  @override
  String get exploreEmptyCreateEventPromptSubtitle =>
      'Be awesome and create an event';

  @override
  String get exploreEmptyReadBlogPromptSubtitle =>
      'Here are some blogs you may like';

  @override
  String get exploreEmptyReadBlogButtonLabel => 'Read Blog';

  @override
  String get exploreEmptyInviteFriendsPromptSubtitle =>
      'Be awesome and invite your friends';

  @override
  String get exploreEmptyInviteFriendsButtonLabel => 'Invite Friends';

  @override
  String get exploreMatchedEventsSectionTitle => 'Matched Event';

  @override
  String get exploreCreatedEventsSectionTitle => 'Created Event';

  @override
  String get exploreHostFallbackName => 'Me';

  @override
  String get addPaypalEmailOrMobileHint => 'Email or Mobile number';

  @override
  String get orDividerLabel => 'Or';

  @override
  String get eventAdsLabel => 'Event Ads';

  @override
  String get paymentThankYouTitle => 'Thank You!';

  @override
  String get paymentCompleteMessage => 'Your payment is complete.';

  @override
  String get viewPaymentLabel => 'View Payment';

  @override
  String get statusLabel => 'Status';

  @override
  String get completedStatusLabel => 'Completed';

  @override
  String get orderCodeLabel => 'Order code';

  @override
  String get dateTimeLabel => 'Date & Time';

  @override
  String get exchangeRateLabel => 'Exchange Rate';

  @override
  String get totalLabel => 'Total';

  @override
  String get paymentProcessedByLabel => 'Payment processed by';

  @override
  String get sendPaymentTitle => 'Send Payment';

  @override
  String get sendPaymentInstructions =>
      'To make a payment, send BTC to the address below';

  @override
  String get payWithWalletLabel => 'Pay With wallet';

  @override
  String get amountLabel => 'Amount';

  @override
  String get copyLabel => 'Copy';

  @override
  String get btcAddressLabel => 'BTC Address';

  @override
  String get payWithCoinbaseLabel => 'Pay with Coinbase';

  @override
  String get selectCryptocurrencyLabel => 'Or select a cryptocurrency';

  @override
  String get showMoreLabel => 'Show more';

  @override
  String get noSubscriptionTierAvailable =>
      'No subscription tier available yet.';

  @override
  String get signInBeforeSubscription =>
      'Please sign in before starting a subscription.';

  @override
  String get subscriptionActivatedMessage => 'Subscription activated';

  @override
  String purchaseFailedMessage(Object error) {
    return 'Purchase failed: $error';
  }

  @override
  String get subscriptionCheckoutSessionFailed =>
      'Could not create the subscription checkout session.';

  @override
  String get subscribeLabel => 'Subscribe';

  @override
  String get paymentCompleteShort => 'Payment complete';

  @override
  String get checkoutStartedMessage => 'Checkout started';

  @override
  String get subscriptionCreatedMessage => 'Subscription created';

  @override
  String get signInToManageSubscription =>
      'Please sign in to manage a subscription.';

  @override
  String get unableToCancelSubscription =>
      'Unable to cancel subscription right now.';

  @override
  String get subscriptionCancellationRequested =>
      'Subscription cancellation requested';

  @override
  String get unableToResumeSubscription =>
      'Unable to resume subscription right now.';

  @override
  String get subscriptionResumedMessage => 'Subscription resumed';

  @override
  String get cryptoPaymentsComingSoon =>
      'Crypto payments are still being wired to the live checkout flow.';

  @override
  String get paymentLabel => 'Payment';

  @override
  String get amountToPayLabel => 'Amount to pay';

  @override
  String get selectSubscriptionLabel => 'Select a subscription';

  @override
  String get monthlyLabel => 'Monthly';

  @override
  String get yearlyLabel => 'Yearly';

  @override
  String tierPlanBillingSummary(Object cycle, Object tierName) {
    return '$tierName plan • $cycle billing';
  }

  @override
  String get subscriptionPlansTitle => 'Subscription plans';

  @override
  String get noSubscriptionTiersAvailable =>
      'No subscription tiers are available right now.';

  @override
  String get popularBadgeLabel => 'Popular';

  @override
  String get priceUnavailableLabel => 'Price unavailable';

  @override
  String get currentSubscriptionTitle => 'Current subscription';

  @override
  String get signInCheckSubscriptionStatus =>
      'Sign in to check your active subscription status.';

  @override
  String get noActiveSubscriptionFound => 'No active subscription found yet.';

  @override
  String get planLabel => 'Plan';

  @override
  String get unknownLabel => 'Unknown';

  @override
  String get renewsEndsLabel => 'Renews / ends';

  @override
  String get cancellationLabel => 'Cancellation';

  @override
  String get scheduledForPeriodEndLabel => 'Scheduled for period end';

  @override
  String get resumeSubscriptionLabel => 'Resume subscription';

  @override
  String get cancelAtPeriodEndLabel => 'Cancel at period end';

  @override
  String get recentPaymentsTitle => 'Recent payments';

  @override
  String get paymentHistoryAfterSignIn =>
      'Payment history becomes available after sign in.';

  @override
  String get noPaymentHistoryFound => 'No payment history found yet.';

  @override
  String paymentIdFallback(Object id) {
    return 'Payment $id';
  }

  @override
  String get providerUnknownLabel => 'Provider unknown';

  @override
  String get refreshDetailsLabel => 'Refresh details';

  @override
  String get cryptoPaymentOptionsLabel => 'Crypto payment options';

  @override
  String get signInToSubscribeLabel => 'Sign in to subscribe';

  @override
  String get continueToCheckoutLabel => 'Continue to checkout';

  @override
  String get enterDiscountCodeHint => 'Enter discount code';

  @override
  String get addDiscountCodeFirstMessage => 'Add a discount code first.';

  @override
  String get discountCodeValidatedAtCheckoutMessage =>
      'Discount code will be validated when checkout starts.';

  @override
  String get applyLabel => 'Apply';

  @override
  String get authBannerSubscriptionMessage =>
      'You can review subscription plans now, but you need to sign in before checkout, cancellation, or payment history will work.';

  @override
  String get actionNotAllowedTitle => 'Action not allowed';

  @override
  String get removeCardTitle => 'Remove Card';

  @override
  String get connectEscrowAccountLabel => 'Connect your Escrow Account';

  @override
  String get subscriptionsTitle => 'Subscriptions';

  @override
  String get buyNowLabel => 'Buy now';

  @override
  String get deactivateLabel => 'Deactivate';

  @override
  String get activateLabel => 'Activate';

  @override
  String get confirmCardDeletionTitle => 'Confirm card deletion';

  @override
  String get eventDetailsTitle => 'Event Details';

  @override
  String get eventNotFoundTitle => 'Event Not Found';

  @override
  String get eventNotFoundDescription =>
      'The requested event details could not be found.';

  @override
  String get eventLocationLabel => 'Location';

  @override
  String get capacityAvailabilityLabel => 'Capacity & Availability';

  @override
  String capacityAvailabilitySummary(
      Object attendeeCount, Object capacity, Object spotsRemaining) {
    return '$attendeeCount / $capacity Attendees ($spotsRemaining spots left)';
  }

  @override
  String get turnOnSoundNotificationLabel => 'Turn on Sound notification';

  @override
  String get emailNotificationsLabel => 'E-Mail notifications';

  @override
  String get medalBronzeTitle => 'Bronze Status';

  @override
  String get medalBronzeDescription =>
      'User created a minimum of 2 events or user attended a minimum of 2 events without fail in the last 30 days. The user gets 2% discount of 1 in-app purchase of choice.';

  @override
  String get medalSilverTitle => 'Silver Status';

  @override
  String get medalSilverDescription =>
      'User created a minimum of 3 events or user attended a minimum of 3 events without fail in the last 30 days. The user gets 4% discount of 1 in-app purchase of choice.';

  @override
  String get medalGoldTitle => 'Gold Status';

  @override
  String get medalGoldDescription =>
      'User created a minimum of 4 events or user attended a minimum of 4 events without fail in the last 30 days. The user gets 8% discount of 1 in-app purchase of choice.';

  @override
  String get connectTvLabel => 'Connect TV';

  @override
  String get tvConnectedSuccessMessage => 'TV connected successfully.';

  @override
  String get couldNotConnectTvMessage => 'Could not connect this TV.';

  @override
  String get blogCommentAuthorYou => 'You';

  @override
  String get blogCommentJustNow => 'Just now';

  @override
  String get discoverGoldBadgeLabel => 'Gold';

  @override
  String get paymentDialogTitle => 'Payment';

  @override
  String get paymentAmountToPayLabel => 'Amount to pay';

  @override
  String get paymentSelectSubscriptionLabel => 'Select a subscription';

  @override
  String get paymentPlanBulletSuffix => 'plan •';

  @override
  String get paymentBillingSuffix => 'billing';

  @override
  String get paymentYearlyLabel => 'Yearly';

  @override
  String get paymentMonthlyLabel => 'Monthly';

  @override
  String get paymentDiscountCodeHint => 'Enter discount code';

  @override
  String get paymentDiscountCodeEmptyMessage => 'Add a discount code first.';

  @override
  String get paymentDiscountCodeValidationMessage =>
      'Discount code will be validated when checkout starts.';

  @override
  String get paymentApplyLabel => 'Apply';

  @override
  String get paymentAuthBannerMessage =>
      'You can review subscription plans now, but you need to sign in before checkout, cancellation, or payment history will work.';

  @override
  String get paymentSubscriptionPlansTitle => 'Subscription plans';

  @override
  String get paymentNoTiersMessage =>
      'No subscription tiers are available right now.';

  @override
  String get paymentPopularBadgeLabel => 'Popular';

  @override
  String get paymentPriceUnavailableLabel => 'Price unavailable';

  @override
  String get paymentCurrentSubscriptionTitle => 'Current subscription';

  @override
  String get paymentSignInToCheckStatusMessage =>
      'Sign in to check your active subscription status.';

  @override
  String get paymentNoActiveSubscriptionMessage =>
      'No active subscription found yet.';

  @override
  String get paymentStatusLabel => 'Status';

  @override
  String get paymentPlanLabel => 'Plan';

  @override
  String get paymentUnknownPlanLabel => 'Unknown';

  @override
  String get paymentRenewsEndsLabel => 'Renews / ends';

  @override
  String get paymentCancellationLabel => 'Cancellation';

  @override
  String get paymentScheduledForPeriodEndLabel => 'Scheduled for period end';

  @override
  String get paymentResumeSubscriptionLabel => 'Resume subscription';

  @override
  String get paymentCancelAtPeriodEndLabel => 'Cancel at period end';

  @override
  String get paymentRecentPaymentsTitle => 'Recent payments';

  @override
  String get paymentHistoryAfterSignInMessage =>
      'Payment history becomes available after sign in.';

  @override
  String get paymentNoHistoryMessage => 'No payment history found yet.';

  @override
  String paymentFallbackDescription(String id) {
    return 'Payment $id';
  }

  @override
  String get paymentProviderUnknownLabel => 'Provider unknown';

  @override
  String get paymentRefreshDetailsLabel => 'Refresh details';

  @override
  String get paymentCryptoOptionsLabel => 'Crypto payment options';

  @override
  String get paymentSignInToSubscribeLabel => 'Sign in to subscribe';

  @override
  String get paymentContinueToCheckoutLabel => 'Continue to checkout';

  @override
  String get interestMovies => 'Movies';

  @override
  String get interestPubsAndBars => 'Pubs & Bars';

  @override
  String get interestLiveShow => 'Live show';

  @override
  String get interestClubbing => 'Clubbing';

  @override
  String get interestFestival => 'Festival';

  @override
  String get interestOutdoors => 'Outdoors';

  @override
  String get interestVolunteer => 'Volunteer';

  @override
  String get interestDiy => 'DIY';

  @override
  String get interestActivism => 'Activism';

  @override
  String get interestPetLove => 'Pet love';

  @override
  String get interestVideoGames => 'Video Games';

  @override
  String get interestFamilyActivities => 'Family activities';

  @override
  String get interestTech => 'Tech';

  @override
  String get interestCostume => 'Costume';

  @override
  String get interestFoodie => 'Foodie';

  @override
  String get interestCamping => 'Camping';

  @override
  String get medalBronzeSubtitle =>
      'User created a minimum of 2 events or user attended a minimum of 2 events without fail in the last 30 days. The user gets 2% discount of 1 in-app purchase of choice.';

  @override
  String get medalSilverSubtitle =>
      'User created a minimum of 3 events or user attended a minimum of 3 events without fail in the last 30 days. The user gets 4% discount of 1 in-app purchase of choice.';

  @override
  String get medalGoldSubtitle =>
      'User created a minimum of 4 events or user attended a minimum of 4 events without fail in the last 30 days. The user gets 8% discount of 1 in-app purchase of choice.';

  @override
  String get removeCardActionNotAllowedTitle => 'Action not allowed';

  @override
  String get removeCardConnectEscrowLabel => 'Connect your Escrow Account';

  @override
  String get removeCardSubscriptionsLabel => 'Subscriptions';

  @override
  String get removeCardConfirmDeletionTitle => 'Confirm card deletion';

  @override
  String get myEventDetailsLabel => 'Event Details';

  @override
  String get connectTvTitle => 'Connect TV';

  @override
  String get advertDialogTitle => 'Advert';

  @override
  String get advertEventStarts48hrs => 'Event starts in 48 hrs';

  @override
  String get advertEventStarts7days => 'Event starts in 7 days';

  @override
  String get userAroundTitle => 'User Around';

  @override
  String get userAroundMessage =>
      'Potential matches matching your criteria found currently';

  @override
  String get guestInviteTitle => 'Guest Invite';

  @override
  String get inviteFriendsToKumeleTitle => 'Invite your friends to Kumele';

  @override
  String get inviteReferralCodeLabel => 'Referral code';

  @override
  String get congratulationsTitle => 'Congratulations';

  @override
  String get congratsNewStatusBronze => 'New Status: Bronze';

  @override
  String get congratsDiscountCode => 'Discount Code: KEMELE20';

  @override
  String get congratsBronzeDescription =>
      'You created a minimum of 3 events or user attended a minimum of 3 events without fail in the last 30 days. The user gets 4% discount of one in-app purchase of choice.';

  @override
  String get passkeyIntroDescription =>
      'Passkeys are easy to set up and let you securely sign in to your Kumele Account using the  security capabilities of your devices like Touch ID and Face ID.  Passkeys are way more secure and are easier to use than all current 2-factor authentication methods.';

  @override
  String get passkeyTitle => 'Passkey';

  @override
  String get signInUsingPasskeyLabel => 'Sign in using passkey';

  @override
  String get signupPasskeyEmailHint => 'Enter your e-mail';

  @override
  String get eventStartInLabel => 'Start in';

  @override
  String get cancelEventTitle => 'Cancel event';

  @override
  String get setTimeTitle => 'Set Time';

  @override
  String get guestPricesTitle => 'Guest Prices';

  @override
  String get guestPricesUnavailableMessage =>
      'Guest prices are unavailable right now.';

  @override
  String get rewardRingsTitle => 'Reward Rings';

  @override
  String get moneyEarnedTitle => 'Money Earned';

  @override
  String get tryAgainLabel => 'Try Again';

  @override
  String get locationServicesOffTitle => 'Location Services Off';

  @override
  String get locationAccessRequiredTitle => 'Location Access Required';

  @override
  String get locationServicesOffMessage =>
      'Please enable location services on your device to discover events near you.';

  @override
  String get locationPermissionPermanentlyDeniedMessage =>
      'Location permission was permanently denied. Please enable it in app settings.';

  @override
  String get locationAccessNeededMessage =>
      'Location access is needed to show events near you.';

  @override
  String get joinEventConfirmTitle => 'Join this event?';

  @override
  String get joinLabel => 'Join';

  @override
  String get kumeleTermsOfUseLabel => 'Kumele Terms of use';

  @override
  String get eventCancelledDialogTitle => 'Event Cancelled';

  @override
  String get eventCancelledDialogMessage =>
      'The host unfortunately cancelled the event. We apologize for the inconvenience. In case of prepayments please contact PayPal immediately for a refund.';

  @override
  String get premiumPurchaseIncludeLabel => 'Premium In-app purchase include:';

  @override
  String get premiumLocationChange => 'Location Change';

  @override
  String get premiumHouseParty => 'House party (Max guest 10)';

  @override
  String get premiumNoAds => 'No Ads';

  @override
  String get premium7DaysAdvertising => '7 days pre event Advertising';

  @override
  String get signupDateOfBirthLabel => 'Date of birth';

  @override
  String get signupGenderLabel => 'Gender';

  @override
  String get signUpButtonLabel => 'Sign up';

  @override
  String myEventJoinedLabel(String date) {
    return 'Joined $date';
  }

  @override
  String get myEventOrganizedByLabel => 'Organized by';

  @override
  String get myEventDateTimeLabel => 'Date & Time';

  @override
  String get myEventLocationLabel => 'Location';

  @override
  String get myEventCapacityAvailabilityLabel => 'Capacity & Availability';

  @override
  String get myEventAboutEventLabel => 'About Event';

  @override
  String get eventRulesTitle => 'Event Rules & Info';

  @override
  String eventRuleAgeLabel(String minAge, String maxAge) {
    return 'Age: $minAge - $maxAge';
  }

  @override
  String get eventRuleNoAgeLimitLabel => 'No limit';

  @override
  String eventRuleGenderLabel(String gender) {
    return 'Gender: $gender';
  }

  @override
  String eventRuleLanguageLabel(String language) {
    return 'Language: $language';
  }

  @override
  String get eventRuleRequiresApprovalLabel => 'Requires Host Approval';

  @override
  String get exploreMatchedEventLabel => 'Matched Event';

  @override
  String get exploreCreatedEventLabel => 'Created Event';

  @override
  String get exploreJoinNowLabel => 'Join Now';

  @override
  String get exploreSwipeNoMoreMatchesLine1 => 'No more matches currently,';

  @override
  String get exploreSwipeNoMoreMatchesLine2 => 'until then';

  @override
  String get exploreSwipeCreateEventCta => 'Be awesome and create an event';

  @override
  String get exploreSwipeBlogsSuggestion => 'Here are some blogs you may like';

  @override
  String get exploreSwipeInviteFriendsCta =>
      'Be awesome and invite your friends';

  @override
  String get exploreNotificationsTitle => 'Notifications';

  @override
  String get exploreTabletHeaderTitle => 'Explore';

  @override
  String get createEventTitle => 'Create event';

  @override
  String get previewEventLabel => 'Preview Event';

  @override
  String get createEventAgeRangeLabel => 'Age range';

  @override
  String get createEventNumberOfGuestsLabel => 'Number of guests';

  @override
  String get createEventRsvpGuestPaymentLabel => 'RSVP Guest Payment';

  @override
  String get createEventFreeEventLabel => 'Free Event';

  @override
  String get createEventCardPaymentLabel => 'Card Payment';

  @override
  String get createEventCashOnEntryLabel => 'Cash On Entry';

  @override
  String get reportEventTitle => 'Report Event';

  @override
  String get reportEventChooseReasonLabel => 'Choose a reason';

  @override
  String get ratingsTitle => 'Ratings';

  @override
  String get rateEventTitle => 'Rate Event';

  @override
  String get attendeeRatingsLabel => 'Attendee Ratings (70%)';

  @override
  String get blogNoCommentsMessage =>
      'No comments yet. Be the first to comment!';

  @override
  String get nftPreviewTitle => 'NFT Preview';

  @override
  String get nftClosePreviewLabel => 'Close Preview';

  @override
  String get walletSignatureRequiredTitle => 'Wallet Signature Required';

  @override
  String get dismissLabel => 'Dismiss';

  @override
  String get soundNotificationTurnOnLabel => 'Turn on Sound notification';

  @override
  String get soundNotificationLabel => 'Sound notification';

  @override
  String get turnOn2faLabel => 'Turn on 2 factor authentications';

  @override
  String get chooseInterestsTitle => 'Choose interests';

  @override
  String chooseUpToInterestsLabel(String count) {
    return 'Choose up to $count interests:';
  }

  @override
  String get earnMedalsAndRewardsTitle => 'Earn medals and rewards';

  @override
  String otherEventsFromHostLabel(String hostName) {
    return 'Other events from $hostName';
  }

  @override
  String get hobbyMeetupTagline => 'Hobby Meetup';

  @override
  String get splashTagline => 'We play. We overcome. We unite. We live.';

  @override
  String get skipLabel => 'Skip';

  @override
  String get guestTileGroupMeditationLabel => 'Group Meditation';

  @override
  String get guestTileHostedByLabel => 'Hosted By Anki Maheshwari';

  @override
  String get guestTileLocationLabel => 'Bahawalpur, Punjab PK';

  @override
  String get filterMockLocationLabel => 'United Kingdom, 39495, kentucky';

  @override
  String get historyTitle => 'History';

  @override
  String get historyStatisticsTitle => 'History & Statistics';

  @override
  String get blogDetailsTitle => 'Blog Details';

  @override
  String get addCardTitle => 'Add card';

  @override
  String get addCardStripeMessage =>
      'Card details are collected securely by Stripe.';

  @override
  String get addCardSubmitLabel => 'Add Card';

  @override
  String get noNotificationsTitle => 'No Notifications';

  @override
  String get noNotificationsDescription =>
      'You have no new notifications right now. Check back later.';

  @override
  String get reportReasonRacist => 'Racist';

  @override
  String get reportReasonScam => 'Scam';

  @override
  String get reportReasonOther => 'Other';

  @override
  String get reportReasonPhysicalAssault => 'Physical assault';

  @override
  String get rateAppTitle => 'Please rate your last event';

  @override
  String get rateAppStoriesTitle => 'Rate this app';

  @override
  String get rateAppThankYouTitle => 'Thank You!';

  @override
  String get rateAppFeedbackTitle => 'How can we make it better?';

  @override
  String get rateAppCommentHint => 'Add Comment';

  @override
  String get rateAppSendButton => 'Send';

  @override
  String get chooseUsernameTitle => 'Choose your username';

  @override
  String get chooseUsernameDescription =>
      'Usernames can only be changed every 3 months.';

  @override
  String get chooseUsernameHint => 'Enter your user name';

  @override
  String get chooseUsernameSkip => 'Skip';

  @override
  String get guestInviteTotalGuests => 'Total Guests';

  @override
  String get guestInviteFreeRange => '1–5 Free';

  @override
  String get guestInviteDialogOr => ' or ';

  @override
  String get signupLegalAdultCheckbox => 'I am a legal adult (18/21+)';

  @override
  String get signupSubscribeCheckbox => 'Subscribe to newsletter';

  @override
  String get signupTermsCheckboxPrefix =>
      'By Creating an account you agree to ';

  @override
  String get signupTermsCheckboxLink => 'Terms & Conditions';

  @override
  String get signupCaptchaCheckbox => 'I am not a robot';

  @override
  String get signupErrorFirstNameRequired => 'Please enter your first name';

  @override
  String get signupErrorEmailRequired => 'Please enter your email';

  @override
  String get signupErrorEmailInvalid => 'Please enter a valid email';

  @override
  String get signupErrorPasswordRequired => 'Please enter password';

  @override
  String get signupErrorPasswordTooShort =>
      'Password must be at least 6 characters';

  @override
  String get signupErrorConfirmPasswordRequired => 'Please confirm password';

  @override
  String get signupErrorPasswordMismatch => 'Passwords do not match';

  @override
  String get signupErrorLegalAgeRequired =>
      'You must confirm that you are of legal age';

  @override
  String get signupErrorTermsRequired =>
      'You must accept the Terms & Conditions';

  @override
  String get signupErrorCaptchaRequired => 'Please confirm you are not a robot';

  @override
  String get permissionGuestInviteTitle => 'Guest Invite';

  @override
  String get permissionEventCanceledTitle => 'Event Canceled';

  @override
  String get permissionFollowHostTitle => 'Follow Host';

  @override
  String get permissionFollowHostConfirm => 'Follow';

  @override
  String get permissionUsernameHint => 'Enter username';

  @override
  String get exploreSwipeCreateEventButton => 'Create Event';

  @override
  String get exploreSwipeReadBlogButton => 'Read Blog';

  @override
  String get exploreSwipeInviteFriendsButton => 'Invite Friends';

  @override
  String get twoFactorGoogleAuthenticator => 'Google\nAuthenticator';

  @override
  String get twoFactorAuthy => 'Authy';

  @override
  String get twoFactorDuo => 'Duo';

  @override
  String get twoFactorMicrosoftAuthenticator => 'Microsoft\nAuthenticator';

  @override
  String get paymentPayPalLabel => 'PayPal';

  @override
  String get paymentMasterCardLabel => 'Master Card';

  @override
  String paymentCardExpiresLabel(String date) {
    return 'Expires $date';
  }

  @override
  String get paymentCoinbaseCommerceLabel => ' Coinbase Commerce';

  @override
  String get paymentEthereumLabel => 'Ethereum';

  @override
  String get paymentDogecoinLabel => 'Dogecoin';

  @override
  String get paymentUsdCoinLabel => 'USD Coin';

  @override
  String paymentTransactionIdLabel(String id) {
    return '$id';
  }

  @override
  String paymentTransactionDateLabel(String date) {
    return '$date';
  }

  @override
  String paymentTransactionAmountLabel(String amount) {
    return '$amount';
  }

  @override
  String get socialMediaYouTube => 'YouTube';

  @override
  String get socialMediaFacebook => 'Facebook';

  @override
  String get socialMediaInstagram => 'Instagram';

  @override
  String get socialMediaPinterest => 'Pinterest';

  @override
  String get socialMediaTwitter => 'Twitter';

  @override
  String get termsSection1Title => '1. Account eligibility';

  @override
  String get termsSection2Title => '2. Acceptable use';

  @override
  String get termsSection3Title => '3. Events and community content';

  @override
  String get termsSection4Title => '4. Payments and subscriptions';

  @override
  String get termsSection5Title => '5. Privacy and communications';

  @override
  String get termsSection6Title => '6. Termination';

  @override
  String get termsSection7Title => '7. Changes to these terms';

  @override
  String get nftClaimingButton => 'Claiming…';

  @override
  String get nftBuyingButton => 'Buying…';

  @override
  String get nftClaimButton => 'Claim';

  @override
  String get nftBuyButton => 'Buy';

  @override
  String get languageUpdateFailed => 'Failed to update language.';

  @override
  String get eventDetailNotFound =>
      'The requested event details could not be found.';

  @override
  String myEventAttendeesLabel(int count, int capacity, int remaining) {
    return '$count / $capacity Attendees ($remaining spots left)';
  }

  @override
  String get shareEventDialogOr => ' or ';

  @override
  String aboutHostPrefix(String hostName) {
    return 'About $hostName: ';
  }

  @override
  String get pleaseCompleteAllFields => 'Please complete all fields';

  @override
  String get ratingSubmittedSuccess => 'Rating submitted successfully';

  @override
  String get ratingSubmitFailed => 'Failed to submit rating';

  @override
  String get reportSubmittedSuccess => 'Report submitted successfully';

  @override
  String get reportSubmitFailed => 'Failed to submit report';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get paymentAddNewCardLabel => 'Add new card';

  @override
  String get paymentPayNowLabel => 'Pay now';

  @override
  String get paymentPayWithLabel => 'Pay with';

  @override
  String get useCurrentLocation => 'Use Current Location';

  @override
  String get orEnterAnAddress => 'OR ENTER AN ADDRESS';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get saveLocation => 'Save Location';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get changeInterestsTitle => 'Change interests';

  @override
  String get houseNumberLabel => 'Number';

  @override
  String get districtCityLabel => 'District / City';

  @override
  String get permissionNotificationPrimerTitle =>
      '\"Kumele\" Would Like to Send You Push Notifications';

  @override
  String get permissionNotificationPrimerMessage =>
      'Notifications may include alerts, sounds and icon badges. These can be configured in Settings.';

  @override
  String get permissionPhotosPrimerTitle =>
      '\"Kumele\" Would Like to Access Your Photos';

  @override
  String get permissionPhotosPrimerMessage =>
      'Allow \"Kumele\" to access your photos to send images or videos';

  @override
  String get permissionLocationPrimerTitle =>
      'Allow \"Kumele\" to access your location?';

  @override
  String get permissionLocationPrimerMessage =>
      'Allow \"Kumele\" to access your location to show events near you';

  @override
  String get permissionDontAllow => 'Don\'t Allow';

  @override
  String get permissionAllow => 'Allow';

  @override
  String get permissionSelectPhotos => 'Select Photos...';

  @override
  String get permissionAllowAllPhotos => 'Allow Access to All Photos';

  @override
  String get permissionAllowWhileUsingApp => 'Allow While Using App';

  @override
  String get permissionAllowOnce => 'Allow Once';

  @override
  String get myEventPlaceholderTitle => 'Hobby Event Title';

  @override
  String get myEventPlaceholderTime => '12:00-13:00';

  @override
  String get myEventPlaceholderStartTime => 'Start in 2d';

  @override
  String get myEventPlaceholderLocation => 'City Center, Berlin';

  @override
  String get welcomeToKumeleMessage => 'Welcome to Kumele!';

  @override
  String get selectDateTimeFirstError => 'Please select a date and time first.';

  @override
  String get accountCreatedSuccessMessage => 'Account created successfully!';

  @override
  String signupFailedPrefix(String error) {
    return 'Signup failed: $error';
  }

  @override
  String get nftClaimedMessage => 'NFT claimed.';

  @override
  String get nftClaimFailedError => 'Could not claim this NFT.';

  @override
  String get nftPurchasedMessage => 'NFT purchased.';

  @override
  String get nftPurchaseFailedError => 'Could not buy this NFT.';

  @override
  String get loadBlogPostFailedError => 'Failed to load blog post.';

  @override
  String get paypalAccountConnectedMessage => 'PayPal account connected.';

  @override
  String get restoringPurchasesMessage =>
      'Restoring purchases — this may take a moment.';

  @override
  String get cardSetupUnavailableError => 'Card setup is unavailable.';

  @override
  String get cardAddedSuccessMessage => 'Card added successfully.';

  @override
  String get addCardFailedError => 'Could not add card.';

  @override
  String get copiedMessage => 'Copied';

  @override
  String get eventCreatedPendingPaymentMessage =>
      'Event created. Complete payment to activate it.';

  @override
  String get eventCreatedSuccessMessage => 'Event created successfully.';
}
