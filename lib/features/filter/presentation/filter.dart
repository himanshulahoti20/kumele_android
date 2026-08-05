import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/limiter.dart';
import 'package:kuemele/shared/components/switch.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

import 'package:kuemele/shared/components/size.dart';

class Filter extends StatefulWidget implements BasePage {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();

  @override
  String get screenName => 'Filter';
}

class _FilterState extends State<Filter> {
  TextEditingController discountCodeCTRL = TextEditingController();
  bool soundNotification = false;
  String selectedGender = '';

  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: buildTablet(context),
      phone: Scaffold(
        backgroundColor: ColorSet.bg3Color,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                MobileHeader(label: 'Filter'),
                Gap(22),
                Expanded(
                  child: SingleChildScrollView(child: buildContent()),
                ),
                buildButtonApply()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTablet(BuildContext context) {
    return Center(
      child: Container(
        height: 580,
        width: 600,
        padding: EdgeInsets.fromLTRB(40, 30, 40, 30),
        decoration: BoxDecoration(
          color: ColorSet.bg3Color,
          borderRadius: BorderRadius.circular(size(19)), // Rounded corners
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Gap(29),
                Text('Filter', style: context.textTheme.titleLargeBold),
                GestureDetector(
                  onTap: () {
                    pop(context);
                  },
                  child: Image.asset(IconSet.closeIcon, width: 29, height: 29),
                ),
              ],
            ),
            Gap(40),
            Expanded(
              child: SingleChildScrollView(
                child: buildContent(),
              ),
            ),
            Gap(15),
            buildButtonApply()
          ],
        ),
      ),
    );
  }

  Widget buildButtonApply() {
    return Align(
      alignment: Alignment.centerRight,
      child: AppButton.primary(
        onPressed: () {},
        label: 'Apply',
      ),
    );
  }

  Widget buildContent() {
    final double horizontalPadding = FormFactor.isTablet ? 48 : 20;
    final sectionColor = FormFactor.isTablet ? ColorSet.tileFillColor : null;
    final inputColor =
        FormFactor.isTablet ? ColorSet.bg3Color : ColorSet.tileFillColor;
    return Column(
      spacing: 15,
      children: [
        Container(
          padding:
              EdgeInsets.symmetric(vertical: 13, horizontal: horizontalPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size(10)),
            color: sectionColor,
          ),
          child: Column(
            spacing: 14,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Current Location', style: context.textTheme.bodyLarge),
                  Text(
                    'Change',
                    style: context.textTheme.bodyLargeBold.copyWith(
                      color: ColorSet.specialYellowColor,
                    ),
                  ),
                ],
              ),
              WidgetByDevice(
                tablet: Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: buildCountryInput(inputColor),
                    ),
                    Expanded(
                      child: buildZipInput(inputColor),
                    ),
                    Expanded(
                      child: buildStateInput(inputColor),
                    ),
                  ],
                ),
                phone: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 47,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    buildCountryInput(inputColor),
                    buildZipInput(inputColor),
                    buildStateInput(inputColor),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Image.asset(IconSet.location,
                        width: 20, height: 20, color: ColorSet.textColor),
                  ),
                  Gap(10),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          'United Kingdom, 39495, kentucky',
                          style: context.textTheme.bodyLarge,
                        )),
                        Gap(10),
                        Image.asset(IconSet.doneIcon, width: 48, height: 48),
                        RASwitch(
                          value: soundNotification,
                          onTap: () {
                            setState(() {
                              soundNotification = !soundNotification;
                            });
                          },
                          size: Size(size(25), size(18)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(28),
            ],
          ),
        ),
        Container(
          padding:
              EdgeInsets.symmetric(vertical: 13, horizontal: horizontalPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size(10)),
            color: sectionColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Distance range (in Kilometers)',
                  style: context.textTheme.bodyLarge),
              Gap(20),
              RALimiter(
                bgWidth: 500,
              ),
              Gap(20),
              Text(
                'Age range',
                style: context.textTheme.bodyMedium.copyWith(fontSize: 14.29),
              ),
              Gap(20),
              RALimiter(
                bgWidth: 500,
              ),
              Gap(20),
              Row(
                children: [
                  Text('PaidEvent', style: context.textTheme.bodyMedium),
                  Spacer(),
                  RASwitch(
                    value: soundNotification,
                    onTap: () {
                      setState(() {
                        soundNotification = !soundNotification;
                      });
                    },
                    size: Size(size(25), size(18)),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  KumeleTextField buildStateInput(Color inputColor) {
    return KumeleTextField(
      controller:
          TextEditingController(), // Replace with appropriate controller
      hintText: "State",
      fillColor: inputColor,
      borderRadius: 5,
    );
  }

  KumeleTextField buildZipInput(Color inputColor) {
    return KumeleTextField(
      controller:
          TextEditingController(), // Replace with appropriate controller
      hintText: "Postal/Zip Code",
      fillColor: inputColor,
      borderRadius: 5,
    );
  }

  KumeleTextField buildCountryInput(Color inputColor) {
    return KumeleTextField(
      controller:
          TextEditingController(), // Replace with appropriate controller
      hintText: "Country",
      fillColor: inputColor,
      borderRadius: 5,
    );
  }
}
