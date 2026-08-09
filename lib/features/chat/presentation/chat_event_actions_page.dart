import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/chat/presentation/guest_scan_page.dart';
import 'package:kuemele/features/chat/presentation/rating_page.dart';
import 'package:kuemele/features/chat/presentation/report_event_page.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

enum ChatEventActionTab { ratings, report, guestScan }

class ChatEventActionsRouteArgs {
  const ChatEventActionsRouteArgs({
    this.initialTab = ChatEventActionTab.ratings,
    this.eventId = '',
  });

  final ChatEventActionTab initialTab;
  final String eventId;
}

class ChatEventActionsPage extends StatefulWidget implements BasePage {
  const ChatEventActionsPage({
    super.key,
    this.initialTab = ChatEventActionTab.ratings,
    this.eventId = '',
  });

  final ChatEventActionTab initialTab;
  final String eventId;

  @override
  State<ChatEventActionsPage> createState() => _ChatEventActionsPageState();

  @override
  String get screenName => 'ChatEventActionsPage';
}

class _ChatEventActionsPageState extends State<ChatEventActionsPage> {
  late var _tab = widget.initialTab;

  void _goBack() {
    if (FormFactor.isTablet) {
      InjectionHelper.homePageCubit.goBack(context);
    } else if (context.canPop()) {
      context.pop();
    } else {
      InjectionHelper.homePageCubit.onTapTab(context, HomeTabType.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _goBack();
      },
      child: Scaffold(
        backgroundColor: ColorSet.bg3Color,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _goBack,
                  child: KumeleAssetWidget(
                    assetPath: IconSet.arrowleft,
                    width: 24.w,
                    height: 24.w,
                    fit: BoxFit.contain,
                  ),
                ),
                Gap(38.h),
                _SegmentedTabs(
                  selected: _tab,
                  onChanged: (tab) => setState(() => _tab = tab),
                ),
                Gap(24.h),
                Expanded(child: _tabContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabContent() {
    return switch (_tab) {
      ChatEventActionTab.ratings => RatingPage(
          embedded: true,
          eventId: widget.eventId,
        ),
      ChatEventActionTab.report => ReportEventPage(
          embedded: true,
          eventId: widget.eventId,
        ),
      ChatEventActionTab.guestScan => GuestScanPage(
          eventId: widget.eventId,
          embedded: true,
        ),
    };
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.selected,
    required this.onChanged,
  });

  final ChatEventActionTab selected;
  final ValueChanged<ChatEventActionTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          _tab(context, ChatEventActionTab.ratings, 'Ratings'),
          _tab(context, ChatEventActionTab.report, 'Report'),
          _tab(context, ChatEventActionTab.guestScan, 'Guest scan'),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, ChatEventActionTab tab, String label) {
    final isSelected = selected == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? ColorSet.bg2Color : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              color: isSelected ? ColorSet.textColor : ColorSet.subTextColor,
              fontSize: 16.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
