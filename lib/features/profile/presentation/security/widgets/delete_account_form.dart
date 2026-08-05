import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/delete_account_bloc.dart';
import 'package:kuemele/shared/components/app_checkbox.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';

class DeleteAccountForm extends StatelessWidget {
  const DeleteAccountForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
      buildWhen: (previous, current) =>
          previous.confirmation != current.confirmation ||
          previous.isSubmitting != current.isSubmitting,
      builder: (context, state) {
        final bloc = context.read<DeleteAccountBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.deleteAccountPageSubtitle,
              style: context.textTheme.bodyMedium.copyWith(
                color: ColorSet.subTextColor,
              ),
            ),
            Gap(24.h),
            KumeleTextField.password(
              labelText: AppStrings.deleteAccountPasswordLabel,
              hintText: AppStrings.deleteAccountPasswordHint,
              textInputAction: TextInputAction.next,
              enabled: !state.isSubmitting,
              onChanged: (value) =>
                  bloc.add(DeleteAccountPasswordChanged(value)),
            ),
            Gap(24.h),
            KumeleTextArea(
              labelText: AppStrings.deleteAccountReasonLabel,
              hintText: AppStrings.deleteAccountReasonHint,
              minLines: 4,
              maxLines: 6,
              enabled: !state.isSubmitting,
              onChanged: (value) => bloc.add(DeleteAccountReasonChanged(value)),
            ),
            Gap(24.h),
            AppCheckbox.label(
              value: state.confirmation,
              text: AppStrings.deleteAccountConfirmationLabel,
              onChanged: state.isSubmitting
                  ? (_) {}
                  : (value) =>
                      bloc.add(DeleteAccountConfirmationChanged(value)),
            ),
            Gap(16.h),
          ],
        );
      },
    );
  }
}
