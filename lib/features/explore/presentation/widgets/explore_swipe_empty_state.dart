import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/home/presentation/home_tab_type.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/services/share/referral_share_helper.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:lottie/lottie.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class ExploreSwipeEmptyState extends StatelessWidget {
  const ExploreSwipeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final textWidth = responsive.screenSize.width * 0.75;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Lottie.asset(
              Assets.animations.manCandy.path,
              width: responsive.w(300),
              height: responsive.w(300),
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),
          Gap(responsive.h(24)),
          SizedBox(
            width: textWidth,
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.exploreSwipeNoMoreMatchesLine1,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLargeBold.copyWith(
                    color: ColorSet.textColor,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.exploreSwipeNoMoreMatchesLine2,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLargeBold.copyWith(
                    color: ColorSet.textColor,
                  ),
                ),
              ],
            ),
          ),
          Gap(responsive.h(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppRoundedIconButton(
                assetPath: Assets.icons.eventsSvg.path,
                iconSize: 20,
                onTap: () => _showCreateEventPrompt(context),
              ),
              Gap(responsive.w(10)),
              AppRoundedIconButton(
                assetPath: Assets.icons.blog.path,
                iconSize: 20,
                onTap: () => _showReadBlogPrompt(context),
              ),
              Gap(responsive.w(10)),
              AppRoundedIconButton(
                assetPath: Assets.icons.shareSvg.path,
                iconSize: 20,
                onTap: () => _showInviteFriendsPrompt(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateEventPrompt(BuildContext context) {
    AppBottomSheet.showPrompt(
      context: context,
      subtitle: AppLocalizations.of(context)!.exploreSwipeCreateEventCta,
      buttonLabel: 'Create Event',
      onButtonPressed: () {
        if (FormFactor.isTablet) {
          InjectionHelper.homePageCubit.onTapTab(
            context,
            HomeTabType.createEvent,
          );
        } else {
          context.push(AppRoutes.createEvent);
        }
      },
    );
  }

  void _showReadBlogPrompt(BuildContext context) {
    AppBottomSheet.showPrompt(
      context: context,
      subtitle: AppLocalizations.of(context)!.exploreSwipeBlogsSuggestion,
      buttonLabel: 'Read Blog',
      onButtonPressed: () {
        InjectionHelper.homePageCubit.onTapTab(context, HomeTabType.blog);
      },
    );
  }

  void _showInviteFriendsPrompt(BuildContext context) {
    AppBottomSheet.showPrompt(
      context: context,
      subtitle: AppLocalizations.of(context)!.exploreSwipeInviteFriendsCta,
      buttonLabel: 'Invite Friends',
      onButtonPressed: () => ReferralShareHelper.shareFromContext(context),
    );
  }
}
