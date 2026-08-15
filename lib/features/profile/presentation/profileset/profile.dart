import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
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
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
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
      case ProfileSettingAction.myEvents:
        context.push(AppRoutes.myEvents);
      case ProfileSettingAction.notifications:
        context.push(AppRoutes.soundNotification);
      case ProfileSettingAction.languages:
        context.push(AppRoutes.languages);
      case ProfileSettingAction.cardPayments:
        context.push(AppRoutes.removeCard);
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
      case ProfileSettingAction.faq:
        context.push(AppRoutes.faq);
      case ProfileSettingAction.nightMode:
        _profilePageBloc.add(const ProfilePageThemeToggled());
      case ProfileSettingAction.deleteAccount:
        context.push(AppRoutes.deleteAccount);
      case ProfileSettingAction.signOut:
        AppDialog.confirm(
          context: context,
          width: AppDialogSize.widthFor(context),
          title: AppLocalizations.of(context)!.signOutConfirmTitle,
          confirmText: AppLocalizations.of(context)!.signOut,
          popOnConfirm: false,
          onConfirmAsync: () => LogoutHelper.doLogout(context),
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
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
            Gap(16.h),
            Expanded(child: _buildScrollableContent(pageState, userData)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletBody(ProfilePageState pageState, userData) {
    final responsive = context.responsive;

    return ResponsiveContent(
      child: Container(
        alignment: Alignment.topCenter,
        width: responsive.screenSize.width * (responsive.isPortrait ? 1 : 0.7),
        padding: EdgeInsets.all(40.r),
        child: _buildScrollableContent(pageState, userData),
      ),
    );
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
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: responsive.isPhone ? 22.h : 24.h,
        children: [
          ProfileHeaderSection(
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
          if (responsive.isPhone)
            Text(
              AppLocalizations.of(context)!.settingsTitle,
              style: context.textTheme.headlineSmallBold.copyWith(
                color: ColorSet.textColor,
                fontSize: 23.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          Column(
            spacing: 12.h,
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
          if (kDebugMode)
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
