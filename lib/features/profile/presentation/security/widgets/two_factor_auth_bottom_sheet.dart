import 'package:flutter/material.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/two_factor_disable_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/two_factor_setup_bloc.dart';
import 'package:kuemele/features/profile/presentation/security/widgets/two_factor_disable_content.dart';
import 'package:kuemele/features/profile/presentation/security/widgets/two_factor_setup_content.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';

class TwoFactorAuthBottomSheet {
  TwoFactorAuthBottomSheet._();

  static Future<void> show({
    required BuildContext context,
    required bool isEnabled,
  }) {
    if (isEnabled) {
      InjectionHelper.twoFactorDisableBloc.add(const TwoFactorDisableOpened());

      return AppBottomSheet.show<void>(
        context: context,
        title: AppLocalizations.of(context)!.twoFactorDisableTitle,
        subtitle: AppLocalizations.of(context)!.twoFactorDisableSubtitle,
        child: const TwoFactorDisableContent(),
      );
    }

    InjectionHelper.twoFactorSetupBloc.add(const TwoFactorSetupOpened());

    return AppBottomSheet.show<void>(
      context: context,
      title: AppLocalizations.of(context)!.twoFactorSetupTitle,
      scrollable: true,
      child: const TwoFactorSetupContent(),
    );
  }
}
