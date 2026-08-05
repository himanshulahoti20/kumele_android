import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/connections/bloc/connections_bloc.dart';
import 'package:kuemele/features/profile/presentation/connections/widgets/connections_list.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

class FollowersPage extends StatefulWidget {
  const FollowersPage({super.key, this.selectedTab});

  final String? selectedTab;

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  @override
  void initState() {
    super.initState();
    InjectionHelper.connectionsBloc.add(
      ConnectionsInit(selectedTab: widget.selectedTab),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Followers(selectedTab: widget.selectedTab);
  }
}

class Followers extends StatelessWidget implements BasePage {
  const Followers({super.key, this.selectedTab});

  final String? selectedTab;

  @override
  String get screenName => 'Followers';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectionsBloc, ConnectionsState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.activeStatus != ConnectionsStatus.failure,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message != null && message.isNotEmpty) {
          InjectionHelper.snackBar.showError(message);
        }
      },
      builder: (context, state) {
        return WidgetByDevice(
          tablet: _FollowersTabletBody(state: state),
          phone: Scaffold(
            backgroundColor: ColorSet.bg3Color,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
                child: Column(
                  children: [
                    const MobileHeader(label: ''),
                    Gap(22.h),
                    Expanded(child: _FollowersContent(state: state)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FollowersTabletBody extends StatelessWidget {
  const _FollowersTabletBody({required this.state});

  final ConnectionsState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          color: ColorSet.bg3Color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Image.asset(
                      IconSet.arrowleft,
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Gap(40),
                  Text(
                    _headerTitle(state),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 0.5),
            Expanded(child: _FollowersContent(state: state)),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

class _FollowersContent extends StatelessWidget {
  const _FollowersContent({required this.state});

  final ConnectionsState state;

  @override
  Widget build(BuildContext context) {
    if (state.activeStatus == ConnectionsStatus.failure &&
        state.activeUsers.isEmpty &&
        !state.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMessage ?? AppStrings.connectionsLoadFailed,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium.copyWith(
                color: ColorSet.textColor,
              ),
            ),
            Gap(16.h),
            AppButton.primary(
              label: AppStrings.retry,
              onPressed: () {
                context.read<ConnectionsBloc>().add(const ConnectionsRetry());
              },
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: FormFactor.isTablet ? 50 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ConnectionsTabBar(state: state),
          Gap(30.h),
          ConnectionsList(
            users: state.activeUsers,
            isLoading: state.isLoading,
          ),
        ],
      ),
    );
  }
}

String _headerTitle(ConnectionsState state) {
  return state.selectedTab == ConnectionsTab.followers
      ? AppStrings.followers
      : AppStrings.following;
}

class _ConnectionsTabBar extends StatelessWidget {
  const _ConnectionsTabBar({required this.state});

  final ConnectionsState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: FormFactor.isTablet ? 80 : 52,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _TabButton(
            label: AppStrings.followers,
            count: state.followersTotal,
            isLoading: state.isLoadingFollowers,
            isSelected: state.selectedTab == ConnectionsTab.followers,
            onTap: () {
              context.read<ConnectionsBloc>().add(
                    const ConnectionsTabChanged(ConnectionsTab.followers),
                  );
            },
          ),
          _TabButton(
            label: AppStrings.following,
            count: state.followingTotal,
            isLoading: state.isLoadingFollowing,
            isSelected: state.selectedTab == ConnectionsTab.following,
            onTap: () {
              context.read<ConnectionsBloc>().add(
                    const ConnectionsTabChanged(ConnectionsTab.following),
                  );
            },
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.count,
    required this.isLoading,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isLoading;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? ColorSet.bg3Color : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Text(
                label,
                style: context.textTheme.bodyMediumSemiBold.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isLoading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorSet.specialYellowColor,
                  ),
                )
              else
                Container(
                  padding: EdgeInsets.all(FormFactor.isTablet ? 8 : 6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorSet.specialYellowColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    count.toString(),
                    style: context.textTheme.bodyMedium,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
