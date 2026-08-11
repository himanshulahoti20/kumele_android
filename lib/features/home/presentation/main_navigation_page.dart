import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/home/cubit/home_page_cubit.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/appbar.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/home/presentation/home_tab_type.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/services/api_service/ads/ads_repo.dart';
import 'package:kuemele/shared/widgets/indicator.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

export 'home_tab_type.dart';

class MainNavigationPage extends StatefulWidget implements BasePage {
  final bool showWelcomeMessage;

  const MainNavigationPage({
    super.key,
    this.showWelcomeMessage = false,
  });

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();

  @override
  String get screenName => 'MainNavigationPage';
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  final cubit = InjectionHelper.homePageCubit;

  @override
  void initState() {
    super.initState();

    if (widget.showWelcomeMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        InjectionHelper.snackBar.showSuccess('Welcome to Kumele!');
      });
    }
    _loadHomeAppearApis();
  }

  void _loadHomeAppearApis() {
    unawaited(InjectionHelper.profileCubit.loadUserData());
    unawaited(InjectionHelper.profileCubit.loadEventCategories());
    unawaited(cubit.refreshBadges());
    unawaited(AdsRepo.fetchCampaigns());
  }

  @override
  Widget build(BuildContext context) {
    final tabs = context.responsive.isTablet
        ? HomeTabType.tabletTabs
        : HomeTabType.mobileTabs;

    return BlocBuilder<HomePageCubit, HomePageState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: context.responsive.isTablet ? CustomAppBar() : null,
          backgroundColor: ColorSet.bg3Color,
          body: Row(
            children: [
              WidgetByDevice(
                tablet: TabletNavigationRail(
                  tabs: tabs,
                  selectedTab: state.selectedTab,
                  onTapItem: (type) => cubit.onTapTab(context, type),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      child: KeyedSubtree(
                        key: ValueKey<HomeTabType>(state.selectedTab),
                        child: state.selectedTab.screen,
                      ),
                    ),
                    if (state.subPage != null) state.subPage!,
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: WidgetByDevice(
            phone: PhoneBottomNavigationBar(
              tabs: tabs,
              selectedTab: state.selectedTab,
              unreadNotifications: state.unreadNotifications,
              unreadChats: state.unreadChats,
              onTapTab: (type) => cubit.onTapTab(context, type),
            ),
          ),
        );
      },
    );
  }
}

class TabletNavigationRail extends StatelessWidget {
  final List<HomeTabType> tabs;
  final HomeTabType selectedTab;
  final ValueChanged<HomeTabType> onTapItem;

  const TabletNavigationRail({
    super.key,
    required this.tabs,
    required this.selectedTab,
    required this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Container(
            height: 1,
            width: 60,
            color: ColorSet.bottomBarColor,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                return TabletNavigationItem(
                  icon: tab.icon,
                  isSelected: selectedTab == tab,
                  onTap: () => onTapItem(tab),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TabletNavigationItem extends StatelessWidget {
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const TabletNavigationItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 6,
                height: 50,
                decoration: BoxDecoration(
                  color:
                      isSelected ? ColorSet.lightBlueColor : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(80),
                    bottomRight: Radius.circular(80),
                  ),
                ),
              ),
            ),
            Indicator(
              hasNew: icon == SVGAsset.icon_chart,
              top: 5,
              right: 5,
              child: KumeleAssetWidget.square(
                assetPath: icon,
                size: 40,
                color:
                    isSelected ? ColorSet.lightBlueColor : ColorSet.textColor,
                semanticLabel: icon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneBottomNavigationBar extends StatelessWidget {
  final List<HomeTabType> tabs;
  final HomeTabType selectedTab;
  final int unreadNotifications;
  final int unreadChats;
  final ValueChanged<HomeTabType> onTapTab;

  const PhoneBottomNavigationBar({
    super.key,
    required this.tabs,
    required this.selectedTab,
    required this.unreadNotifications,
    required this.unreadChats,
    required this.onTapTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorSet.bg2Color,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Row(
            children: tabs
                .map(
                  (tab) => Expanded(
                    child: PhoneNavigationItem(
                      tab: tab,
                      isSelected: tab == selectedTab,
                      badgeCount: tab == HomeTabType.more
                          ? unreadNotifications + unreadChats
                          : 0,
                      onTap: () => onTapTab(tab),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class PhoneNavigationItem extends StatelessWidget {
  final HomeTabType tab;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;

  const PhoneNavigationItem({
    super.key,
    required this.tab,
    required this.isSelected,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        opacity: isSelected ? 1.0 : 0.7,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              child: Center(
                child: _NavBadge(
                  count: badgeCount,
                  numeric: false,
                  child: isSelected
                      ? Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: LightColors.specialColor,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: KumeleAssetWidget.square(
                            assetPath: tab.icon,
                            size: 30,
                            semanticLabel: tab.name,
                          ),
                        )
                      : KumeleAssetWidget.square(
                          assetPath: tab.icon,
                          size: 30,
                          color: ColorSet.textColor,
                          semanticLabel: tab.name,
                        ),
                ),
              ),
            ),
            Text(
              tab.name.capitalize(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMediumBold.copyWith(
                color: ColorSet.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBadge extends StatelessWidget {
  const _NavBadge({
    required this.count,
    required this.child,
    this.numeric = true,
  });

  final int count;
  final Widget child;
  final bool numeric;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -3,
          right: -3,
          child: Container(
            constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
            padding: numeric
                ? const EdgeInsets.symmetric(horizontal: 4)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: ColorSet.specialYellowColor,
              shape: numeric ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: numeric ? BorderRadius.circular(999) : null,
            ),
            alignment: Alignment.center,
            child: numeric
                ? Text(
                    count > 99 ? '99+' : '$count',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
