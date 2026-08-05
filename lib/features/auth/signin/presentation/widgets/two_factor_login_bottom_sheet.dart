import 'package:flutter/material.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/auth/bloc/auth_bloc.dart';
import 'package:kuemele/features/auth/signin/presentation/widgets/two_factor_login_content.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';

class TwoFactorLoginBottomSheet {
  TwoFactorLoginBottomSheet._();

  static Future<void> show({required BuildContext context}) {
    return AppBottomSheet.show<void>(
      context: context,
      title: AppStrings.twoFactorLoginTitle,
      subtitle: AppStrings.twoFactorLoginSubtitle,
      isDismissible: false,
      dragToClose: false,
      onClose: () => getIt<AuthBloc>().add(const AuthTwoFactorCancelled()),
      child: const TwoFactorLoginContent(),
    ).whenComplete(() {
      final authState = getIt<AuthBloc>().state;
      if (authState.status == AuthStatus.twoFactorRequired) {
        getIt<AuthBloc>().add(const AuthTwoFactorCancelled());
      }
    });
  }
}
