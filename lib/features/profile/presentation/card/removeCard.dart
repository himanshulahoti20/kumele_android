import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/features/profile/presentation/card/AddPaypal.dart';
import 'package:kuemele/features/shop/presentation/shop.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:lottie/lottie.dart';

import 'package:kuemele/shared/components/radio.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class RemovecardDialog extends StatefulWidget implements BasePage {
  const RemovecardDialog({super.key});

  @override
  State<RemovecardDialog> createState() => _RemovecardDialogState();

  @override
  String get screenName => 'RemovecardDialog';
}

class _RemovecardDialogState extends State<RemovecardDialog> {
  TextEditingController discountCodeCTRL = TextEditingController();
  bool soundNotification = false;
  String selectedGender = '';

  void showActionNotAllowedDialog(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    showDialog(
      context: context,
      barrierColor: ColorSet.bcColor, // Less dark background
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: size(isPortrait ? 250 : 400),
            height: size(isPortrait ? 200 : 300),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorSet.bg2Color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: isPortrait
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  IconSet.jsonImportant,
                  height: 98,
                  width: 98,
                  fit: BoxFit.fill,
                ),
                Text(AppLocalizations.of(context)!.removeCardActionNotAllowedTitle,
                    style: context.textTheme.titleLarge,
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: buildTablet(),
      phone: Scaffold(
        backgroundColor: ColorSet.bg3Color,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                MobileHeader(label: AppLocalizations.of(context)!.removeCardTitle),
                Gap(22),
                Expanded(
                  child: SingleChildScrollView(child: buildContent()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTablet() {
    return AppTitledDialog(
      title: AppLocalizations.of(context)!.removeCardTitle,
      child: buildContent(),
    );
  }

  Widget buildContent() {
    return Column(
      children: [
        SizedBox(height: size(30)),
        cardPart1(),
        SizedBox(height: size(15)),
        Divider(color: ColorSet.profileBorderColor),
        SizedBox(height: size(30)),
        Row(
          children: <Widget>[
            Text(AppLocalizations.of(context)!.removeCardConnectEscrowLabel,
                style: context.textTheme.bodySmall.copyWith(fontSize: 13)),
            Spacer(),
            AppButton.primary(
              label: 'PayPal',
              iconAsset: IconSet.paypalIcon,
              foregroundColor: ColorSet.bg2Color,
              onPressed: () {
                if (FormFactor.isTablet) {
                  Navigator.of(context).pop();
                }
                if (FormFactor.isPhone) {
                  AppBottomSheet.show(
                    context: context,
                    child: AddpaypalDialog(),
                  );
                } else {
                  showDialog(
                    context: context,
                    barrierColor: ColorSet.bcColor,
                    builder: (context) => AddpaypalDialog(),
                  );
                }
              },
            ),
            Gap(10),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: ColorSet.bgColor,
                  borderRadius: BorderRadius.circular(size(8)),
                ),
                child: Image.asset(IconSet.redok, height: 22, width: 22),
              ),
            ),
          ],
        ),
        SizedBox(height: size(50)),
        Divider(color: ColorSet.profileBorderColor),
        SizedBox(height: size(40)),
        Center(
          child: Text(AppLocalizations.of(context)!.removeCardSubscriptionsLabel,
              style: context.textTheme.heading3
                  .copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        SizedBox(height: size(40)),
        FutureBuilder<List<SubscriptionTier>>(
          future: Web3Repo.getSubscriptionTiers(),
          builder: (context, snapshot) {
            final tiers = snapshot.data ?? const [];
            if (tiers.isEmpty) return const SizedBox.shrink();
            return Column(
              children: [
                for (final tier in tiers.take(3)) ...[
                  eventTile1(_tierToTile(tier)),
                  SizedBox(height: size(10)),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Subscription _tierToTile(SubscriptionTier tier) {
    return Subscription(
      icon: SVGAsset.icon_crown,
      title: tier.name,
      subtitle: tier.description,
      actionName: 'Buy now',
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

  Widget cardPart1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCardRow('1'),
        Gap(26),
        buildCardRow('2'),
        Gap(26),
        buildCardRow('3'),
        Gap(26),
        buildCardRow('4'),
      ],
    );
  }

  Widget buildCardRow(String id) {
    return GestureDetector(
      onTap: () => setState(() => selectedGender = id),
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RARadio(
              onChanged: (value, isSelected) =>
                  setState(() => selectedGender = id),
              value: id,
              textSize: size(16),
              radioSize: 18,
              groupValue: selectedGender,
            ),
            Gap(5),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 3,
                    children: [
                      Text('•••• •••• •••• 4634',
                          style: context.textTheme.bodySmall
                              .copyWith(fontSize: 13)),
                      GestureDetector(
                        onTap: () {
                          showActionNotAllowedDialog(context);
                        },
                        child: Image.asset(
                          IconSet.cardLogoIcon,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text('Master Card',
                          style: context.textTheme.bodySmall
                              .copyWith(fontSize: 13)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('Expires 12-08-23', style: context.textTheme.labelSmall),
                ],
              ),
            ),
            Gap(10),
            ClickWidget(
                onPressed: () {
                  AppDialog.confirm(
                    context: context,
                    title: AppLocalizations.of(context)!.removeCardConfirmDeletionTitle,
                    width: AppDialogSize.widthFor(context),
                  );
                },
                child: Image.asset(IconSet.trashIcon,
                    width: 26, height: 26, fit: BoxFit.fill))
          ],
        ),
      ),
    );
  }

  Widget eventTile1(Subscription subscription) {
    bool isActive = subscription.actionName == 'Active';
    return Padding(
      padding: EdgeInsets.only(bottom: size(30.5)),
      child: Container(
        padding: EdgeInsets.fromLTRB(17, 17, 17, 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size(20)),
          color: isActive ? ColorSet.specialYellowColor : ColorSet.bgColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KumeleAssetWidget(
              assetPath: subscription.icon,
              width: 25,
              height: 25,
              color: isActive ? Colors.black : ColorSet.textColor,
            ),
            Gap(10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(subscription.title,
                          style: context.textTheme.bodyLargeBold.copyWith(
                              color:
                                  isActive ? Colors.black : ColorSet.textColor,
                              fontWeight: FontWeight.w700)),
                      const Spacer(),
                      if (subscription.priceLabel.isNotEmpty)
                        Text(subscription.priceLabel,
                            style: context.textTheme.bodyLargeBold.copyWith(
                                color: isActive &&
                                        subscription.title
                                            .toLowerCase()
                                            .contains('yearly gold')
                                    ? ColorSet.specialBlueColor
                                    : const Color(0xFFFFC533),
                                fontWeight: FontWeight.w700)),
                    ],
                  ),
                  if (isActive) ...[
                    SizedBox(height: size(8)),
                    Text(AppLocalizations.of(context)!.active,
                        style: context.textTheme.bodySmallSemiBold.copyWith(
                            color: const Color(0xFF004DFF),
                            fontWeight: FontWeight.w600)),
                  ],
                  SizedBox(height: size(8)),
                  Text(subscription.subtitle,
                      style: context.textTheme.bodySmall.copyWith(
                          color: isActive
                              ? const Color(0xFF000000)
                              : ColorSet.textColor),
                      overflow: TextOverflow.visible),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppButton.primary(
                      label: isActive ? "Deactivate" : "Activate",
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
