import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/features/profile/presentation/card/completed.dart';

import 'package:kuemele/shared/components/radio.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class PayWithWalletDialog extends StatefulWidget {
  const PayWithWalletDialog({super.key});

  @override
  State<PayWithWalletDialog> createState() => _PayWithWalletDialogState();
}

class _PayWithWalletDialogState extends State<PayWithWalletDialog> {
  TextEditingController discountCodeCTRL = TextEditingController();
  bool soundNotification = false;
  String selectedGender = '';

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          // Keep original landscape layout exactly as is
          return _buildLandscapeLayout(context);
        } else {
          // Portrait layout
          return _buildPortraitLayout(context);
        }
      },
    );
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
          height: 530,
          width: defaultWidth,
          padding: EdgeInsets.all(size(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: sizeW(55)),
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset(IconSet.celebrateIcon),
                  ),
                  SizedBox(width: sizeW(5)),
                  Text(AppLocalizations.of(context)!.eventAdsLabel, style: context.textTheme.titleLarge.copyWith(fontSize: 20)),
                  SizedBox(width: sizeW(49)),
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
              SizedBox(height: size(40)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Image.asset(IconSet.celebrateIcon),
                  ),
                  SizedBox(width: sizeW(2)),
                  Text(AppLocalizations.of(context)!.eventAdsLabel, style: context.textTheme.bodyLarge),
                  SizedBox(width: sizeW(115)),
                  GestureDetector(
                    onTap: () {
                      pop(context);
                    },
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: Image.asset(
                        IconSet.dropDownIcon,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.totalLabel, style: context.textTheme.bodyMedium),
                      Text('\$23.07', style: context.textTheme.heading3.copyWith(color: const Color(0xFF004DFF), fontWeight: FontWeight.w700)),
                    ],
                  ),
                  SizedBox(width: size(165)),
                  SizedBox(width: sizeW(22)),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        barrierColor: ColorSet.bcColor,
                        context: context,
                        builder: (context) => CompletedPayDialog(),
                      );
                    },
                    child: Container(
                      width: sizeW(60),
                      height: size(45),
                      decoration: BoxDecoration(
                        color: ColorSet.revertBgColor,
                        borderRadius: BorderRadius.circular(size(5)),
                      ),
                      child: Center(
                        child: Text(AppLocalizations.of(context)!.payWithCoinbaseLabel, style: context.textTheme.bodyMedium.copyWith(color: ColorSet.bg2Color)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size(5)),
              Text(AppLocalizations.of(context)!.selectCryptocurrencyLabel, style: context.textTheme.bodySmall.copyWith(fontSize: 13)),
              SizedBox(height: size(10)),
              cardPart1(defaultWidth),
              SizedBox(height: size(5)),
              Padding(
                padding: EdgeInsets.only(left: size(445)),
                child: Text(AppLocalizations.of(context)!.showMoreLabel, style: context.textTheme.bodySmall.copyWith(color: ColorSet.specialBlueColor, fontSize: 13)),
              ),
              SizedBox(height: size(20)),
              Row(
                children: [
                  SizedBox(width: size(115)),
                  Text(AppLocalizations.of(context)!.paymentProcessedByLabel, style: context.textTheme.bodySmall.copyWith(color: Colors.grey, fontSize: 13)),
                  Text(' Coinbase Commerce', style: context.textTheme.bodySmall.copyWith(color: ColorSet.specialBlueColor, fontSize: 13))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double defaultWidth = width * 0.7;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: sizeW(10),
        vertical: size(10),
      ),
      backgroundColor: ColorSet.bg2Color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size(20)),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: defaultWidth,
          padding: EdgeInsets.all(size(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: width * 0.23),
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset(IconSet.celebrateIcon),
                  ),
                  SizedBox(width: sizeW(5)),
                  Text(AppLocalizations.of(context)!.eventAdsLabel, style: context.textTheme.bodySmall),
                  SizedBox(width: width * 0.2),
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

              // Event Ads with dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 15,
                        width: 15,
                        child: Image.asset(IconSet.celebrateIcon),
                      ),
                      SizedBox(width: sizeW(5)),
                      Text(AppLocalizations.of(context)!.eventAdsLabel, style: context.textTheme.labelSmall.copyWith(fontSize: 10)),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: Image.asset(
                      IconSet.dropDownIcon,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size(20)),

              // Total and Pay with Coinbase
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.totalLabel, style: context.textTheme.labelSmall.copyWith(fontSize: 10)),
                      Text('\$23.07', style: context.textTheme.bodyMediumBold.copyWith(color: const Color(0xFF004DFF), fontWeight: FontWeight.w700)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        barrierColor: ColorSet.bcColor,
                        context: context,
                        builder: (context) => CompletedPayDialog(),
                      );
                    },
                    child: Container(
                      width: width * 0.22,
                      height: size(35),
                      decoration: BoxDecoration(
                        color: ColorSet.revertBgColor,
                        borderRadius: BorderRadius.circular(size(5)),
                      ),
                      child: Center(
                        child: Text(AppLocalizations.of(context)!.payWithCoinbaseLabel, style: context.textTheme.labelSmall.copyWith(color: ColorSet.bg2Color, fontSize: 10)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size(10)),

              Text(AppLocalizations.of(context)!.selectCryptocurrencyLabel, style: context.textTheme.bodySmall),
              SizedBox(height: size(10)),

              // Card section
              cardPart1(defaultWidth),
              SizedBox(height: size(10)),

              // Show more
              Align(
                alignment: Alignment.centerRight,
                child: Text(AppLocalizations.of(context)!.showMoreLabel, style: context.textTheme.labelSmall.copyWith(color: ColorSet.specialBlueColor, fontSize: 10)),
              ),
              SizedBox(height: size(20)),

              // Footer
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.paymentProcessedByLabel, style: context.textTheme.labelSmall.copyWith(color: Colors.grey, fontSize: 10)),
                    Text(' Coinbase Commerce', style: context.textTheme.labelSmall.copyWith(color: ColorSet.specialBlueColor, fontSize: 10))
                  ],
                ),
              ),
              SizedBox(height: size(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardPart1(double defaultWidth) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Container(
      width: defaultWidth,
      decoration: BoxDecoration(
        color: ColorSet.bg6Color,
        borderRadius: BorderRadius.circular(size(8)),
        boxShadow: [
          BoxShadow(
            color: ColorSet.bg7Color,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedGender = '⬤⬤⬤⬤ ⬤⬤⬤⬤ ⬤⬤⬤⬤ 1234';
              });
            },
            child: Padding(
              padding: EdgeInsets.all(size(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RARadio(
                    onChanged: (value, isSelected) {
                      setState(() {
                        selectedGender = '⬤⬤⬤⬤ ⬤⬤⬤⬤ ⬤⬤⬤⬤ 1234';
                      });
                    },
                    value: '⬤⬤⬤⬤ ⬤⬤⬤⬤ ⬤⬤⬤⬤ 1234',
                    textSize: size(16),
                    radioSize: size(isPortrait ? 16 : 20),
                    groupValue: selectedGender,
                  ),
                  SizedBox(width: sizeW(2)),
                  SizedBox(
                    height: size(30),
                    width: size(30),
                    child: Image.asset(IconSet.etherum),
                  ),
                  SizedBox(width: 10),
                  Text('Ethereum', style: context.textTheme.bodyLarge),
                ],
              ),
            ),
          ),
          Divider(color: ColorSet.profileBorderColor),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedGender = '⬤⬤⬤⬤ ⬤⬤⬤⬤ ⬤⬤⬤⬤ 1234';
              });
            },
            child: Padding(
              padding: EdgeInsets.all(size(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RARadio(
                    onChanged: (value, isSelected) {
                      setState(() {
                        selectedGender = '⬤⬤⬤⬤ ⬤⬤⬤⬤ ⬤⬤⬤⬤ 1234';
                      });
                    },
                    value: '⬤⬤⬤⬤ ⬤⬤⬤⬤ ⬤⬤⬤⬤ 1234',
                    textSize: size(16),
                    radioSize: size(isPortrait ? 16 : 20),
                    groupValue: selectedGender,
                  ),
                  SizedBox(width: sizeW(2)),
                  SizedBox(
                    height: size(30),
                    width: size(30),
                    child: Image.asset(IconSet.doge),
                  ),
                  SizedBox(width: 10),
                  Text('Dogecoin', style: context.textTheme.bodyLarge),
                ],
              ),
            ),
          ),
          Divider(color: ColorSet.profileBorderColor),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedGender = '⬤⬤⬤⬤ ⬤⬤⬤⬤ ⬤⬤⬤⬤ 1234';
              });
            },
            child: Padding(
              padding: EdgeInsets.all(size(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RARadio(
                    onChanged: (value, isSelected) {},
                    value: '⬤⬤⬤⬤ ⬤⬤⬤⬤ ⬤⬤⬤⬤ 1234',
                    textSize: size(16),
                    radioSize: size(isPortrait ? 16 : 20),
                    groupValue: selectedGender,
                  ),
                  SizedBox(width: sizeW(2)),
                  SizedBox(
                    height: size(30),
                    width: size(30),
                    child: Image.asset(IconSet.usdcoin),
                  ),
                  SizedBox(width: 10),
                  Text('USD Coin', style: context.textTheme.bodyLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
