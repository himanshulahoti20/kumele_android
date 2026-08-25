import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/discover/data/models/event_plan_model.dart';
import 'package:kuemele/features/shop/presentation/nfts/nft_tab_view.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/modals/dialog/subscription_expired_dialog.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/services/payment/google_play_billing_service.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/store_credit_toggle.dart';
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
  List<EventPlanModel> _eventPlans = const [];
  bool _isLoadingEventPlans = true;
  List<SubscriptionTier> _tiers = const [];
  SubscriptionStatus? _subscriptionStatus;
  StoreCreditBalance? _storeCreditBalance;
  bool _isLoadingTiers = true;
  bool _isBuyingSubscription = false;

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
    _loadStoreCreditBalance();
  }

  Future<void> _loadStoreCreditBalance() async {
    try {
      final balance = await Web3Repo.getStoreCreditBalance();
      if (!mounted) return;
      setState(() => _storeCreditBalance = balance);
    } catch (_) {
      // Balance card just stays hidden if this fails.
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
      AppDialog.show(
        context: context,
        width: AppDialogSize.widthFor(context),
        dialog: SubscriptionDialog(
          tierName: _subscriptionDisplayName(status),
          periodEnd: periodEnd,
        ),
      );
    });
  }

  String _subscriptionDisplayName(SubscriptionStatus status) {
    for (final tier in _tiers) {
      if (status.matchesTier(tier)) return tier.name;
    }
    return status.tierName?.trim().isNotEmpty == true
        ? status.tierName!.trim()
        : 'active';
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
        backgroundColor: ColorSet.bg2Color,
        body: WidgetByDevice(
          tablet: _buildTablet(),
          phone: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(20),
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
      padding: const EdgeInsets.all(20),
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
        const Gap(12),
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
    final label = tab == 'Guest Tickets' ? 'Guest tickets' : tab;
    return GestureDetector(
      onTap: isSelected ? null : () => setState(() => selectedTab = tab),
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
            label,
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

    final isSubscriptionsTab = selectedTab == 'Subscriptions';
    if (selectedTab == 'Guest Tickets' && _isLoadingEventPlans ||
        isSubscriptionsTab && _isLoadingTiers) {
      return Center(
        child: Lottie.asset(IconSet.jsonLoading, width: 98, height: 98),
      );
    }
    final list = selectedTab == 'Guest Tickets'
        ? _eventPlans.map(_eventPlanToTile).toList()
        : _tiers.map(_tierToTile).toList();
    if (list.isEmpty) {
      return _withStoreCreditCard(
        isSubscriptionsTab,
        Padding(
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
        ),
      );
    }
    final useListLayout = Utils.isPortrait;
    return _withStoreCreditCard(
      isSubscriptionsTab,
      WidgetByDevice(
        tablet: GridView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: useListLayout ? 1 : 2,
            childAspectRatio: useListLayout ? 4.5 : 3.0,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
          ),
          children: list.map(eventTile).toList(),
        ),
        phone: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: list.length,
          separatorBuilder: (_, __) => const Gap(16),
          itemBuilder: (_, index) => eventTileMobile(list[index]),
        ),
      ),
    );
  }

  Widget _withStoreCreditCard(bool isSubscriptionsTab, Widget child) {
    final balance = _storeCreditBalance;
    if (!isSubscriptionsTab || balance == null) {
      return child;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [_storeCreditCard(balance), const Gap(18), child],
    );
  }

  Widget _storeCreditCard(StoreCreditBalance balance) {
    final expiry = formatStoreCreditExpiry(balance);
    final nextExpiry = expiry?.replaceFirst('Expires', 'Next credit expires');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorSet.profileBorderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorSet.tileFillColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AppSvgImage(
              assetName: Assets.icons.notifications.wallet.path,
              width: 30,
              height: 30,
              color: StoreCreditToggle.yellow,
            ),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Store Credit',
                  style: context.textTheme.titleLargeBold.copyWith(
                    color: ColorSet.textColor,
                    fontSize: 21,
                  ),
                ),
                const Gap(4),
                Text(
                  'Available for event tickets\nand NFTs',
                  style: context.textTheme.bodyMedium.copyWith(
                    color: ColorSet.color525252,
                    fontSize: 15,
                  ),
                ),
                if (nextExpiry != null) ...[
                  const Gap(4),
                  Text(
                    nextExpiry,
                    style: context.textTheme.bodyMedium.copyWith(
                      color: ColorSet.color525252,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Gap(8),
          Text(
            formatStoreCreditAmount(balance),
            style: context.textTheme.heading1.copyWith(
              color: StoreCreditToggle.yellow,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Subscription _eventPlanToTile(EventPlanModel plan) {
    return Subscription(
      icon: IconSet.ticketsIcon,
      title: plan.guestRangeLabel,
      subtitle: AppLocalizations.of(context)!.guestCountValidForEventOnly,
      actionName: plan.priceEur == 0 ? 'Active' : 'Inactive',
      priceLabel: plan.priceLabel,
    );
  }

  Subscription _tierToTile(SubscriptionTier tier) {
    final status = _subscriptionStatus;
    final isActiveTier = status?.isActive == true && status!.matchesTier(tier);
    final normalizedName = tier.name.toLowerCase();
    return Subscription(
      tier: tier,
      icon: normalizedName.contains('event ad')
          ? SVGAsset.icon_party
          : SVGAsset.icon_crown,
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
    final currency = (tier.currency ?? 'USD').toUpperCase();
    final symbol = switch (currency) {
      'EUR' => '€',
      'USD' => r'$',
      'GBP' => '£',
      _ => '$currency ',
    };
    return '$symbol${price.toStringAsFixed(2)}';
  }

  Future<void> _buySubscription(SubscriptionTier? tier) async {
    final l10n = AppLocalizations.of(context)!;
    if (tier == null) {
      InjectionHelper.snackBar.showError(l10n.noSubscriptionTierAvailable);
      return;
    }
    if (!ApiService.hasToken()) {
      InjectionHelper.snackBar.showError(l10n.signInBeforeSubscription);
      return;
    }

    final googleProductId = tier.googleProductId?.trim();
    if (googleProductId == null || googleProductId.isEmpty) {
      InjectionHelper.snackBar.showError(
        l10n.purchaseFailedMessage('Google Play product is not configured.'),
      );
      return;
    }

    setState(() => _isBuyingSubscription = true);
    try {
      final status = await GooglePlayBillingService.buySubscription(
        googleProductId,
        basePlanId: tier.googleBasePlanId,
      );
      if (status == null) return; // user cancelled the Play Billing sheet
      InjectionHelper.snackBar.showSuccess(l10n.subscriptionActivatedMessage);
      await _loadSubscriptions();
    } catch (e) {
      InjectionHelper.snackBar.showError(l10n.purchaseFailedMessage(e));
    } finally {
      if (mounted) setState(() => _isBuyingSubscription = false);
    }
  }

  Widget eventTileMobile(Subscription subscription) {
    final isActive = subscription.actionName == 'Active';
    final canBuy = subscription.actionName == 'Buy now';
    final isGuestTicket = selectedTab == 'Guest Tickets';
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: _shopCardBackground(isActive),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shopCardIcon(subscription, isActive),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            subscription.title,
                            style: context.textTheme.titleLargeBold.copyWith(
                              color: _shopCardTextColor(isActive),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Gap(5),
                        if (subscription.priceLabel.isNotEmpty)
                          Text(
                            subscription.priceLabel,
                            style: context.textTheme.titleLargeBold.copyWith(
                              color: isActive
                                  ? const Color(0xFF0057FF)
                                  : StoreCreditToggle.yellow,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                    const Gap(5),
                    Text(
                      subscription.subtitle,
                      style: context.textTheme.bodyLarge.copyWith(
                        color: _shopCardTextColor(isActive),
                        fontSize: 17,
                        height: 1.2,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: GestureDetector(
              onTap: selectedTab == 'Subscriptions' &&
                      canBuy &&
                      !_isBuyingSubscription
                  ? () => _buySubscription(subscription.tier)
                  : null,
              child: Container(
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _shopActionBackground(isActive, isGuestTicket),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isGuestTicket
                      ? (isActive ? 'Active' : 'Inactive')
                      : subscription.actionName,
                  style: context.textTheme.titleLarge.copyWith(
                    color: _shopActionForeground(isActive, isGuestTicket),
                    fontSize: 16,
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
    final isActive = subscription.actionName == 'Active';
    final canBuy = subscription.actionName == 'Buy now';
    final isGuestTicket = selectedTab == 'Guest Tickets';
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size(20)),
        color: _shopCardBackground(isActive),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 25,
                  height: 25,
                  child:
                      FittedBox(child: _shopCardIcon(subscription, isActive)),
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
                color: _shopActionBackground(isActive, isGuestTicket),
                borderRadius:
                    BorderRadius.circular(12), // Match the button's radius
              ),
              child: Center(
                child: GestureDetector(
                  onTap: selectedTab == 'Subscriptions' &&
                          canBuy &&
                          !_isBuyingSubscription
                      ? () => _buySubscription(subscription.tier)
                      : null,
                  child: Text(
                      isGuestTicket
                          ? (isActive ? 'Active' : 'Inactive')
                          : subscription.actionName,
                      style: context.textTheme.titleSmall.copyWith(
                          color: _shopActionForeground(isActive, isGuestTicket),
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _shopActionBackground(bool isActive, bool isGuestTicket) {
    if (isActive) return const Color(0xFFF4F4F4);
    if (isGuestTicket) return const Color(0xFF808080);
    return ColorSet.isDarkMode ? const Color(0xFFF4F4F4) : Colors.black;
  }

  Color _shopActionForeground(bool isActive, bool isGuestTicket) {
    if (isActive) return Colors.black;
    if (isGuestTicket) return Colors.white;
    return ColorSet.isDarkMode ? Colors.black : Colors.white;
  }

  Color _shopCardBackground(bool isActive) =>
      isActive ? StoreCreditToggle.yellow : ColorSet.home2ndCardColor;

  Color _shopCardTextColor(bool isActive) =>
      isActive ? Colors.black : ColorSet.textColor;

  Widget _shopCardIcon(Subscription subscription, bool isActive) {
    final color = _shopCardTextColor(isActive);
    if (subscription.title.toLowerCase().contains('location')) {
      return Icon(Icons.card_travel_rounded, size: 40, color: color);
    }
    return AppSvgImage(
      assetName: subscription.icon,
      width: 40,
      height: 40,
      color: color,
    );
  }
}

class Subscription {
  final SubscriptionTier? tier;
  final String icon;
  final String title;
  final String subtitle;
  final String actionName;
  final String priceLabel;

  Subscription({
    this.tier,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionName,
    required this.priceLabel,
  });
}
