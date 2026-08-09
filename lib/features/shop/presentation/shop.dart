import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/discover/data/models/event_plan_model.dart';
import 'package:kuemele/features/shop/presentation/nfts/nft_tab_view.dart';
import 'package:kuemele/features/profile/presentation/card/payment_subscriptions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/modals/dialog/subscription_expired_dialog.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:lottie/lottie.dart';

import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class Shop extends StatefulWidget {
  final bool? isHome;
  const Shop({super.key, this.isHome});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  String selectedTab = 'Subscriptions';
  bool okay = true;
  List<EventPlanModel> _eventPlans = const [];
  bool _isLoadingEventPlans = true;
  List<SubscriptionTier> _tiers = const [];
  SubscriptionStatus? _subscriptionStatus;
  bool _isLoadingTiers = true;

  @override
  void initState() {
    super.initState();
    _loadEventPlans();
    _loadSubscriptions();
  }

  Future<void> _loadEventPlans() async {
    try {
      final plans = await Web3Repo.getEventPlans();
      if (!mounted) return;
      setState(() {
        _eventPlans = plans;
        _isLoadingEventPlans = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingEventPlans = false);
    }
  }

  Future<void> _loadSubscriptions() async {
    try {
      final results = await Future.wait([
        Web3Repo.getSubscriptionTiers(),
        Web3Repo.getSubscriptionStatus(),
      ]);
      if (!mounted) return;
      final status = results[1] as SubscriptionStatus?;
      setState(() {
        _tiers = results[0] as List<SubscriptionTier>;
        _subscriptionStatus = status;
        _isLoadingTiers = false;
      });
      _maybeShowExpiringDialog(status);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingTiers = false);
    }
  }

  void _maybeShowExpiringDialog(SubscriptionStatus? status) {
    if (status == null || !status.isActive || status.cancelAtPeriodEnd) {
      return;
    }
    final periodEnd = DateTime.tryParse(status.currentPeriodEnd ?? '');
    if (periodEnd == null) return;
    final daysRemaining = periodEnd.difference(DateTime.now()).inDays;
    if (daysRemaining < 0 || daysRemaining > 30) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      AppDialog.adaptive(
        context: context,
        width: AppDialogSize.widthFor(context),
        dialog: SubscriptionDialog(
          tierName: status.tierName ?? 'active',
          periodEnd: periodEnd,
        ),
      );
    });
  }

  bool isHome() {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return widget.isHome ?? args?['isHome'] as bool? ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        InjectionHelper.homePageCubit.goBack(context);
      },
      child: Scaffold(
        backgroundColor: ColorSet.bgColor,
        body: WidgetByDevice(
          tablet: _buildTablet(),
          phone: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: Utils.isPortrait
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  switchTile(),
                  SizedBox(height: size(15)),
                  switchEventTile(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTablet() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: Utils.isPortrait
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          switchTile(),
          SizedBox(height: size(15)),
          switchEventTile(),
        ],
      ),
    );
  }

  Widget switchTile() {
    return Column(
      children: [
        buildTabBar(),
        Gap(12),
      ],
    );
  }

  Container buildTabBar() {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: buildTab('Subscriptions')),
          Expanded(child: buildTab('Guest Tickets')),
          Expanded(child: buildTab('NFTs')),
        ],
      ),
    );
  }

  Widget buildTab(String tab) {
    final isSelected = selectedTab == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = tab;
          okay = false;
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              okay = true;
            });
          });
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? ColorSet.bg2Color : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            tab,
            maxLines: 1,
            softWrap: false,
            style: context.textTheme.titleMediumSemiBold.copyWith(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? ColorSet.textColor
                  : ColorSet.profileSubTextColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget switchEventTile() {
    if (selectedTab == 'NFTs') {
      return const NftTabView();
    }

    if (okay) {
      final isSubscriptionsTab = selectedTab == 'Subscriptions';
      if (selectedTab == 'Guest Tickets' && _isLoadingEventPlans) {
        return Center(
          child: Lottie.asset(IconSet.jsonLoading, width: 98, height: 98),
        );
      }
      if (isSubscriptionsTab && _isLoadingTiers) {
        return Center(
          child: Lottie.asset(IconSet.jsonLoading, width: 98, height: 98),
        );
      }
      final list = selectedTab == 'Guest Tickets'
          ? _eventPlans.map(_eventPlanToTile).toList()
          : _tiers.map(_tierToTile).toList();
      if (list.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              selectedTab == 'Guest Tickets'
                  ? 'No guest tickets available.'
                  : 'No subscriptions available.',
              style: context.textTheme.bodyLarge
                  .copyWith(color: ColorSet.textColor),
            ),
          ),
        );
      }
      final useListLayout = Utils.isPortrait;
      return WidgetByDevice(
        tablet: GridView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: useListLayout ? 1 : 2,
            childAspectRatio: useListLayout ? 4.5 : 3.0,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
          ),
          children: list.map((e) => eventTile(e)).toList(),
        ),
        phone: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: list.length,
          separatorBuilder: (c, i) => Gap(20),
          itemBuilder: (c, i) {
            final e = list[i];
            return eventTileMobile(e);
          },
        ),
      );
    } else {
      return Center(
        child: Lottie.asset(IconSet.jsonLoading, width: 98, height: 98),
      );
    }
  }

  Subscription _eventPlanToTile(EventPlanModel plan) {
    return Subscription(
      icon: IconSet.ticketsIcon,
      title: plan.guestRangeLabel,
      subtitle: AppLocalizations.of(context)!.guestCountValidForEventOnly,
      actionName: plan.priceEur == 0 ? 'Active' : 'Buy now',
      priceLabel: plan.priceLabel,
    );
  }

  Subscription _tierToTile(SubscriptionTier tier) {
    final isActiveTier = _subscriptionStatus?.isActive == true &&
        _subscriptionStatus?.tierName == tier.name;
    return Subscription(
      icon: SVGAsset.icon_crown,
      title: tier.name,
      subtitle: tier.description.isNotEmpty
          ? tier.description
          : tier.features.join('\n'),
      actionName: isActiveTier ? 'Active' : 'Buy now',
      priceLabel: _formatSubscriptionPrice(tier),
    );
  }

  String _formatSubscriptionPrice(SubscriptionTier tier) {
    final price = tier.price ?? tier.priceMonthly ?? tier.priceYearly;
    if (price == null) return '';
    final currency = tier.currency?.toUpperCase();
    final symbol = currency == null || currency == 'USD' ? r'$' : '$currency ';
    return '$symbol${price.toStringAsFixed(price % 1 == 0 ? 0 : 2)}';
  }

  Widget eventTileMobile(Subscription subscription) {
    bool isActive = subscription.actionName == 'Active';
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size(20)),
        color: isActive ? const Color(0xFFFFC533) : ColorSet.bg2Color,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSvgImage(
                assetName: subscription.icon,
                width: 40,
                height: 40,
                color: isActive ? const Color(0xFF000000) : ColorSet.textColor,
              ),
              Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(subscription.title,
                              style: context.textTheme.bodyLargeBold.copyWith(
                                  color: isActive
                                      ? const Color(0xFF000000)
                                      : ColorSet.textColor,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Gap(5),
                        if (subscription.priceLabel.isNotEmpty)
                          Text(subscription.priceLabel,
                              style: context.textTheme.bodyLargeBold.copyWith(
                                  color: isActive
                                      ? const Color(0xFF004DFF)
                                      : const Color(0xFFFFC533),
                                  fontWeight: FontWeight.w700)),
                      ],
                    ),
                    Gap(5),
                    Text(subscription.subtitle,
                        style: context.textTheme.bodyLarge.copyWith(
                            color: isActive
                                ? const Color(0xFF000000)
                                : ColorSet.textColor),
                        overflow: TextOverflow.visible),
                  ],
                ),
              ),
            ],
          ),
          Gap(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: GestureDetector(
              onTap: selectedTab == 'Subscriptions' && !isActive
                  ? () => showPaymentSubscriptionsDialog(context)
                  : null,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _shopActionBackground(isActive),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isActive ? 'Active' : 'Buy now',
                  style: context.textTheme.titleSmall.copyWith(
                    color: _shopActionForeground(isActive),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget eventTile(Subscription subscription) {
    bool isActive = subscription.actionName == 'Active';
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size(20)),
        color: isActive ? const Color(0xFFFFC533) : ColorSet.bg2Color,
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSvgImage(
                  assetName: subscription.icon,
                  width: 25,
                  height: 25,
                  color:
                      isActive ? const Color(0xFF000000) : ColorSet.textColor,
                ),
                Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subscription.title,
                          style: context.textTheme.bodyLargeBold.copyWith(
                              color: isActive
                                  ? const Color(0xFF000000)
                                  : ColorSet.textColor,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: size(5)),
                      Expanded(
                        child: Text(subscription.subtitle,
                            style: context.textTheme.bodyMedium.copyWith(
                                color: isActive
                                    ? const Color(0xFF000000)
                                    : ColorSet.textColor),
                            overflow: TextOverflow.visible),
                      ),
                    ],
                  ),
                ),
                Gap(12),
                if (subscription.priceLabel.isNotEmpty)
                  Text(subscription.priceLabel,
                      style: context.textTheme.bodyLargeBold.copyWith(
                          color: isActive
                              ? const Color(0xFF004DFF)
                              : const Color(0xFFFFC533),
                          fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: size(144),
              height: size(40),
              decoration: BoxDecoration(
                color: _shopActionBackground(isActive),
                borderRadius:
                    BorderRadius.circular(12), // Match the button's radius
              ),
              child: Center(
                child: GestureDetector(
                  onTap: selectedTab == 'Subscriptions' && !isActive
                      ? () => showPaymentSubscriptionsDialog(context)
                      : null,
                  child: Text(isActive ? "Active" : "Buy now",
                      style: context.textTheme.titleSmall.copyWith(
                          color: _shopActionForeground(isActive),
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _shopActionBackground(bool isActive) {
    if (isActive) return const Color(0xFF000000);
    return ColorSet.isDarkMode ? Colors.white : Colors.black;
  }

  Color _shopActionForeground(bool isActive) {
    if (isActive) return Colors.white;
    return ColorSet.isDarkMode ? Colors.black : Colors.white;
  }
}

class Subscription {
  final String icon;
  final String title;
  final String subtitle;
  final String actionName;
  final String priceLabel;

  Subscription({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionName,
    required this.priceLabel,
  });
}
