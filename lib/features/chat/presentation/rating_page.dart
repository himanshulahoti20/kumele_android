import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/close_keyboard_widget.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/rating.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class RatingPage extends StatefulWidget implements BasePage {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();

  @override
  String get screenName => 'RatingPage';
}

class _RatingPageState extends State<RatingPage> {
  final _commentController = TextEditingController();
  final Map<RatingType, double> ratingSummaryData = {
    RatingType.communication: 0,
    RatingType.respect: 0,
    RatingType.professional: 0,
    RatingType.atmosphere: 0,
    RatingType.value: 0,
  };

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void goBack() {
    if (FormFactor.isTablet) {
      InjectionHelper.homePageCubit.goBack(context);
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        InjectionHelper.homePageCubit.onTapTab(context, HomeTabType.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        goBack();
      },
      child: Scaffold(
        backgroundColor: ColorSet.bgColor,
        body: WidgetByDevice(
          tablet: buildTablet(),
          phone: Container(
            color: ColorSet.bg3Color,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(26, 16, 26, 0),
                child: Column(
                  children: [
                    MobileHeader(label: 'Rating'),
                    const Gap(22),
                    Expanded(
                      child: SingleChildScrollView(child: buildContent()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTablet() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorSet.bg3Color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: goBack,
                    child: KumeleAssetWidget(
                      assetPath: IconSet.arrowleft,
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Gap(40),
                  const Text(
                    "Ratings",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Divider(thickness: 0.5, color: Colors.grey[200]),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: buildContent(),
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget buildContent() {
    return CloseKeyboard(
      child: SizedBox(
        width: FormFactor.isTablet ? Utils.getLongestSide * 0.45 : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate Event',
              style: context.textTheme.bodyMediumBold
                  .copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.justify,
              overflow: TextOverflow.visible,
            ),
            Gap(size(10)),
            Text(
              "Attendee Ratings (70%)",
              style: context.textTheme.bodySmallSemiBold.copyWith(
                color: ColorSet.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(15),
            RARatingSummary(
              ratingSummaryData: ratingSummaryData,
              showValue: false,
              onChanged: (type, star) {
                setState(() {
                  ratingSummaryData[type] = star;
                });
              },
            ),
            Gap(size(10)),
            Text(
              'Comment',
              style: context.textTheme.bodyMediumBold
                  .copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.justify,
              overflow: TextOverflow.visible,
            ),
            Gap(size(10)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: ColorSet.bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Add Comments",
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                  labelStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Gap(size(45)),
            AppButton.primary(
              onPressed: () {
                context.pop();
              },
              width: FormFactor.isTablet ? 300 : null,
              fullWidth: !FormFactor.isTablet,
              label: 'Send',
            ),
          ],
        ),
      ),
    );
  }
}
