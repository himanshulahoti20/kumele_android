import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/home/cubit/home_page_cubit.dart';
import 'package:kuemele/features/profile/cubit/profile_cubit.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/appbar.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/home/presentation/home_tab_type.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/utils/utils.dart';
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
  bool _wasDark = ColorSet.isDarkMode;

  @override
  void initState() {
    super.initState();

    if (widget.showWelcomeMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        InjectionHelper.snackBar
            .showSuccess(AppLocalizations.of(context)!.welcomeToKumeleMessage);
      });
    }
    _loadHomeAppearApis();
  }

  void _loadHomeAppearApis() {
    unawaited(InjectionHelper.profileCubit.loadUserData());
    unawaited(InjectionHelper.profileCubit.loadEventCategories());
    unawaited(cubit.refreshBadges());
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final tabs =
        responsive.isTablet ? HomeTabType.tabletTabs : HomeTabType.mobileTabs;

    // Rebuild the nav bar/rail when the theme flips (HomePageCubit doesn't emit).
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: InjectionHelper.profileCubit,
      buildWhen: (_, __) {
        final changed = _wasDark != ColorSet.isDarkMode;
        _wasDark = ColorSet.isDarkMode;
        return changed;
      },
      builder: (context, _) => _buildScaffold(context, responsive, tabs),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    ResponsiveData responsive,
    List<HomeTabType> tabs,
  ) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: responsive.isTablet ? CustomAppBar() : null,
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
          bottomNavigationBar: responsive.isPhone
              ? PhoneBottomNavigationBar(
                  tabs: tabs,
                  selectedTab: state.selectedTab,
                  unreadNotifications: state.unreadNotifications,
                  unreadChats: state.unreadChats,
                  onTapTab: (type) => cubit.onTapTab(context, type),
                )
              : null,
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
      width: 96,
      child: Column(
        children: [
          Container(
            height: 1,
            width: 80,
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
  // Bumped from 56 so the biggest-compensated icon (chart, below) has room
  // to render at a larger, uniform target size instead of maxing out the box.
  static const double _iconBoxSize = 72;
  static const double _iconSize = 32;

  // The nav icon SVGs weren't drawn to a shared padding convention — each
  // one's actual glyph fills a different fraction of its own viewBox
  // (measured: chart ~50%, book ~56%, home ~62%, basket ~65%, cart ~80%,
  // paint ~81%, chat ~82%, filter ~89%). Every size below is that icon's
  // own fill ratio solved for a ~30px visual glyph size (reduced from ~34px),
  // so all 8 now read as genuinely the same size at a slightly smaller scale.
  static const Map<String, double> _visualIconSize = {
    SVGAsset.icon_chart: 61,
    SVGAsset.icon_book: 55,
    SVGAsset.icon_home: 49,
    SVGAsset.icon_basket: 48,
    SVGAsset.icon_cart: 39,
    SVGAsset.icon_paint: 38,
    SVGAsset.icon_chat: 37,
    SVGAsset.icon_filter: 34,
  };

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
        padding: const EdgeInsets.only(top: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 8,
                height: 64,
                decoration: BoxDecoration(
                  color: isSelected
                      ? ColorSet.specialBlueColor
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(80),
                    bottomRight: Radius.circular(80),
                  ),
                ),
              ),
            ),
            SizedBox.square(
              dimension: _iconBoxSize,
              child: Center(
                child: KumeleAssetWidget.square(
                  assetPath: icon,
                  size: _visualIconSize[icon] ?? _iconSize,
                  // BoxFit.scaleDown only ever shrinks — every per-icon
                  // size above is larger than that icon's own native SVG
                  // dimension, so scaleDown was clamping each one right
                  // back down to its native size and silently ignoring
                  // `size` entirely. contain scales both up and down.
                  fit: BoxFit.contain,
                  color: isSelected
                      ? ColorSet.specialBlueColor
                      : ColorSet.textColor,
                  semanticLabel: icon,
                ),
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
  static const double _iconSize = 30;
  // Bumped from 40 so the sparsest icon (book, below) has room for a
  // bigger uniform target size without crowding the selected-state circle.
  static const double _iconBoxSize = 46;

  // Same fix as TabletNavigationItem: these icons' glyphs fill different
  // fractions of their own viewBox (measured: book ~56%, profile ~60%,
  // home/more ~62%, basket ~65%). Each size below is that icon's own fill
  // ratio solved for the same ~25px visual glyph size, so all five read as
  // genuinely the same size — capped by `_iconBoxSize` (book's 45 is the
  // tightest fit, 1px of margin).
  static const Map<String, double> _visualIconSize = {
    SVGAsset.icon_book: 45,
    SVGAsset.icon_profile: 42,
    SVGAsset.icon_home: 40,
    SVGAsset.icon_more: 40,
    SVGAsset.icon_basket: 39,
  };

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
              height: _iconBoxSize,
              child: Center(
                child: _NavBadge(
                  count: badgeCount,
                  numeric: false,
                  child: isSelected
                      ? Container(
                          width: _iconBoxSize,
                          height: _iconBoxSize,
                          decoration: const BoxDecoration(
                            color: LightColors.specialColor,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: KumeleAssetWidget.square(
                            assetPath: tab.icon,
                            size: _visualIconSize[tab.icon] ?? _iconSize,
                            semanticLabel: tab.name,
                          ),
                        )
                      : KumeleAssetWidget.square(
                          assetPath: tab.icon,
                          size: _visualIconSize[tab.icon] ?? _iconSize,
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
