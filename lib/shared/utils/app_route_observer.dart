import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  // ignore: constant_identifier_names
  static const UNDEFINED_SCREEN_NAME = 'undefined screenName';

  static StreamController<String> screenChangeStreamCtrl =
      StreamController<String>.broadcast();
  static String currentScreen = UNDEFINED_SCREEN_NAME;
  String myCurrentScreen = UNDEFINED_SCREEN_NAME;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      updateCurrentScreen(getScreenName(route));
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      updateCurrentScreen(getScreenName(newRoute));
    }
  }

  // @override
  // void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
  //   super.didRemove(route, previousRoute);
  //   if (previousRoute is PageRoute) {
  //     updateCurrentScreen(previousRoute);
  //   }
  // }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute) {
      updateCurrentScreen(getScreenName(previousRoute));
    }
  }

  void updateCurrentScreen(String screen) {
    currentScreen = screen;
    myCurrentScreen = screen;
    screenChangeStreamCtrl.add(currentScreen);
    log('--- CURRENT SCREEN $currentScreen');
  }

  String getScreenName(Route<dynamic>? route) {
    if (route != null) {
      var screenName = route.settings.name ?? UNDEFINED_SCREEN_NAME;
      if (screenName == '/') {
        screenName = ApiService.hasToken() ? 'MainNavigationPage' : 'LoginPage';
      }
      return screenName;
    } else {
      return UNDEFINED_SCREEN_NAME;
    }
  }
}
