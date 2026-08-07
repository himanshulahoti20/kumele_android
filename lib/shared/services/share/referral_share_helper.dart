import 'package:flutter/material.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class ReferralShareHelper {
  ReferralShareHelper._();

  static Future<void> shareFromContext(BuildContext context) async {
    final referral = InjectionHelper.profileCubit.referralInfo;

    if (referral == null || !referral.isValid) {
      InjectionHelper.snackBar.show(AppLocalizations.of(context)!.referralCodeUnavailable);
      return;
    }

    await InjectionHelper.shareService.shareReferral(
      referralCode: referral.referralCode,
      referralLink: referral.referralLink,
      sharePositionOrigin: InjectionHelper.shareService.shareOriginFor(context),
    );
  }
}
