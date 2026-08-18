import 'package:flutter/material.dart';
import 'package:kuemele/features/statistics/history_statistics.dart';
import 'package:kuemele/features/blog/presentation/blog.dart';
import 'package:kuemele/features/chat/presentation/mchat.dart';
import 'package:kuemele/features/discover/presentation/create_event_page.dart';
import 'package:kuemele/features/explore/presentation/explore.dart';
import 'package:kuemele/features/profile/presentation/card/cart_checkout_page.dart';
import 'package:kuemele/features/profile/presentation/profileset/profile.dart';
import 'package:kuemele/features/shop/presentation/shop.dart';
import 'package:kuemele/shared/theme/app_image.dart';

enum HomeTabType {
  home,
  blog,
  shop,
  chat,
  statistic,
  createEvent,
  filter,
  cart,
  more,
  profile;

  static const mobileTabs = [
    HomeTabType.home,
    HomeTabType.blog,
    HomeTabType.shop,
    HomeTabType.more,
    HomeTabType.profile,
  ];

  static const tabletTabs = [
    HomeTabType.home,
    HomeTabType.blog,
    HomeTabType.shop,
    HomeTabType.chat,
    HomeTabType.statistic,
    HomeTabType.createEvent,
    HomeTabType.filter,
    HomeTabType.cart,
  ];

  String get icon => switch (this) {
        home => SVGAsset.icon_home,
        blog => SVGAsset.icon_book,
        shop => SVGAsset.icon_basket,
        chat => SVGAsset.icon_chat,
        statistic => SVGAsset.icon_chart,
        createEvent => SVGAsset.icon_paint,
        filter => SVGAsset.icon_filter,
        cart => SVGAsset.icon_cart,
        more => SVGAsset.icon_more,
        profile => SVGAsset.icon_profile,
      };

  Widget get screen => switch (this) {
        home => Explore(),
        blog => Blog(),
        shop => Shop(),
        chat => ChatScreen(),
        statistic => HistoryAndStatistics(),
        createEvent => CreateEvent(),
        filter => SizedBox.shrink(),
        cart => CartCheckoutPage(),
        more => SizedBox.shrink(),
        profile => Profile(),
      };
}
