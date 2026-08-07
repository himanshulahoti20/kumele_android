import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/features/profile/presentation/card/pay_with_wallet.dart';

import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class PayWithCryptoDialog extends StatefulWidget {
  const PayWithCryptoDialog({super.key});

  @override
  State<PayWithCryptoDialog> createState() => _PayWithCryptoDialogState();
}

class _PayWithCryptoDialogState extends State<PayWithCryptoDialog> {
  TextEditingController discountCodeCTRL = TextEditingController();
  bool soundNotification = false;
  String selectedGender = '';

  @override
  Widget build(BuildContext context) {
    return _buildLandscapeLayout(context);
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double defaultWidth = width * 0.45;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: sizeW(20),
        vertical: size(20),
      ),
      backgroundColor: ColorSet.bg2Color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size(20)),
      ),
      child: SingleChildScrollView(
        child: Container(
          height: 550,
          width: defaultWidth,
          padding: EdgeInsets.all(size(50)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(25),
                  Spacer(),
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset(IconSet.celebrateIcon),
                  ),
                  SizedBox(width: sizeW(2)),
                  Text(AppLocalizations.of(context)!.eventAdsLabel, style: context.textTheme.titleLarge.copyWith(fontSize: 20)),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      pop(context);
                    },
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: Image.asset(
                        IconSet.closeIcon,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size(20)),
              Text(AppLocalizations.of(context)!.sendPaymentTitle, style: context.textTheme.titleMediumSemiBold.copyWith(fontWeight: FontWeight.w600)),
              Text(AppLocalizations.of(context)!.sendPaymentInstructions, style: context.textTheme.bodyMedium.copyWith(color: ColorSet.textColor)),
              SizedBox(height: size(20)),
              cardPart1(defaultWidth),
              SizedBox(height: size(15)),
              SizedBox(
                width: defaultWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: size(100)),
                    Expanded(
                      child: Container(
                        color: ColorSet.textColor,
                        height: size(0.3),
                      ),
                    ),
                    SizedBox(width: size(20)),
                    Text(AppLocalizations.of(context)!.orDividerLabel, style: context.textTheme.bodyMedium.copyWith(fontSize: 15)),
                    SizedBox(width: size(20)),
                    Expanded(
                      child: Container(
                        color: ColorSet.textColor,
                        height: size(0.3),
                      ),
                    ),
                    SizedBox(width: size(100)),
                  ],
                ),
              ),
              SizedBox(height: size(30)),
              Padding(
                padding: EdgeInsets.only(left: size(170)),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      barrierColor: ColorSet.bcColor,
                      context: context,
                      builder: (context) => PayWithWalletDialog(),
                    );
                  },
                  child: Container(
                    width: 140,
                    height: size(45),
                    decoration: BoxDecoration(
                      color: ColorSet.revbg3Color,
                      borderRadius: BorderRadius.circular(size(8)),
                    ),
                    child: Center(
                      child: Text(AppLocalizations.of(context)!.payWithWalletLabel, style: context.textTheme.bodyMedium.copyWith(color: ColorSet.bg2Color, fontSize: 15)),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size(212),
                    top: size(30),
                  ),
                  child: Text(AppLocalizations.of(context)!.cancel, style: context.textTheme.bodyMedium.copyWith(fontSize: 15)),
                ),
              ),
              SizedBox(height: size(25)),
              Row(
                children: [
                  SizedBox(width: size(85)),
                  Text(AppLocalizations.of(context)!.paymentProcessedByLabel, style: context.textTheme.bodyMedium.copyWith(color: ColorSet.textColor)),
                  Gap(2),
                  Text(' Coinbase Commerce', style: context.textTheme.bodyMedium.copyWith(color: ColorSet.lightBlueColor))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget cardPart1(double defaultWidth) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorSet.bg7Color,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(size(8)),
        border: Border.all(color: ColorSet.profileBorderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(size(12)),
            child: Row(
              children: [
                Text(AppLocalizations.of(context)!.amountLabel, style: context.textTheme.bodyLarge),
                Spacer(),
                Text('0.00079 BTC', style: context.textTheme.bodyMediumSemiBold.copyWith(fontWeight: FontWeight.w600)),
                Gap(8),
                Text(AppLocalizations.of(context)!.copyLabel, style: context.textTheme.bodyMedium.copyWith(color: ColorSet.lightBlueColor)),
              ],
            ),
          ),
          Divider(color: ColorSet.profileBorderColor),
          Padding(
            padding: EdgeInsets.all(size(10)),
            child: Row(
              children: [
                Text(AppLocalizations.of(context)!.btcAddressLabel, style: context.textTheme.bodyLarge),
                Spacer(),
                Text('0xfffDFDFdf', style: context.textTheme.bodyMediumSemiBold.copyWith(fontWeight: FontWeight.w600)),
                Gap(8),
                Text(AppLocalizations.of(context)!.copyLabel, style: context.textTheme.bodyMedium.copyWith(color: ColorSet.lightBlueColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
