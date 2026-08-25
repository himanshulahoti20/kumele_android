import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class GuidelinePageLayout extends StatelessWidget {
  const GuidelinePageLayout({
    super.key,
    required this.child,
    this.onWillPop,
  });

  final Widget child;
  final Future<bool> Function()? onWillPop;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
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
                  const MobileHeader(label: ''),
                  const Gap(22),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (onWillPop == null) return scaffold;

    return WillPopScope(
      onWillPop: onWillPop,
      child: scaffold,
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
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        InjectionHelper.homePageCubit
                            .onTapTab(context, HomeTabType.home);
                      }
                    },
                    child: KumeleAssetWidget.square(
                      assetPath: IconSet.arrowleft,
                      size: 25,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 0.5, color: ColorSet.border),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: child,
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
