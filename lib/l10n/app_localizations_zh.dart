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
  String get daysLeftToRate => '还剩 -- 天可评分和\n评价';

  @override
  String get scannedList => '扫描列表：--';

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
  String get groupMeditation => '集体冥想';

  @override
  String get demoHostName => 'Ankit Maheswari';

  @override
  String get demoLocation => '巴哈瓦尔布尔，巴基斯坦旁遮普省';

  @override
  String get signIn => '登录';

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
