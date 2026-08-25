import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/radio.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';

/// The selectable store-credit row shared by event and NFT checkout.
class StoreCreditToggle extends StatelessWidget {
  const StoreCreditToggle({
    super.key,
    required this.balance,
    required this.notifier,
  });

  final StoreCreditBalance balance;
  final ValueNotifier<bool> notifier;

  static const yellow = Color(0xFFFFC533);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, isActive, _) {
        final expiry = formatStoreCreditExpiry(balance);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: ColorSet.tileFillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorSet.profileBorderColor),
          ),
          child: Row(
            children: [
              AppSvgImage(
                assetName: Assets.icons.notifications.wallet.path,
                width: 28,
                height: 28,
                color: yellow,
              ),
              const Gap(10),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => notifier.value = !notifier.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Store Credit',
                            style: context.textTheme.bodyLargeBold.copyWith(
                              color: ColorSet.textColor,
                            ),
                          ),
                          const Gap(8),
                          Text(
                            formatStoreCreditAmount(balance),
                            style: context.textTheme.bodyLargeBold.copyWith(
                              color: yellow,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Use for events and NFTs',
                        style: context.textTheme.bodySmall.copyWith(
                          color: ColorSet.subTextColor,
                        ),
                      ),
                      if (expiry != null)
                        Text(
                          expiry,
                          style: context.textTheme.bodySmall.copyWith(
                            color: ColorSet.subTextColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const Gap(8),
              RARadio(
                value: 'store-credit',
                groupValue: isActive ? 'store-credit' : '',
                radioSize: 22,
                spaceBetween: 0,
                toggleable: true,
                onChanged: (_, selected) => notifier.value = selected,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Shared by every store-credit display (join-event toggle, Shop balance
/// card, Cart checkout) so the balance always reads the same way.
String formatStoreCreditAmount(StoreCreditBalance balance) {
  final symbol = switch (balance.currency.toUpperCase()) {
    'EUR' => '€',
    'USD' => r'$',
    'GBP' => '£',
    _ => '${balance.currency} ',
  };
  return '$symbol${balance.amount.toStringAsFixed(2)}';
}

String? formatStoreCreditExpiry(StoreCreditBalance balance) {
  final expiry = balance.expiryDate;
  if (expiry == null) return null;
  return 'Expires ${DateFormat('dd MMM yyyy').format(expiry.toLocal())}';
}
