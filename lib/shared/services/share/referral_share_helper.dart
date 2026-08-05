import 'package:flutter/material.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/service_locator.dart';

class ReferralShareHelper {
  ReferralShareHelper._();

  static Future<void> shareFromContext(BuildContext context) async {
    final referral = InjectionHelper.profileCubit.referralInfo;

    if (referral == null || !referral.isValid) {
      InjectionHelper.snackBar.show(AppStrings.referralCodeUnavailable);
      return;
    }

    await InjectionHelper.shareService.shareReferral(
      referralCode: referral.referralCode,
      referralLink: referral.referralLink,
      sharePositionOrigin: InjectionHelper.shareService.shareOriginFor(context),
    );
  }
}
