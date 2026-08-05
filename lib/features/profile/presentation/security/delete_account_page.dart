import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/delete_account_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/widgets/delete_account_form.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/utils/logout_helper.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  @override
  void initState() {
    super.initState();
    InjectionHelper.deleteAccountBloc.add(const DeleteAccountOpened());
  }

  @override
  Widget build(BuildContext context) {
    return const DeleteAccountView();
  }
}

class DeleteAccountView extends StatelessWidget implements BasePage {
  const DeleteAccountView({super.key});

  @override
  String get screenName => 'DeleteAccount';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
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
                  MobileHeader(label: AppStrings.deleteAccount),
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

  void _onStateChanged(BuildContext context, DeleteAccountState state) {
    final errorMessage = state.errorMessage;
    if (errorMessage != null && errorMessage.isNotEmpty) {
      InjectionHelper.snackBar.showError(errorMessage);
    }

    if (state.status == DeleteAccountStatus.success) {
      InjectionHelper.snackBar.showSuccess(
        state.successMessage ?? AppStrings.deleteAccountSuccessMessage,
      );
      LogoutHelper.handleLogout(context: context);
    }
  }

  Widget _buildBody(BuildContext context, DeleteAccountState state) {
    return Column(
      children: [
        const Expanded(
          child: SingleChildScrollView(
            child: DeleteAccountForm(),
          ),
        ),
        _buildSubmitButton(context, state),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, DeleteAccountState state) {
    return AppButton.primary(
      label: AppStrings.deleteAccountSubmitLabel,
      isLoading: state.isSubmitting,
      onPressed: state.isSubmitting
          ? null
          : () => context
              .read<DeleteAccountBloc>()
              .add(const DeleteAccountSubmitted()),
    );
  }
}
