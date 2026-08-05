import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/category.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/list.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/base/base_page.dart';

import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class AddCardDialog extends StatefulWidget implements BasePage {
  const AddCardDialog({super.key});

  @override
  State<AddCardDialog> createState() => _AddCardDialogState();

  @override
  String get screenName => 'AddCardDialog';
}

class _AddCardDialogState extends State<AddCardDialog> {
  TextEditingController cardHolderName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController cvc = TextEditingController();
  GlobalKey key = GlobalKey();
  String selectedCategory = '';
  int selectedCountry = 0;

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
    double width = sizeW(188);
    double height = size(550);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(size(40)),
        decoration: BoxDecoration(
          color: ColorSet.bg2Color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: sizeW(70)),
                Text('Add card', style: context.textTheme.heading3.copyWith(fontWeight: FontWeight.w700)),
                SizedBox(width: sizeW(60)),
                GestureDetector(
                  onTap: () {
                    pop(context);
                  },
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: Image.asset(
                      IconSet.closeIcon,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size(40)),
            Text('Country', style: context.textTheme.bodyMedium),
            SizedBox(height: size(5)),
            country(width),
            SizedBox(height: size(20)),
            Text('Cardholder\'s name', style: context.textTheme.bodyMedium),
            KumeleTextField(
              controller: cardHolderName,
              hintText: "Jane Doe",
            ),
            SizedBox(height: size(20)),
            Text('Card number', style: context.textTheme.bodyMedium),
            KumeleTextField(
              controller: cardNumber,
              hintText: "•••• •••• •••• 4234",
              suffixIcon: Icon(
                Icons.remove_red_eye,
                size: size(20),
                color: Colors.grey,
              ),
            ),
            SizedBox(height: size(20)),
            bottomPart(width),
            SizedBox(height: size(30)),
            Padding(
              padding: EdgeInsets.only(left: size(418)),
              child: GestureDetector(
                onTap: () {
                  InjectionHelper.snackBar.showSuccess('Card Add successful');
                },
                child: Container(
                  width: 160,
                  height: size(45),
                  decoration: BoxDecoration(
                    color: ColorSet.revbg3Color,
                    borderRadius: BorderRadius.circular(size(8)),
                  ),
                  child: Center(
                    child: Text('Add Card', style: context.textTheme.bodySmall.copyWith(color: ColorSet.bg2Color, fontSize: 13)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.all(size(20)),
          decoration: BoxDecoration(
            color: ColorSet.bg2Color,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Add card', style: context.textTheme.bodySmallBold.copyWith(fontWeight: FontWeight.w700)),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      pop(context);
                    },
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: Image.asset(
                        IconSet.closeIcon,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size(20)),

              // Form Fields
              Text('Country', style: context.textTheme.labelSmall),
              SizedBox(height: size(5)),
              country(width),
              SizedBox(height: size(10)),

              Text('Cardholder\'s name', style: context.textTheme.labelSmall),
              KumeleTextField(
                controller: cardHolderName,
                hintText: "Jane Doe",
              ),
              SizedBox(height: size(10)),

              Text('Card number', style: context.textTheme.labelSmall),
              KumeleTextField(
                controller: cardNumber,
                hintText: "•••• •••• •••• 4234",
                suffixIcon: Icon(
                  Icons.remove_red_eye,
                  size: size(20),
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: size(10)),

              // Date and CVC
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Expiry date', style: context.textTheme.labelSmall),
                        KumeleTextField(
                          controller: date,
                          hintText: "MM-YY",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: size(10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CVC', style: context.textTheme.labelSmall),
                        KumeleTextField(
                          controller: cvc,
                          hintText: "MM-YY",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: size(20)),

              // Add Card Button
              Center(
                child: GestureDetector(
                  onTap: () {
                    InjectionHelper.snackBar.showSuccess('Card Add successful');
                  },
                  child: Container(
                    width: width * 0.4,
                    height: size(35),
                    decoration: BoxDecoration(
                      color: ColorSet.revbg3Color,
                      borderRadius: BorderRadius.circular(size(8)),
                    ),
                    child: Center(
                      child: Text('Add Card', style: context.textTheme.labelSmall.copyWith(color: ColorSet.bg2Color)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size(10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget country(double width) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    List<String> codeList = mobileCodeList.map((map) => map.name).toList();
    return RACategory(
      globalKey: key,
      categories: codeList,
      selectedCategory: codeList[selectedCountry],
      onChanged: (String val) {
        setState(() {
          selectedCountry = codeList.indexOf(val);
        });
      },
      size: Size(width, size(isPortrait ? 30 : 45)),
      textAlignt: TextAlign.left,
      hintText: 'Country',
    );
  }

  Widget bottomPart(double width) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expiry date', style: context.textTheme.bodyMedium),
            KumeleTextField(
              controller: date,
              hintText: "MM-YY",
            ),
          ],
        ),
        SizedBox(width: size(10)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CVC', style: context.textTheme.bodyMedium),
            KumeleTextField(
              controller: cvc,
              hintText: "MM-YY",
            ),
          ],
        ),
      ],
    );
  }
}
