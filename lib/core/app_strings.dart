abstract final class AppStrings {
  // Actions
  static const String cancel = 'Cancel';
  static const String ok = 'OK';
  static const String save = 'Save';
  static const String continueLabel = 'Continue';
  static const String submit = 'Submit';
  static const String close = 'Close';
  static const String confirm = 'Confirm';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String done = 'Done';
  static const String retry = 'Retry';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String selfCheck = 'Self-check';

  // Feedback
  static const String success = 'Success';
  static const String error = 'Error';
  static const String loading = 'Loading...';
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';
  static const String comment = 'Comment';
  static const String addYourComment = 'Add your comment...';
  static const String publishComment = 'Publish comment';
  static const String posted = 'Posted!';

  // Validation
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';

  // Empty states
  static const String noResults = 'No results found';
  static const String noData = 'No data available';
  static const String noChats = 'No Chats';
  static const String noChatsDescription =
      'You have no chats right now. Start a conversation or check back later.';
  static const String noGuests = 'No Guests';
  static const String noGuestsDescription =
      'There are no guests checked in or registered for this event yet.';

  // Chat
  static const String chat = 'Chat';
  static const String spirituality = 'Spirituality';
  static const String hostedBy = 'Hosted by';
  static const String rateEvent = 'Rate event';
  static const String reportEvent = 'Report event';
  static const String guestScan = 'Guest Scan';
  static const String scanQrCode = 'Scan QR Code';
  static const String alignQrInFrame =
      'Align the guest QR code within the frame';
  static const String guestNotFound = 'Guest not found in this event';
  static const String invalidQrCode = 'Invalid QR code';
  static const String confirmCheckIn = 'Confirm check-in';
  static const String confirmGuestCheckInDescription =
      'Check in this guest for the event?';
  static String checkedInSuccess(String name) =>
      'Successfully checked in $name!';
  static const String checkedInLabel = 'Checked In';
  static const String notCheckedInLabel = 'Not Checked In';
  static const String confirmedLabel = 'Confirmed';
  static const String followHost = 'Follow Host';
  static const String daysLeftToRate = '-- days left to rate &\nreview';
  static const String scannedList = 'Scanned list: --';
  static const String eventCanceled = 'Event Canceled';
  static const String noMessages = 'No Messages';
  static const String noMessagesDescription = 'There are no messages here yet.';
  static const String joinChatFailed = 'Failed to join chat room';
  static const String joinChatSuccess = 'Successfully joined the chat room';
  static const String loadMessagesFailed = 'Failed to load chat messages';
  static const String sendMessageFailed = 'Failed to send message';
  static const String chatNotAvailable = 'Chat is not available';
  static const String chatAccessDenied = 'You do not have access to this chat';
  static const String chatClosed = 'This chat is closed';
  static const String typeAMessage = 'Type a message';
  static const String reply = 'Reply';
  static const String unknownUser = 'Unknown';
  static const String activeEvent = 'Active Event';
  static const String active = 'Active';
  static const String eventChat = 'Event Chat';
  static const String guests = 'Guests';
  static const String guest = 'Guest';
  static const String priceLabel = 'Price';
  static const String eventAddressLabel = 'Event Address';
  static const String cashOnEntry = 'Cash on entry';
  static const String free = 'Free';

  // Profile
  static const String profileTitle = 'Profile';
  static const String myEvents = 'My Events';
  static const String createdEvents = 'Created Events';
  static const String joinedEvents = 'Joined Events';
  static const String noEventsCreatedYet =
      'You haven\'t created any events yet.';
  static const String noEventsJoinedYet = 'You haven\'t joined any events yet.';
  static const String blogsTitle = 'Blogs';
  static const String settingsTitle = 'Setting';
  static const String interestedHobbies = 'Interested hobbies';
  static const String editHobbies = 'Edit hobbies';
  static const String showMore = 'Show more';
  static const String showLess = 'Show less';
  static const String myQrCode = 'My QR Code';
  static const String following = 'Following';
  static const String followers = 'Followers';
  static const String goldStatus = 'Gold status';
  static const String notifications = 'Notifications';
  static const String languages = 'Languages';
  static const String languagesLoadFailed = 'Failed to load languages.';
  static const String connectionsLoadFailed =
      'Failed to load followers and following.';
  static const String cardPaymentsSubscriptions =
      'Card Payments, Subscriptions & Escrow ';
  static const String security = 'Security';
  static const String contact = 'Contact';
  static const String contactPageSubtitle = 'Tell us how we can help.';
  static const String contactSubjectLabel = 'Subject';
  static const String contactSubjectHint = 'Brief summary of your issue';
  static const String contactDescriptionLabel = 'Description';
  static const String contactDescriptionHint = 'Describe your issue in detail';
  static const String contactCategoryLabel = 'Category';
  static const String contactPriorityLabel = 'Priority';
  static const String contactAttachmentLabel = 'Attachment (optional)';
  static const String contactAttachmentHint = 'Upload a screenshot';
  static const String contactSubmitLabel = 'Submit';
  static const String contactSuccessMessage = 'Your message has been sent.';
  static const String contactSubmitFailed =
      'Failed to send message. Please try again.';
  static const String contactDescriptionTooShort =
      'Please enter at least 20 characters so support can help properly.';
  static const String contactSubjectRequired = 'Please enter a subject.';
  static const String contactDescriptionRequired =
      'Please enter a description.';
  static const String contactAttachmentPickFailed = 'Failed to pick image.';
  static const String guidelines = 'Guidelines';
  static const String referAFriend = 'Refer a Friend';
  static const String referralCodeUnavailable =
      'Your referral code is not available right now. Please try again later.';
  static const String referralShareSubject = 'Join me on Kumele';
  static String referralShareMessage({
    required String referralCode,
    required String referralLink,
  }) =>
      'Join me on Kumele — meet local hobby friends through shared interests!\n\n'
      'Use my referral code: $referralCode\n\n'
      'Sign up here: $referralLink';
  static const String termsAndConditions = 'Terms and Conditions';
  static const String nightMode = 'Night Mode';
  static const String deleteAccount = 'Delete Account';
  static const String signOut = 'Signout';
  static const String deleteAccountConfirmTitle =
      'Are you sure? This action cannot\n be undone. Please retype \npassword.';
  static const String deleteAccountPasswordHint = 'Enter current password';
  static const String deleteAccountPageSubtitle =
      'This action is permanent. Enter your password and tell us why you are leaving.';
  static const String deleteAccountPasswordLabel = 'Password';
  static const String deleteAccountReasonLabel = 'Reason';
  static const String deleteAccountReasonHint = 'Tell us why you are leaving';
  static const String deleteAccountConfirmationLabel =
      'I understand this action is permanent and cannot be undone';
  static const String deleteAccountSubmitLabel = 'Delete Account';
  static const String deleteAccountSuccessMessage =
      'Account successfully deleted.';
  static const String deleteAccountSubmitFailed =
      'Failed to delete account. Please try again.';
  static const String deleteAccountPasswordRequired =
      'Please enter your password.';
  static const String deleteAccountReasonRequired =
      'Please tell us why you are leaving.';
  static const String deleteAccountConfirmationRequired =
      'Please confirm that you understand this action is permanent.';
  static const String signOutConfirmTitle =
      'Are you sure you want to\n signout?';
  static const String signOutSuccessMessage = 'Signed out successfully.';

  // Forgot / Reset password
  static const String forgotPasswordPageTitle = 'Forgot Password';
  static const String forgotPasswordSubtitle =
      'Enter your email address and we will send you a reset token.';
  static const String forgotPasswordEmailLabel = 'E-Mail';
  static const String forgotPasswordHint = 'Enter E-Mail';
  static const String forgotPasswordSubmitLabel = 'Send Reset Email';
  static const String forgotPasswordSuccessMessage =
      'If that email exists, a reset link has been sent.';
  static const String resetPasswordPageTitle = 'Reset Password';
  static const String resetPasswordSubtitle =
      'Enter the code sent to your email and choose a new password.';
  static const String resetPasswordTokenLabel = 'Verification Code';
  static const String resetPasswordTokenHint = 'Enter code';
  static const String resetPasswordNewPasswordLabel = 'New Password';
  static const String resetPasswordNewPasswordHint = 'Enter new password';
  static const String resetPasswordConfirmPasswordLabel = 'Confirm Password';
  static const String resetPasswordConfirmPasswordHint =
      'Re-enter new password';
  static const String resetPasswordSubmitLabel = 'Reset Password';
  static const String resetPasswordSuccessMessage =
      'Password reset successfully';
  static const String passwordMinLengthError =
      'Password must be at least 6 characters';
  static const String passwordsDoNotMatchError = 'Passwords do not match';

  // Email verification
  static const String emailVerificationPageTitle = 'Verify Your Email';
  static const String emailVerificationSubtitle =
      'We sent a 6-digit verification code to your email. Enter it below to continue.';
  static const String emailVerificationVerifyLabel = 'Verify Email';
  static const String emailVerificationResendLabel = 'Resend Code';
  static const String emailVerificationResendInLabel = 'Resend code in';
  static const String emailVerificationSentMessage =
      'Verification code sent to your email.';
  static const String emailVerificationFailedMessage =
      'Invalid verification code. Please try again.';
  static const String emailVerificationSendFailedMessage =
      'Failed to send verification code. Please try again.';
  static const String emailVerificationSuccessMessage =
      'Email verified successfully!';

  // Security
  static const String changePassword = 'Change Password';
  static const String changePasswordCurrentLabel = 'Current Password';
  static const String changePasswordCurrentHint = 'Enter current password';
  static const String changePasswordNewLabel = 'New Password';
  static const String changePasswordNewHint = 'Enter new password';
  static const String changePasswordConfirmLabel = 'Confirm New Password';
  static const String changePasswordConfirmHint = 'Re-enter new password';
  static const String changePasswordSubmitLabel = 'Update Password';
  static const String changePasswordSuccessMessage =
      'Password updated successfully. Please sign in with your new password.';
  static const String changePasswordSubmitFailed =
      'Failed to update password. Please try again.';
  static const String changePasswordCurrentRequired =
      'Please enter your current password.';
  static const String registerPasskey = 'Register Passkey';
  static const String twoFactorAuth = 'Two Factor Authentication';
  static const String twoFactorSetupTitle = 'Authenticator App Setup';
  static const String twoFactorSetupStep1 =
      '1. Open an authenticator app on your mobile device';
  static const String twoFactorSetupStep1Hint =
      "If you don't have one, download and install one of the recommended apps:";
  static const String twoFactorSetupStep2Lead =
      '2. Scan this barcode with your ';
  static const String twoFactorSetupStep2Bold = 'authenticator app';
  static const String twoFactorSetupCantScan =
      "Can't scan? Use this code instead";
  static const String twoFactorSetupStep3Lead =
      '3. Enter the six-digit code from the ';
  static const String twoFactorSetupStep3Bold = 'authenticator app';
  static const String twoFactorVerificationHint =
      'Enter Verification Code Here';
  static const String twoFactorSetupLoadFailed =
      'Failed to load 2FA setup. Please try again.';
  static const String twoFactorEnableFailed =
      'Failed to enable 2FA. Please check your code and try again.';
  static const String twoFactorEnableSuccess =
      'Two factor authentication enabled successfully.';
  static const String twoFactorManualCodeCopied =
      'Setup code copied to clipboard';
  static const String setup = 'Setup';
  static const String twoFactorDisableTitle =
      'Disable Two Factor Authentication';
  static const String twoFactorDisableSubtitle =
      'Are you sure you want to turn off two factor authentication?';
  static const String twoFactorDisableDescription =
      'Your account will only be protected by your password. We recommend keeping 2FA enabled for better security.';
  static const String twoFactorDisableConfirm = 'Disable Two Factor';
  static const String twoFactorDisableCodeLead =
      'Enter the six-digit code from your ';
  static const String twoFactorDisableSuccess =
      'Two factor authentication disabled successfully.';
  static const String twoFactorDisableFailed =
      'Failed to disable 2FA. Please check your code and try again.';
  static const String twoFactorLoginTitle = 'Two Factor Authentication';
  static const String twoFactorLoginSubtitle =
      'Enter the code from your authenticator app to continue';
  static const String twoFactorLoginDescription =
      'Your account is protected with two factor authentication.';
  static const String twoFactorLoginCodeLead =
      'Enter the six-digit code from your ';
  static const String twoFactorLoginCodeBold = 'authenticator app';
  static const String twoFactorLoginVerify = 'Verify';
  static const String twoFactorLoginFailed =
      'Invalid verification code. Please try again.';
  static const String passkeyRegisterSuccess =
      'Passkey registered successfully';

  // Onboarding
  static const String onboardingPageTitle = 'Set up your profile';
  static const String onboardingPageSubtitle =
      'Add a photo and tell the community about yourself.';
  static const String onboardingAvatarHint = 'Tap to add photo';
  static const String onboardingImagePickerTitle = 'Add profile photo';
  static const String onboardingImagePickerSubtitle =
      'Choose gallery or camera for your profile picture';
  static const String gallery = 'Gallery';
  static const String camera = 'Camera';
  static const String onboardingUsernameLabel = 'Username';
  static const String onboardingUsernameHint = 'Choose a username (optional)';
  static const String onboardingUsernameHelper =
      'Usernames can only be changed every 3 months';
  static const String onboardingUsernameChecking = 'Checking username...';
  static const String onboardingUsernameAvailable = 'Username is available';
  static const String onboardingUsernameTaken = 'Username is already taken';
  static const String onboardingPhoneLabel = 'Phone number';
  static const String onboardingPhoneHint =
      'Enter your phone number (optional)';
  static const String onboardingAboutLabel = 'About me';
  static const String onboardingAboutHint =
      'Tell us about your interests, hobbies, and what you enjoy doing';
  static const String onboardingSuccessMessage = 'Profile saved successfully.';
  static const String onboardingImageRequired = 'Please add a profile photo.';
  static const String onboardingPhoneRequired =
      'Please enter your phone number.';
  static const String onboardingPhoneInvalid =
      'Please enter a valid phone number.';
  static const String onboardingAboutTooShort =
      'About me must be at least 200 characters.';
  static const String onboardingAboutTooLong =
      'About me cannot exceed 500 characters.';
  static const String onboardingImagePlatformUnsupported =
      'Image upload is only available on Android.';
  static const String onboardingImagePickFailed = 'Failed to pick image.';
  static const String onboardingSubmitFailed =
      'Failed to save profile. Please try again.';

  // Edit profile
  static const String editProfileTitle = 'Edit Profile';
  static const String editProfileFirstNameLabel = 'First name';
  static const String editProfileFirstNameHint = 'Enter your first name';
  static const String editProfileLastNameLabel = 'Last name';
  static const String editProfileLastNameHint = 'Enter your last name';
  static const String editProfileAboutLabel = 'About me';
  static const String editProfileAboutHint =
      'Tell us about your interests, hobbies, and what you enjoy doing';
  static const String editProfilePhoneLabel = 'Phone number';
  static const String editProfilePhoneHint = 'Enter your phone number';
  static const String editProfileUpdateLabel = 'Update';
  static const String editProfileSuccessMessage =
      'Profile updated successfully.';
  static const String editProfileSubmitFailed =
      'Failed to update profile. Please try again.';
  static const String editProfileFirstNameRequired =
      'Please enter your first name.';
  static const String editProfileAboutTooLong =
      'About me cannot exceed 500 characters.';
  static const String editProfilePhoneInvalid =
      'Please enter a valid phone number.';
  static const String editProfileUserMissing =
      'Unable to update profile. User not found.';

  // Map & Location Picker
  static const String pickEventLocation = 'Pick Event Location';
  static const String selectedLocation = 'Selected Location';
  static const String fetchingAddress = 'Fetching address…';
  static const String moveMapToPickLocation = 'Move the map to pick a location';
  static const String confirmLocation = 'Confirm Location';
  static const String searching = 'Searching…';
  static const String unknownLocation = 'Unknown location';
  static const String couldNotFetchAddress = 'Could not fetch address';
  static const String locationServicesDisabled =
      'Location services are disabled.';
  static const String locationPermissionDenied = 'Location permission denied.';
  static const String locationPermissionPermanentlyDenied =
      'Location permission permanently denied.';
  static const String pickEventLocationPlaceholder = 'Pick event location';
  static const String tapToOpenMapPlaceholder =
      'Tap to open map and drop a pin';

  // Share Event Bottom Sheet
  static const String limitedInvites = 'Limited Invites';
  static const String howItWorks = 'How it works:';
  static const String login = 'Login';
  static const String signup = 'Signup';
  static const String inviteFriendsAndFamily = 'Invite your friends and family';
  static const String eventCodeCopied = 'Event code copied to clipboard!';
  static const String copyTo = 'Copy to';
  static const String clipboard = 'clipboard';
  static const String eventIdLabel = 'Event ID: ';
  static const String locationLabel = 'Location: ';

  // Scan QR Page
  static const String scanQr = 'Scan QR';
  static const String hostQr = 'Host QR';
  static const String groupMeditation = 'Group meditation';
  static const String demoHostName = 'Ankit Maheswari';
  static const String demoLocation = 'Bahawalpur, Pun Pakistan';
}
