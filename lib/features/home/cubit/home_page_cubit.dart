import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/get_it.dart';
import 'package:kuemele/features/explore/domain/repositories/notification_repository.dart';
import 'package:kuemele/features/filter/presentation/filter.dart';
import 'package:kuemele/features/home/cubit/event_search_filters.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/features/home/cubit/home_page_state.dart';
import 'package:kuemele/features/profile/presentation/connections/followers.dart';
import 'package:kuemele/features/profile/presentation/guideline/community_guidelines.dart';
import 'package:kuemele/features/profile/presentation/terms_and_conditions/terms_and_conditions.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/modals/dialog/more_dialog.dart';
import 'package:kuemele/features/home/presentation/home_tab_type.dart';

export 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageState.initial);

  Future<void> refreshBadges() async {
    try {
      final notifications = await getIt<NotificationRepository>()
          .getNotifications(page: 1, limit: 100);
      safeEmit(
        state.copyWith(
          unreadNotifications:
              notifications.items.where((item) => !item.isRead).length,
        ),
      );
    } catch (_) {}
  }

  void setUnreadChats(int count) {
    safeEmit(state.copyWith(unreadChats: count));
  }

  void applyEventFilters(EventSearchFilters filters) {
    safeEmit(
      state.copyWith(
        selectedTab: HomeTabType.home,
        clearSubPage: true,
        eventFilters: filters,
        eventFilterRevision: state.eventFilterRevision + 1,
      ),
    );
  }

  void clearEventFilters() {
    safeEmit(
      state.copyWith(
        selectedTab: HomeTabType.home,
        clearSubPage: true,
        clearEventFilters: true,
        eventFilterRevision: state.eventFilterRevision + 1,
      ),
    );
  }

  void onTapTab(BuildContext context, HomeTabType type) {
    if (type == HomeTabType.cart) {
      safeEmit(
        state.copyWith(
          selectedTab: HomeTabType.cart,
          clearSubPage: true,
        ),
      );
      return;
    }

    if (type == HomeTabType.filter) {
      AppDialog.show(
        context: context,
        width: AppDialogSize.widthFor(context),
        dialog: const Filter(),
      );
      return;
    }

    if (type == HomeTabType.more) {
      MoreDialog.show(context: context);
      return;
    }

    safeEmit(
      state.copyWith(
        selectedTab: type,
        clearSubPage: true,
      ),
    );
  }

  void goBack(BuildContext context) {
    if (state.subPage != null) {
      popSubPage();
      return;
    }

    onTapTab(context, HomeTabType.home);
  }

  void popSubPage() {
    safeEmit(state.copyWith(clearSubPage: true));
  }

  void openCommunityGuideLines() {
    safeEmit(state.copyWith(subPage: CommunityGuideLines()));
  }

  void openTermsAndConditions() {
    safeEmit(state.copyWith(subPage: TermsAndConditions()));
  }

  void openFollowers() {
    safeEmit(
      state.copyWith(
        subPage: FollowersPage(),
      ),
    );
  }
}
