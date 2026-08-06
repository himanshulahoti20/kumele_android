import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class WelcomeNotificationDialog extends StatefulWidget {
  const WelcomeNotificationDialog({
    super.key,
  });

  @override
  State<WelcomeNotificationDialog> createState() =>
      _WelcomeNotificationDialogState();
}

class _WelcomeNotificationDialogState extends State<WelcomeNotificationDialog> {
  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: buildTablet(),
      phone: AppTitledDialog(
        header: Container(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => context.pop(),
            child: KumeleAssetWidget(
              assetPath: SVGAsset.icon_close,
              width: 30,
              height: 30,
              color: ColorSet.textColor,
            ),
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                IconSet.welcomebanner,
                height: Utils.getHeight * 0.25,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            mainView(),
            buildCreateEventButton(),
          ],
        ),
      ),
    );
  }

  Widget buildTablet() {
    return AppScrollDialog(
      showClose: true,
      footer: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: buildCreateEventButton(),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              IconSet.welcomebanner,
              height: Utils.getHeight * 0.25,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          mainView(),
        ],
      ),
    );
  }

  Widget buildCreateEventButton() {
    return GestureDetector(
      onTap: () {
        context.pop();
        if (FormFactor.isTablet) {
          InjectionHelper.homePageCubit
              .onTapTab(context, HomeTabType.createEvent);
        } else {
          context.push(AppRoutes.createEvent);
        }
      },
      child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size(10)),
            color: ColorSet.revertBgColor,
          ),
          child: Center(
            child: Text("Create Event",
                style: context.textTheme.bodyLarge
                    .copyWith(color: ColorSet.bg2Color)),
          )),
    );
  }

  Widget mainView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size(12)),
        Text("Welcome to Kuemele",
            style: context.textTheme.headlineSmallBold
                .copyWith(fontSize: 26, fontWeight: FontWeight.w700)),
        Gap(4),
        Text("23November, 2022", style: context.textTheme.bodySmall),
        Gap(4),
        Text(
          'Maecenas quam nunc, sagittis non condimentum at, rutrum sit amet\n eros. Fusce rutrum,lectus\n \nin blandit sagittis, mi tortor ullamcorper mi, vitae vestibulum libero quam a nisi.\n\n In eu mauris et neque sodales porta eu eget dui. Nunc eu quam sit amet justo elementum mollis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.s quis lectus maximus fermentum.',
          maxLines: 10,
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.textColor,
            fontSize: 15,
          ),
        ),
        Gap(30),
      ],
    );
  }
}
