import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/features/home/cubit/home_page_cubit.dart';
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
        cart => () async =>
            InjectionHelper.homePageCubit.onTapTab(context, HomeTabType.cart),
      };
}

class MoreDialog extends StatelessWidget {
  const MoreDialog({super.key});

  static Future<void> show({required BuildContext context}) {
    InjectionHelper.homePageCubit.refreshBadges();
    return AppBottomSheet.show<void>(
      context: context,
      scrollable: true,
      child: const MoreDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      bloc: InjectionHelper.homePageCubit,
      builder: (context, state) => GridView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 100,
          mainAxisSpacing: 30,
          crossAxisSpacing: 20,
        ),
        children: MoreType.values.map((e) {
          final badgeCount = switch (e) {
            MoreType.notification => state.unreadNotifications,
            MoreType.chat => state.unreadChats,
            _ => 0,
          };
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MoreBadge(
                count: badgeCount,
                child: AppRoundedIconButton(
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
      ),
    );
  }
}

class _MoreBadge extends StatelessWidget {
  const _MoreBadge({
    required this.count,
    required this.child,
  });

  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -4,
          right: -2,
          child: Container(
            constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: ColorSet.specialYellowColor,
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.center,
            child: Text(
              count > 99 ? '99+' : '$count',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
