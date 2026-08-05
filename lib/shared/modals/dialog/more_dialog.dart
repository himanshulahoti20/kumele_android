import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

enum MoreType {
  createEvent,
  filter,
  statistic,
  notification,
  chat,
  cart;

  String get icon => switch (this) {
        createEvent => SVGAsset.icon_paint,
        filter => SVGAsset.icon_filter,
        statistic => SVGAsset.icon_chart,
        notification => SVGAsset.icon_noti,
        chat => SVGAsset.icon_chat,
        cart => SVGAsset.icon_cart,
      };

  String get label => switch (this) {
        createEvent => 'Create Hobby\nEvents',
        filter => 'Find Hobby\nEvents',
        statistic => 'History &\nStatistics',
        notification => 'Notifications',
        chat => 'Chat',
        cart => 'Cart',
      };

  Future<void> Function() onPressed(BuildContext context) => switch (this) {
        createEvent => () async => context.push(AppRoutes.createEvent),
        filter => () async => context.push(AppRoutes.filter),
        statistic => () async => context.push(AppRoutes.statistic),
        notification => () async => context.push(AppRoutes.notification),
        chat => () async => context.push(AppRoutes.chatList),
        cart => () async => context.push(AppRoutes.paymentSubscriptions),
      };
}

class MoreDialog extends StatelessWidget {
  const MoreDialog({super.key});

  static Future<void> show({required BuildContext context}) {
    return AppBottomSheet.show<void>(
      context: context,
      scrollable: true,
      child: const MoreDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 100,
        mainAxisSpacing: 30,
        crossAxisSpacing: 20,
      ),
      children: MoreType.values.map((e) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppRoundedIconButton(
              assetPath: e.icon,
              iconColor: ColorSet.textColor,
              iconSize: 24.w,
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  InjectionHelper.homePageCubit
                      .onTapTab(context, HomeTabType.home);
                }
                e.onPressed(context).call();
              },
            ),
            Text(
              e.label,
              style: context.textTheme.titleSmall,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        );
      }).toList(),
    );
  }
}
