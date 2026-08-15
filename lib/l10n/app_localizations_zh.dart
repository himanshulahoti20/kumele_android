// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get cancel => '取消';

  @override
  String get ok => '确定';

  @override
  String get save => '保存';

  @override
  String get continueLabel => '继续';

  @override
  String get submit => '提交';

  @override
  String get close => '关闭';

  @override
  String get confirm => '确认';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get done => '完成';

  @override
  String get retry => '重试';

  @override
  String get back => '返回';

  @override
  String get next => '下一步';

  @override
  String get selfCheck => '自检';

  @override
  String get success => '成功';

  @override
  String get error => '错误';

  @override
  String get loading => '加载中...';

  @override
  String get somethingWentWrong => '出错了，请重试。';

  @override
  String get comment => '评论';

  @override
  String get addYourComment => '添加您的评论...';

  @override
  String get publishComment => '发表评论';

  @override
  String get posted => '已发布！';

  @override
  String get requiredField => '此字段必填';

  @override
  String get invalidEmail => '请输入有效的电子邮件地址';

  @override
  String get noResults => '未找到结果';

  @override
  String get noData => '暂无数据';

  @override
  String get noChats => '暂无聊天';

  @override
  String get noChatsDescription => '您现在没有任何聊天记录。请发起对话或稍后再来看看。';

  @override
  String get noGuests => '暂无来宾';

  @override
  String get noGuestsDescription => '此活动尚未有来宾签到或注册。';

  @override
  String get chat => '聊天';

  @override
  String get spirituality => '灵性';

  @override
  String get hostedBy => '主办方';

  @override
  String get rateEvent => '为活动评分';

  @override
  String get reportEvent => '举报活动';

  @override
  String get guestScan => '来宾扫描';

  @override
  String get scanQrCode => '扫描二维码';

  @override
  String get alignQrInFrame => '请从来宾的二维码对准取景框';

  @override
  String get guestNotFound => '在此活动中未找到该来宾';

  @override
  String get invalidQrCode => '无效的二维码';

  @override
  String get confirmCheckIn => '确认签到';

  @override
  String get confirmGuestCheckInDescription => '为该来宾办理活动签到？';

  @override
  String checkedInSuccess(String name) {
    return '成功为 $name 办理签到！';
  }

  @override
  String get checkedInLabel => '已签到';

  @override
  String get notCheckedInLabel => '未签到';

  @override
  String get confirmedLabel => '已确认';

  @override
  String get followHost => '关注主办方';

  @override
  String daysLeftToRate(int days) {
    return '还剩 -- 天可评分和\n评价';
  }

  @override
  String scannedList(int count) {
    return '扫描列表：--';
  }

  @override
  String get chatToday => 'Today';

  @override
  String get chatYesterday => 'Yesterday';

  @override
  String get eventCanceled => '活动已取消';

  @override
  String get noMessages => '暂无消息';

  @override
  String get noMessagesDescription => '这里还没有消息。';

  @override
  String get joinChatFailed => '加入聊天室失败';

  @override
  String get joinChatSuccess => '成功加入聊天室';

  @override
  String get loadMessagesFailed => '加载聊天消息失败';

  @override
  String get sendMessageFailed => '发送消息失败';

  @override
  String get chatNotAvailable => '聊天不可用';

  @override
  String get chatAccessDenied => '您没有访问此聊天的权限';

  @override
  String get chatClosed => '此聊天已关闭';

  @override
  String get typeAMessage => '输入消息';

  @override
  String get reply => '回复';

  @override
  String get unknownUser => '未知用户';

  @override
  String get activeEvent => '进行中的活动';

  @override
  String get active => '进行中';

  @override
  String get eventChat => '活动聊天';

  @override
  String get guests => '来宾';

  @override
  String get guest => '来宾';

  @override
  String get priceLabel => '价格';

  @override
  String get eventAddressLabel => '活动地址';

  @override
  String get cashOnEntry => '入场时付现';

  @override
  String get free => '免费';

  @override
  String get profileTitle => '个人资料';

  @override
  String get myEvents => '我的活动';

  @override
  String get createdEvents => '已创建的活动';

  @override
  String get joinedEvents => '已加入的活动';

  @override
  String get noEventsCreatedYet => '您还没有创建任何活动。';

  @override
  String get noEventsJoinedYet => '您还没有加入任何活动。';

  @override
  String get blogsTitle => '博客';

  @override
  String get settingsTitle => '设置';

  @override
  String get interestedHobbies => '感兴趣的爱好';

  @override
  String get editHobbies => '编辑爱好';

  @override
  String get showMore => '显示更多';

  @override
  String get showLess => '显示较少';

  @override
  String get myQrCode => '我的二维码';

  @override
  String get following => '关注';

  @override
  String get followers => '粉丝';

  @override
  String get goldStatus => '黄金会员';

  @override
  String get notifications => '通知';

  @override
  String get languages => '语言';

  @override
  String get languagesLoadFailed => '加载语言失败。';

  @override
  String get connectionsLoadFailed => '加载关注和粉丝失败。';

  @override
  String get cardPaymentsSubscriptions => '银行卡支付、订阅与托管';

  @override
  String get security => '安全';

  @override
  String get contact => '联系我们';

  @override
  String get faq => '常见问题';

  @override
  String get contactPageSubtitle => '告诉我们如何能帮到您。';

  @override
  String get contactSubjectLabel => '主题';

  @override
  String get contactSubjectHint => '简要说明您的问题';

  @override
  String get contactDescriptionLabel => '描述';

  @override
  String get contactDescriptionHint => '详细描述您的问题';

  @override
  String get contactCategoryLabel => '类别';

  @override
  String get contactPriorityLabel => '优先级';

  @override
  String get contactAttachmentLabel => '附件（可选）';

  @override
  String get contactAttachmentHint => '上传屏幕截图';

  @override
  String get contactSubmitLabel => '提交';

  @override
  String get contactSuccessMessage => '您的消息已发送。';

  @override
  String get contactSubmitFailed => '发送消息失败，请重试。';

  @override
  String get contactDescriptionTooShort => '请输入至少 20 个字符，以便支持团队能更好地为您提供帮助。';

  @override
  String get contactSubjectRequired => '请输入主题。';

  @override
  String get contactDescriptionRequired => '请输入描述。';

  @override
  String get contactAttachmentPickFailed => '选择图片失败。';

  @override
  String get guidelines => '指南';

  @override
  String get referAFriend => '推荐好友';

  @override
  String get referralCodeUnavailable => '您的推荐码目前不可用，请稍后再试。';

  @override
  String get referralShareSubject => '和我一起加入 Kumele';

  @override
  String referralShareMessage(String referralCode, String referralLink) {
    return '和我一起加入 Kumele ——通过共同的兴趣认识本地爱好相同的朋友！\n\n使用我的推荐码：$referralCode\n\n在此注册：$referralLink';
  }

  @override
  String get termsAndConditions => '条款和条件';

  @override
  String get nightMode => '夜间模式';

  @override
  String get deleteAccount => '删除账号';

  @override
  String get signOut => '退出登录';

  @override
  String get deleteAccountConfirmTitle => '您确定吗？此操作无法\n撤销。请重新输入\n密码。';

  @override
  String get deleteAccountPasswordHint => '输入当前密码';

  @override
  String get deleteAccountPageSubtitle => '此操作是永久性的。请输入您的密码并告诉我们您离开的原因。';

  @override
  String get deleteAccountPasswordLabel => '密码';

  @override
  String get deleteAccountReasonLabel => '原因';

  @override
  String get deleteAccountReasonHint => '告诉我们您离开的原因';

  @override
  String get deleteAccountConfirmationLabel => '我了解此操作是永久性的，且无法撤销';

  @override
  String get deleteAccountSubmitLabel => '删除账号';

  @override
  String get deleteAccountSuccessMessage => '账号已成功删除。';

  @override
  String get deleteAccountSubmitFailed => '删除账号失败，请重试。';

  @override
  String get deleteAccountPasswordRequired => '请输入您的密码。';

  @override
  String get deleteAccountReasonRequired => '请告诉我们您离开的原因。';

  @override
  String get deleteAccountConfirmationRequired => '请确认您了解此操作是永久性的。';

  @override
  String get signOutConfirmTitle => '您确定要\n退出登录吗？';

  @override
  String get signOutSuccessMessage => '已成功退出登录。';

  @override
  String get forgotPasswordPageTitle => '忘记密码';

  @override
  String get forgotPasswordSubtitle => '输入您的电子邮件地址，我们将向您发送重置验证码。';

  @override
  String get forgotPasswordEmailLabel => '电子邮件';

  @override
  String get forgotPasswordHint => '输入电子邮件';

  @override
  String get forgotPasswordSubmitLabel => '发送重置邮件';

  @override
  String get forgotPasswordSuccessMessage => '如果该电子邮件存在，重置链接已发送。';

  @override
  String get resetPasswordPageTitle => '重置密码';

  @override
  String get resetPasswordSubtitle => '输入发送到您电子邮件的验证码并选择新密码。';

  @override
  String get resetPasswordTokenLabel => '验证码';

  @override
  String get resetPasswordTokenHint => '输入验证码';

  @override
  String get resetPasswordNewPasswordLabel => '新密码';

  @override
  String get resetPasswordNewPasswordHint => '输入新密码';

  @override
  String get resetPasswordConfirmPasswordLabel => '确认密码';

  @override
  String get resetPasswordConfirmPasswordHint => '重新输入新密码';

  @override
  String get resetPasswordSubmitLabel => '重置密码';

  @override
  String get resetPasswordSuccessMessage => '密码重置成功';

  @override
  String get passwordMinLengthError => '密码长度必须至少为 6 个字符';

  @override
  String get passwordsDoNotMatchError => '两次输入的密码不一致';

  @override
  String get emailVerificationPageTitle => '验证您的电子邮件';

  @override
  String get emailVerificationSubtitle => '我们已向您的电子邮件发送了 6 位验证码，请在下方输入以继续。';

  @override
  String get emailVerificationVerifyLabel => '验证电子邮件';

  @override
  String get emailVerificationResendLabel => '重新发送验证码';

  @override
  String get emailVerificationResendInLabel => '重新发送验证码倒计时：';

  @override
  String get emailVerificationSentMessage => '验证码已发送至您的电子邮件。';

  @override
  String get emailVerificationFailedMessage => '无效的验证码，请重试。';

  @override
  String get emailVerificationSendFailedMessage => '发送验证码失败，请重试。';

  @override
  String get emailVerificationSuccessMessage => '电子邮件验证成功！';

  @override
  String get changePassword => '修改密码';

  @override
  String get changePasswordCurrentLabel => '当前密码';

  @override
  String get changePasswordCurrentHint => '输入当前密码';

  @override
  String get changePasswordNewLabel => '新密码';

  @override
  String get changePasswordNewHint => '输入新密码';

  @override
  String get changePasswordConfirmLabel => '确认新密码';

  @override
  String get changePasswordConfirmHint => '重新输入新密码';

  @override
  String get changePasswordSubmitLabel => '更新密码';

  @override
  String get changePasswordSuccessMessage => '密码更新成功，请使用新密码重新登录。';

  @override
  String get changePasswordSubmitFailed => '更新密码失败，请重试。';

  @override
  String get changePasswordCurrentRequired => '请输入您的当前密码。';

  @override
  String get registerPasskey => '注册通行密钥 (Passkey)';

  @override
  String get twoFactorAuth => '双重认证 (2FA)';

  @override
  String get twoFactorSetupTitle => '身份验证器应用设置';

  @override
  String get twoFactorSetupStep1 => '1. 在您的移动设备上打开身份验证器应用';

  @override
  String get twoFactorSetupStep1Hint => '如果您还没有，请下载并安装推荐的应用之一：';

  @override
  String get twoFactorSetupStep2Lead => '2. 使用您的';

  @override
  String get twoFactorSetupStep2Bold => '身份验证器应用';

  @override
  String get twoFactorSetupCantScan => '无法扫描？请使用此代码代替';

  @override
  String get twoFactorSetupStep3Lead => '3. 输入来自';

  @override
  String get twoFactorSetupStep3Bold => '身份验证器应用';

  @override
  String get twoFactorVerificationHint => '在此处输入验证码';

  @override
  String get twoFactorSetupLoadFailed => '加载双重认证设置失败，请重试。';

  @override
  String get twoFactorEnableFailed => '开启双重认证失败，请检查验证码并重试。';

  @override
  String get twoFactorEnableSuccess => '已成功开启双重认证。';

  @override
  String get twoFactorManualCodeCopied => '设置代码已复制到剪贴板';

  @override
  String get setup => '设置';

  @override
  String get twoFactorDisableTitle => '关闭双重认证';

  @override
  String get twoFactorDisableSubtitle => '您确定要关闭双重认证吗？';

  @override
  String get twoFactorDisableDescription => '您的账号将仅受密码保护。为了提升安全性，我们建议保持双重认证开启。';

  @override
  String get twoFactorDisableConfirm => '关闭双重认证';

  @override
  String get twoFactorDisableCodeLead => '输入来自您';

  @override
  String get twoFactorDisableSuccess => '双重认证已成功关闭。';

  @override
  String get twoFactorDisableFailed => '关闭双重认证失败，请检查验证码并重试。';

  @override
  String get twoFactorLoginTitle => '双重认证';

  @override
  String get twoFactorLoginSubtitle => '输入来自您的身份验证器应用的代码以继续';

  @override
  String get twoFactorLoginDescription => '您的账号受双重认证保护。';

  @override
  String get twoFactorLoginCodeLead => '输入来自您';

  @override
  String get twoFactorLoginCodeBold => '身份验证器应用';

  @override
  String get twoFactorLoginVerify => '验证';

  @override
  String get twoFactorLoginFailed => '验证码无效，请重试。';

  @override
  String get passkeyRegisterSuccess => '通行密钥注册成功';

  @override
  String get onboardingPageTitle => '设置您的个人资料';

  @override
  String get onboardingPageSubtitle => '添加一张照片并向社区介绍一下您自己。';

  @override
  String get onboardingAvatarHint => '轻触以添加照片';

  @override
  String get onboardingImagePickerTitle => '添加头像';

  @override
  String get onboardingImagePickerSubtitle => '从图库或相机选择您的头像';

  @override
  String get gallery => '图库';

  @override
  String get camera => '相机';

  @override
  String get onboardingUsernameLabel => '用户名';

  @override
  String get onboardingUsernameHint => '选择一个用户名（可选）';

  @override
  String get onboardingUsernameHelper => '用户名每 3 个月只能更改一次';

  @override
  String get onboardingUsernameChecking => '正在检查用户名...';

  @override
  String get onboardingUsernameAvailable => '用户名可用';

  @override
  String get onboardingUsernameTaken => '用户名已被占用';

  @override
  String get onboardingPhoneLabel => '手机号码';

  @override
  String get onboardingPhoneHint => '输入您的手机号码（可选）';

  @override
  String get onboardingAboutLabel => '关于我';

  @override
  String get onboardingAboutHint => '告诉我们您的兴趣、爱好以及您喜欢做的事情';

  @override
  String get onboardingSuccessMessage => '个人资料保存成功。';

  @override
  String get onboardingImageRequired => '请添加一张头像。';

  @override
  String get onboardingPhoneRequired => '请输入您的手机号码。';

  @override
  String get onboardingPhoneInvalid => '请输入有效的手机号码。';

  @override
  String get onboardingAboutTooShort => '“关于我”的内容必须至少包含 200 个字符。';

  @override
  String get onboardingAboutTooLong => '“关于我”的内容不能超过 500 个字符。';

  @override
  String get onboardingImagePlatformUnsupported => '图片上传功能目前仅支持 Android。';

  @override
  String get onboardingImagePickFailed => '选择图片失败。';

  @override
  String get onboardingSubmitFailed => '保存个人资料失败，请重试。';

  @override
  String get editProfileTitle => '编辑个人资料';

  @override
  String get editProfileFirstNameLabel => '名字';

  @override
  String get editProfileFirstNameHint => '输入您的名字';

  @override
  String get editProfileLastNameLabel => '姓氏';

  @override
  String get editProfileLastNameHint => '输入您的姓氏';

  @override
  String get editProfileAboutLabel => '关于我';

  @override
  String get editProfileAboutHint => '告诉我们您的兴趣、爱好以及您喜欢做的事情';

  @override
  String get editProfilePhoneLabel => '手机号码';

  @override
  String get editProfilePhoneHint => '输入您的手机号码';

  @override
  String get editProfileUpdateLabel => '更新';

  @override
  String get editProfileSuccessMessage => '个人资料更新成功。';

  @override
  String get editProfileSubmitFailed => '更新个人资料失败，请重试。';

  @override
  String get editProfileFirstNameRequired => '请输入您的名字。';

  @override
  String get editProfileAboutTooLong => '“关于我”的内容不能超过 500 个字符。';

  @override
  String get editProfilePhoneInvalid => '请输入有效的手机号码。';

  @override
  String get editProfileUserMissing => '无法更新个人资料，未找到用户。';

  @override
  String get pickEventLocation => '选择活动地点';

  @override
  String get selectedLocation => '已选位置';

  @override
  String get fetchingAddress => '正在获取地址...';

  @override
  String get moveMapToPickLocation => '移动地图以选择位置';

  @override
  String get confirmLocation => '确认位置';

  @override
  String get searching => '搜索中...';

  @override
  String get unknownLocation => '未知位置';

  @override
  String get couldNotFetchAddress => '无法获取地址';

  @override
  String get locationServicesDisabled => '位置服务已禁用。';

  @override
  String get locationPermissionDenied => '定位权限被拒绝。';

  @override
  String get locationPermissionPermanentlyDenied => '定位权限被永久拒绝。';

  @override
  String get pickEventLocationPlaceholder => '选择活动地点';

  @override
  String get tapToOpenMapPlaceholder => '轻触以打开地图并放置图钉';

  @override
  String get limitedInvites => '限量邀请';

  @override
  String get howItWorks => '运作方式：';

  @override
  String get login => '登录';

  @override
  String get signup => '注册';

  @override
  String get inviteFriendsAndFamily => '邀请您的朋友和家人';

  @override
  String get eventCodeCopied => '活动代码已复制到剪贴板！';

  @override
  String get copyTo => '复制到';

  @override
  String get clipboard => '剪贴板';

  @override
  String get eventIdLabel => '活动 ID：';

  @override
  String get locationLabel => '地点：';

  @override
  String get scanQr => '扫码';

  @override
  String get hostQr => '主办方二维码';

  @override
  String get demoHostName => 'Ankit Maheswari';

  @override
  String get demoLocation => '巴哈瓦尔布尔，巴基斯坦旁遮普省';

  @override
  String get signIn => '登录';

  @override
  String get signInEmailHint => '输入邮箱 | 昵称';

  @override
  String get signInPasswordHint => '输入密码';

  @override
  String get signInRememberMeLabel => '记住我';

  @override
  String get signInForgotPasswordLabel => '忘记密码？';

  @override
  String get signInCaptchaLabel => '我不是机器人';

  @override
  String get signInNotAMemberPrefix => '还不是会员？';

  @override
  String get signInNoAccountPrefix => '没有账号？';

  @override
  String get signInPasskeyDividerLabel => '或使用通行密钥登录';

  @override
  String get signInPasskeyDescription =>
      '我们建议所有用户使用通行密钥（如果您的设备支持），以提高安全性并获得更好的用户体验。';

  @override
  String get signInLanguageChoiceLabel => '语言';

  @override
  String get signInFillFieldsError => '请填写所有必填字段';

  @override
  String get signInCaptchaRequiredError => '请确认您不是机器人';

  @override
  String get signInSuccessMessage => '登录成功';

  @override
  String get signInWithGoogleLabel => '使用 Google 登录';

  @override
  String get alreadyHaveAccount => '已有账号？';

  @override
  String get signupFirstNameLabel => '名字';

  @override
  String get signupFirstNameHint => '输入名字';

  @override
  String get signupLastNameLabel => '姓氏';

  @override
  String get signupLastNameHint => '输入姓氏';

  @override
  String get signupEmailHint => '输入电子邮件';

  @override
  String get signupPasswordHint => '输入密码';

  @override
  String get signupConfirmPasswordHint => '确认密码';

  @override
  String get signupReferralCodeLabel => '推荐码';

  @override
  String get signupBetaCodeLabel => '测试码';

  @override
  String get signupCodeHint => '例如：DF4R435';

  @override
  String get passkeySignInTitle => '使用您的 Kumele 通行密钥登录';

  @override
  String get earnMedals => '赢取勋章';

  @override
  String get bronzeStatus => '青铜状态';

  @override
  String get silverStatus => '白银状态';

  @override
  String get goldStatusMedal => '黄金状态';

  @override
  String get bronzeStatusDescription =>
      '用户在过去 30 天内创建了至少 2 个活动，或无缺席地参加了至少 2 个活动。用户可任选 1 项应用内购并获得 2% 的折扣。';

  @override
  String get silverStatusDescription =>
      '用户在过去 30 天内创建了至少 3 个活动，或无缺席地参加了至少 3 个活动。用户可任选 1 项应用内购并获得 4% 的折扣。';

  @override
  String get goldStatusMedalDescription =>
      '用户在过去 30 天内创建了至少 4 个活动，或无缺席地参加了至少 4 个活动。用户可任选 1 项应用内购并获得 8% 的折扣。';

  @override
  String get filterTitle => '筛选';

  @override
  String get currentLocation => '当前位置';

  @override
  String get change => '更改';

  @override
  String get distanceRangeLabel => '距离范围（公里）';

  @override
  String get ageRangeLabel => '年龄范围';

  @override
  String get paidEvent => '付费活动';

  @override
  String get stateHint => '州/省';

  @override
  String get postalZipCodeHint => '邮政编码';

  @override
  String get countryHint => '国家/地区';

  @override
  String get openPhantomWallet => '打开 Phantom 钱包';

  @override
  String get nftDescriptionLabel => '描述';

  @override
  String get nftDetailsLabel => 'NFT 详情';

  @override
  String get guestCountValidForEventOnly => '来宾人数仅对此活动有效';

  @override
  String get tokenIdLabel => '代币 ID';

  @override
  String get tokenStandardLabel => '代币标准';

  @override
  String get blockchainLabel => '区块链';

  @override
  String get creatorLabel => '创作者';

  @override
  String get addCommentsHint => '添加评论';

  @override
  String get reportEventPageTitle => '举报活动';

  @override
  String get ratingPageTitle => '评分';

  @override
  String get send => '发送';

  @override
  String get blogLikePostSemanticLabel => '点赞文章';

  @override
  String get blogLikesLabel => '点赞';

  @override
  String get blogShareLabel => '分享';

  @override
  String get replyDialogTitlePrefix => '回复';

  @override
  String get replyDialogHint => '写下您的回复...';

  @override
  String get blogEmptyStateTitle => '未找到博客';

  @override
  String get blogEmptyStateDescription => '请尝试使用其他类别过滤器。';

  @override
  String get blogCategoryAll => '全部';

  @override
  String get blogCategoryFood => '美食';

  @override
  String get blogCategoryTravel => '旅行';

  @override
  String get blogCategorySports => '体育';

  @override
  String get blogCategoryMusic => '音乐';

  @override
  String get blogPlaceholderTitle => '博客文章加载效果的占位符标题';

  @override
  String get blogPlaceholderExcerpt => '骨架屏加载的占位符摘要。';

  @override
  String get blogPlaceholderAuthorName => '加载作者';

  @override
  String get blogPlaceholderCategoryName => '类别';

  @override
  String get blogPostShareSampleTitle =>
      '格兰奥德 (Glen Ord) 38 年苏格登 (Singleton) 及苏格登系列。';

  @override
  String get blogPostShareCategoryLabel => '灵性';

  @override
  String get blogPostShareAuthorLabel => ' 作者：';

  @override
  String get blogPostSharePublishDateLabel => ' 发布日期：';

  @override
  String get blogPostShareHowItWorksTitle => '运作方式';

  @override
  String get blogPostShareStep1 => '1. 检查 Url 以打开博客';

  @override
  String get blogPostShareStep2 => '2. 或在登录状态下搜索博客以点赞';

  @override
  String get blogPostShareInviteTitle => '邀请您的朋友\n和家人';

  @override
  String get blogPostCommentsTitle => '评论';

  @override
  String get blogPostPreviousLabel => '上一页';

  @override
  String get blogRepliesCountLabel => '回复';

  @override
  String get blogReplyPlaceholderText => '准备好迎接一个充满欢笑的夜晚吧';

  @override
  String get blogSearchHint => '搜索';

  @override
  String get createEventNameLabel => '活动名称';

  @override
  String get createEventTitleHint => '添加标题';

  @override
  String get createEventSubtitleLabel => '副标题';

  @override
  String get createEventSubtitleHint => '添加副标题';

  @override
  String get createEventDescriptionMaxLabel => '最大';

  @override
  String get createEventDescriptionLabel => '描述';

  @override
  String get createEventDescriptionHint => '更多关于活动的内容';

  @override
  String get createEventDateLabel => '日期';

  @override
  String get createEventStartTimeLabel => '活动开始时间';

  @override
  String get createEventStartTimePlaceholder => '开始时间';

  @override
  String get createEventEndTimeLabel => '活动结束时间';

  @override
  String get createEventEndTimePlaceholder => '结束时间';

  @override
  String get createEventCheckAvailabilityLabel => '检查用户可用性';

  @override
  String get createEventAvailabilityDisclaimer =>
      '要使用此功能，请添加您的地址和宾客人数。免责声明：由于某些我们无法控制的因素，我们无法保证100%匹配。';

  @override
  String get createEventStartsInLabel => '活动开始于';

  @override
  String get createEventDecreaseTimeSemanticLabel => '减少时间';

  @override
  String get createEventIncreaseTimeSemanticLabel => '增加时间';

  @override
  String get createEventStreetLabel => '街道';

  @override
  String get createEventStreetHint => '输入街道';

  @override
  String get createEventHomeNumberLabel => '门牌号';

  @override
  String get createEventHomeNumberHint => '输入门牌号';

  @override
  String get createEventDistrictLabel => '区域';

  @override
  String get createEventDistrictHint => '输入区域';

  @override
  String get createEventPostalCodeLabel => '邮政编码';

  @override
  String get createEventPostalCodeHint => '输入邮政编码';

  @override
  String get createEventStateLabel => '州/省';

  @override
  String get createEventStateHint => '输入州/省';

  @override
  String get createEventUploadImageTitle => '上传图片';

  @override
  String get createEventUploadImageSubtitle => '为您的活动图片选择来源';

  @override
  String get createEventCategoryPlaceholder => '类别';

  @override
  String get createEventCategoryLabel => '活动类别';

  @override
  String get createEventImageLabel => '活动图片';

  @override
  String get createEventImageSizeHint => '（推荐尺寸 400 x 400px）';

  @override
  String get createEventStripeConnectedLabel => 'Stripe 已连接';

  @override
  String get createEventPreviewSubmitLabel => '创建活动';

  @override
  String get createEventPreviewGuestsSuffix => '位宾客';

  @override
  String get createEventPreviewAlreadyStarted => '活动已经开始';

  @override
  String createEventPreviewStartsInDays(Object days) {
    return '在 $days 天后开始';
  }

  @override
  String get createEventPreviewStartsTomorrow => '明天开始';

  @override
  String createEventPreviewStartsInHour(Object hours) {
    return '在 $hours 小时后开始';
  }

  @override
  String createEventPreviewStartsInHours(Object hours) {
    return '在 $hours 小时后开始';
  }

  @override
  String createEventPreviewStartsInMinute(Object minutes) {
    return '在 $minutes 分钟后开始';
  }

  @override
  String createEventPreviewStartsInMinutes(Object minutes) {
    return '在 $minutes 分钟后开始';
  }

  @override
  String get createEventPreviewStartingNow => '现在开始';

  @override
  String get createEventPreviewDefaultCategory => '灵性';

  @override
  String get createEventPreviewDefaultHostName => '我';

  @override
  String createEventPreviewExpectedLabel(Object label) {
    return '预期 $label';
  }

  @override
  String createEventPreviewPricingLabel(Object label) {
    return '定价 $label';
  }

  @override
  String get discoverNoMatchesMessage => '目前没有更多匹配，在此之前';

  @override
  String get discoverGuestsSuffix => '位宾客';

  @override
  String get discoverGoToChatLabel => '前往聊天';

  @override
  String get discoverLocationLabel => '地点：';

  @override
  String get discoverStartsInLabel => '开始于';

  @override
  String get discoverHoursSuffix => '小时';

  @override
  String get discoverShareLabel => '分享';

  @override
  String get discoverHostLabel => '主办方';

  @override
  String get discoverHostMedalGoldLabel => '金';

  @override
  String get discoverFollowersSuffix => ' 位关注者';

  @override
  String get discoverOverallRatingsSuffix => '总体评分';

  @override
  String get exploreSwipeCardToday => '今天';

  @override
  String get exploreSearchHint => '搜索兴趣活动';

  @override
  String get exploreSwipeCardStartInPrefix => '开始于';

  @override
  String get exploreSwipeCardHostLabel => '主办方';

  @override
  String get exploreSwipeCardFollowersSuffix => '位关注者';

  @override
  String get exploreSwipeCardOverallRatingsLabel => '总体评分';

  @override
  String get exploreCategoryVanLife => '房车生活';

  @override
  String get exploreCategoryPetLove => '宠物之爱';

  @override
  String get exploreCategorySpirituality => '灵性';

  @override
  String get exploreCategoryBoardGames => '桌游';

  @override
  String get exploreDiscountDeclineMessage => '拒绝';

  @override
  String get openLabel => '打开';

  @override
  String get exploreDiscountNoOfferTitle => '暂无可用优惠';

  @override
  String get exploreDiscountCheckBackLaterMessage => '请稍后再查看。';

  @override
  String get exploreDiscountNoAdDetailsMessage => '未提供广告详情。';

  @override
  String get exploreDiscountOfferFallback => '优惠';

  @override
  String get exploreLoadEventsFailed => '加载活动失败。';

  @override
  String get exploreInterestedLabel => '感兴趣';

  @override
  String get exploreEventDetailLoadFailed => '加载活动详情失败。';

  @override
  String get birthdayNotificationTitle => '祝您生日快乐！';

  @override
  String get birthdayNotificationMessage => '“生日快乐！祝您所有生日愿望和梦想都能实现。”';

  @override
  String get birthdayNotificationSignature => 'Kumele 团队';

  @override
  String get commentsTitle => '评论';

  @override
  String get previousLabel => '上一页';

  @override
  String get blogCommentRepliesCount => '3条回复';

  @override
  String get blogCommentReplayAction => '回复';

  @override
  String get welcomeNotificationTitle => '欢迎来到 Kumele';

  @override
  String get welcomeNotificationDate => '2022年11月23日';

  @override
  String get welcomeNotificationBody =>
      '欢迎来到 Kumele！我们很高兴您加入。探索您附近的活动，与志同道合的人联系，创造难忘的时刻。';

  @override
  String get createEventButtonLabel => '创建活动';

  @override
  String get notificationsEmptyTitle => '暂无通知';

  @override
  String get notificationsEmptyDescription => '您现在没有新通知。请稍后再查看。';

  @override
  String get exploreEmptyNoMoreMatches => '目前没有更多匹配，';

  @override
  String get exploreEmptyUntilThen => '在此之前';

  @override
  String get exploreEmptyCreateEventPromptSubtitle => '变得出色，创建一个活动';

  @override
  String get exploreEmptyReadBlogPromptSubtitle => '这里有一些您可能喜欢的博客';

  @override
  String get exploreEmptyReadBlogButtonLabel => '阅读博客';

  @override
  String get exploreEmptyInviteFriendsPromptSubtitle => '变得出色，邀请您的朋友';

  @override
  String get exploreEmptyInviteFriendsButtonLabel => '邀请朋友';

  @override
  String get exploreMatchedEventsSectionTitle => '匹配的活动';

  @override
  String get exploreCreatedEventsSectionTitle => '已创建的活动';

  @override
  String get exploreHostFallbackName => '我';

  @override
  String get addPaypalEmailOrMobileHint => '电子邮箱或手机号码';

  @override
  String get orDividerLabel => '或';

  @override
  String get eventAdsLabel => '活动广告';

  @override
  String get paymentThankYouTitle => '谢谢！';

  @override
  String get paymentCompleteMessage => '您的付款已完成。';

  @override
  String get viewPaymentLabel => '查看付款';

  @override
  String get statusLabel => '状态';

  @override
  String get completedStatusLabel => '已完成';

  @override
  String get orderCodeLabel => '订单代码';

  @override
  String get dateTimeLabel => '日期和时间';

  @override
  String get exchangeRateLabel => '汇率';

  @override
  String get totalLabel => '总计';

  @override
  String get paymentProcessedByLabel => '付款处理方';

  @override
  String get sendPaymentTitle => '发送付款';

  @override
  String get sendPaymentInstructions => '要进行付款，请将 BTC 发送到以下地址';

  @override
  String get payWithWalletLabel => '使用钱包支付';

  @override
  String get amountLabel => '金额';

  @override
  String get copyLabel => '复制';

  @override
  String get btcAddressLabel => 'BTC 地址';

  @override
  String get payWithCoinbaseLabel => '使用 Coinbase 支付';

  @override
  String get selectCryptocurrencyLabel => '或选择一种加密货币';

  @override
  String get showMoreLabel => '显示更多';

  @override
  String get noSubscriptionTierAvailable => '暂无可用订阅等级。';

  @override
  String get signInBeforeSubscription => '开始订阅前请先登录。';

  @override
  String get subscriptionActivatedMessage => '订阅已激活';

  @override
  String purchaseFailedMessage(Object error) {
    return '购买失败：$error';
  }

  @override
  String get subscriptionCheckoutSessionFailed => '无法创建订阅结账会话。';

  @override
  String get subscribeLabel => '订阅';

  @override
  String get paymentCompleteShort => '付款完成';

  @override
  String get checkoutStartedMessage => '结账已开始';

  @override
  String get subscriptionCreatedMessage => '订阅已创建';

  @override
  String get signInToManageSubscription => '请登录以管理订阅。';

  @override
  String get unableToCancelSubscription => '目前无法取消订阅。';

  @override
  String get subscriptionCancellationRequested => '已请求取消订阅';

  @override
  String get unableToResumeSubscription => '目前无法恢复订阅。';

  @override
  String get subscriptionResumedMessage => '订阅已恢复';

  @override
  String get cryptoPaymentsComingSoon => '加密货币支付仍在接入实时结账流程中。';

  @override
  String get paymentLabel => '付款';

  @override
  String get amountToPayLabel => '应付金额';

  @override
  String get selectSubscriptionLabel => '选择订阅';

  @override
  String get monthlyLabel => '每月';

  @override
  String get yearlyLabel => '每年';

  @override
  String tierPlanBillingSummary(Object cycle, Object tierName) {
    return '$tierName 套餐 • $cycle 计费';
  }

  @override
  String get subscriptionPlansTitle => '订阅套餐';

  @override
  String get noSubscriptionTiersAvailable => '目前没有可用的订阅等级。';

  @override
  String get popularBadgeLabel => '热门';

  @override
  String get priceUnavailableLabel => '价格不可用';

  @override
  String get currentSubscriptionTitle => '当前订阅';

  @override
  String get signInCheckSubscriptionStatus => '登录以查看您的有效订阅状态。';

  @override
  String get noActiveSubscriptionFound => '尚未找到有效订阅。';

  @override
  String get planLabel => '套餐';

  @override
  String get unknownLabel => '未知';

  @override
  String get renewsEndsLabel => '续订 / 结束';

  @override
  String get cancellationLabel => '取消';

  @override
  String get scheduledForPeriodEndLabel => '计划在周期结束时执行';

  @override
  String get resumeSubscriptionLabel => '恢复订阅';

  @override
  String get cancelAtPeriodEndLabel => '在周期结束时取消';

  @override
  String get recentPaymentsTitle => '最近付款';

  @override
  String get paymentHistoryAfterSignIn => '登录后可查看付款历史。';

  @override
  String get noPaymentHistoryFound => '尚未找到付款历史。';

  @override
  String paymentIdFallback(Object id) {
    return '付款 $id';
  }

  @override
  String get providerUnknownLabel => '提供方未知';

  @override
  String get refreshDetailsLabel => '刷新详情';

  @override
  String get cryptoPaymentOptionsLabel => '加密货币付款选项';

  @override
  String get signInToSubscribeLabel => '登录以订阅';

  @override
  String get continueToCheckoutLabel => '继续结账';

  @override
  String get enterDiscountCodeHint => '输入折扣代码';

  @override
  String get addDiscountCodeFirstMessage => '请先添加折扣代码。';

  @override
  String get discountCodeValidatedAtCheckoutMessage => '折扣代码将在结账开始时验证。';

  @override
  String get applyLabel => '应用';

  @override
  String get authBannerSubscriptionMessage =>
      '您现在可以查看订阅套餐，但需要先登录，结账、取消或付款历史才能使用。';

  @override
  String get actionNotAllowedTitle => '不允许的操作';

  @override
  String get removeCardTitle => '移除银行卡';

  @override
  String get connectEscrowAccountLabel => '连接您的托管账户';

  @override
  String get subscriptionsTitle => '订阅';

  @override
  String get buyNowLabel => '立即购买';

  @override
  String get deactivateLabel => '停用';

  @override
  String get activateLabel => '启用';

  @override
  String get confirmCardDeletionTitle => '确认删除银行卡';

  @override
  String get eventDetailsTitle => '活动详情';

  @override
  String get eventNotFoundTitle => '未找到活动';

  @override
  String get eventNotFoundDescription => '找不到所请求的活动详情。';

  @override
  String get eventLocationLabel => '地点';

  @override
  String get capacityAvailabilityLabel => '容量和可用性';

  @override
  String capacityAvailabilitySummary(
      Object attendeeCount, Object capacity, Object spotsRemaining) {
    return '$attendeeCount / $capacity 位参与者（剩余 $spotsRemaining 个名额）';
  }

  @override
  String get turnOnSoundNotificationLabel => '开启声音通知';

  @override
  String get emailNotificationsLabel => '电子邮箱通知';

  @override
  String get medalBronzeTitle => '铜牌状态';

  @override
  String get medalBronzeDescription =>
      '用户在最近30天内创建了至少2个活动，或成功参加了至少2个活动。用户可获得任意1次应用内购买2%的折扣。';

  @override
  String get medalSilverTitle => '银牌状态';

  @override
  String get medalSilverDescription =>
      '用户在最近30天内创建了至少3个活动，或成功参加了至少3个活动。用户可获得任意1次应用内购买4%的折扣。';

  @override
  String get medalGoldTitle => '金牌状态';

  @override
  String get medalGoldDescription =>
      '用户在最近30天内创建了至少4个活动，或成功参加了至少4个活动。用户可获得任意1次应用内购买8%的折扣。';

  @override
  String get connectTvLabel => '连接电视';

  @override
  String get tvConnectedSuccessMessage => '电视连接成功。';

  @override
  String get couldNotConnectTvMessage => '无法连接此电视。';

  @override
  String get blogCommentAuthorYou => '您';

  @override
  String get blogCommentJustNow => '刚刚';

  @override
  String get discoverGoldBadgeLabel => '金';

  @override
  String get paymentDialogTitle => '付款';

  @override
  String get paymentAmountToPayLabel => '应付金额';

  @override
  String get paymentSelectSubscriptionLabel => '选择订阅';

  @override
  String get paymentPlanBulletSuffix => '套餐 •';

  @override
  String get paymentBillingSuffix => '计费';

  @override
  String get paymentYearlyLabel => '每年';

  @override
  String get paymentMonthlyLabel => '每月';

  @override
  String get paymentDiscountCodeHint => '输入折扣代码';

  @override
  String get paymentDiscountCodeEmptyMessage => '请先添加折扣代码。';

  @override
  String get paymentDiscountCodeValidationMessage => '折扣代码将在结账开始时验证。';

  @override
  String get paymentApplyLabel => '应用';

  @override
  String get paymentAuthBannerMessage => '您现在可以查看订阅套餐，但需要先登录，结账、取消或付款历史才能使用。';

  @override
  String get paymentSubscriptionPlansTitle => '订阅套餐';

  @override
  String get paymentNoTiersMessage => '目前没有可用的订阅等级。';

  @override
  String get paymentPopularBadgeLabel => '热门';

  @override
  String get paymentPriceUnavailableLabel => '价格不可用';

  @override
  String get paymentCurrentSubscriptionTitle => '当前订阅';

  @override
  String get paymentSignInToCheckStatusMessage => '登录以查看您的有效订阅状态。';

  @override
  String get paymentNoActiveSubscriptionMessage => '尚未找到有效订阅。';

  @override
  String get paymentStatusLabel => '状态';

  @override
  String get paymentPlanLabel => '套餐';

  @override
  String get paymentUnknownPlanLabel => '未知';

  @override
  String get paymentRenewsEndsLabel => '续订 / 结束';

  @override
  String get paymentCancellationLabel => '取消';

  @override
  String get paymentScheduledForPeriodEndLabel => '计划在周期结束时执行';

  @override
  String get paymentResumeSubscriptionLabel => '恢复订阅';

  @override
  String get paymentCancelAtPeriodEndLabel => '在周期结束时取消';

  @override
  String get paymentRecentPaymentsTitle => '最近付款';

  @override
  String get paymentHistoryAfterSignInMessage => '登录后可查看付款历史。';

  @override
  String get paymentNoHistoryMessage => '尚未找到付款历史。';

  @override
  String paymentFallbackDescription(String id) {
    return '付款 $id';
  }

  @override
  String get paymentProviderUnknownLabel => '提供方未知';

  @override
  String get paymentRefreshDetailsLabel => '刷新详情';

  @override
  String get paymentCryptoOptionsLabel => '加密货币付款选项';

  @override
  String get paymentSignInToSubscribeLabel => '登录以订阅';

  @override
  String get paymentContinueToCheckoutLabel => '继续结账';

  @override
  String get interestMovies => '电影';

  @override
  String get interestPubsAndBars => '酒吧';

  @override
  String get interestLiveShow => '现场表演';

  @override
  String get interestClubbing => '夜店';

  @override
  String get interestFestival => '节日';

  @override
  String get interestOutdoors => '户外';

  @override
  String get interestVolunteer => '志愿服务';

  @override
  String get interestDiy => 'DIY';

  @override
  String get interestActivism => '社会活动';

  @override
  String get interestPetLove => '宠物之爱';

  @override
  String get interestVideoGames => '电子游戏';

  @override
  String get interestFamilyActivities => '家庭活动';

  @override
  String get interestTech => '科技';

  @override
  String get interestCostume => '角色扮演';

  @override
  String get interestFoodie => '美食';

  @override
  String get interestCamping => '露营';

  @override
  String get medalBronzeSubtitle =>
      '用户在最近30天内创建了至少2个活动，或成功参加了至少2个活动。用户可获得任意1次应用内购买2%的折扣。';

  @override
  String get medalSilverSubtitle =>
      '用户在最近30天内创建了至少3个活动，或成功参加了至少3个活动。用户可获得任意1次应用内购买4%的折扣。';

  @override
  String get medalGoldSubtitle =>
      '用户在最近30天内创建了至少4个活动，或成功参加了至少4个活动。用户可获得任意1次应用内购买8%的折扣。';

  @override
  String get removeCardActionNotAllowedTitle => '不允许的操作';

  @override
  String get removeCardConnectEscrowLabel => '连接您的托管账户';

  @override
  String get removeCardSubscriptionsLabel => '订阅';

  @override
  String get removeCardConfirmDeletionTitle => '确认删除银行卡';

  @override
  String get myEventDetailsLabel => '活动详情';

  @override
  String get connectTvTitle => '连接电视';

  @override
  String get advertDialogTitle => '广告';

  @override
  String get advertEventStarts48hrs => '活动在48小时内开始';

  @override
  String get advertEventStarts7days => '活动在7天后开始';

  @override
  String get userAroundTitle => '附近用户';

  @override
  String get userAroundMessage => '目前找到符合您标准的潜在匹配';

  @override
  String get guestInviteTitle => '宾客邀请';

  @override
  String get inviteFriendsToKumeleTitle => '邀请您的朋友加入 Kumele';

  @override
  String get inviteReferralCodeLabel => '推荐码';

  @override
  String get congratulationsTitle => '恭喜';

  @override
  String get congratsNewStatusBronze => '新状态：铜牌';

  @override
  String get congratsDiscountCode => '折扣代码：KEMELE20';

  @override
  String get congratsBronzeDescription =>
      '您在最近30天内创建了至少3个活动，或成功参加了至少3个活动。用户可获得任意1次应用内购买4%的折扣。';

  @override
  String get passkeyIntroDescription =>
      '通行密钥易于设置，可让您使用设备的生物识别安全功能（如 Touch ID 和 Face ID）安全地登录您的 Kumele 账户。通行密钥比所有现有的双因素身份验证方法更安全、更易于使用。';

  @override
  String get passkeyTitle => '通行密钥';

  @override
  String get signInUsingPasskeyLabel => '使用通行密钥登录';

  @override
  String get signupPasskeyEmailHint => '输入您的电子邮箱';

  @override
  String get eventStartInLabel => '开始于';

  @override
  String get cancelEventTitle => '取消活动';

  @override
  String get setTimeTitle => '设置时间';

  @override
  String get guestPricesTitle => '宾客价格';

  @override
  String get guestPricesUnavailableMessage => '宾客价格目前不可用。';

  @override
  String get rewardRingsTitle => '奖励环';

  @override
  String get moneyEarnedTitle => '赚取的金额';

  @override
  String get tryAgainLabel => '重试';

  @override
  String get locationServicesOffTitle => '定位服务已关闭';

  @override
  String get locationAccessRequiredTitle => '需要位置访问权限';

  @override
  String get locationServicesOffMessage => '请在您的设备上启用定位服务，以发现您附近的活动。';

  @override
  String get locationPermissionPermanentlyDeniedMessage =>
      '位置权限已被永久拒绝。请在应用设置中启用。';

  @override
  String get locationAccessNeededMessage => '需要位置访问权限才能显示您附近的活动。';

  @override
  String get joinEventConfirmTitle => '加入此活动？';

  @override
  String get joinLabel => '加入';

  @override
  String get kumeleTermsOfUseLabel => 'Kumele 使用条款';

  @override
  String get eventCancelledDialogTitle => '活动已取消';

  @override
  String get eventCancelledDialogMessage =>
      '很遗憾，主办方取消了活动。给您带来不便，我们深表歉意。如已预付款项，请立即联系 PayPal 申请退款。';

  @override
  String get premiumPurchaseIncludeLabel => '高级应用内购买包括：';

  @override
  String get premiumLocationChange => '更改位置';

  @override
  String get premiumHouseParty => '家庭派对（最多10位宾客）';

  @override
  String get premiumNoAds => '无广告';

  @override
  String get premium7DaysAdvertising => '活动前7天广告推广';

  @override
  String get signupDateOfBirthLabel => '出生日期';

  @override
  String get signupGenderLabel => '性别';

  @override
  String get signUpButtonLabel => '注册';

  @override
  String myEventJoinedLabel(String date) {
    return '于 $date 加入';
  }

  @override
  String get myEventOrganizedByLabel => '由以下方组织';

  @override
  String get myEventDateTimeLabel => '日期和时间';

  @override
  String get myEventLocationLabel => '地点';

  @override
  String get myEventCapacityAvailabilityLabel => '容量和可用性';

  @override
  String get myEventAboutEventLabel => '关于活动';

  @override
  String get eventRulesTitle => '活动规则和信息';

  @override
  String eventRuleAgeLabel(String minAge, String maxAge) {
    return '年龄：$minAge - $maxAge';
  }

  @override
  String get eventRuleNoAgeLimitLabel => '无限制';

  @override
  String eventRuleGenderLabel(String gender) {
    return '性别：$gender';
  }

  @override
  String eventRuleLanguageLabel(String language) {
    return '语言：$language';
  }

  @override
  String get eventRuleRequiresApprovalLabel => '需要主办方批准';

  @override
  String get exploreMatchedEventLabel => '匹配的活动';

  @override
  String get exploreCreatedEventLabel => '已创建的活动';

  @override
  String get exploreJoinNowLabel => '立即加入';

  @override
  String get exploreSwipeNoMoreMatchesLine1 => '目前没有更多匹配，';

  @override
  String get exploreSwipeNoMoreMatchesLine2 => '在此之前';

  @override
  String get exploreSwipeCreateEventCta => '变得出色，创建一个活动';

  @override
  String get exploreSwipeBlogsSuggestion => '这里有一些您可能喜欢的博客';

  @override
  String get exploreSwipeInviteFriendsCta => '变得出色，邀请您的朋友';

  @override
  String get exploreNotificationsTitle => '通知';

  @override
  String get exploreTabletHeaderTitle => '探索';

  @override
  String get createEventTitle => '创建活动';

  @override
  String get previewEventLabel => '活动预览';

  @override
  String get createEventAgeRangeLabel => '年龄范围';

  @override
  String get createEventNumberOfGuestsLabel => '宾客人数';

  @override
  String get createEventRsvpGuestPaymentLabel => 'RSVP 宾客付款';

  @override
  String get createEventFreeEventLabel => '免费活动';

  @override
  String get createEventCardPaymentLabel => '银行卡付款';

  @override
  String get createEventCashOnEntryLabel => '入场现金支付';

  @override
  String get reportEventTitle => '举报活动';

  @override
  String get reportEventChooseReasonLabel => '选择原因';

  @override
  String get ratingsTitle => '评分';

  @override
  String get rateEventTitle => '评价活动';

  @override
  String get attendeeRatingsLabel => '参与者评分（70%）';

  @override
  String get blogNoCommentsMessage => '暂无评论。成为第一个评论的人！';

  @override
  String get nftPreviewTitle => 'NFT 预览';

  @override
  String get nftClosePreviewLabel => '关闭预览';

  @override
  String get walletSignatureRequiredTitle => '需要钱包签名';

  @override
  String get dismissLabel => '关闭';

  @override
  String get soundNotificationTurnOnLabel => '开启声音通知';

  @override
  String get soundNotificationLabel => '声音通知';

  @override
  String get turnOn2faLabel => '开启双因素身份验证';

  @override
  String get chooseInterestsTitle => '选择兴趣';

  @override
  String chooseUpToInterestsLabel(String count) {
    return '最多选择 $count 个兴趣：';
  }

  @override
  String get earnMedalsAndRewardsTitle => '赢取奖牌和奖励';

  @override
  String otherEventsFromHostLabel(String hostName) {
    return '$hostName 的其他活动';
  }

  @override
  String get hobbyMeetupTagline => '兴趣聚会';

  @override
  String get splashTagline => '我们玩耍。我们克服。我们团结。我们生活。';

  @override
  String get skipLabel => '跳过';

  @override
  String get guestTileGroupMeditationLabel => '集体冥想';

  @override
  String get guestTileHostedByLabel => '主办方：Anki Maheshwari';

  @override
  String get guestTileLocationLabel => '巴哈瓦尔布尔，旁遮普省，巴基斯坦';

  @override
  String get filterMockLocationLabel => '英国，39495，肯塔基州';

  @override
  String get historyTitle => '历史记录';

  @override
  String get historyStatisticsTitle => '历史记录和统计';

  @override
  String get blogDetailsTitle => '博客详情';

  @override
  String get addCardTitle => '添加银行卡';

  @override
  String get addCardStripeMessage => '银行卡信息由 Stripe 安全收集。';

  @override
  String get addCardSubmitLabel => '添加银行卡';

  @override
  String get noNotificationsTitle => '暂无通知';

  @override
  String get noNotificationsDescription => '您现在没有新通知。请稍后再查看。';

  @override
  String get reportReasonRacist => '种族歧视';

  @override
  String get reportReasonScam => '诈骗';

  @override
  String get reportReasonOther => '其他';

  @override
  String get reportReasonPhysicalAssault => '人身攻击';

  @override
  String get rateAppTitle => '请为您最近参加的活动评分';

  @override
  String get rateAppStoriesTitle => '评价此应用';

  @override
  String get rateAppThankYouTitle => '谢谢！';

  @override
  String get rateAppFeedbackTitle => '我们如何才能做得更好？';

  @override
  String get rateAppCommentHint => '添加评论';

  @override
  String get rateAppSendButton => '发送';

  @override
  String get chooseUsernameTitle => '选择您的用户名';

  @override
  String get chooseUsernameDescription => '用户名每 3 个月只能更改一次。';

  @override
  String get chooseUsernameHint => '输入您的用户名';

  @override
  String get chooseUsernameSkip => '跳过';

  @override
  String get guestInviteTotalGuests => '宾客总数';

  @override
  String get guestInviteFreeRange => '1–5 免费';

  @override
  String get guestInviteDialogOr => ' 或 ';

  @override
  String get signupLegalAdultCheckbox => '我已是成年人（18/21 岁以上）';

  @override
  String get signupSubscribeCheckbox => '订阅新闻通讯';

  @override
  String get signupTermsCheckboxPrefix => '创建账号即表示您同意';

  @override
  String get signupTermsCheckboxLink => '条款与条件';

  @override
  String get signupCaptchaCheckbox => '我不是机器人';

  @override
  String get signupErrorFirstNameRequired => '请输入您的名字';

  @override
  String get signupErrorEmailRequired => '请输入您的邮箱';

  @override
  String get signupErrorEmailInvalid => '请输入有效的邮箱地址';

  @override
  String get signupErrorPasswordRequired => '请输入密码';

  @override
  String get signupErrorPasswordTooShort => '密码长度至少为 6 个字符';

  @override
  String get signupErrorConfirmPasswordRequired => '请确认密码';

  @override
  String get signupErrorPasswordMismatch => '两次输入的密码不一致';

  @override
  String get signupErrorLegalAgeRequired => '您必须确认您已达到法定年龄';

  @override
  String get signupErrorTermsRequired => '您必须接受条款与条件';

  @override
  String get signupErrorCaptchaRequired => '请确认您不是机器人';

  @override
  String get permissionGuestInviteTitle => '宾客邀请';

  @override
  String get permissionEventCanceledTitle => '活动已取消';

  @override
  String get permissionFollowHostTitle => '关注主持人';

  @override
  String get permissionFollowHostConfirm => '关注';

  @override
  String get permissionUsernameHint => '输入用户名';

  @override
  String get exploreSwipeCreateEventButton => '创建活动';

  @override
  String get exploreSwipeReadBlogButton => '阅读博客';

  @override
  String get exploreSwipeInviteFriendsButton => '邀请好友';

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
  String get paymentMasterCardLabel => '万事达卡';

  @override
  String paymentCardExpiresLabel(String date) {
    return '有效期至 $date';
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
  String get socialMediaTwitter => '推特';

  @override
  String get termsSection1Title => '1. 账号资格';

  @override
  String get termsSection2Title => '2. 可接受的使用';

  @override
  String get termsSection3Title => '3. 活动与社区内容';

  @override
  String get termsSection4Title => '4. 支付与订阅';

  @override
  String get termsSection5Title => '5. 隐私与通信';

  @override
  String get termsSection6Title => '6. 终止';

  @override
  String get termsSection7Title => '7. 条款变更';

  @override
  String get nftClaimingButton => '正在领取…';

  @override
  String get nftBuyingButton => '正在购买…';

  @override
  String get nftClaimButton => '领取';

  @override
  String get nftBuyButton => '购买';

  @override
  String get languageUpdateFailed => '语言更新失败。';

  @override
  String get eventDetailNotFound => '找不到所请求的活动详情。';

  @override
  String myEventAttendeesLabel(int count, int capacity, int remaining) {
    return '$count / $capacity 名参与者（剩余 $remaining 个名额）';
  }

  @override
  String get shareEventDialogOr => ' 或 ';

  @override
  String aboutHostPrefix(String hostName) {
    return '关于 $hostName: ';
  }

  @override
  String get pleaseCompleteAllFields => '请填写所有字段';

  @override
  String get ratingSubmittedSuccess => '评分提交成功';

  @override
  String get ratingSubmitFailed => '评分提交失败';

  @override
  String get reportSubmittedSuccess => '举报提交成功';

  @override
  String get reportSubmitFailed => '举报提交失败';

  @override
  String get markAllAsRead => '全部标记为已读';

  @override
  String get paymentAddNewCardLabel => '添加新卡';

  @override
  String get paymentPayNowLabel => '立即支付';

  @override
  String get paymentPayWithLabel => '使用以下方式支付';

  @override
  String get useCurrentLocation => '使用当前位置';

  @override
  String get orEnterAnAddress => '或输入地址';

  @override
  String get openSettings => '打开设置';

  @override
  String get saveLocation => '保存位置';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get changeInterestsTitle => '修改兴趣';

  @override
  String get houseNumberLabel => '门牌号';

  @override
  String get districtCityLabel => '区 / 城市';

  @override
  String get permissionNotificationPrimerTitle => '“Kumele”想要向您发送推送通知';

  @override
  String get permissionNotificationPrimerMessage =>
      '通知可能包括提醒、声音和图标标记。可在“设置”中进行配置。';

  @override
  String get permissionPhotosPrimerTitle => '“Kumele”想要访问您的照片';

  @override
  String get permissionPhotosPrimerMessage => '允许“Kumele”访问您的照片以发送图片或视频';

  @override
  String get permissionLocationPrimerTitle => '允许“Kumele”访问您的位置？';

  @override
  String get permissionLocationPrimerMessage => '允许“Kumele”访问您的位置，以显示您附近的活动';

  @override
  String get permissionDontAllow => '不允许';

  @override
  String get permissionAllow => '允许';

  @override
  String get permissionSelectPhotos => '选择照片…';

  @override
  String get permissionAllowAllPhotos => '允许访问所有照片';

  @override
  String get permissionAllowWhileUsingApp => '使用App期间允许';

  @override
  String get permissionAllowOnce => '允许一次';

  @override
  String get myEventPlaceholderTitle => '兴趣活动标题';

  @override
  String get myEventPlaceholderTime => '12:00-13:00';

  @override
  String get myEventPlaceholderStartTime => '2天后开始';

  @override
  String get myEventPlaceholderLocation => '市中心，柏林';

  @override
  String get welcomeToKumeleMessage => '欢迎使用 Kumele！';

  @override
  String get selectDateTimeFirstError => '请先选择日期和时间。';

  @override
  String get accountCreatedSuccessMessage => '账户创建成功！';

  @override
  String signupFailedPrefix(String error) {
    return '注册失败：$error';
  }

  @override
  String get nftClaimedMessage => 'NFT 已领取。';

  @override
  String get nftClaimFailedError => '无法领取此 NFT。';

  @override
  String get nftPurchasedMessage => 'NFT 已购买。';

  @override
  String get nftPurchaseFailedError => '无法购买此 NFT。';

  @override
  String get loadBlogPostFailedError => '无法加载博客文章。';

  @override
  String get paypalAccountConnectedMessage => 'PayPal 账户已连接。';

  @override
  String get restoringPurchasesMessage => '正在恢复购买——可能需要一点时间。';

  @override
  String get cardSetupUnavailableError => '银行卡设置不可用。';

  @override
  String get cardAddedSuccessMessage => '银行卡添加成功。';

  @override
  String get addCardFailedError => '无法添加银行卡。';

  @override
  String get copiedMessage => '已复制';

  @override
  String get eventCreatedPendingPaymentMessage => '活动已创建。完成付款以激活它。';

  @override
  String get eventCreatedSuccessMessage => '活动创建成功。';
}
