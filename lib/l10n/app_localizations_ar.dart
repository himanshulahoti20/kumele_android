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
  String get discoverLocationLabel => 'Location:';

  @override
  String get discoverMockLocationLabel => 'Indore, Madhya radesh, IN';

  @override
  String get discoverStartsInLabel => 'Starts in';

  @override
  String get discoverHoursSuffix => 'hrs';

  @override
  String get discoverShareLabel => 'Share';

  @override
  String get discoverMockEventTitle =>
      '🌟 Invitation to a Transformative Yoga Experience: Kundalini Awakening Gathering';

  @override
  String get discoverMockEventDescription =>
      'Embark on a profound journey of self-discovery and inner transformation with our exclusive Kundalini Awakening Yoga event! We invite you to join us for a harmonious gathering where ten individuals will come together to explore the ancient practice of Kundalini yoga. This';

  @override
  String get discoverHostLabel => 'Host';

  @override
  String get discoverHostMedalGoldLabel => 'Gold';

  @override
  String get discoverMockAboutHostLabel => 'About Alkesh:';

  @override
  String get discoverMockAboutHostText =>
      'Engineering Marvel with a Passion for Beats and Serenity';

  @override
  String get discoverMockHostBio =>
      'Welcome to my world of innovation and\nrhythm! I’m Alkesh, an engineer by profession\nand a connoisseur of life’s eclectic\nexperiences.';

  @override
  String get discoverFollowersSuffix => ' followers';

  @override
  String get discoverOverallRatingsSuffix => 'Overall Ratings';

  @override
  String get discoverMockCategoryLabel => '90’s Hip-Hop';

  @override
  String get discoverMockPartyTypeLabel => 'House Party';

  @override
  String get discoverMockRatingSummaryLabel => '3.6 out of 5';

  @override
  String get discoverMockGuestRatingsLabel => '6 Guest ratings';

  @override
  String get discoverMockReviewerName => 'Jakob Hoffman';

  @override
  String get discoverMockReviewDate => '⬤ 23 August 2023';

  @override
  String get discoverMockReviewText =>
      'What a display  dsn  cdn zxnc nzc njzcn nzcjcnzjncjcnzjcnzc ncnz cjkznkcnzc kcnznczn cznzxnc  czc znc zncznc z nzcxnjcc ncjcnz nc nzcnnz cc';

  @override
  String get discoverMockOtherEventsLabel => 'Other Events from Alkesh';

  @override
  String get exploreSwipeCardToday => 'Today';

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
}
