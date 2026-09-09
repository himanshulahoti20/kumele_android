import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/radio.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/models/crypto_mint_models.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/commerce/commerce_repo.dart';
import 'package:kuemele/shared/services/api_service/web3/crypto_mint_repo.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/services/payment/checkout_flow.dart';
import 'package:kuemele/shared/services/payment/payment_sdk_service.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/store_credit_toggle.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/core/service_locator.dart';

/// Checkout for everything that isn't a subscription (NFTs today — pushed
/// from `nft_tab_view.dart`'s "Buy" action with the tapped [NftItem] as
/// route `extra`). Subscriptions are bought directly from the Shop screen's
/// Subscriptions tab (`shop.dart`'s `_buySubscription`), never through here.
///
/// Also reachable with no [nft] at all (the "Cart" entry in the More menu,
/// and payment-notification taps) — in that case there's nothing to check
/// out, so it just shows the store-credit balance and saved cards.
class CartCheckoutPage extends StatefulWidget implements BasePage {
  const CartCheckoutPage({super.key, this.nft});

  final NftItem? nft;

  @override
  State<CartCheckoutPage> createState() => _CartCheckoutPageState();

  @override
  String get screenName => 'CartCheckoutPage';
}

class _CartCheckoutPageState extends State<CartCheckoutPage> {
  List<SavedCard> _cards = const [];
  StoreCreditBalance? _storeCreditBalance;
  final ValueNotifier<bool> _useStoreCredit = ValueNotifier<bool>(false);
  final TextEditingController _discountCodeController = TextEditingController();
  String? _selectedCardId;
  bool _payWithCrypto = false;
  String? _appliedDiscountCode;
  int? _discountedTotalMinor;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isApplyingDiscount = false;
  String? _loadError;

  // Crypto ("pay with crypto") flow — inlined from the removed
  // CryptoPaymentDialog popup so it lives on this page instead, below
  // "Pay With".
  final _cryptoWalletController = TextEditingController();
  CryptoMintFeeQuote? _cryptoFeeQuote;
  String? _cryptoStatusMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _useStoreCredit.dispose();
    _discountCodeController.dispose();
    _cryptoWalletController.dispose();
    super.dispose();
  }

  /// Just for display — a fresh quote is fetched again right before
  /// creating the payment intent in [_handlePayNow], since quotes expire
  /// quickly.
  Future<void> _loadCryptoFeeQuote() async {
    try {
      final quote = await CryptoMintRepo.getFeeQuote();
      if (mounted && quote.quoteId.isNotEmpty) {
        setState(() => _cryptoFeeQuote = quote);
      }
    } catch (_) {
      // Silent — the fee shows as "--" and the real quote is still
      // fetched (and its failure surfaced) when the user taps Pay Now.
    }
  }

  Future<CryptoMintPayment> _pollCryptoPaymentUntilTerminal(
      String paymentId) async {
    const maxAttempts = 30;
    const interval = Duration(seconds: 2);
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      await Future.delayed(interval);
      if (!mounted) {
        return CryptoMintPayment(
          paymentId: paymentId,
          status: CryptoMintPaymentStatus.pending,
        );
      }
      final payment = await CryptoMintRepo.getPaymentStatus(paymentId);
      if (payment.status.isTerminal) return payment;
    }
    return CryptoMintPayment(
      paymentId: paymentId,
      status: CryptoMintPaymentStatus.pending,
    );
  }

  Future<void> _applyDiscount() async {
    final nft = widget.nft;
    final code = _discountCodeController.text.trim();
    if (nft?.price == null || code.isEmpty || _isApplyingDiscount) return;

    setState(() => _isApplyingDiscount = true);
    try {
      final originalMinor = (nft!.price! * 100).round();
      final result = await CommerceRepo.validateDiscount(
        code: code,
        productType: 'NFT',
        amountMinor: originalMinor,
      );
      if (result['valid'] != true && result['isValid'] != true) {
        InjectionHelper.snackBar.showError(
          result['message']?.toString() ?? 'Discount code is not valid.',
        );
        return;
      }

      final finalMinor =
          (result['finalAmountMinor'] ?? result['amountDueMinor']) as num?;
      final discountMinor = result['discountAmountMinor'] as num?;
      if (!mounted) return;
      setState(() {
        _appliedDiscountCode = code;
        _discountedTotalMinor = finalMinor?.toInt() ??
            (originalMinor - (discountMinor?.toInt() ?? 0))
                .clamp(0, originalMinor);
      });
      InjectionHelper.snackBar.showSuccess('Discount applied.');
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    } finally {
      if (mounted) setState(() => _isApplyingDiscount = false);
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final results = await Future.wait([
        Web3Repo.listSavedCards(),
        Web3Repo.getStoreCreditBalance(),
      ]);
      if (!mounted) return;

      final cards = results[0] as List<SavedCard>;
      setState(() {
        _cards = cards;
        _storeCreditBalance = results[1] as StoreCreditBalance;
        _selectedCardId = cards.isEmpty
            ? null
            : cards
                .firstWhere((c) => c.isDefault == true,
                    orElse: () => cards.first)
                .id;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.error ?? ApiErrorMessage.APP_API_ERROR;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError = ApiErrorMessage.APP_UNKNOWN_ERROR;
        _isLoading = false;
      });
    }
  }

  Future<void> _handlePayNow() async {
    final nft = widget.nft;
    if (nft == null) return;

    if (!ApiService.hasToken()) {
      InjectionHelper.snackBar
          .showError(AppLocalizations.of(context)!.signInBeforeSubscription);
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    if (_payWithCrypto) {
      final address = _cryptoWalletController.text.trim();
      if (address.isEmpty) {
        InjectionHelper.snackBar
            .showError('Enter your Solana wallet address.');
        return;
      }

      setState(() {
        _isSubmitting = true;
        _cryptoStatusMessage = 'Getting the network fee...';
      });
      try {
        final quote = await CryptoMintRepo.getFeeQuote();
        if (quote.quoteId.isEmpty) {
          throw Exception('No fee quote available right now.');
        }

        final intent = await CryptoMintRepo.createPaymentIntent(
          quoteId: quote.quoteId,
          ownerAddress: address,
          name: nft.title,
          metadataUri: _nftMetadataUri(nft),
        );
        if (intent.paymentId.isEmpty ||
            intent.clientSecret == null ||
            intent.clientSecret!.isEmpty) {
          throw Exception('Could not start the payment.');
        }

        if (!mounted) return;
        setState(() => _cryptoStatusMessage = 'Waiting for card payment...');
        final confirmed = await PaymentSdkService.presentStripePaymentSheet(
          {'clientSecret': intent.clientSecret},
          primaryButtonLabel: 'Pay now',
        );
        if (!confirmed) return;

        if (!mounted) return;
        setState(() => _cryptoStatusMessage =
            'Minting your NFT... this can take a moment.');
        final finalPayment =
            await _pollCryptoPaymentUntilTerminal(intent.paymentId);
        if (!mounted) return;

        if (finalPayment.status.isSuccess) {
          InjectionHelper.snackBar.showSuccess(l10n.nftPurchasedMessage);
          context.pop(true);
        } else {
          InjectionHelper.snackBar.showError(
            finalPayment.status == CryptoMintPaymentStatus.refunded
                ? 'Payment was refunded. Please try again.'
                : 'Minting failed. Your card was not charged successfully.',
          );
        }
      } catch (_) {
        if (!mounted) return;
        // A Stripe-sheet cancel also lands here (flutter_stripe throws
        // rather than returning false).
        InjectionHelper.snackBar
            .showError('Payment was not completed. Please try again.');
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
            _cryptoStatusMessage = null;
          });
        }
      }
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final useStoreCredit = _useStoreCredit.value;
      final discountCode =
          _appliedDiscountCode == _discountCodeController.text.trim()
              ? _appliedDiscountCode
              : null;
      await CheckoutFlow.payStripeThenPayPal(
        context: context,
        // The NFT Stripe endpoint has no store-credit request contract. The
        // PayPal order DTO does, so credit-selected NFT checkouts start there.
        createStripePayment: useStoreCredit || discountCode != null
            ? () async => const <String, dynamic>{}
            : () => Web3Repo.createNftPayment(nft.id),
        createPayPalOrder: () => Web3Repo.createPayPalOrder(
          body: CreateEventPaymentRequest(
            nftId: nft.id,
            discountCode: discountCode,
            useStoreCredit: useStoreCredit,
          ),
        ),
      );
      if (!mounted) return;
      InjectionHelper.snackBar.showSuccess(l10n.nftPurchasedMessage);
      context.pop(true);
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? l10n.nftPurchaseFailedError);
    } catch (_) {
      InjectionHelper.snackBar.showError(l10n.nftPurchaseFailedError);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: _buildTablet(),
      phone: Scaffold(
        backgroundColor: ColorSet.bg2Color,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                const MobileHeader(label: 'Cart'),
                const Gap(22),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTablet() {
    return Scaffold(
      backgroundColor: ColorSet.bg2Color,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            children: [
              const MobileHeader(label: 'Cart'),
              const Gap(22),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: _buildContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: ColorSet.darkBlueColor),
      );
    }

    if (_loadError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_loadError!,
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center),
            const Gap(16),
            AppButton.primary(
              label: AppLocalizations.of(context)!.retry,
              onPressed: _loadData,
            ),
          ],
        ),
      );
    }

    final nft = widget.nft;
    final balance = _storeCreditBalance;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (nft == null) _buildEmptyCart(),
          _buildTotals(nft),
          const Gap(22),
          if (balance != null) ...[
            _buildStoreCreditCard(balance),
            const Gap(20),
          ],
          _buildDiscountRow(nft),
          const Gap(20),
          _buildSavedCardPanel(),
          const Gap(20),
          if (nft != null) ...[
            _buildPayWithRow(),
            const Gap(20),
          ],
          if (nft != null && _payWithCrypto) ...[
            _buildCryptoSection(),
            const Gap(20),
          ],
          if (!_payWithCrypto)
            _buildBlackButton(
              label: AppLocalizations.of(context)!.paymentAddNewCardLabel,
              onPressed: () => context.push(AppRoutes.addCard),
            ),
          const Gap(10),
          _buildBlackButton(
            label: AppLocalizations.of(context)!.paymentPayNowLabel,
            isLoading: _isSubmitting,
            onPressed: _isSubmitting ? null : _handlePayNow,
          ),
          const Gap(40),
          Divider(height: 1, color: ColorSet.profileBorderColor),
        ],
      ),
    );
  }

  /// Best-effort extraction from whatever the backend already sends on the
  /// NFT payload — there's no dedicated field for this yet.
  String? _nftMetadataUri(NftItem nft) {
    final fromMetadata = nft.metadata['metadataUri'] ??
        nft.metadata['metadata_uri'] ??
        nft.metadata['uri'];
    final fromRaw = nft.raw['metadataUri'] ??
        nft.raw['metadata_uri'] ??
        nft.raw['tokenUri'] ??
        nft.raw['token_uri'];
    return (fromMetadata ?? fromRaw)?.toString();
  }

  String _formatNftAmount(NftItem nft) {
    if (nft.price == null) return '--';
    final amount = (_discountedTotalMinor ?? (nft.price! * 100).round()) / 100;
    final currency = (nft.currency ?? 'EUR').toUpperCase();
    final symbol = switch (currency) {
      'EUR' => '€',
      'USD' => r'$',
      'GBP' => '£',
      _ => '$currency ',
    };
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  Widget _buildEmptyCart() {
    return Column(
      children: [
        const Gap(50),
        Icon(Icons.shopping_cart_rounded, size: 60, color: ColorSet.bg5Color),
        const Gap(18),
        Text(
          'Your cart is empty',
          style: context.textTheme.titleLargeBold.copyWith(fontSize: 22),
        ),
        const Gap(12),
        Text(
          'Add subscriptions or products to get started.',
          textAlign: TextAlign.center,
          style: context.textTheme.bodyLarge.copyWith(
            color: ColorSet.color525252,
            fontSize: 16,
          ),
        ),
        const Gap(24),
      ],
    );
  }

  Widget _buildTotals(NftItem? nft) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total items',
            style: context.textTheme.titleLarge.copyWith(fontSize: 20)),
        Text(
          nft == null ? '0' : '1',
          style: context.textTheme.heading1.copyWith(
            color: ColorSet.specialBlueColor,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(20),
        Text(AppLocalizations.of(context)!.amountToPayLabel,
            style: context.textTheme.titleLarge.copyWith(fontSize: 20)),
        Text(
          nft == null ? '€0.00' : _formatNftAmount(nft),
          style: context.textTheme.heading1.copyWith(
            color: ColorSet.specialBlueColor,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildStoreCreditCard(StoreCreditBalance balance) {
    final expiry = formatStoreCreditExpiry(balance)?.replaceFirst(
      'Expires',
      'Next credit expires',
    );
    return ValueListenableBuilder<bool>(
      valueListenable: _useStoreCredit,
      builder: (context, selected, _) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _useStoreCredit.value = !selected,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
          decoration: BoxDecoration(
            color: ColorSet.bg2Color,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ColorSet.profileBorderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppSvgImage(
                    assetName: Assets.icons.notifications.wallet.path,
                    width: 30,
                    height: 30,
                    color: StoreCreditToggle.yellow,
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Store Credit',
                            style: context.textTheme.titleLargeBold
                                .copyWith(fontSize: 18)),
                        if (expiry != null)
                          Text(
                            expiry,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium.copyWith(
                              color: ColorSet.color525252,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    formatStoreCreditAmount(balance),
                    style: context.textTheme.titleLarge.copyWith(
                      color: StoreCreditToggle.yellow,
                      fontSize: 20,
                    ),
                  ),
                  const Gap(12),
                  RARadio(
                    value: 'store-credit',
                    groupValue: selected ? 'store-credit' : '',
                    radioSize: 24,
                    spaceBetween: 0,
                    toggleable: true,
                    onChanged: (_, value) => _useStoreCredit.value = value,
                  ),
                ],
              ),
              const Gap(8),
              Text(
                'Use for eligible event tickets.',
                style: context.textTheme.bodyMedium.copyWith(
                  color: ColorSet.color525252,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountRow(NftItem? nft) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _discountCodeController,
            enabled: nft != null,
            onChanged: (_) {
              if (_appliedDiscountCode != null) {
                setState(() {
                  _appliedDiscountCode = null;
                  _discountedTotalMinor = null;
                });
              }
            },
            decoration: InputDecoration(
              hintText: 'Enter Discount code',
              hintStyle: context.textTheme.bodyLarge.copyWith(
                color: ColorSet.subTextColor,
                fontSize: 16,
              ),
              filled: true,
              fillColor: ColorSet.txtFieldFillColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const Gap(6),
        SizedBox(
          width: 76,
          height: 56,
          child: FilledButton(
            style: FilledButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.black,
              disabledForegroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed:
                nft == null || _isApplyingDiscount ? null : _applyDiscount,
            child: _isApplyingDiscount
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Apply', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildPayWithRow() {
    return Row(
      children: [
        Text('Pay with',
            style: context.textTheme.titleLarge.copyWith(fontSize: 18)),
        const Spacer(),
        _payMethodIcon(
          selected: !_payWithCrypto,
          onTap: () => setState(() => _payWithCrypto = false),
          child: Image.asset(IconSet.cardLogoIcon, width: 26, height: 18),
        ),
        const Gap(12),
        _payMethodIcon(
          selected: _payWithCrypto,
          onTap: () {
            setState(() => _payWithCrypto = true);
            if (_cryptoFeeQuote == null) _loadCryptoFeeQuote();
          },
          child: AppSvgImage(
            assetName: Assets.icons.crypto.path,
            width: 22,
            height: 22,
          ),
        ),
      ],
    );
  }

  /// Everything the removed crypto popup used to show — mint fee, wallet
  /// address field, network-fee disclaimer — now inline below "Pay with".
  Widget _buildCryptoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppSvgImage(
              assetName: Assets.icons.crypto.path,
              width: 26,
              height: 26,
            ),
            const Gap(10),
            Expanded(
              child: Text(
                'Mint fee',
                style: context.textTheme.bodyLargeSemiBold.copyWith(
                  color: ColorSet.specialBlueColor,
                ),
              ),
            ),
            Text(
              _cryptoFeeQuote?.feeLabel ?? '--',
              style: context.textTheme.bodyLargeBold.copyWith(
                color: ColorSet.specialBlueColor,
              ),
            ),
          ],
        ),
        const Gap(16),
        Text(
          'Solana wallet address',
          style: context.textTheme.bodyMedium
              .copyWith(color: ColorSet.textColor),
        ),
        const Gap(6),
        TextField(
          controller: _cryptoWalletController,
          style:
              context.textTheme.bodyMedium.copyWith(color: ColorSet.textColor),
          decoration: InputDecoration(
            hintText: 'Paste your wallet address',
            hintStyle: context.textTheme.bodyMedium
                .copyWith(color: ColorSet.subTextColor),
            filled: true,
            fillColor: ColorSet.txtFieldFillColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const Gap(10),
        Text(
          'Your wallet or payment network may charge a separate network fee',
          style: context.textTheme.bodySmall
              .copyWith(color: ColorSet.specialBlueColor, fontSize: 12),
        ),
        if (_isSubmitting && _cryptoStatusMessage != null) ...[
          const Gap(10),
          Text(
            _cryptoStatusMessage!,
            style: context.textTheme.bodySmall
                .copyWith(color: ColorSet.specialBlueColor, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _payMethodIcon({
    required bool selected,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorSet.tileFillColor,
          border: Border.all(
            color: selected ? ColorSet.specialBlueColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: child,
      ),
    );
  }

  Widget _buildSavedCardPanel() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: ColorSet.color525252),
      ),
      child: Column(
        children: [
          if (_cards.isEmpty)
            SizedBox(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    RARadio(
                      value: 'none',
                      groupValue: '',
                      radioSize: 22,
                      spaceBetween: 0,
                      onChanged: (_, __) {},
                    ),
                    const Gap(10),
                    Expanded(
                      child: Text('No saved card',
                          style: context.textTheme.titleLarge
                              .copyWith(fontSize: 19)),
                    ),
                    Image.asset(IconSet.cardLogoIcon, width: 44, height: 28),
                  ],
                ),
              ),
            )
          else
            for (final card in _cards) ...[
              _buildCardRow(card),
              if (card != _cards.last)
                Divider(height: 1, color: ColorSet.profileBorderColor),
            ],
          Divider(height: 1, color: ColorSet.profileBorderColor),
          SizedBox(
            height: 62,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('Card status',
                      style:
                          context.textTheme.titleLarge.copyWith(fontSize: 18)),
                  const Spacer(),
                  Text(
                    _cards.isEmpty ? 'Not Connected' : 'Connected',
                    style: context.textTheme.titleMediumSemiBold.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardRow(SavedCard card) {
    final selected = card.id == _selectedCardId;
    return GestureDetector(
      onTap: () => setState(() => _selectedCardId = card.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            RARadio(
              onChanged: (value, isSelected) =>
                  setState(() => _selectedCardId = card.id),
              value: card.id,
              textSize: size(16),
              radioSize: 20,
              groupValue: selected ? card.id : '',
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•••• •••• •••• ${card.last4 ?? '••••'}',
                      style: context.textTheme.bodyLargeBold),
                  if (card.expMonth != null && card.expYear != null) ...[
                    const Gap(2),
                    Text(
                      AppLocalizations.of(context)!.paymentCardExpiresLabel(
                          '${card.expMonth}/${card.expYear}'),
                      style: context.textTheme.bodySmall
                          .copyWith(color: ColorSet.color525252),
                    ),
                  ],
                ],
              ),
            ),
            Image.asset(IconSet.cardLogoIcon, width: 32, height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBlackButton({
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.black,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label,
                style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
