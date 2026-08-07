import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';

import 'package:kuemele/shared/components/radio.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class CompletedPayDialog extends StatefulWidget {
  const CompletedPayDialog({super.key});

  @override
  State<CompletedPayDialog> createState() => _CompletedPayDialogState();
}

class _CompletedPayDialogState extends State<CompletedPayDialog> {
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
          height: 480,
          width: defaultWidth,
          padding: EdgeInsets.all(size(50)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: sizeW(50)),
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset(IconSet.celebrateIcon),
                  ),
                  SizedBox(width: sizeW(2)),
                  Text(AppLocalizations.of(context)!.eventAdsLabel, style: context.textTheme.titleLarge.copyWith(fontSize: 20)),
                  SizedBox(width: sizeW(42)),
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
              SizedBox(
                height: size(70),
                width: size(100),
                child: Image.asset(
                  IconSet.logoImage,
                  fit: BoxFit.cover,
                ),
              ),
              Text(AppLocalizations.of(context)!.paymentThankYouTitle, style: context.textTheme.titleMediumSemiBold.copyWith(color: ColorSet.textColor, fontWeight: FontWeight.w600)),
              Text(AppLocalizations.of(context)!.paymentCompleteMessage, style: context.textTheme.bodySmall.copyWith(color: Colors.grey[600], fontSize: 13)),
              Text(AppLocalizations.of(context)!.viewPaymentLabel, style: context.textTheme.bodySmall.copyWith(color: ColorSet.specialBlueColor, fontSize: 13)),
              SizedBox(height: size(10)),
              SizedBox(
                width: width * 0.4,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.statusLabel, style: context.textTheme.bodySmall.copyWith(color: ColorSet.textColor, fontSize: 13)),
                        Text(AppLocalizations.of(context)!.completedStatusLabel, style: context.textTheme.bodySmall.copyWith(color: ColorSet.specialBlueColor, fontSize: 13)),
                      ],
                    ),
                    SizedBox(height: size(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.orderCodeLabel, style: context.textTheme.bodySmall.copyWith(color: ColorSet.textColor, fontSize: 13)),
                        Text('79VGFGVD', style: context.textTheme.bodySmall.copyWith(color: ColorSet.textColor, fontSize: 13)),
                      ],
                    ),
                    SizedBox(height: size(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.dateTimeLabel, style: context.textTheme.bodySmall.copyWith(color: ColorSet.textColor, fontSize: 13)),
                        Text('Feb 2,2021 10:24 AM', style: context.textTheme.bodySmall.copyWith(color: ColorSet.textColor, fontSize: 13)),
                      ],
                    ),
                    SizedBox(height: size(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.exchangeRateLabel, style: context.textTheme.bodySmall.copyWith(color: ColorSet.textColor, fontSize: 13)),
                        Text('1 BTC 33.644 USD', style: context.textTheme.bodySmall.copyWith(color: ColorSet.textColor, fontSize: 13)),
                      ],
                    ),
                    SizedBox(height: size(10)),
                    Divider(thickness: 0.3),
                    SizedBox(height: size(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.totalLabel, style: context.textTheme.bodySmallSemiBold.copyWith(color: ColorSet.textColor, fontWeight: FontWeight.w600)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('\$16.129', style: context.textTheme.bodySmallSemiBold.copyWith(color: ColorSet.textColor, fontWeight: FontWeight.w600)),
                            Text('0.43BTC', style: context.textTheme.bodySmall.copyWith(color: ColorSet.textColor, fontSize: 13)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: size(24)),
                    Row(
                      children: [
                        SizedBox(width: size(100)),
                        Text(AppLocalizations.of(context)!.paymentProcessedByLabel, style: context.textTheme.bodySmall.copyWith(color: Colors.grey, fontSize: 13)),
                        Text(' Coinbase Commerce', style: context.textTheme.bodySmall.copyWith(color: ColorSet.specialBlueColor, fontSize: 13)),
                      ],
                    )
                  ],
                ),
              ),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset(IconSet.celebrateIcon),
                  ),
                  SizedBox(width: sizeW(5)),
                  Text(AppLocalizations.of(context)!.eventAdsLabel, style: context.textTheme.titleLarge.copyWith(fontSize: 20)),
                  SizedBox(width: width * 0.15),
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

              // Logo and Thank You message
              SizedBox(
                height: size(70),
                width: size(100),
                child: Image.asset(
                  IconSet.logoImage,
                  fit: BoxFit.cover,
                ),
              ),
              Text(AppLocalizations.of(context)!.paymentThankYouTitle, style: context.textTheme.titleMediumSemiBold.copyWith(color: ColorSet.textColor, fontWeight: FontWeight.w600)),
              Text(AppLocalizations.of(context)!.paymentCompleteMessage, style: context.textTheme.bodySmall.copyWith(color: Colors.grey[600], fontSize: 13)),
              Text(AppLocalizations.of(context)!.viewPaymentLabel, style: context.textTheme.bodySmall.copyWith(color: ColorSet.specialBlueColor, fontSize: 13)),
              SizedBox(height: size(20)),

              // Payment details
              Container(
                width: defaultWidth * 0.8,
                child: Column(
                  children: [
                    _buildDetailRow(AppLocalizations.of(context)!.statusLabel, AppLocalizations.of(context)!.completedStatusLabel,
                        valueColor: ColorSet.specialBlueColor),
                    SizedBox(height: size(10)),
                    _buildDetailRow(AppLocalizations.of(context)!.orderCodeLabel, '79VGFGVD'),
                    SizedBox(height: size(10)),
                    _buildDetailRow(AppLocalizations.of(context)!.dateTimeLabel, 'Feb 2,2021 10:24 AM'),
                    SizedBox(height: size(10)),
                    _buildDetailRow(AppLocalizations.of(context)!.exchangeRateLabel, '1 BTC 33.644 USD'),
                    SizedBox(height: size(10)),
                    Divider(thickness: 0.3),
                    SizedBox(height: size(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.totalLabel, style: context.textTheme.bodySmallSemiBold.copyWith(color: ColorSet.textColor, fontWeight: FontWeight.w600)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('\$16.129', style: context.textTheme.bodySmallSemiBold.copyWith(color: ColorSet.textColor, fontWeight: FontWeight.w600)),
                            Text('0.43BTC', style: context.textTheme.bodySmall.copyWith(color: ColorSet.textColor, fontSize: 13)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: size(24)),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.paymentProcessedByLabel, style: context.textTheme.bodySmall.copyWith(color: Colors.grey, fontSize: 13)),
                  Text(' Coinbase Commerce', style: context.textTheme.bodySmall.copyWith(color: ColorSet.specialBlueColor, fontSize: 13)),
                ],
              ),
              SizedBox(height: size(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.textTheme.bodySmall.copyWith(color: ColorSet.textColor, fontSize: 13)),
        Text(value, style: context.textTheme.bodySmall.copyWith(color: valueColor ?? ColorSet.textColor, fontSize: 13)),
      ],
    );
  }

  Widget cardPart1(double defaultWidth) {
    return Card(
      elevation: 5,
      child: Container(
        width: defaultWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size(8)),
          border: Border.all(color: ColorSet.profileBorderColor),
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
                        radioSize: size(20),
                        groupValue: selectedGender,
                      ),
                      SizedBox(width: sizeW(2)),
                      SizedBox(
                        height: size(30),
                        width: size(30),
                        child: Image.asset(IconSet.etherum),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Ethereum', style: context.textTheme.bodyLarge),
                    ]),
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
                        radioSize: size(20),
                        groupValue: selectedGender,
                      ),
                      SizedBox(width: sizeW(2)),
                      SizedBox(
                        height: size(30),
                        width: size(30),
                        child: Image.asset(IconSet.doge),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Dogecoin', style: context.textTheme.bodyLarge),
                    ]),
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
                        radioSize: size(20),
                        groupValue: selectedGender,
                      ),
                      SizedBox(width: sizeW(2)),
                      SizedBox(
                        height: size(30),
                        width: size(30),
                        child: Image.asset(IconSet.usdcoin),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('USD Coin', style: context.textTheme.bodyLarge),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
