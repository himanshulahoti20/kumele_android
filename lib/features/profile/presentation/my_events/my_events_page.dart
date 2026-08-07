import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/my_events/cubit/my_events_cubit.dart';
import 'package:kuemele/features/profile/presentation/my_events/cubit/my_events_state.dart';
import 'package:kuemele/features/profile/presentation/my_events/pages/created_events_page.dart';
import 'package:kuemele/features/profile/presentation/my_events/pages/joined_events_page.dart';
import 'package:kuemele/features/profile/presentation/my_events/widgets/my_events_tab_bar.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

class MyEventsPage extends StatefulWidget implements BasePage {
  const MyEventsPage({super.key});

  @override
  State<MyEventsPage> createState() => _MyEventsPageState();

  @override
  String get screenName => 'MyEvents';
}

class _MyEventsPageState extends State<MyEventsPage> {
  final MyEventsCubit _cubit = InjectionHelper.myEventsCubit;

  @override
  void initState() {
    super.initState();
    _cubit.loadCreatedEvents();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyEventsCubit, MyEventsState>(
      bloc: _cubit,
      builder: (context, state) {
        return WidgetByDevice(
          tablet: buildTablet(state),
          phone: Scaffold(
            backgroundColor: ColorSet.bg3Color,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
                child: Column(
                  children: [
                    MobileHeader(label: AppLocalizations.of(context)!.myEvents),
                    Gap(22.h),
                    MyEventsTabBar(
                      activeTab: state.activeTab,
                      onTabSelected: _cubit.selectTab,
                    ),
                    Gap(20.h),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildTabContent(state),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTablet(MyEventsState state) {
    return AppTitledDialog(
      title: AppLocalizations.of(context)!.myEvents,
      child: Column(
        children: [
          MyEventsTabBar(
            activeTab: state.activeTab,
            onTabSelected: _cubit.selectTab,
          ),
          Gap(20.h),
          _buildTabContent(state),
        ],
      ),
    );
  }

  Widget _buildTabContent(MyEventsState state) {
    switch (state.activeTab) {
      case MyEventsTab.created:
        return CreatedEventsPage(state: state, cubit: _cubit);
      case MyEventsTab.joined:
        return JoinedEventsPage(state: state, cubit: _cubit);
    }
  }
}
