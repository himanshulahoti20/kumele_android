// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get cancel => 'إلغاء';

  @override
  String get ok => 'حسنا';

  @override
  String get save => 'حفظ';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get submit => 'إرسال';

  @override
  String get close => 'إغلاق';

  @override
  String get confirm => 'تأكيد';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get done => 'تم';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get selfCheck => 'فحص ذاتي';

  @override
  String get success => 'نجاح';

  @override
  String get error => 'خطأ';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get somethingWentWrong => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get comment => 'تعليق';

  @override
  String get addYourComment => 'أضف تعليقك...';

  @override
  String get publishComment => 'نشر التعليق';

  @override
  String get posted => 'تم النشر!';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'يرجى إدخال عنوان بريد إلكتروني صالح';

  @override
  String get noResults => 'لم يتم العثور على نتائج';

  @override
  String get noData => 'لا توجد بيانات متاحة';

  @override
  String get noChats => 'لا توجد دردشات';

  @override
  String get noChatsDescription =>
      'ليس لديك أي دردشات في الوقت الحالي. ابدأ محادثة أو عد لاحقًا.';

  @override
  String get noGuests => 'لا يوجد ضيوف';

  @override
  String get noGuestsDescription =>
      'لا يوجد ضيوف مسجلين أو قاموا بتسجيل الدخول لهذا الحدث حتى الآن.';

  @override
  String get chat => 'دردشة';

  @override
  String get spirituality => 'روحانية';

  @override
  String get hostedBy => 'باستضافة';

  @override
  String get rateEvent => 'تقييم الحدث';

  @override
  String get reportEvent => 'الإبلاغ عن الحدث';

  @override
  String get guestScan => 'مسح الضيف';

  @override
  String get scanQrCode => 'مسح رمز الاستجابة السريعة';

  @override
  String get alignQrInFrame =>
      'قم بمحاذاة رمز الاستجابة السريعة للضيف داخل الإطار';

  @override
  String get guestNotFound => 'الضيف غير موجود في هذا الحدث';

  @override
  String get invalidQrCode => 'رمز استجابة سريعة غير صالح';

  @override
  String get confirmCheckIn => 'تأكيد الحضور';

  @override
  String get confirmGuestCheckInDescription => 'تأكيد حضور هذا الضيف للحدث؟';

  @override
  String checkedInSuccess(String name) {
    return 'تم تسجيل حضور $name بنجاح!';
  }

  @override
  String get checkedInLabel => 'تم تسجيل الحضور';

  @override
  String get notCheckedInLabel => 'لم يتم تسجيل الحضور';

  @override
  String get confirmedLabel => 'مؤكد';

  @override
  String get followHost => 'متابعة المضيف';

  @override
  String get daysLeftToRate => 'بقي -- أيام للتقييم \nوالمراجعة';

  @override
  String get scannedList => 'القائمة الممسوحة ضوئيًا: --';

  @override
  String get eventCanceled => 'تم إلغاء الحدث';

  @override
  String get noMessages => 'لا توجد رسائل';

  @override
  String get noMessagesDescription => 'لا توجد رسائل هنا حتى الآن.';

  @override
  String get joinChatFailed => 'فشل الانضمام إلى غرفة الدردشة';

  @override
  String get joinChatSuccess => 'تم الانضمام إلى غرفة الدردشة بنجاح';

  @override
  String get loadMessagesFailed => 'فشل تحميل رسائل الدردشة';

  @override
  String get sendMessageFailed => 'فشل إرسال الرسالة';

  @override
  String get chatNotAvailable => 'الدردشة غير متاحة';

  @override
  String get chatAccessDenied => 'ليس لديك صلاحية الوصول إلى هذه الدردشة';

  @override
  String get chatClosed => 'هذه الدردشة مغلقة';

  @override
  String get typeAMessage => 'اكتب رسالة';

  @override
  String get reply => 'رد';

  @override
  String get unknownUser => 'غير معروف';

  @override
  String get activeEvent => 'حدث نشط';

  @override
  String get active => 'نشط';

  @override
  String get eventChat => 'دردشة الحدث';

  @override
  String get guests => 'الضيوف';

  @override
  String get guest => 'ضيف';

  @override
  String get priceLabel => 'السعر';

  @override
  String get eventAddressLabel => 'عنوان الحدث';

  @override
  String get cashOnEntry => 'الدفع نقدًا عند الدخول';

  @override
  String get free => 'مجاني';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get myEvents => 'أحداثي';

  @override
  String get createdEvents => 'الأحداث التي أنشأتها';

  @override
  String get joinedEvents => 'الأحداث المنضم إليها';

  @override
  String get noEventsCreatedYet => 'لم تقم بإنشاء أي أحداث حتى الآن.';

  @override
  String get noEventsJoinedYet => 'لم تنضم إلى أي أحداث حتى الآن.';

  @override
  String get blogsTitle => 'المدونات';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get interestedHobbies => 'الهوايات المثيرة للاهتمام';

  @override
  String get editHobbies => 'تعديل الهوايات';

  @override
  String get showMore => 'عرض المزيد';

  @override
  String get showLess => 'عرض أقل';

  @override
  String get myQrCode => 'رمز الاستجابة السريعة (QR) الخاص بي';

  @override
  String get following => 'أتابع';

  @override
  String get followers => 'المتابعون';

  @override
  String get goldStatus => 'الحالة الذهبية';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get languages => 'اللغات';

  @override
  String get languagesLoadFailed => 'فشل تحميل اللغات.';

  @override
  String get connectionsLoadFailed => 'فشل تحميل المتابعين وجهات الاتصال.';

  @override
  String get cardPaymentsSubscriptions =>
      'المدفوعات بالبطاقة، الاشتراكات والضمان';

  @override
  String get security => 'الأمان';

  @override
  String get contact => 'اتصل بنا';

  @override
  String get contactPageSubtitle => 'أخبرنا كيف يمكننا المساعدة.';

  @override
  String get contactSubjectLabel => 'الموضوع';

  @override
  String get contactSubjectHint => 'ملخص موجز لمشكلتك';

  @override
  String get contactDescriptionLabel => 'الوصف';

  @override
  String get contactDescriptionHint => 'صف مشكلتك بالتفصيل';

  @override
  String get contactCategoryLabel => 'الفئة';

  @override
  String get contactPriorityLabel => 'الأولوية';

  @override
  String get contactAttachmentLabel => 'المرفقات (اختياري)';

  @override
  String get contactAttachmentHint => 'تحميل لقطة شاشة';

  @override
  String get contactSubmitLabel => 'إرسال';

  @override
  String get contactSuccessMessage => 'تم إرسال رسالتك.';

  @override
  String get contactSubmitFailed =>
      'فشل إرسال الرسالة. يرجى المحاولة مرة أخرى.';

  @override
  String get contactDescriptionTooShort =>
      'يرجى إدخال 20 حرفًا على الأقل حتى يتمكن الدعم من المساعدة بشكل صحيح.';

  @override
  String get contactSubjectRequired => 'يرجى إدخال موضوع.';

  @override
  String get contactDescriptionRequired => 'يرجى إدخال وصف.';

  @override
  String get contactAttachmentPickFailed => 'فشل اختيار الصورة.';

  @override
  String get guidelines => 'الإرشادات';

  @override
  String get referAFriend => 'دعوة صديق';

  @override
  String get referralCodeUnavailable =>
      'رمز الدعوة الخاص بك غير متوفر الآن. يرجى المحاولة لاحقًا.';

  @override
  String get referralShareSubject => 'انضم إلي على Kumele';

  @override
  String referralShareMessage(String referralCode, String referralLink) {
    return 'انضم إلي على Kumele — تعرف على أصدقاء محليين يشاركونك نفس الاهتمامات!\n\nاستخدم رمز الدعوة الخاص بي: $referralCode\n\nسجل هنا: $referralLink';
  }

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get nightMode => 'الوضع الليلي';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get deleteAccountConfirmTitle =>
      'هل أنت متأكد؟ لا يمكن\n التراجع عن هذا الإجراء. يرجى إعادة إدخال \nكلمة المرور.';

  @override
  String get deleteAccountPasswordHint => 'أدخل كلمة المرور الحالية';

  @override
  String get deleteAccountPageSubtitle =>
      'هذا الإجراء دائم. أدخل كلمة المرور الخاصة بك وأخبرنا بسبب مغادرتك.';

  @override
  String get deleteAccountPasswordLabel => 'كلمة المرور';

  @override
  String get deleteAccountReasonLabel => 'السبب';

  @override
  String get deleteAccountReasonHint => 'أخبرنا لماذا تغادر';

  @override
  String get deleteAccountConfirmationLabel =>
      'أفهم أن هذا الإجراء دائم ولا يمكن التراجع عنه';

  @override
  String get deleteAccountSubmitLabel => 'حذف الحساب';

  @override
  String get deleteAccountSuccessMessage => 'تم حذف الحساب بنجاح.';

  @override
  String get deleteAccountSubmitFailed =>
      'فشل حذف الحساب. يرجى المحاولة مرة أخرى.';

  @override
  String get deleteAccountPasswordRequired =>
      'يرجى إدخال كلمة المرور الخاصة بك.';

  @override
  String get deleteAccountReasonRequired => 'يرجى إخبارنا بسبب مغادرتك.';

  @override
  String get deleteAccountConfirmationRequired =>
      'يرجى التأكيد على أنك تفهم أن هذا الإجراء دائم.';

  @override
  String get signOutConfirmTitle => 'هل أنت متأكد أنك تريد\n تسجيل الخروج؟';

  @override
  String get signOutSuccessMessage => 'تم تسجيل الخروج بنجاح.';

  @override
  String get forgotPasswordPageTitle => 'نسيت كلمة المرور';

  @override
  String get forgotPasswordSubtitle =>
      'أدخل عنوان بريدك الإلكتروني وسنرسل لك رمز إعادة التعيين.';

  @override
  String get forgotPasswordEmailLabel => 'البريد الإلكتروني';

  @override
  String get forgotPasswordHint => 'أدخل البريد الإلكتروني';

  @override
  String get forgotPasswordSubmitLabel => 'إرسال بريد إعادة التعيين';

  @override
  String get forgotPasswordSuccessMessage =>
      'إذا كان البريد الإلكتروني مسجلاً لدينا، فسيتم إرسال رابط إعادة التعيين.';

  @override
  String get resetPasswordPageTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordSubtitle =>
      'أدخل الرمز المرسل إلى بريدك الإلكتروني واختر كلمة مرور جديدة.';

  @override
  String get resetPasswordTokenLabel => 'رمز التحقق';

  @override
  String get resetPasswordTokenHint => 'أدخل الرمز';

  @override
  String get resetPasswordNewPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get resetPasswordNewPasswordHint => 'أدخل كلمة المرور الجديدة';

  @override
  String get resetPasswordConfirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get resetPasswordConfirmPasswordHint =>
      'أعد إدخال كلمة المرور الجديدة';

  @override
  String get resetPasswordSubmitLabel => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordSuccessMessage => 'تم إعادة تعيين كلمة المرور بنجاح';

  @override
  String get passwordMinLengthError =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get passwordsDoNotMatchError => 'كلمات المرور غير متطابقة';

  @override
  String get emailVerificationPageTitle => 'التحقق من بريدك الإلكتروني';

  @override
  String get emailVerificationSubtitle =>
      'لقد أرسلنا رمز تحقق مكون من 6 أرقام إلى بريدك الإلكتروني. أدخله أدناه للمتابعة.';

  @override
  String get emailVerificationVerifyLabel => 'التحقق من البريد الإلكتروني';

  @override
  String get emailVerificationResendLabel => 'إعادة إرسال الرمز';

  @override
  String get emailVerificationResendInLabel => 'إعادة إرسال الرمز في';

  @override
  String get emailVerificationSentMessage =>
      'تم إرسال رمز التحقق إلى بريدك الإلكتروني.';

  @override
  String get emailVerificationFailedMessage =>
      'رمز التحقق غير صالح. يرجى المحاولة مرة أخرى.';

  @override
  String get emailVerificationSendFailedMessage =>
      'فشل إرسال رمز التحقق. يرجى المحاولة مرة أخرى.';

  @override
  String get emailVerificationSuccessMessage =>
      'تم التحقق من البريد الإلكتروني بنجاح!';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get changePasswordCurrentLabel => 'كلمة المرور الحالية';

  @override
  String get changePasswordCurrentHint => 'أدخل كلمة المرور الحالية';

  @override
  String get changePasswordNewLabel => 'كلمة المرور الجديدة';

  @override
  String get changePasswordNewHint => 'أدخل كلمة المرور الجديدة';

  @override
  String get changePasswordConfirmLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get changePasswordConfirmHint => 'أعد إدخال كلمة المرور الجديدة';

  @override
  String get changePasswordSubmitLabel => 'تحديث كلمة المرور';

  @override
  String get changePasswordSuccessMessage =>
      'تم تحديث كلمة المرور بنجاح. يرجى تسجيل الدخول باستخدام كلمة المرور الجديدة الخاصة بك.';

  @override
  String get changePasswordSubmitFailed =>
      'فشل تحديث كلمة المرور. يرجى المحاولة مرة أخرى.';

  @override
  String get changePasswordCurrentRequired =>
      'يرجى إدخال كلمة المرور الحالية الخاصة بك.';

  @override
  String get registerPasskey => 'تسجيل مفتاح المرور';

  @override
  String get twoFactorAuth => 'المصادقة الثنائية (2FA)';

  @override
  String get twoFactorSetupTitle => 'إعداد تطبيق المصادقة';

  @override
  String get twoFactorSetupStep1 => '1. افتح تطبيق مصادقة على جهازك المحمول';

  @override
  String get twoFactorSetupStep1Hint =>
      'إذا لم يكن لديك واحد، فقم بتنزيل وتثبيت أحد التطبيقات الموصى بها:';

  @override
  String get twoFactorSetupStep2Lead =>
      '2. امسح هذا الرمز الشريطي ضوئيًا باستخدام ';

  @override
  String get twoFactorSetupStep2Bold => 'تطبيق المصادقة';

  @override
  String get twoFactorSetupCantScan =>
      'لا يمكنك المسح الضوئي؟ استخدم هذا الرمز بدلاً من ذلك';

  @override
  String get twoFactorSetupStep3Lead => '3. أدخل الرمز المكون من ستة أرقام من ';

  @override
  String get twoFactorSetupStep3Bold => 'تطبيق المصادقة';

  @override
  String get twoFactorVerificationHint => 'أدخل رمز التحقق هنا';

  @override
  String get twoFactorSetupLoadFailed =>
      'فشل تحميل إعداد المصادقة الثنائية. يرجى المحاولة مرة أخرى.';

  @override
  String get twoFactorEnableFailed =>
      'فشل تمكين المصادقة الثنائية. يرجى التحقق من الرمز الخاص بك والمحاولة مرة أخرى.';

  @override
  String get twoFactorEnableSuccess => 'تم تمكين المصادقة الثنائية بنجاح.';

  @override
  String get twoFactorManualCodeCopied => 'تم نسخ رمز الإعداد إلى الحافظة';

  @override
  String get setup => 'إعداد';

  @override
  String get twoFactorDisableTitle => 'تعطيل المصادقة الثنائية';

  @override
  String get twoFactorDisableSubtitle =>
      'هل أنت متأكد من أنك تريد إيقاف تشغيل المصادقة الثنائية؟';

  @override
  String get twoFactorDisableDescription =>
      'ستتم حماية حسابك بواسطة كلمة المرور الخاصة بك فقط. نوصي بالاحتفاظ بتمكين المصادقة الثنائية للحصول على أمان أفضل.';

  @override
  String get twoFactorDisableConfirm => 'تعطيل المصادقة الثنائية';

  @override
  String get twoFactorDisableCodeLead => 'أدخل الرمز المكون من ستة أرقام من ';

  @override
  String get twoFactorDisableSuccess => 'تم تعطيل المصادقة الثنائية بنجاح.';

  @override
  String get twoFactorDisableFailed =>
      'فشل تعطيل المصادقة الثنائية. يرجى التحقق من الرمز الخاص بك والمحاولة مرة أخرى.';

  @override
  String get twoFactorLoginTitle => 'المصادقة الثنائية';

  @override
  String get twoFactorLoginSubtitle =>
      'أدخل الرمز من تطبيق المصادقة الخاص بك للمتابعة';

  @override
  String get twoFactorLoginDescription => 'حسابك محمي بالمصادقة الثنائية.';

  @override
  String get twoFactorLoginCodeLead => 'أدخل الرمز المكون من ستة أرقام من ';

  @override
  String get twoFactorLoginCodeBold => 'تطبيق المصادقة';

  @override
  String get twoFactorLoginVerify => 'تحقق';

  @override
  String get twoFactorLoginFailed =>
      'رمز التحقق غير صالح. يرجى المحاولة مرة أخرى.';

  @override
  String get passkeyRegisterSuccess => 'تم تسجيل مفتاح المرور بنجاح';

  @override
  String get onboardingPageTitle => 'إعداد ملفك الشخصي';

  @override
  String get onboardingPageSubtitle => 'أضف صورة وأخبر المجتمع عن نفسك.';

  @override
  String get onboardingAvatarHint => 'انقر لإضافة صورة';

  @override
  String get onboardingImagePickerTitle => 'إضافة صورة ملف شخصي';

  @override
  String get onboardingImagePickerSubtitle =>
      'اختر المعرض أو الكاميرا للحصول على صورة ملفك الشخصي';

  @override
  String get gallery => 'المعرض';

  @override
  String get camera => 'الكاميرا';

  @override
  String get onboardingUsernameLabel => 'اسم المستخدم';

  @override
  String get onboardingUsernameHint => 'اختر اسم مستخدم (اختياري)';

  @override
  String get onboardingUsernameHelper =>
      'لا يمكن تغيير أسماء المستخدمين إلا كل 3 أشهر';

  @override
  String get onboardingUsernameChecking => 'جاري التحقق من اسم المستخدم...';

  @override
  String get onboardingUsernameAvailable => 'اسم المستخدم متاح';

  @override
  String get onboardingUsernameTaken => 'اسم المستخدم مستخدم بالفعل';

  @override
  String get onboardingPhoneLabel => 'رقم الهاتف';

  @override
  String get onboardingPhoneHint => 'أدخل رقم هاتفك (اختياري)';

  @override
  String get onboardingAboutLabel => 'نبذة عني';

  @override
  String get onboardingAboutHint =>
      'أخبرنا عن اهتماماتك وهواياتك وما تستمتع بفعله';

  @override
  String get onboardingSuccessMessage => 'تم حفظ الملف الشخصي بنجاح.';

  @override
  String get onboardingImageRequired => 'يرجى إضافة صورة للملف الشخصي.';

  @override
  String get onboardingPhoneRequired => 'يرجى إدخال رقم هاتفك.';

  @override
  String get onboardingPhoneInvalid => 'يرجى إدخال رقم هاتف صالح.';

  @override
  String get onboardingAboutTooShort =>
      'يجب أن تكون النبذة عني 200 حرف على الأقل.';

  @override
  String get onboardingAboutTooLong => 'لا يمكن أن تتجاوز النبذة عني 500 حرف.';

  @override
  String get onboardingImagePlatformUnsupported =>
      'رفع الصور متاح فقط على أجهزة Android.';

  @override
  String get onboardingImagePickFailed => 'فشل اختيار الصورة.';

  @override
  String get onboardingSubmitFailed =>
      'فشل حفظ الملف الشخصي. يرجى المحاولة مرة أخرى.';

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get editProfileFirstNameLabel => 'الاسم الأول';

  @override
  String get editProfileFirstNameHint => 'أدخل اسمك الأول';

  @override
  String get editProfileLastNameLabel => 'اسم العائلة';

  @override
  String get editProfileLastNameHint => 'أدخل اسم العائلة';

  @override
  String get editProfileAboutLabel => 'نبذة عني';

  @override
  String get editProfileAboutHint =>
      'أخبرنا عن اهتماماتك وهواياتك وما تستمتع بفعله';

  @override
  String get editProfilePhoneLabel => 'رقم الهاتف';

  @override
  String get editProfilePhoneHint => 'أدخل رقم هاتفك';

  @override
  String get editProfileUpdateLabel => 'تحديث';

  @override
  String get editProfileSuccessMessage => 'تم تحديث الملف الشخصي بنجاح.';

  @override
  String get editProfileSubmitFailed =>
      'فشل تحديث الملف الشخصي. يرجى المحاولة مرة أخرى.';

  @override
  String get editProfileFirstNameRequired => 'يرجى إدخال اسمك الأول.';

  @override
  String get editProfileAboutTooLong => 'لا يمكن أن تتجاوز النبذة عني 500 حرف.';

  @override
  String get editProfilePhoneInvalid => 'يرجى إدخال رقم هاتف صالح.';

  @override
  String get editProfileUserMissing =>
      'تعذر تحديث الملف الشخصي. المستخدم غير موجود.';

  @override
  String get pickEventLocation => 'اختيار موقع الحدث';

  @override
  String get selectedLocation => 'الموقع المحدد';

  @override
  String get fetchingAddress => 'جاري جلب العنوان…';

  @override
  String get moveMapToPickLocation => 'حرك الخريطة لاختيار الموقع';

  @override
  String get confirmLocation => 'تأكيد الموقع';

  @override
  String get searching => 'جاري البحث…';

  @override
  String get unknownLocation => 'موقع غير معروف';

  @override
  String get couldNotFetchAddress => 'تعذر جلب العنوان';

  @override
  String get locationServicesDisabled => 'خدمات الموقع معطلة.';

  @override
  String get locationPermissionDenied => 'تم رفض إذن الوصول إلى الموقع.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'تم رفض إذن الوصول إلى الموقع بشكل دائم.';

  @override
  String get pickEventLocationPlaceholder => 'اختر موقع الحدث';

  @override
  String get tapToOpenMapPlaceholder => 'اضغط لفتح الخريطة وإسقاط دبوس';

  @override
  String get limitedInvites => 'دعوات محدودة';

  @override
  String get howItWorks => 'كيف تعمل:';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get inviteFriendsAndFamily => 'قم بدعوة أصدقائك وعائلتك';

  @override
  String get eventCodeCopied => 'تم نسخ رمز الحدث إلى الحافظة!';

  @override
  String get copyTo => 'نسخ إلى';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get eventIdLabel => 'معرف الحدث: ';

  @override
  String get locationLabel => 'الموقع: ';

  @override
  String get scanQr => 'مسح QR';

  @override
  String get hostQr => 'QR المضيف';

  @override
  String get groupMeditation => 'تأمل جماعي';

  @override
  String get demoHostName => 'أنكيت ماهيشواري';

  @override
  String get demoLocation => 'بهاوالبور، البنجاب باكستان';

  @override
  String get signIn => 'تسجيل الدخول';

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
  String get signInLanguageChoiceLabel => 'Language choice:';

  @override
  String get signInFillFieldsError => 'Please fill all required fields';

  @override
  String get signInCaptchaRequiredError => 'Please confirm you are not a robot';

  @override
  String get signInSuccessMessage => 'Signed in successfully';

  @override
  String get signInWithGoogleLabel => 'Sign in with Google';

  @override
  String get alreadyHaveAccount => 'هل لديك حساب بالفعل؟ ';

  @override
  String get signupFirstNameLabel => 'الاسم الأول';

  @override
  String get signupFirstNameHint => 'أدخل الاسم الأول';

  @override
  String get signupLastNameLabel => 'اسم العائلة';

  @override
  String get signupLastNameHint => 'أدخل اسم العائلة';

  @override
  String get signupEmailHint => 'أدخل البريد الإلكتروني';

  @override
  String get signupPasswordHint => 'أدخل كلمة المرور';

  @override
  String get signupConfirmPasswordHint => 'تأكيد كلمة المرور';

  @override
  String get signupReferralCodeLabel => 'رمز الدعوة';

  @override
  String get signupBetaCodeLabel => 'رمز الإصدار التجريبي';

  @override
  String get signupCodeHint => ' مثال: DF4R435';

  @override
  String get passkeySignInTitle => 'تسجيل الدخول باستخدام مفتاح مرور Kumele';

  @override
  String get earnMedals => 'كسب الميداليات';

  @override
  String get bronzeStatus => 'الحالة البرونزية';

  @override
  String get silverStatus => 'الحالة الفضية';

  @override
  String get goldStatusMedal => 'الحالة الذهبية';

  @override
  String get bronzeStatusDescription =>
      'قام المستخدم بإنشاء ما لا يقل عن حدثين أو حضر ما لا يقل عن حدثين دون انقطاع في \nآخر 30 يومًا. يحصل المستخدم على خصم 2% على عملية شراء واحدة من اختياره داخل التطبيق.';

  @override
  String get silverStatusDescription =>
      'قام المستخدم بإنشاء ما لا يقل عن 3 أحداث أو حضر ما لا يقل عن 3 أحداث دون انقطاع في\n آخر 30 يومًا. يحصل المستخدم على خصم 4% على عملية شراء واحدة من اختياره داخل التطبيق.';

  @override
  String get goldStatusMedalDescription =>
      'قام المستخدم بإنشاء ما لا يقل عن 4 أحداث أو حضر ما لا يقل عن 4 أحداث دون انقطاع في \nآخر 30 يومًا. يحصل المستخدم على خصم 8% على عملية شراء واحدة من اختياره داخل التطبيق.';

  @override
  String get filterTitle => 'تصفية';

  @override
  String get currentLocation => 'الموقع الحالي';

  @override
  String get change => 'تغيير';

  @override
  String get distanceRangeLabel => 'نطاق المسافة (بالكيلومترات)';

  @override
  String get ageRangeLabel => 'نطاق العمر';

  @override
  String get paidEvent => 'حدث مدفوع';

  @override
  String get stateHint => 'الولاية/المقاطعة';

  @override
  String get postalZipCodeHint => 'الرمز البريدي';

  @override
  String get countryHint => 'البلد';

  @override
  String get openPhantomWallet => 'فتح محفظة فانتوم';

  @override
  String get nftDescriptionLabel => 'الوصف';

  @override
  String get nftDetailsLabel => 'تفاصيل NFT';

  @override
  String get guestCountValidForEventOnly => 'عدد الضيوف صالح لهذا الحدث فقط';

  @override
  String get tokenIdLabel => 'معرف الرمز (Token ID)';

  @override
  String get tokenStandardLabel => 'معيار الرمز';

  @override
  String get blockchainLabel => 'البلوكتشين';

  @override
  String get creatorLabel => 'المنشئ';

  @override
  String get addCommentsHint => 'إضافة تعليقات';

  @override
  String get reportEventPageTitle => 'الإبلاغ عن الحدث';

  @override
  String get ratingPageTitle => 'التقييم';

  @override
  String get send => 'إرسال';

  @override
  String get blogLikePostSemanticLabel => 'إعجاب بالمنشور';

  @override
  String get blogLikesLabel => 'الإعجابات';

  @override
  String get blogShareLabel => 'مشاركة';

  @override
  String get replyDialogTitlePrefix => 'الرد على';

  @override
  String get replyDialogHint => 'اكتب ردك...';

  @override
  String get blogEmptyStateTitle => 'لم يتم العثور على مدونات';

  @override
  String get blogEmptyStateDescription => 'جرب عامل تصفية فئة مختلف.';

  @override
  String get blogCategoryAll => 'الكل';

  @override
  String get blogCategoryFood => 'طعام';

  @override
  String get blogCategoryTravel => 'سفر';

  @override
  String get blogCategorySports => 'رياضة';

  @override
  String get blogCategoryMusic => 'موسيقى';

  @override
  String get blogPlaceholderTitle =>
      'عنوان عنصر نائب لتأثير تحميل منشور المدونة';

  @override
  String get blogPlaceholderExcerpt => 'مقتطف عنصر نائب للتحميل الهيكلي.';

  @override
  String get blogPlaceholderAuthorName => 'جاري تحميل المؤلف';

  @override
  String get blogPlaceholderCategoryName => 'الفئة';

  @override
  String get blogPostShareSampleTitle =>
      'Singleton of Glen Ord بعمر 38 عامًا ومجموعة Singleton.';

  @override
  String get blogPostShareCategoryLabel => 'روحانية';

  @override
  String get blogPostShareAuthorLabel => ' المؤلف:';

  @override
  String get blogPostSharePublishDateLabel => ' تاريخ النشر:';

  @override
  String get blogPostShareHowItWorksTitle => 'كيف تعمل';

  @override
  String get blogPostShareStep1 => '1. تحقق من الرابط لفتح المدونة';

  @override
  String get blogPostShareStep2 =>
      '2. أو ابحث عن المدونة عند تسجيل الدخول للإعجاب بها';

  @override
  String get blogPostShareInviteTitle => 'قم بدعوة أصدقائك \n وعائلتك';

  @override
  String get blogPostCommentsTitle => 'التعليقات';

  @override
  String get blogPostPreviousLabel => 'السابق';

  @override
  String get blogRepliesCountLabel => 'الردود';

  @override
  String get blogReplyPlaceholderText => 'استعد لأمسية مليئة بالضحك';

  @override
  String get blogSearchHint => 'بحث';

  @override
  String get createEventNameLabel => 'اسم الحدث';

  @override
  String get createEventTitleHint => 'أضف عنواناً';

  @override
  String get createEventSubtitleLabel => 'العنوان الفرعي';

  @override
  String get createEventSubtitleHint => 'أضف عنواناً فرعياً';

  @override
  String get createEventDescriptionMaxLabel => 'الحد الأقصى';

  @override
  String get createEventDescriptionLabel => 'الوصف';

  @override
  String get createEventDescriptionHint => 'المزيد عن الحدث';

  @override
  String get createEventDateLabel => 'التاريخ';

  @override
  String get createEventStartTimeLabel => 'وقت بدء الحدث';

  @override
  String get createEventStartTimePlaceholder => 'وقت البدء';

  @override
  String get createEventEndTimeLabel => 'وقت انتهاء الحدث';

  @override
  String get createEventEndTimePlaceholder => 'وقت الانتهاء';

  @override
  String get createEventCheckAvailabilityLabel => 'التحقق من توفر المستخدم';

  @override
  String get createEventAvailabilityDisclaimer =>
      'لاستخدام هذا، يرجى إضافة عنوانك وعدد الضيوف. تنبيه: لا يمكننا ضمان تطابقات 100٪ بسبب عوامل معينة خارجة عن سيطرتنا.';

  @override
  String get createEventStartsInLabel => 'يبدأ الحدث في';

  @override
  String get createEventDecreaseTimeSemanticLabel => 'تقليل الوقت';

  @override
  String get createEventIncreaseTimeSemanticLabel => 'زيادة الوقت';

  @override
  String get createEventStreetLabel => 'الشارع';

  @override
  String get createEventStreetHint => 'أدخل الشارع';

  @override
  String get createEventHomeNumberLabel => 'رقم المنزل';

  @override
  String get createEventHomeNumberHint => 'أدخل رقم المنزل';

  @override
  String get createEventDistrictLabel => 'المنطقة';

  @override
  String get createEventDistrictHint => 'أدخل المنطقة';

  @override
  String get createEventPostalCodeLabel => 'الرمز البريدي';

  @override
  String get createEventPostalCodeHint => 'أدخل الرمز البريدي';

  @override
  String get createEventStateLabel => 'الولاية';

  @override
  String get createEventStateHint => 'أدخل الولاية';

  @override
  String get createEventUploadImageTitle => 'رفع صورة';

  @override
  String get createEventUploadImageSubtitle =>
      'اختر مصدراً لصورة الحدث الخاصة بك';

  @override
  String get createEventCategoryPlaceholder => 'الفئة';

  @override
  String get createEventCategoryLabel => 'فئة الحدث';

  @override
  String get createEventImageLabel => 'صورة الحدث';

  @override
  String get createEventImageSizeHint => '(الحجم الموصى به 400 × 400 بكسل)';

  @override
  String get createEventStripeConnectedLabel => 'تم ربط Stripe';

  @override
  String get createEventPreviewSubmitLabel => 'إنشاء حدث';

  @override
  String get createEventPreviewGuestsSuffix => 'ضيوف';

  @override
  String get createEventPreviewAlreadyStarted => 'لقد بدأ الحدث بالفعل';

  @override
  String createEventPreviewStartsInDays(Object days) {
    return 'يبدأ خلال $days أيام';
  }

  @override
  String get createEventPreviewStartsTomorrow => 'يبدأ غداً';

  @override
  String createEventPreviewStartsInHour(Object hours) {
    return 'يبدأ خلال $hours ساعة';
  }

  @override
  String createEventPreviewStartsInHours(Object hours) {
    return 'يبدأ خلال $hours ساعات';
  }

  @override
  String createEventPreviewStartsInMinute(Object minutes) {
    return 'يبدأ خلال $minutes دقيقة';
  }

  @override
  String createEventPreviewStartsInMinutes(Object minutes) {
    return 'يبدأ خلال $minutes دقائق';
  }

  @override
  String get createEventPreviewStartingNow => 'يبدأ الآن';

  @override
  String get createEventPreviewDefaultCategory => 'الروحانية';

  @override
  String get createEventPreviewDefaultHostName => 'أنا';

  @override
  String createEventPreviewExpectedLabel(Object label) {
    return 'متوقع $label';
  }

  @override
  String createEventPreviewPricingLabel(Object label) {
    return 'التسعير $label';
  }

  @override
  String get discoverNoMatchesMessage =>
      'لا توجد تطابقات أخرى حالياً، حتى ذلك الحين';

  @override
  String get discoverGuestsSuffix => 'ضيوف';

  @override
  String get discoverGoToChatLabel => 'Go to chat';

  @override
  String get discoverLocationLabel => 'الموقع:';

  @override
  String get discoverMockLocationLabel => 'إندور، مادهيا براديش، الهند';

  @override
  String get discoverStartsInLabel => 'يبدأ في';

  @override
  String get discoverHoursSuffix => 'ساعات';

  @override
  String get discoverShareLabel => 'مشاركة';

  @override
  String get discoverMockEventTitle =>
      '🌟 دعوة لتجربة يوجا تحويلية: لقاء صحوة الكونداليني';

  @override
  String get discoverMockEventDescription =>
      'انطلق في رحلة عميقة لاكتشاف الذات والتحول الداخلي مع حدثنا الحصري ليوجا صحوة الكونداليني! ندعوك للانضمام إلى لقاء متناغم حيث سيجتمع عشرة أفراد لاستكشاف ممارسة الكونداليني القديمة.';

  @override
  String get discoverHostLabel => 'المضيف';

  @override
  String get discoverHostMedalGoldLabel => 'ذهبي';

  @override
  String get discoverMockAboutHostLabel => 'عن ألكيش:';

  @override
  String get discoverMockAboutHostText =>
      'عبقرية هندسية بشغف للإيقاعات والهدوء';

  @override
  String get discoverMockHostBio =>
      'مرحباً بك في عالمي من الابتكار والإيقاع! أنا ألكيش، مهندس بالمهنة ومتذوق للتجارب الانتقائية في الحياة.';

  @override
  String get discoverFollowersSuffix => ' متابع';

  @override
  String get discoverOverallRatingsSuffix => 'التقييمات الإجمالية';

  @override
  String get discoverMockCategoryLabel => 'هيب هوب التسعينات';

  @override
  String get discoverMockPartyTypeLabel => 'حفلة منزلية';

  @override
  String get discoverMockRatingSummaryLabel => '3.6 من 5';

  @override
  String get discoverMockGuestRatingsLabel => '6 تقييمات للضيوف';

  @override
  String get discoverMockReviewerName => 'جاكوب هوفمان';

  @override
  String get discoverMockReviewDate => '⬤ 23 أغسطس 2023';

  @override
  String get discoverMockReviewText => 'يا له من عرض رائع!';

  @override
  String get discoverMockOtherEventsLabel => 'أحداث أخرى من ألكيش';

  @override
  String get exploreSwipeCardToday => 'اليوم';

  @override
  String get exploreSearchHint => 'Search Hobby Events';

  @override
  String get exploreSwipeCardStartInPrefix => 'يبدأ في';

  @override
  String get exploreSwipeCardHostLabel => 'المضيف';

  @override
  String get exploreSwipeCardFollowersSuffix => 'متابع';

  @override
  String get exploreSwipeCardOverallRatingsLabel => 'التقييمات الإجمالية';

  @override
  String get exploreCategoryVanLife => 'حياة الشاحنات';

  @override
  String get exploreCategoryPetLove => 'حب الحيوانات الأليفة';

  @override
  String get exploreCategorySpirituality => 'الروحانية';

  @override
  String get exploreCategoryBoardGames => 'ألعاب الطاولة';

  @override
  String get exploreDiscountDeclineMessage => 'رفض';

  @override
  String get openLabel => 'فتح';

  @override
  String get exploreDiscountNoOfferTitle => 'لا يوجد عرض متاح';

  @override
  String get exploreDiscountCheckBackLaterMessage => 'يرجى العودة لاحقاً.';

  @override
  String get exploreDiscountNoAdDetailsMessage =>
      'لم يتم تقديم تفاصيل الإعلان.';

  @override
  String get exploreDiscountOfferFallback => 'عرض';

  @override
  String get exploreLoadEventsFailed => 'فشل تحميل الأحداث.';

  @override
  String get exploreInterestedLabel => 'مهتم';

  @override
  String get exploreEventDetailLoadFailed => 'فشل تحميل تفاصيل الحدث.';

  @override
  String get birthdayNotificationTitle => 'عيد ميلاد سعيد!';

  @override
  String get birthdayNotificationMessage =>
      '«عيد ميلاد سعيد! أتمنى أن تتحقق جميع أمنيات وأحلام عيد ميلادك.»';

  @override
  String get birthdayNotificationSignature => 'فريق كوميلي';

  @override
  String get commentsTitle => 'التعليقات';

  @override
  String get previousLabel => 'السابق';

  @override
  String get blogCommentRepliesCount => '3 ردود';

  @override
  String get blogCommentReplayAction => 'رد';

  @override
  String get welcomeNotificationTitle => 'مرحباً بك في كوميلي';

  @override
  String get welcomeNotificationDate => '23 نوفمبر 2022';

  @override
  String get welcomeNotificationBody =>
      'مرحباً بك في كوميلي! يسعدنا انضمامك إلينا. اكتشف الأحداث القريبة منك، وتواصل مع الأشخاص ذوي الاهتمامات المشتركة، وعش لحظات لا تُنسى.';

  @override
  String get createEventButtonLabel => 'إنشاء حدث';

  @override
  String get notificationsEmptyTitle => 'لا توجد إشعارات';

  @override
  String get notificationsEmptyDescription =>
      'لا توجد لديك إشعارات جديدة حالياً. عد لاحقاً.';

  @override
  String get exploreEmptyNoMoreMatches => 'لا توجد تطابقات أخرى حالياً،';

  @override
  String get exploreEmptyUntilThen => 'حتى ذلك الحين';

  @override
  String get exploreEmptyCreateEventPromptSubtitle => 'كن رائعاً وأنشئ حدثاً';

  @override
  String get exploreEmptyReadBlogPromptSubtitle =>
      'إليك بعض المدونات التي قد تعجبك';

  @override
  String get exploreEmptyReadBlogButtonLabel => 'قراءة المدونة';

  @override
  String get exploreEmptyInviteFriendsPromptSubtitle =>
      'كن رائعاً وادعُ أصدقاءك';

  @override
  String get exploreEmptyInviteFriendsButtonLabel => 'دعوة الأصدقاء';

  @override
  String get exploreMatchedEventsSectionTitle => 'حدث متطابق';

  @override
  String get exploreCreatedEventsSectionTitle => 'حدث منشأ';

  @override
  String get exploreHostFallbackName => 'أنا';

  @override
  String get addPaypalEmailOrMobileHint => 'البريد الإلكتروني أو رقم الجوال';

  @override
  String get orDividerLabel => 'أو';

  @override
  String get eventAdsLabel => 'إعلانات الأحداث';

  @override
  String get paymentThankYouTitle => 'شكراً لك!';

  @override
  String get paymentCompleteMessage => 'تم إتمام عملية الدفع.';

  @override
  String get viewPaymentLabel => 'عرض الدفع';

  @override
  String get statusLabel => 'الحالة';

  @override
  String get completedStatusLabel => 'مكتمل';

  @override
  String get orderCodeLabel => 'رمز الطلب';

  @override
  String get dateTimeLabel => 'التاريخ والوقت';

  @override
  String get exchangeRateLabel => 'سعر الصرف';

  @override
  String get totalLabel => 'الإجمالي';

  @override
  String get paymentProcessedByLabel => 'تمت معالجة الدفع بواسطة';

  @override
  String get sendPaymentTitle => 'إرسال الدفع';

  @override
  String get sendPaymentInstructions =>
      'لإجراء الدفع، أرسل BTC إلى العنوان أدناه';

  @override
  String get payWithWalletLabel => 'الدفع بالمحفظة';

  @override
  String get amountLabel => 'المبلغ';

  @override
  String get copyLabel => 'نسخ';

  @override
  String get btcAddressLabel => 'عنوان BTC';

  @override
  String get payWithCoinbaseLabel => 'الدفع عبر Coinbase';

  @override
  String get selectCryptocurrencyLabel => 'أو اختر عملة مشفرة';

  @override
  String get showMoreLabel => 'عرض المزيد';

  @override
  String get noSubscriptionTierAvailable => 'لا توجد درجة اشتراك متاحة بعد.';

  @override
  String get signInBeforeSubscription => 'يرجى تسجيل الدخول قبل بدء الاشتراك.';

  @override
  String get subscriptionActivatedMessage => 'تم تفعيل الاشتراك';

  @override
  String purchaseFailedMessage(Object error) {
    return 'فشل الشراء: $error';
  }

  @override
  String get subscriptionCheckoutSessionFailed =>
      'تعذر إنشاء جلسة الدفع للاشتراك.';

  @override
  String get subscribeLabel => 'اشترك';

  @override
  String get paymentCompleteShort => 'اكتمل الدفع';

  @override
  String get checkoutStartedMessage => 'بدأ الدفع';

  @override
  String get subscriptionCreatedMessage => 'تم إنشاء الاشتراك';

  @override
  String get signInToManageSubscription => 'يرجى تسجيل الدخول لإدارة الاشتراك.';

  @override
  String get unableToCancelSubscription => 'تعذر إلغاء الاشتراك حالياً.';

  @override
  String get subscriptionCancellationRequested => 'تم طلب إلغاء الاشتراك';

  @override
  String get unableToResumeSubscription => 'تعذر استئناف الاشتراك حالياً.';

  @override
  String get subscriptionResumedMessage => 'تم استئناف الاشتراك';

  @override
  String get cryptoPaymentsComingSoon =>
      'لا تزال المدفوعات بالعملات المشفرة قيد الدمج في عملية الدفع المباشرة.';

  @override
  String get paymentLabel => 'الدفع';

  @override
  String get amountToPayLabel => 'المبلغ المستحق';

  @override
  String get selectSubscriptionLabel => 'اختر اشتراكاً';

  @override
  String get monthlyLabel => 'شهري';

  @override
  String get yearlyLabel => 'سنوي';

  @override
  String tierPlanBillingSummary(Object cycle, Object tierName) {
    return 'خطة $tierName • فواتير $cycle';
  }

  @override
  String get subscriptionPlansTitle => 'خطط الاشتراك';

  @override
  String get noSubscriptionTiersAvailable =>
      'لا توجد درجات اشتراك متاحة حالياً.';

  @override
  String get popularBadgeLabel => 'شائع';

  @override
  String get priceUnavailableLabel => 'السعر غير متاح';

  @override
  String get currentSubscriptionTitle => 'الاشتراك الحالي';

  @override
  String get signInCheckSubscriptionStatus =>
      'سجل الدخول للتحقق من حالة اشتراكك النشط.';

  @override
  String get noActiveSubscriptionFound => 'لم يتم العثور على اشتراك نشط بعد.';

  @override
  String get planLabel => 'الخطة';

  @override
  String get unknownLabel => 'غير معروف';

  @override
  String get renewsEndsLabel => 'يتجدد / ينتهي';

  @override
  String get cancellationLabel => 'الإلغاء';

  @override
  String get scheduledForPeriodEndLabel => 'مجدول لنهاية الفترة';

  @override
  String get resumeSubscriptionLabel => 'استئناف الاشتراك';

  @override
  String get cancelAtPeriodEndLabel => 'إلغاء في نهاية الفترة';

  @override
  String get recentPaymentsTitle => 'المدفوعات الأخيرة';

  @override
  String get paymentHistoryAfterSignIn =>
      'يصبح سجل المدفوعات متاحاً بعد تسجيل الدخول.';

  @override
  String get noPaymentHistoryFound => 'لم يتم العثور على سجل مدفوعات بعد.';

  @override
  String paymentIdFallback(Object id) {
    return 'الدفع $id';
  }

  @override
  String get providerUnknownLabel => 'المزود غير معروف';

  @override
  String get refreshDetailsLabel => 'تحديث التفاصيل';

  @override
  String get cryptoPaymentOptionsLabel => 'خيارات الدفع بالعملات المشفرة';

  @override
  String get signInToSubscribeLabel => 'سجل الدخول للاشتراك';

  @override
  String get continueToCheckoutLabel => 'متابعة إلى الدفع';

  @override
  String get enterDiscountCodeHint => 'أدخل رمز الخصم';

  @override
  String get addDiscountCodeFirstMessage => 'أضف رمز خصم أولاً.';

  @override
  String get discountCodeValidatedAtCheckoutMessage =>
      'سيتم التحقق من رمز الخصم عند بدء الدفع.';

  @override
  String get applyLabel => 'تطبيق';

  @override
  String get authBannerSubscriptionMessage =>
      'يمكنك مراجعة خطط الاشتراك الآن، لكن يتعين عليك تسجيل الدخول قبل أن يعمل الدفع أو الإلغاء أو سجل المدفوعات.';

  @override
  String get actionNotAllowedTitle => 'الإجراء غير مسموح';

  @override
  String get removeCardTitle => 'إزالة البطاقة';

  @override
  String get connectEscrowAccountLabel => 'اربط حساب الضمان الخاص بك';

  @override
  String get subscriptionsTitle => 'الاشتراكات';

  @override
  String get buyNowLabel => 'اشترِ الآن';

  @override
  String get deactivateLabel => 'إلغاء التفعيل';

  @override
  String get activateLabel => 'تفعيل';

  @override
  String get confirmCardDeletionTitle => 'تأكيد حذف البطاقة';

  @override
  String get eventDetailsTitle => 'تفاصيل الحدث';

  @override
  String get eventNotFoundTitle => 'الحدث غير موجود';

  @override
  String get eventNotFoundDescription =>
      'تعذر العثور على تفاصيل الحدث المطلوب.';

  @override
  String get eventLocationLabel => 'الموقع';

  @override
  String get capacityAvailabilityLabel => 'السعة والتوفر';

  @override
  String capacityAvailabilitySummary(
      Object attendeeCount, Object capacity, Object spotsRemaining) {
    return '$attendeeCount / $capacity من الحضور ($spotsRemaining أماكن متبقية)';
  }

  @override
  String get turnOnSoundNotificationLabel => 'تشغيل إشعار الصوت';

  @override
  String get emailNotificationsLabel => 'إشعارات البريد الإلكتروني';

  @override
  String get medalBronzeTitle => 'حالة البرونزية';

  @override
  String get medalBronzeDescription =>
      'أنشأ المستخدم حداً أدنى من حدثين أو حضر حداً أدنى من حدثين دون فشل خلال آخر 30 يوماً. يحصل المستخدم على خصم 2٪ على عملية شراء واحدة داخل التطبيق من اختياره.';

  @override
  String get medalSilverTitle => 'حالة الفضية';

  @override
  String get medalSilverDescription =>
      'أنشأ المستخدم حداً أدنى من 3 أحداث أو حضر حداً أدنى من 3 أحداث دون فشل خلال آخر 30 يوماً. يحصل المستخدم على خصم 4٪ على عملية شراء واحدة داخل التطبيق من اختياره.';

  @override
  String get medalGoldTitle => 'حالة الذهبية';

  @override
  String get medalGoldDescription =>
      'أنشأ المستخدم حداً أدنى من 4 أحداث أو حضر حداً أدنى من 4 أحداث دون فشل خلال آخر 30 يوماً. يحصل المستخدم على خصم 8٪ على عملية شراء واحدة داخل التطبيق من اختياره.';

  @override
  String get connectTvLabel => 'ربط التلفزيون';

  @override
  String get tvConnectedSuccessMessage => 'تم ربط التلفزيون بنجاح.';

  @override
  String get couldNotConnectTvMessage => 'تعذر ربط هذا التلفزيون.';

  @override
  String get blogCommentAuthorYou => 'أنت';

  @override
  String get blogCommentJustNow => 'الآن فقط';

  @override
  String get discoverGoldBadgeLabel => 'ذهبي';

  @override
  String get paymentDialogTitle => 'الدفع';

  @override
  String get paymentAmountToPayLabel => 'المبلغ المستحق';

  @override
  String get paymentSelectSubscriptionLabel => 'اختر اشتراكاً';

  @override
  String get paymentPlanBulletSuffix => 'خطة •';

  @override
  String get paymentBillingSuffix => 'فوترة';

  @override
  String get paymentYearlyLabel => 'سنوي';

  @override
  String get paymentMonthlyLabel => 'شهري';

  @override
  String get paymentDiscountCodeHint => 'أدخل رمز الخصم';

  @override
  String get paymentDiscountCodeEmptyMessage => 'أضف رمز خصم أولاً.';

  @override
  String get paymentDiscountCodeValidationMessage =>
      'سيتم التحقق من رمز الخصم عند بدء الدفع.';

  @override
  String get paymentApplyLabel => 'تطبيق';

  @override
  String get paymentAuthBannerMessage =>
      'يمكنك مراجعة خطط الاشتراك الآن، لكن يتعين عليك تسجيل الدخول قبل أن يعمل الدفع أو الإلغاء أو سجل المدفوعات.';

  @override
  String get paymentSubscriptionPlansTitle => 'خطط الاشتراك';

  @override
  String get paymentNoTiersMessage => 'لا توجد درجات اشتراك متاحة حالياً.';

  @override
  String get paymentPopularBadgeLabel => 'شائع';

  @override
  String get paymentPriceUnavailableLabel => 'السعر غير متاح';

  @override
  String get paymentCurrentSubscriptionTitle => 'الاشتراك الحالي';

  @override
  String get paymentSignInToCheckStatusMessage =>
      'سجل الدخول للتحقق من حالة اشتراكك النشط.';

  @override
  String get paymentNoActiveSubscriptionMessage =>
      'لم يتم العثور على اشتراك نشط بعد.';

  @override
  String get paymentStatusLabel => 'الحالة';

  @override
  String get paymentPlanLabel => 'الخطة';

  @override
  String get paymentUnknownPlanLabel => 'غير معروف';

  @override
  String get paymentRenewsEndsLabel => 'يتجدد / ينتهي';

  @override
  String get paymentCancellationLabel => 'الإلغاء';

  @override
  String get paymentScheduledForPeriodEndLabel => 'مجدول لنهاية الفترة';

  @override
  String get paymentResumeSubscriptionLabel => 'استئناف الاشتراك';

  @override
  String get paymentCancelAtPeriodEndLabel => 'إلغاء في نهاية الفترة';

  @override
  String get paymentRecentPaymentsTitle => 'المدفوعات الأخيرة';

  @override
  String get paymentHistoryAfterSignInMessage =>
      'يصبح سجل المدفوعات متاحاً بعد تسجيل الدخول.';

  @override
  String get paymentNoHistoryMessage => 'لم يتم العثور على سجل مدفوعات بعد.';

  @override
  String paymentFallbackDescription(String id) {
    return 'الدفع $id';
  }

  @override
  String get paymentProviderUnknownLabel => 'المزود غير معروف';

  @override
  String get paymentRefreshDetailsLabel => 'تحديث التفاصيل';

  @override
  String get paymentCryptoOptionsLabel => 'خيارات الدفع بالعملات المشفرة';

  @override
  String get paymentSignInToSubscribeLabel => 'سجل الدخول للاشتراك';

  @override
  String get paymentContinueToCheckoutLabel => 'متابعة إلى الدفع';

  @override
  String get interestMovies => 'الأفلام';

  @override
  String get interestPubsAndBars => 'الحانات والبارات';

  @override
  String get interestLiveShow => 'عرض مباشر';

  @override
  String get interestClubbing => 'النوادي الليلية';

  @override
  String get interestFestival => 'المهرجانات';

  @override
  String get interestOutdoors => 'الأنشطة الخارجية';

  @override
  String get interestVolunteer => 'العمل التطوعي';

  @override
  String get interestDiy => 'افعلها بنفسك';

  @override
  String get interestActivism => 'النشاط الاجتماعي';

  @override
  String get interestPetLove => 'حب الحيوانات الأليفة';

  @override
  String get interestVideoGames => 'ألعاب الفيديو';

  @override
  String get interestFamilyActivities => 'أنشطة عائلية';

  @override
  String get interestTech => 'التقنية';

  @override
  String get interestCostume => 'الأزياء التنكرية';

  @override
  String get interestFoodie => 'محبو الطعام';

  @override
  String get interestCamping => 'التخييم';

  @override
  String get medalBronzeSubtitle =>
      'أنشأ المستخدم حداً أدنى من حدثين أو حضر حداً أدنى من حدثين دون فشل خلال آخر 30 يوماً. يحصل المستخدم على خصم 2٪ على عملية شراء واحدة داخل التطبيق من اختياره.';

  @override
  String get medalSilverSubtitle =>
      'أنشأ المستخدم حداً أدنى من 3 أحداث أو حضر حداً أدنى من 3 أحداث دون فشل خلال آخر 30 يوماً. يحصل المستخدم على خصم 4٪ على عملية شراء واحدة داخل التطبيق من اختياره.';

  @override
  String get medalGoldSubtitle =>
      'أنشأ المستخدم حداً أدنى من 4 أحداث أو حضر حداً أدنى من 4 أحداث دون فشل خلال آخر 30 يوماً. يحصل المستخدم على خصم 8٪ على عملية شراء واحدة داخل التطبيق من اختياره.';

  @override
  String get removeCardActionNotAllowedTitle => 'الإجراء غير مسموح';

  @override
  String get removeCardConnectEscrowLabel => 'اربط حساب الضمان الخاص بك';

  @override
  String get removeCardSubscriptionsLabel => 'الاشتراكات';

  @override
  String get removeCardConfirmDeletionTitle => 'تأكيد حذف البطاقة';

  @override
  String get myEventDetailsLabel => 'تفاصيل الحدث';

  @override
  String get connectTvTitle => 'ربط التلفزيون';

  @override
  String get advertDialogTitle => 'إعلان';

  @override
  String get advertEventStarts48hrs => 'يبدأ الحدث خلال 48 ساعة';

  @override
  String get advertEventStarts7days => 'يبدأ الحدث خلال 7 أيام';

  @override
  String get userAroundTitle => 'المستخدمون حولك';

  @override
  String get userAroundMessage =>
      'تم العثور حالياً على تطابقات محتملة تطابق معاييرك';

  @override
  String get guestInviteTitle => 'دعوة ضيف';

  @override
  String get inviteFriendsToKumeleTitle => 'ادعُ أصدقاءك إلى كوميلي';

  @override
  String get inviteReferralCodeLabel => 'رمز الإحالة';

  @override
  String get congratulationsTitle => 'مبروك';

  @override
  String get congratsNewStatusBronze => 'الحالة الجديدة: برونزية';

  @override
  String get congratsDiscountCode => 'رمز الخصم: KEMELE20';

  @override
  String get congratsBronzeDescription =>
      'لقد أنشأت حداً أدنى من 3 أحداث أو حضرت حداً أدنى من 3 أحداث دون فشل خلال آخر 30 يوماً. يحصل المستخدم على خصم 4٪ على عملية شراء واحدة داخل التطبيق من اختياره.';

  @override
  String get passkeyIntroDescription =>
      'مفاتيح المرور سهلة الإعداد وتتيح لك تسجيل الدخول بأمان إلى حساب كوميلي الخاص بك باستخدام إمكانيات الأمان في أجهزتك مثل Touch ID وFace ID. مفاتيح المرور أكثر أماناً وأسهل في الاستخدام من جميع طرق المصادقة الثنائية الحالية.';

  @override
  String get passkeyTitle => 'مفتاح المرور';

  @override
  String get signInUsingPasskeyLabel => 'تسجيل الدخول باستخدام مفتاح المرور';

  @override
  String get signupPasskeyEmailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get eventStartInLabel => 'يبدأ في';

  @override
  String get cancelEventTitle => 'إلغاء الحدث';

  @override
  String get setTimeTitle => 'ضبط الوقت';

  @override
  String get guestPricesTitle => 'أسعار الضيوف';

  @override
  String get guestPricesUnavailableMessage => 'أسعار الضيوف غير متاحة حالياً.';

  @override
  String get rewardRingsTitle => 'حلقات المكافآت';

  @override
  String get moneyEarnedTitle => 'الأموال المكتسبة';

  @override
  String get tryAgainLabel => 'إعادة المحاولة';

  @override
  String get locationServicesOffTitle => 'خدمات الموقع معطلة';

  @override
  String get locationAccessRequiredTitle => 'الوصول إلى الموقع مطلوب';

  @override
  String get locationServicesOffMessage =>
      'يرجى تفعيل خدمات الموقع على جهازك لاكتشاف الأحداث القريبة منك.';

  @override
  String get locationPermissionPermanentlyDeniedMessage =>
      'تم رفض إذن الموقع بشكل دائم. يرجى تفعيله في إعدادات التطبيق.';

  @override
  String get locationAccessNeededMessage =>
      'الوصول إلى الموقع مطلوب لعرض الأحداث القريبة منك.';

  @override
  String get joinEventConfirmTitle => 'الانضمام إلى هذا الحدث؟';

  @override
  String get joinLabel => 'انضمام';

  @override
  String get kumeleTermsOfUseLabel => 'شروط استخدام كوميلي';

  @override
  String get eventCancelledDialogTitle => 'تم إلغاء الحدث';

  @override
  String get eventCancelledDialogMessage =>
      'للأسف، ألغى المضيف الحدث. نعتذر عن الإزعاج. في حالة الدفعات المسبقة، يرجى الاتصال بـ PayPal فوراً لطلب استرداد.';

  @override
  String get premiumPurchaseIncludeLabel => 'يشمل الشراء المميز داخل التطبيق:';

  @override
  String get premiumLocationChange => 'تغيير الموقع';

  @override
  String get premiumHouseParty => 'حفلة منزلية (بحد أقصى 10 ضيوف)';

  @override
  String get premiumNoAds => 'بدون إعلانات';

  @override
  String get premium7DaysAdvertising => 'إعلان قبل الحدث بـ 7 أيام';

  @override
  String get signupDateOfBirthLabel => 'تاريخ الميلاد';

  @override
  String get signupGenderLabel => 'الجنس';

  @override
  String get signUpButtonLabel => 'إنشاء حساب';

  @override
  String myEventJoinedLabel(String date) {
    return 'انضممت في $date';
  }

  @override
  String get myEventOrganizedByLabel => 'منظم بواسطة';

  @override
  String get myEventDateTimeLabel => 'التاريخ والوقت';

  @override
  String get myEventLocationLabel => 'الموقع';

  @override
  String get myEventCapacityAvailabilityLabel => 'السعة والتوفر';

  @override
  String get myEventAboutEventLabel => 'عن الحدث';

  @override
  String get eventRulesTitle => 'قواعد ومعلومات الحدث';

  @override
  String eventRuleAgeLabel(String minAge, String maxAge) {
    return 'العمر: $minAge - $maxAge';
  }

  @override
  String get eventRuleNoAgeLimitLabel => 'بدون حد';

  @override
  String eventRuleGenderLabel(String gender) {
    return 'الجنس: $gender';
  }

  @override
  String eventRuleLanguageLabel(String language) {
    return 'اللغة: $language';
  }

  @override
  String get eventRuleRequiresApprovalLabel => 'يتطلب موافقة المضيف';

  @override
  String get exploreMatchedEventLabel => 'حدث متطابق';

  @override
  String get exploreCreatedEventLabel => 'حدث منشأ';

  @override
  String get exploreJoinNowLabel => 'انضم الآن';

  @override
  String get exploreSwipeNoMoreMatchesLine1 => 'لا توجد تطابقات أخرى حالياً،';

  @override
  String get exploreSwipeNoMoreMatchesLine2 => 'حتى ذلك الحين';

  @override
  String get exploreSwipeCreateEventCta => 'كن رائعاً وأنشئ حدثاً';

  @override
  String get exploreSwipeBlogsSuggestion => 'إليك بعض المدونات التي قد تعجبك';

  @override
  String get exploreSwipeInviteFriendsCta => 'كن رائعاً وادعُ أصدقاءك';

  @override
  String get exploreNotificationsTitle => 'الإشعارات';

  @override
  String get exploreTabletHeaderTitle => 'استكشف';

  @override
  String get createEventTitle => 'إنشاء حدث';

  @override
  String get previewEventLabel => 'معاينة الحدث';

  @override
  String get createEventAgeRangeLabel => 'الفئة العمرية';

  @override
  String get createEventNumberOfGuestsLabel => 'عدد الضيوف';

  @override
  String get createEventRsvpGuestPaymentLabel => 'دفع ضيوف RSVP';

  @override
  String get createEventFreeEventLabel => 'حدث مجاني';

  @override
  String get createEventCardPaymentLabel => 'الدفع بالبطاقة';

  @override
  String get createEventCashOnEntryLabel => 'نقداً عند الدخول';

  @override
  String get reportEventTitle => 'الإبلاغ عن حدث';

  @override
  String get reportEventChooseReasonLabel => 'اختر سبباً';

  @override
  String get ratingsTitle => 'التقييمات';

  @override
  String get rateEventTitle => 'تقييم الحدث';

  @override
  String get attendeeRatingsLabel => 'تقييمات الحضور (70٪)';

  @override
  String get blogNoCommentsMessage => 'لا توجد تعليقات بعد. كن أول من يعلق!';

  @override
  String get nftPreviewTitle => 'معاينة NFT';

  @override
  String get nftClosePreviewLabel => 'إغلاق المعاينة';

  @override
  String get walletSignatureRequiredTitle => 'توقيع المحفظة مطلوب';

  @override
  String get dismissLabel => 'تجاهل';

  @override
  String get soundNotificationTurnOnLabel => 'تشغيل إشعار الصوت';

  @override
  String get soundNotificationLabel => 'إشعار الصوت';

  @override
  String get turnOn2faLabel => 'تفعيل المصادقة الثنائية';

  @override
  String get chooseInterestsTitle => 'اختر الاهتمامات';

  @override
  String chooseUpToInterestsLabel(String count) {
    return 'اختر حتى $count من الاهتمامات:';
  }

  @override
  String get earnMedalsAndRewardsTitle => 'اكسب الميداليات والمكافآت';

  @override
  String otherEventsFromHostLabel(String hostName) {
    return 'أحداث أخرى من $hostName';
  }

  @override
  String get hobbyMeetupTagline => 'لقاء الهوايات';

  @override
  String get splashTagline => 'نلعب. نتغلب. نتحد. نعيش.';

  @override
  String get skipLabel => 'تخطي';

  @override
  String get guestTileGroupMeditationLabel => 'تأمل جماعي';

  @override
  String get guestTileHostedByLabel => 'يستضيفه أنكي ماهيشواري';

  @override
  String get guestTileLocationLabel => 'بهاوالبور، البنجاب باكستان';

  @override
  String get filterMockLocationLabel => 'المملكة المتحدة، 39495، كنتاكي';

  @override
  String get historyTitle => 'السجل';

  @override
  String get historyStatisticsTitle => 'السجل والإحصائيات';

  @override
  String get blogDetailsTitle => 'تفاصيل المدونة';

  @override
  String get addCardTitle => 'إضافة بطاقة';

  @override
  String get addCardStripeMessage =>
      'يتم جمع بيانات البطاقة بأمان بواسطة Stripe.';

  @override
  String get addCardSubmitLabel => 'إضافة بطاقة';

  @override
  String get noNotificationsTitle => 'لا توجد إشعارات';

  @override
  String get noNotificationsDescription =>
      'لا توجد لديك إشعارات جديدة حالياً. عد لاحقاً.';
}
