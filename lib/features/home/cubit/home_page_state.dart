import 'package:flutter/widgets.dart';
import 'package:kuemele/features/home/presentation/home_tab_type.dart';

class HomePageState {
  const HomePageState({
    this.selectedTab = HomeTabType.home,
    this.subPage,
  });

  final HomeTabType selectedTab;
  final Widget? subPage;

  static const initial = HomePageState();

  HomePageState copyWith({
    HomeTabType? selectedTab,
    Widget? subPage,
    bool clearSubPage = false,
  }) {
    return HomePageState(
      selectedTab: selectedTab ?? this.selectedTab,
      subPage: clearSubPage ? null : (subPage ?? this.subPage),
    );
  }
}
