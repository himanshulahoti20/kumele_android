import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/edit_profile_bloc.dart';
import 'package:kuemele/features/profile/presentation/profileset/presentation/widgets/edit_profile_form.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();
    InjectionHelper.editProfileBloc.add(const EditProfileInit());
  }

  @override
  Widget build(BuildContext context) {
    return const EditProfileDialog();
  }
}

class EditProfileDialog extends StatelessWidget implements BasePage {
  const EditProfileDialog({super.key});

  @override
  String get screenName => 'EditProfileDialog';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: _onStateChanged,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorSet.bg3Color,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
              child: Column(
                children: [
                  MobileHeader(
                      label: AppLocalizations.of(context)!.editProfileTitle),
                  Gap(22.h),
                  Expanded(child: _buildBody(context, state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onStateChanged(BuildContext context, EditProfileState state) {
    final errorMessage = state.errorMessage;
    if (errorMessage != null && errorMessage.isNotEmpty) {
      InjectionHelper.snackBar.showError(errorMessage);
    }

    if (state.status == EditProfileStatus.success) {
      InjectionHelper.snackBar.showSuccess(
        AppLocalizations.of(context)!.editProfileSuccessMessage,
      );
      if (context.canPop()) {
        context.pop();
      }
    }
  }

  Widget _buildBody(BuildContext context, EditProfileState state) {
    return Column(
      children: [
        const Expanded(
          child: SingleChildScrollView(
            child: EditProfileForm(),
          ),
        ),
        _buildUpdateButton(context, state),
      ],
    );
  }

  Widget _buildUpdateButton(BuildContext context, EditProfileState state) {
    final username = state.username.trim();
    final originalUsername = state.originalUsername.trim();
    final isUsernameValid = username.isEmpty ||
        username == originalUsername ||
        state.isUsernameAvailable == true;

    return AppButton.primary(
      label: AppLocalizations.of(context)!.editProfileUpdateLabel,
      fullWidth: true,
      isLoading: state.isSubmitting,
      onPressed: state.isSubmitting ||
              !state.isInitialized ||
              state.isCheckingUsername ||
              !isUsernameValid
          ? null
          : () =>
              context.read<EditProfileBloc>().add(const EditProfileSubmit()),
    );
  }
}
