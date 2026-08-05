import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:kuemele/features/home/presentation/main_navigation_page.dart';

abstract class BaseHomeTab extends StatelessWidget {
  const BaseHomeTab({super.key});

  @protected
  HomeTabType get type;

  @protected
  String get icon;

  @protected
  String get iconInactive;

  @protected
  String get label;

  void onOpenTab(Map<String, dynamic>? args) {
    log('onOpenTab $label');
  }

  void onSwitchTab(Map<String, dynamic>? args) {
    log('onSwitchTab $label');
  }

  void onClickTab() {
    log('onClickTab $label');
  }

  @protected
  Widget buildTab(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return buildTab(context);
  }
}
