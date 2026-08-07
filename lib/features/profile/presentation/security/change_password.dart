import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/change_password_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/widgets/change_password_form.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/utils/logout_helper.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  void initState() {
    super.initState();
    InjectionHelper.changePasswordBloc.add(const ChangePasswordOpened());
  }

  @override
  Widget build(BuildContext context) {
    return const ChangePasswordDialog();
  }
}

class ChangePasswordDialog extends StatelessWidget implements BasePage {
  const ChangePasswordDialog({super.key});

  @override
  String get screenName => 'ChangePasswordDialog';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
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
                  MobileHeader(label: AppLocalizations.of(context)!.changePassword),
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

  void _onStateChanged(BuildContext context, ChangePasswordState state) {
    final errorMessage = state.errorMessage;
    if (errorMessage != null && errorMessage.isNotEmpty) {
      InjectionHelper.snackBar.showError(errorMessage);
    }

    if (state.status == ChangePasswordStatus.success) {
      InjectionHelper.snackBar.showSuccess(
        AppLocalizations.of(context)!.changePasswordSuccessMessage,
      );
      LogoutHelper.doLogout(context, showSuccessMessage: false);
    }
  }

  Widget _buildBody(BuildContext context, ChangePasswordState state) {
    return Column(
      children: [
        const Expanded(
          child: SingleChildScrollView(
            child: ChangePasswordForm(),
          ),
        ),
        _buildSubmitButton(context, state),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, ChangePasswordState state) {
    return AppButton.primary(
      label: AppLocalizations.of(context)!.changePasswordSubmitLabel,
      fullWidth: true,
      isLoading: state.isSubmitting,
      onPressed: state.isSubmitting
          ? null
          : () => context
              .read<ChangePasswordBloc>()
              .add(const ChangePasswordSubmitted()),
    );
  }
}
