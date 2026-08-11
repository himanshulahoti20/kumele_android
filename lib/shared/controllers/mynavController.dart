import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuemele/features/statistics/history_statistics.dart';
import 'package:kuemele/features/blog/presentation/blog.dart';
import 'package:kuemele/features/chat/presentation/mchat.dart';
import 'package:kuemele/features/chat/presentation/rating_page.dart';
import 'package:kuemele/features/discover/presentation/create_event_page.dart';
import 'package:kuemele/features/explore/presentation/explore.dart';
import 'package:kuemele/features/profile/presentation/card/payment_subscriptions.dart';
import 'package:kuemele/features/profile/presentation/connections/followers.dart';
import 'package:kuemele/features/profile/presentation/guideline/community_guidelines.dart';
import 'package:kuemele/features/profile/presentation/profileset/profile.dart';
import 'package:kuemele/features/profile/presentation/terms_and_conditions/terms_and_conditions.dart';
import 'package:kuemele/features/shop/presentation/shop.dart';

class MyNavController extends GetxController {
  static MyNavController get to => Get.find();

  final PageController pageController = PageController();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final List<Widget> screens = [
    Explore(),
    const Blog(),
    Shop(),
    const ChatScreen(),
    HistoryAndStatistics(),
    CreateEvent(),
    Profile(),
    const PaymentSubscriptionsDialog(),
    const ChatScreen(),
    FollowersPage(),
    CommunityGuideLines(),
    TermsAndConditions(),
    RatingPage(),
  ];
  int index = 0;

  void changeIndex(int i) {
    if (i < 0 || i >= screens.length) return;
    index = i;
    pageController.jumpToPage(index);
    update();
  }

  void onItemTapped(int myindex) {
    if (myindex < 0 || myindex >= screens.length) return;
    index = myindex;
    update();
    changeIndex(myindex);
    navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
        builder: (context) => screens[myindex], settings: RouteSettings()));
  }
}
