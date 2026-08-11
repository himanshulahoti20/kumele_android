import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/legal/widgets/faq_content.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

class FaqPage extends StatelessWidget implements BasePage {
  const FaqPage({super.key});

  @override
  String get screenName => 'FAQ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet.bgColor,
      body: WidgetByDevice(
        tablet: _buildTablet(context),
        phone: Container(
          color: ColorSet.bg3Color,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  const MobileHeader(label: 'FAQ'),
                  const Gap(22),
                  Expanded(
                    child: SingleChildScrollView(
                      child: FaqContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTablet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorSet.bg3Color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: KumeleAssetWidget.square(
                      assetPath: IconSet.arrowleft,
                      size: 25,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Gap(40),
                  Text(
                    'FAQ',
                    style: context.textTheme.headlineSmallBold.copyWith(
                      fontSize: 30,
                      color: ColorSet.textColor,
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 0.5, color: ColorSet.border),
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: FaqContent(),
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
