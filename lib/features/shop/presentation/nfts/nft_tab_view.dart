import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/shop/presentation/nfts/nft_card_deck.dart';
import 'package:kuemele/features/shop/presentation/nfts/wallet_signature_sheet.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/services/payment/checkout_flow.dart';
import 'package:lottie/lottie.dart';
import 'package:kuemele/shared/components/icons.dart';

const _innerTabs = ['Rewards', 'Claimed', 'Market Place'];

const _emptyMessages = {
  'Rewards': 'No reward NFTs yet.',
  'Claimed': "You haven't claimed any NFTs yet.",
  'Market Place': 'No NFTs in the marketplace right now.',
};

/// Shop → NFTs segment (see AI/14_NFTModulePixelPerfectUIGuide.md §3).
/// Inner Rewards/Claimed/Market Place tabs, each backed by the real
/// `/nfts/*` endpoints via [Web3Repo], rendered as a swipeable card deck.
class NftTabView extends StatefulWidget {
  const NftTabView({super.key});

  @override
  State<NftTabView> createState() => _NftTabViewState();
}

class _NftTabViewState extends State<NftTabView> {
  String _innerTab = 'Rewards';
  final Map<String, List<NftItem>> _data = {};
  final Map<String, bool> _loading = {};
  final Map<String, String?> _error = {};
  final Set<String> _pendingIds = {};

  @override
  void initState() {
    super.initState();
    _load('Rewards');
  }

  Future<void> _load(String tab) async {
    setState(() {
      _loading[tab] = true;
      _error[tab] = null;
    });
    try {
      final items = switch (tab) {
        'Rewards' => await Web3Repo.getRewardNfts(),
        'Claimed' => await Web3Repo.getMyNfts(),
        _ => await Web3Repo.getMarketplaceNfts(),
      };
      if (!mounted) return;
      setState(() {
        _data[tab] = items;
        _loading[tab] = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error[tab] = e.error ?? ApiErrorMessage.APP_API_ERROR;
        _loading[tab] = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error[tab] = ApiErrorMessage.APP_UNKNOWN_ERROR;
        _loading[tab] = false;
      });
    }
  }

  void _selectTab(String tab) {
    if (tab == _innerTab) return;
    setState(() => _innerTab = tab);
    if (!_data.containsKey(tab) && _loading[tab] != true) {
      _load(tab);
    }
  }

  Future<void> _handleClaim(NftItem item) async {
    setState(() => _pendingIds.add(item.id));
    try {
      final result = await Web3Repo.claimNft(item.id);
      if (result?.pendingTransactionBase64 != null) {
        _showWalletSheet(result!.message);
      } else {
        InjectionHelper.snackBar
            .showSuccess(AppLocalizations.of(context)!.nftClaimedMessage);
      }
      await _load('Rewards');
      await _load('Claimed');
    } on ApiException catch (e) {
      InjectionHelper.snackBar.showError(
          e.error ?? AppLocalizations.of(context)!.nftClaimFailedError);
    } catch (_) {
      InjectionHelper.snackBar
          .showError(AppLocalizations.of(context)!.nftClaimFailedError);
    } finally {
      if (mounted) setState(() => _pendingIds.remove(item.id));
    }
  }

  Future<void> _handleBuy(NftItem item) async {
    setState(() => _pendingIds.add(item.id));
    try {
      if (item.isFree) {
        final result = await Web3Repo.purchaseNft(item.id);
        if (result?.pendingTransactionBase64 != null) {
          _showWalletSheet(result!.message);
        } else {
          InjectionHelper.snackBar
              .showSuccess(AppLocalizations.of(context)!.nftPurchasedMessage);
        }
      } else {
        if (!mounted) return;
        await CheckoutFlow.payStripeThenPayPal(
          context: context,
          createStripePayment: () => Web3Repo.createNftPayment(item.id),
          createPayPalOrder: () => Web3Repo.createPayPalOrder(
            body: CreateEventPaymentRequest(nftId: item.id),
          ),
        );
        InjectionHelper.snackBar
            .showSuccess(AppLocalizations.of(context)!.nftPurchasedMessage);
      }
      await _load('Market Place');
      await _load('Claimed');
    } on ApiException catch (e) {
      InjectionHelper.snackBar.showError(
          e.error ?? AppLocalizations.of(context)!.nftPurchaseFailedError);
    } catch (_) {
      InjectionHelper.snackBar
          .showError(AppLocalizations.of(context)!.nftPurchaseFailedError);
    } finally {
      if (mounted) setState(() => _pendingIds.remove(item.id));
    }
  }

  void _showWalletSheet(String? message) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WalletSignatureSheet(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loading = _loading[_innerTab] ?? false;
    final error = _error[_innerTab];
    final items = _data[_innerTab];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInnerTabBar(),
        const Gap(12),
        if (loading)
          Center(
              child: Lottie.asset(IconSet.jsonLoading, width: 98, height: 98))
        else if (error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(error,
                  style: context.textTheme.bodyMedium
                      .copyWith(fontSize: 14, color: ColorSet.textColor)),
            ),
          )
        else if (items == null || items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                _emptyMessages[_innerTab]!,
                style: context.textTheme.bodyMedium
                    .copyWith(fontSize: 14, color: ColorSet.textColor),
              ),
            ),
          )
        else
          NftCardDeck(
            items: items,
            tabKey: _innerTab,
            height: math.min(MediaQuery.sizeOf(context).height * 0.62, 560.0),
            pendingIds: _pendingIds,
            onClaim: _handleClaim,
            onBuy: _handleBuy,
          ),
      ],
    );
  }

  Widget _buildInnerTabBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (final tab in _innerTabs)
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectTab(tab),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          tab,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 16,
                            fontWeight: tab == _innerTab
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: tab == _innerTab
                                ? ColorSet.textColor
                                : ColorSet.profileSubTextColor,
                          ),
                        ),
                      ),
                      const Gap(8),
                      Center(
                        child: Container(
                          height: 3,
                          width: tab == _innerTab
                              ? _tabTextWidth(context, tab)
                              : 0,
                          decoration: BoxDecoration(
                            color: ColorSet.textColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  double _tabTextWidth(BuildContext context, String tab) {
    final painter = TextPainter(
      text: TextSpan(
        text: tab,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    return painter.width;
  }
}
