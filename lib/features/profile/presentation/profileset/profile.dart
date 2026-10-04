import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/cubit/profile_cubit.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/profile_page_bloc.dart';
import 'package:kuemele/features/profile/presentation/profileset/presentation/widgets/profile_header_section.dart';
import 'package:kuemele/features/profile/presentation/profileset/presentation/widgets/profile_settings_section.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/switch.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/modals/dialog/sign_out_dialog.dart';
import 'package:kuemele/shared/services/ads/ad_consent_service.dart';
import 'package:kuemele/shared/services/share/referral_share_helper.dart';
import 'package:kuemele/shared/utils/logout_helper.dart';

class Profile extends StatefulWidget implements BasePage {
  const Profile({super.key, this.thisIsDLG});

  final bool? thisIsDLG;

  @override
  State<Profile> createState() => _ProfileState();

  @override
  String get screenName => 'Profile';
}

class _ProfileState extends State<Profile> {
  ProfilePageBloc get _profilePageBloc => InjectionHelper.profilePageBloc;

  @override
  void initState() {
    super.initState();
    // Refetch on every tab entry (cache still paints instantly via
    // ProfilePageRefresh below) — a direct one-shot call, not routed
    // through ProfilePageRefresh, since that's re-dispatched by the
    // BlocConsumer listener below on every ProfileCubit emission.
    InjectionHelper.profileCubit.loadUserData();
    _profilePageBloc.add(const ProfilePageRefresh());
  }

  void _openFollowers({String? selectedTab}) {
    context.push(
      AppRoutes.followers,
      extra: FollowersRouteArgs(selectedTab: selectedTab),
    );
  }

  void _onStatTap(ProfileStatItem stat) {
    final l10n = AppLocalizations.of(context)!;
    if (stat.label == l10n.goldStatus) return;

    _openFollowers(
      selectedTab:
          stat.label == l10n.following ? l10n.following : l10n.followers,
    );
  }

  void _onEditProfile() => context.push(AppRoutes.editProfile);

  void _onHobbiesTap() {
    context.push(
      AppRoutes.interestedHobbies,
      extra: const InterestedHobbiesRouteArgs(isFromSignUp: false),
    );
  }

  void _handleSettingTap(ProfileSettingItem item) {
    switch (item.action) {
      case ProfileSettingAction.notifications:
        context.push(AppRoutes.soundNotification);
      case ProfileSettingAction.languages:
        context.push(AppRoutes.languages);
      case ProfileSettingAction.cardPayments:
        context.push(AppRoutes.profilePayment);
      case ProfileSettingAction.security:
        context.push(AppRoutes.security);
      case ProfileSettingAction.contact:
        context.push(AppRoutes.contact);
      case ProfileSettingAction.guidelines:
        context.push(AppRoutes.communityGuidelines);
      case ProfileSettingAction.referFriend:
        ReferralShareHelper.shareFromContext(context);
      case ProfileSettingAction.termsAndConditions:
        context.push(AppRoutes.termsAndConditions);
      case ProfileSettingAction.privacyChoices:
        _openPrivacyChoices();
      case ProfileSettingAction.nightMode:
        _profilePageBloc.add(const ProfilePageThemeToggled());
      case ProfileSettingAction.deleteAccount:
        context.push(AppRoutes.deleteAccount);
      case ProfileSettingAction.signOut:
        SignOutDialog.show(
          context,
          // Matches iOS: PopUpSignOutView shows nothing after sign-out
          // completes, so this call site opts out of the generic
          // post-logout success toast.
          onSignOut: () => LogoutHelper.doLogout(
            context,
            showSuccessMessage: false,
          ),
        );
    }
  }

  // Matches iOS's ProfileView_iPhone/iPad: false means there's nothing to
  // show (not required for this user/region, or the form failed to load),
  // so the tap gets visible feedback instead of silently doing nothing.
  Future<void> _openPrivacyChoices() async {
    final shown = await AdConsentService.instance.showPrivacyChoices();
    if (!shown && mounted) {
      InjectionHelper.snackBar.showError(
        'There are no additional privacy choices to show for your account right now.',
      );
    }
  }

  Widget? _buildSettingTrailing(ProfileSettingItem item) {
    if (item.action != ProfileSettingAction.nightMode) return null;

    return RASwitch(
      value: InjectionHelper.profileCubit.isDark,
      valueOnColor: Colors.white,
      valueOnThumbColor: '#959595'.toColor(),
      onTap: () => _profilePageBloc.add(const ProfilePageThemeToggled()),
      size: Size(25.r, 18.r),
    );
  }

  Widget _buildBody(ProfilePageState pageState) {
    final userData = pageState.userData;

    return ResponsiveDeviceBuilder(
      tablet: _buildTabletBody(pageState, userData),
      phone: _buildPhoneBody(pageState, userData),
    );
  }

  Widget _buildPhoneBody(ProfilePageState pageState, userData) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 19.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(16.h),
            Text(
              AppLocalizations.of(context)!.profileTitle,
              style: context.textTheme.headlineSmallBold.copyWith(
                color: ColorSet.textColor,
                fontSize: 23.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gap(8.h),
            Expanded(child: _buildScrollableContent(pageState, userData)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletBody(ProfilePageState pageState, userData) {

    return Padding(
      padding: EdgeInsets.only(top: 35.h),
      child: _buildScrollableContent(pageState, userData),
    );
  }

  // iOS iPad: min(screenWidth - 32, max) centered; phone fills the padding.
  Widget _tabletWidth(double max, {required Widget child, double inset = 0}) {
    if (context.responsive.isPhone) return child;
    final w = MediaQuery.sizeOf(context).width - 32;
    return SizedBox(width: (w < max ? w : max) - inset, child: child);
  }

  Widget _buildScrollableContent(ProfilePageState pageState, userData) {
    final responsive = context.responsive;
    final fullName = [
      userData?.fullname,
      userData?.displayName,
      userData?.username,
      userData?.email,
    ].whereType<String>().firstWhere(
          (value) => value.trim().isNotEmpty,
          orElse: () => '',
        );

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: responsive.isPhone
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        spacing: 8.h,
        children: [
          _tabletWidth(
            675,
            inset: 38,
            child: ProfileHeaderSection(
              fullName: fullName,
              email: userData?.email ?? '',
              aboutMe: userData?.aboutMe ?? '',
              profilePicture: userData?.profilePicture,
              qrData: pageState.qrCodeInfo?.qrCodeUrl,
              profileStats: pageState.profileStats,
              onEditTap: _onEditProfile,
              onHobbiesTap: _onHobbiesTap,
              onStatTap: _onStatTap,
            ),
          ),
          Gap(11.h),
          if (responsive.isPhone)
            Text(
              AppLocalizations.of(context)!.settingsTitle,
              style: context.textTheme.headlineSmallBold.copyWith(
                color: ColorSet.textColor,
                fontSize: 19.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          _tabletWidth(
            652,
            child: Column(
              spacing: 24.h,
              children: [
                ProfileSettingsSection(
                  items: pageState.primarySettings,
                  onItemTap: _handleSettingTap,
                ),
                ProfileSettingsSection(
                  items: pageState.secondarySettings,
                  onItemTap: _handleSettingTap,
                  trailingBuilder: _buildSettingTrailing,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: ChuckerFlutter.showChuckerScreen,
              icon: const Icon(Icons.terminal),
              label: const Text('Chucker'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: InjectionHelper.profileCubit,
      listener: (context, state) {
        _profilePageBloc.add(const ProfilePageRefresh());
      },
      builder: (context, _) {
        return BlocBuilder<ProfilePageBloc, ProfilePageState>(
          builder: (context, pageState) {
            return Scaffold(
              backgroundColor: ColorSet.bg3Color,
              body: _buildBody(pageState),
            );
          },
        );
      },
    );
  }
}
