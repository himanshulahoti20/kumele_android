import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// Half-sheet shown whenever a claim/purchase response contains a pending
/// on-chain transaction that needs a wallet signature (see guide §3.9).
/// Tapping "Open Phantom Wallet" fires the deep link and dismisses — it does
/// NOT wait for a callback confirming the sign succeeded.
class WalletSignatureSheet extends StatelessWidget {
  final String? message;

  const WalletSignatureSheet({super.key, this.message});

  static const _phantomDeepLink = 'https://phantom.app/ul/v1/signAndSendTransaction';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: ColorSet.bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.24), borderRadius: BorderRadius.circular(3)),
          ),
          const Gap(24),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF9945FF), Color(0xFF14F195)],
            ).createShader(bounds),
            child: const Icon(Icons.draw_outlined, size: 48, color: Colors.white),
          ),
          const Gap(24),
          Text(
            'Wallet Signature Required',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, fontWeight: FontWeight.w700, color: ColorSet.textColor),
          ),
          const Gap(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              message ?? 'Open your wallet app to approve this transaction.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, color: ColorSet.textColor.withValues(alpha: 0.65)),
            ),
          ),
          const Gap(24),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () async {
                final uri = Uri.tryParse(_phantomDeepLink);
                if (uri != null) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
                if (context.mounted) Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF9945FF), Color(0xFF6B2FBA)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 20),
                    Gap(8),
                    Text('Open Phantom Wallet', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          const Gap(12),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Text(
              'Dismiss',
              style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, color: ColorSet.textColor.withValues(alpha: 0.5)),
            ),
          ),
        ],
      ),
    );
  }
}
