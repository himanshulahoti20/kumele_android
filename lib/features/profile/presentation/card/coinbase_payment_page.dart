import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';

enum _Step { sendPayment, checkout, complete }

/// Mirrors iOS CoinbasePaymentView: UI only — every amount, address, order
/// code and date is the placeholder copy from the design. Nothing here calls
/// a Coinbase API yet.
class CoinbasePaymentPage extends StatefulWidget {
  const CoinbasePaymentPage({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => const CoinbasePaymentPage(),
      ),
    );
  }

  @override
  State<CoinbasePaymentPage> createState() => _CoinbasePaymentPageState();
}

class _CoinbasePaymentPageState extends State<CoinbasePaymentPage> {
  _Step _step = _Step.sendPayment;
  bool _isMerchantExpanded = false;

  Color get _borderColor => ColorSet.textColor.withValues(alpha: 0.18);

  void _goToComplete() {
    setState(() => _step = _Step.complete);
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet.bg3Color,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSvgImage(
                    assetName: ColorSet.isDarkMode
                        ? Assets.svg.icConfettiDark.path
                        : Assets.svg.icConfetti.path,
                    width: 26,
                    height: 26,
                  ),
                  const Gap(8),
                  Text(
                    'Event Ads',
                    style: context.textTheme.titleLargeBold
                        .copyWith(fontSize: 22, color: ColorSet.textColor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: switch (_step) {
                  _Step.sendPayment => _buildSendPayment(),
                  _Step.checkout => _buildCheckout(),
                  _Step.complete => _buildComplete(),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text.rich(
                TextSpan(
                  text: 'Payments processed by ',
                  style: context.textTheme.bodyMedium.copyWith(
                    fontSize: 13,
                    color: ColorSet.textColor.withValues(alpha: 0.5),
                  ),
                  children: [
                    TextSpan(
                      text: 'Coinbase Commerce',
                      style: TextStyle(color: ColorSet.specialBlueColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendPayment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Send payment',
          style: context.textTheme.titleLargeBold
              .copyWith(fontSize: 22, color: ColorSet.textColor),
        ),
        const Gap(8),
        Text(
          'To make a payment, send BTC to the address below',
          style: context.textTheme.bodyLarge.copyWith(
            fontSize: 16,
            color: ColorSet.textColor.withValues(alpha: 0.75),
          ),
        ),
        const Gap(24),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _borderColor),
          ),
          child: Column(
            children: [
              _copyableRow('Amount', '0.00079 BTC'),
              Divider(height: 1, color: _borderColor),
              _copyableRow('BTC Address', '0x2d…3b1c'),
            ],
          ),
        ),
        const Gap(24),
        Row(
          children: [
            Expanded(child: Divider(color: _borderColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Or',
                style: context.textTheme.bodyMedium.copyWith(
                  fontSize: 15,
                  color: ColorSet.textColor.withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(child: Divider(color: _borderColor)),
          ],
        ),
        const Gap(20),
        _primaryButton(
          'Pay with wallet',
          onTap: () => setState(() => _step = _Step.checkout),
        ),
        const Gap(4),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            foregroundColor: ColorSet.textColor,
          ),
          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildCheckout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () =>
              setState(() => _isMerchantExpanded = !_isMerchantExpanded),
          child: Row(
            children: [
              AppSvgImage(
                assetName: ColorSet.isDarkMode
                    ? Assets.svg.icConfettiDark.path
                    : Assets.svg.icConfetti.path,
                width: 22,
                height: 22,
              ),
              const Gap(8),
              Text(
                'Event Ads',
                style: context.textTheme.bodyLarge
                    .copyWith(fontSize: 16, color: ColorSet.textColor),
              ),
              const Spacer(),
              Icon(
                _isMerchantExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 20,
                color: ColorSet.textColor,
              ),
            ],
          ),
        ),
        const Gap(24),
        Text(
          'Total',
          style: context.textTheme.bodyLarge
              .copyWith(fontSize: 16, color: ColorSet.textColor),
        ),
        const Gap(4),
        Text(
          r'$23.07',
          style: context.textTheme.titleLargeBold
              .copyWith(fontSize: 28, color: ColorSet.specialBlueColor),
        ),
        const Gap(20),
        _primaryButton('Pay with Coinbase', onTap: _goToComplete),
      ],
    );
  }

  Widget _buildComplete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.asset(IconSet.closeIcon, width: 24, height: 24),
          ),
        ),
        const Gap(12),
        Center(
          child: Column(
            children: [
              Image.asset(Assets.logo.kumeleLogo.path, width: 60, height: 60),
              const Gap(8),
              Text(
                'Thank You!',
                style: context.textTheme.titleLargeBold
                    .copyWith(fontSize: 24, color: ColorSet.textColor),
              ),
              const Gap(8),
              Text(
                'Your payment is complete.',
                style: context.textTheme.bodyLarge.copyWith(
                  fontSize: 16,
                  color: ColorSet.textColor.withValues(alpha: 0.75),
                ),
              ),
              const Gap(8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View payment',
                    style: context.textTheme.bodyLarge.copyWith(
                      fontSize: 16,
                      color: ColorSet.specialBlueColor,
                    ),
                  ),
                  const Gap(4),
                  Icon(Icons.open_in_new,
                      size: 16, color: ColorSet.specialBlueColor),
                ],
              ),
            ],
          ),
        ),
        const Gap(32),
        _receiptRow('Status', 'Completed', valueColor: ColorSet.specialBlueColor),
        _receiptRow('Order code', 'Z93B7TWA'),
        _receiptRow('Date & time', 'Feb 2, 2024, 10:24 AM'),
        _receiptRow('Exchange rate', '1 BTC 33.644 USD'),
        const Gap(12),
        Divider(height: 1, color: _borderColor),
        const Gap(16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total',
              style: context.textTheme.titleLargeBold
                  .copyWith(fontSize: 17, color: ColorSet.textColor),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  r'$16.29',
                  style: context.textTheme.titleLargeBold
                      .copyWith(fontSize: 17, color: ColorSet.textColor),
                ),
                Text(
                  '0.00048 BTC',
                  style: context.textTheme.bodyMedium.copyWith(
                    fontSize: 15,
                    color: ColorSet.textColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _copyableRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(
            label,
            style: context.textTheme.bodyLarge
                .copyWith(fontSize: 16, color: ColorSet.textColor),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyLargeSemiBold
                  .copyWith(fontSize: 16, color: ColorSet.textColor),
            ),
          ),
          const Gap(12),
          GestureDetector(
            onTap: () => Clipboard.setData(ClipboardData(text: value)),
            child: Text(
              'Copy',
              style: context.textTheme.bodyLarge
                  .copyWith(fontSize: 16, color: ColorSet.specialBlueColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _receiptRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: context.textTheme.bodyLarge
                .copyWith(fontSize: 16, color: ColorSet.textColor),
          ),
          const Spacer(),
          Text(
            value,
            style: context.textTheme.bodyLarge.copyWith(
              fontSize: 16,
              color: valueColor ?? ColorSet.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton(String label, {required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: ColorSet.revbg3Color,
          foregroundColor: ColorSet.bg2Color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontSize: 17)),
      ),
    );
  }
}
