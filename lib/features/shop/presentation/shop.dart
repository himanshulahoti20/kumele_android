import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/shop/presentation/nfts/nft_tab_view.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/modals/dialog/subscription_expired_dialog.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
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

  @override
  void initState() {
    super.initState();
    // Show the subscription expired dialog when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppDialog.adaptive(
        context: context,
        width: AppDialogSize.widthFor(context),
        dialog: SubscriptionDialog(),
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
    return WillPopScope(
      onWillPop: () async {
        InjectionHelper.homePageCubit.goBack(context);
        return false;
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
        WidgetByDevice(
          phone: buildTabBar(),
          tablet: Row(
            children: [
              Expanded(
                flex: 2,
                child: buildTabBar(),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 26),
                  child: buildStoreCredit(),
                ),
              ),
            ],
          ),
        ),
        WidgetByDevice(
          phone: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: buildStoreCredit(),
          ),
        ),
        Gap(12),
      ],
    );
  }

  Container buildTabBar() {
    return Container(
      height: 50,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: buildTab('Subscriptions')),
          Expanded(child: buildTab('Guest tickets')),
          Expanded(child: buildTab('NFTs')),
        ],
      ),
    );
  }

  Widget buildStoreCredit() {
    return Row(
      mainAxisAlignment: FormFactor.isTablet
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      children: [
        Text('Store Credit ',
            style: context.textTheme.headlineSmallBold
                .copyWith(fontSize: 27, fontWeight: FontWeight.w700)),
        SizedBox(height: size(5)),
        Text('\$25',
            style: context.textTheme.headlineSmallBold.copyWith(
                color: ColorSet.lightBlueColor,
                fontSize: 27,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget buildTab(String tab) {
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
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selectedTab == tab ? ColorSet.bg2Color : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(tab,
            style: context.textTheme.titleMediumSemiBold
                .copyWith(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget switchEventTile() {
    if (selectedTab == 'NFTs') {
      return const NftTabView();
    }

    if (okay) {
      final list =
          selectedTab == 'Guest tickets' ? guestTicketList : subscriptionsList;
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
                        Text('\$${subscription.price}',
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
            child: AppButton.primary(
              label: 'Buy Now',
              onPressed: () {},
              backgroundColor:
                  isActive ? const Color(0xFF000000) : ColorSet.textColor,
              foregroundColor: isActive ? Colors.white : ColorSet.bg2Color,
              fullWidth: true,
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
                Text('\$${subscription.price}',
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
                color: isActive
                    ? const Color(0xFF000000)
                    : ColorSet.textColor, // Adjust color as needed
                borderRadius:
                    BorderRadius.circular(12), // Match the button's radius
              ),
              child: Center(
                child: Text("Buy Now",
                    style: context.textTheme.titleSmall.copyWith(
                        color: isActive ? Colors.white : ColorSet.bg2Color,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Subscription {
  final String icon;
  final String title;
  final String subtitle;
  final String actionName;
  final double price;

  Subscription({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionName,
    required this.price,
  });
}

List<Subscription> subscriptionsList = [
  Subscription(
    icon: SVGAsset.icon_crown,
    title: "Event ads",
    subtitle: "Purchase 7 days pre-event AD",
    actionName: "Buy now",
    price: 7.07,
  ),
  Subscription(
    icon: SVGAsset.icon_crown,
    title: "Yearly Gold",
    subtitle: "Unlimited location change, valid for 30 days",
    actionName: "Buy now",
    price: 8.25,
  ),
  Subscription(
    icon: SVGAsset.icon_crown,
    title: "Monthly Silver",
    subtitle:
        "Get 30 days ADs free experience. Cancel anytime but before the new month starts.",
    actionName: "Buy now",
    price: 15.00,
  ),
  Subscription(
    icon: SVGAsset.icon_crown,
    title: "Monthly Gold",
    subtitle:
        "Get 30 days ADs free experience. One time fr guest. Cancel anytime but before the new month starts.",
    actionName: "Buy now",
    price: 18.87,
  ),
  Subscription(
    icon: SVGAsset.icon_crown,
    title: "Yearly Gold",
    subtitle:
        "Get 365 days ADs free experience. One time free (6-20 guest invite). Unlimited location change",
    actionName: "Buy now",
    price: 120.00,
  ),
];

class GuestTicket {
  final String icon;
  final String title;
  final String subtitle;
  final String actionName;
  final double price;

  GuestTicket({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionName,
    required this.price,
  });
}

List<Subscription> guestTicketList = [
  Subscription(
    icon: IconSet.ticketsIcon,
    title: "6-20 guests",
    subtitle: "Number of guests valid only for this event",
    actionName: "Active",
    price: 7.07,
  ),
  Subscription(
    icon: IconSet.ticketsIcon,
    title: "21-40 guests",
    subtitle: "Number of guests valid only for this event",
    actionName: "Buy now",
    price: 10.61,
  ),
  Subscription(
    icon: IconSet.ticketsIcon,
    title: "41-60 guests",
    subtitle: "Number of guests valid only for this event",
    actionName: "Buy now",
    price: 14.15,
  ),
  Subscription(
    icon: IconSet.ticketsIcon,
    title: "61-80 guests",
    subtitle: "Number of guests valid only for this event",
    actionName: "Buy now",
    price: 17.69,
  ),
  Subscription(
    icon: IconSet.ticketsIcon,
    title: "81-150 guests",
    subtitle: "Number of guests valid only for this event",
    actionName: "Buy now",
    price: 21.23,
  ),
];
