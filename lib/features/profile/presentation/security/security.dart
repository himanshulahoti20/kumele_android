import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/core/theme/app_radius.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/profile_page_bloc.dart';
import 'package:kuemele/features/profile/presentation/profileset/presentation/widgets/profile_setting_tile.dart';
import 'package:kuemele/features/profile/presentation/security/security_config.dart';
import 'package:kuemele/features/profile/presentation/security/widgets/two_factor_auth_bottom_sheet.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/camera_scanner_page.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/authen/authen_repo.dart';
import 'package:kuemele/shared/widgets/app_divider.dart';
import 'package:kuemele/shared/widgets/app_loading_indicator.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';

class Security extends StatelessWidget implements BasePage {
  const Security({super.key});

  @override
  String get screenName => 'Security';

  void _handleSettingTap(
    BuildContext context,
    SecuritySettingItem item,
    ProfilePageBloc bloc,
    ProfilePageState state,
  ) {
    switch (item.action) {
      case SecuritySettingAction.changePassword:
        context.push(AppRoutes.changePassword);
      case SecuritySettingAction.registerPasskey:
        bloc.add(const ProfilePagePasskeyRegisterRequested());
      case SecuritySettingAction.connectTv:
        _scanAndClaimDevice(context);
      case SecuritySettingAction.twoFactorAuth:
        _showTwoFactorSheet(context, state, bloc);
    }
  }

  Future<void> _scanAndClaimDevice(BuildContext context) async {
    final code = await AppBottomSheet.show<String>(
      context: context,
      title: AppLocalizations.of(context)!.connectTvTitle,
      child: const CameraScannerSheet(),
    );
    if (code == null || code.trim().isEmpty) return;

    try {
      await AuthenRepo.claimDevice(code.trim());
      InjectionHelper.snackBar.showSuccess(
          AppLocalizations.of(context)!.tvConnectedSuccessMessage);
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? 'Could not connect this TV.');
    } catch (_) {
      InjectionHelper.snackBar
          .showError(AppLocalizations.of(context)!.couldNotConnectTvMessage);
    }
  }

  void _showTwoFactorSheet(
    BuildContext context,
    ProfilePageState state,
    ProfilePageBloc bloc,
  ) {
    TwoFactorAuthBottomSheet.show(
      context: context,
      isEnabled: state.twoFactorEnabled,
    );
  }

  VoidCallback? _settingOnTap(
    SecuritySettingItem item,
    ProfilePageState state,
    ProfilePageBloc bloc,
    BuildContext context,
  ) {
    if (item.action == SecuritySettingAction.twoFactorAuth) {
      if (!state.twoFactorEnabled) return null;
      return () => _showTwoFactorSheet(context, state, bloc);
    }

    if (state.isPasskeyRegistering &&
        item.action == SecuritySettingAction.registerPasskey) {
      return null;
    }

    return () => _handleSettingTap(context, item, bloc, state);
  }

  Widget? _buildTwoFactorTrailing(
    BuildContext context,
    ProfilePageState state,
    ProfilePageBloc bloc,
  ) {
    if (state.twoFactorEnabled) {
      return KumeleAssetWidget.square(
        assetPath: ProfileConfig.arrowRightIcon,
        size: 28.r,
      );
    }

    return AppButton.primarySmall(
      label: AppLocalizations.of(context)!.setup,
      onPressed: () => _showTwoFactorSheet(context, state, bloc),
    );
  }

  Widget? _buildSettingTrailing(
    BuildContext context,
    SecuritySettingItem item,
    ProfilePageState state,
    ProfilePageBloc bloc,
  ) {
    switch (item.action) {
      case SecuritySettingAction.twoFactorAuth:
        return _buildTwoFactorTrailing(context, state, bloc);
      case SecuritySettingAction.registerPasskey:
        if (!state.isPasskeyRegistering) return null;
        return AppLoadingIndicator.circle();
      case SecuritySettingAction.connectTv:
        return null;
      case SecuritySettingAction.changePassword:
        return null;
    }
  }

  Widget _buildSettingsSection(
    BuildContext context,
    ProfilePageState state,
    ProfilePageBloc bloc,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: ColorSet.profileTileFillColor,
        borderRadius: BorderRadius.circular(AppRadius.md.r),
      ),
      child: Column(
        children: [
          for (var i = 0; i < state.securitySettings.length; i++) ...[
            if (i > 0) const AppDivider.horizontal(),
            ProfileSettingTile(
              title: state.securitySettings[i].title,
              iconPath: state.securitySettings[i].iconPath,
              showTrailingArrow: state.securitySettings[i].action !=
                      SecuritySettingAction.twoFactorAuth &&
                  state.securitySettings[i].showTrailingArrow,
              trailing: _buildSettingTrailing(
                context,
                state.securitySettings[i],
                state,
                bloc,
              ),
              onTap: _settingOnTap(
                state.securitySettings[i],
                state,
                bloc,
                context,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfilePageBloc, ProfilePageState>(
      bloc: InjectionHelper.profilePageBloc,
      listenWhen: (previous, current) =>
          previous.successMessage != current.successMessage ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        final successMessage = state.successMessage;
        final errorMessage = state.errorMessage;

        if (successMessage != null) {
          InjectionHelper.snackBar.showSuccess(successMessage);
        }
        if (errorMessage != null) {
          InjectionHelper.snackBar.showError(errorMessage);
        }

        if (successMessage != null || errorMessage != null) {
          InjectionHelper.profilePageBloc
              .add(const ProfilePageFeedbackCleared());
        }
      },
      builder: (context, state) {
        final bloc = InjectionHelper.profilePageBloc;

        return Scaffold(
          backgroundColor: ColorSet.bg3Color,
          body: SafeArea(
            child: ResponsivePadding(
              phone: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Column(
                children: [
                  MobileHeader(label: AppLocalizations.of(context)!.security),
                  Gap(22.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildSettingsSection(context, state, bloc),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
