import 'package:flutter/widgets.dart';
import 'package:kuemele/features/home/presentation/home_tab_type.dart';

class HomePageState {
  const HomePageState({
    this.selectedTab = HomeTabType.home,
    this.subPage,
    this.unreadNotifications = 0,
    this.unreadChats = 0,
  });

  final HomeTabType selectedTab;
  final Widget? subPage;
  final int unreadNotifications;
  final int unreadChats;

  static const initial = HomePageState();

  HomePageState copyWith({
    HomeTabType? selectedTab,
    Widget? subPage,
    int? unreadNotifications,
    int? unreadChats,
    bool clearSubPage = false,
  }) {
    return HomePageState(
      selectedTab: selectedTab ?? this.selectedTab,
      subPage: clearSubPage ? null : (subPage ?? this.subPage),
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      unreadChats: unreadChats ?? this.unreadChats,
    );
  }
}
