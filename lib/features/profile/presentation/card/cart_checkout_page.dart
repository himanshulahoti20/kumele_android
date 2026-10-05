import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive_extensions.dart';
import 'package:kuemele/features/profile/presentation/card/coinbase_payment_page.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/radio.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/models/commerce_models.dart';
import 'package:kuemele/shared/models/crypto_mint_models.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/commerce/commerce_repo.dart';
import 'package:kuemele/shared/services/api_service/web3/crypto_mint_repo.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/services/payment/checkout_flow.dart';
import 'package:kuemele/shared/services/payment/payment_sdk_service.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/store_credit_toggle.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/core/service_locator.dart';

/// Mirrors iOS PaymentView_iPhone / PaymentView_iPad: the `/cart` contents
/// (qty stepper, remove, Clear All), store credit, discount code, saved
/// cards (set default / delete) and the "Pay with" methods.
///
/// Also the checkout for NFTs — pushed from `nft_tab_view.dart`'s "Buy"
/// action with the tapped [NftItem] as route `extra`. Subscriptions are
/// bought directly from the Shop screen (`shop.dart`'s `_buySubscription`),
/// never through here.
class CartCheckoutPage extends StatefulWidget implements BasePage {
  const CartCheckoutPage({super.key, this.nft, this.isPopup = false});

  final NftItem? nft;

  /// Tablet-only: rendered as a centered popup card matching iPad's
  /// PaymentView_iPad (a rounded card, not a full page) instead of being
  /// pushed as a full-screen route.
  final bool isPopup;

  @override
  State<CartCheckoutPage> createState() => _CartCheckoutPageState();

  @override
  String get screenName => 'CartCheckoutPage';
}

class _CartCheckoutPageState extends State<CartCheckoutPage> {
  CartModel? _cart;
  String? _cartError;
  String? _mutatingItemId;
  List<SavedCard> _cards = const [];
  String? _mutatingCardId;
  StoreCreditBalance? _storeCreditBalance;
  final ValueNotifier<bool> _useStoreCredit = ValueNotifier<bool>(false);
  final TextEditingController _discountCodeController = TextEditingController();
  bool _payWithCrypto = false;
  String? _appliedDiscountCode;
  String? _discountMessage;
  int? _discountedTotalMinor;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isApplyingDiscount = false;
  String? _loadError;

  // Crypto ("pay with crypto") flow for NFTs — Solana mint paid by card.
  final _cryptoWalletController = TextEditingController();
  CryptoMintFeeQuote? _cryptoFeeQuote;
  String? _cryptoStatusMessage;

  SavedCard? get _heroCard => _cards.isEmpty
      ? null
      : _cards.firstWhere((c) => c.isDefault == true,
          orElse: () => _cards.first);

  List<CartItem> get _items => _cart?.items ?? const [];

  int get _itemCount =>
      _items.fold(0, (sum, i) => sum + (i.quantity ?? 1)) +
      (widget.nft != null ? 1 : 0);

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

  // ---------------------------------------------------------------------------
  // Loading
  // ---------------------------------------------------------------------------

  Future<void> _loadData({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    try {
      final results = await Future.wait([
        Web3Repo.listSavedCards(),
        Web3Repo.getStoreCreditBalance(),
        _loadCart(),
      ]);
      if (!mounted) return;

      final balance = results[1] as StoreCreditBalance;
      setState(() {
        _cards = results[0] as List<SavedCard>;
        _storeCreditBalance = balance;
        if (!balance.hasCredit) _useStoreCredit.value = false;
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

  /// Cart failures are shown inline (like iOS) rather than replacing the
  /// whole page, so saved cards and store credit still render.
  Future<void> _loadCart() async {
    try {
      final cart = await CommerceRepo.getCart();
      if (!mounted) return;
      setState(() {
        _cart = cart;
        _cartError = null;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _cart ??= CartModel.empty;
        _cartError = e.error ?? ApiErrorMessage.APP_API_ERROR;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cart ??= CartModel.empty;
        _cartError = ApiErrorMessage.APP_UNKNOWN_ERROR;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Cart mutations
  // ---------------------------------------------------------------------------

  Future<void> _updateQuantity(CartItem item, int quantity) async {
    if (quantity <= 0) return _removeItem(item);
    setState(() => _mutatingItemId = item.id);
    try {
      final cart = await CommerceRepo.updateCartItem(
        itemId: item.id,
        quantity: quantity,
      );
      if (mounted) setState(() => _cart = cart);
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    } finally {
      if (mounted) setState(() => _mutatingItemId = null);
    }
  }

  Future<void> _removeItem(CartItem item) async {
    setState(() => _mutatingItemId = item.id);
    try {
      final cart = await CommerceRepo.removeFromCart(item.id);
      if (mounted) setState(() => _cart = cart);
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    } finally {
      if (mounted) setState(() => _mutatingItemId = null);
    }
  }

  Future<void> _confirmClearCart() async {
    await AppDialog.confirm<void>(
      context: context,
      width: AppDialogSize.widthFor(context),
      title: 'Clear your entire cart?',
      confirmText: 'Clear All',
      popOnConfirm: true,
      onConfirmAsync: _clearCart,
    );
  }

  Future<void> _clearCart() async {
    try {
      final cart = await CommerceRepo.clearCart();
      if (mounted) setState(() => _cart = cart);
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    }
  }

  // ---------------------------------------------------------------------------
  // Saved cards
  // ---------------------------------------------------------------------------

  Future<void> _setDefaultCard(SavedCard card) async {
    if (card.isDefault == true || _mutatingCardId != null) return;
    setState(() => _mutatingCardId = card.id);
    try {
      await Web3Repo.setDefaultCard(card.id);
      final cards = await Web3Repo.listSavedCards();
      if (mounted) setState(() => _cards = cards);
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    } finally {
      if (mounted) setState(() => _mutatingCardId = null);
    }
  }

  Future<void> _confirmDeleteCard(SavedCard card) async {
    await AppDialog.confirm<void>(
      context: context,
      width: AppDialogSize.widthFor(context),
      title: AppLocalizations.of(context)!.confirmCardDeletionTitle,
      confirmText: AppLocalizations.of(context)!.delete,
      popOnConfirm: true,
      onConfirmAsync: () => _deleteCard(card),
    );
  }

  Future<void> _deleteCard(SavedCard card) async {
    setState(() => _mutatingCardId = card.id);
    try {
      final success = await Web3Repo.deleteCard(card.id);
      if (!success) {
        InjectionHelper.snackBar.showError(ApiErrorMessage.APP_API_ERROR);
        return;
      }
      if (mounted) {
        setState(() => _cards = _cards.where((c) => c.id != card.id).toList());
      }
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    } finally {
      if (mounted) setState(() => _mutatingCardId = null);
    }
  }

  // ---------------------------------------------------------------------------
  // Discount
  // ---------------------------------------------------------------------------

  Future<void> _applyDiscount() async {
    final nft = widget.nft;
    final code = _discountCodeController.text.trim();
    if (code.isEmpty) {
      setState(() => _discountMessage = 'Enter a discount code.');
      return;
    }
    if (_isApplyingDiscount) return;

    final originalMinor = nft?.price != null
        ? (nft!.price! * 100).round()
        : ((_cart?.total ?? 0) * 100).round();

    setState(() {
      _isApplyingDiscount = true;
      _discountMessage = null;
    });
    try {
      final result = await CommerceRepo.validateDiscount(
        code: code,
        productType: nft != null ? 'NFT' : 'PRODUCT',
        amountMinor: originalMinor,
      );
      if (!mounted) return;
      if (result['valid'] != true && result['isValid'] != true) {
        setState(() {
          _appliedDiscountCode = null;
          _discountedTotalMinor = null;
          _discountMessage =
              result['message']?.toString() ?? 'Discount code is not valid.';
        });
        return;
      }

      final finalMinor =
          (result['finalAmountMinor'] ?? result['amountDueMinor']) as num?;
      final discountMinor = result['discountAmountMinor'] as num?;
      setState(() {
        _appliedDiscountCode = code;
        _discountedTotalMinor = finalMinor?.toInt() ??
            (originalMinor - (discountMinor?.toInt() ?? 0))
                .clamp(0, originalMinor);
        _discountMessage = 'Discount code applied.';
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _appliedDiscountCode = null;
        _discountMessage = e.error ?? ApiErrorMessage.APP_API_ERROR;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _appliedDiscountCode = null;
        _discountMessage = ApiErrorMessage.APP_UNKNOWN_ERROR;
      });
    } finally {
      if (mounted) setState(() => _isApplyingDiscount = false);
    }
  }

  // ---------------------------------------------------------------------------
  // NFT checkout (unchanged)
  // ---------------------------------------------------------------------------

  /// Just for display — a fresh quote is fetched again right before
  /// creating the payment intent in [_handlePayNow], since quotes expire
  /// quickly.
  Future<void> _loadCryptoFeeQuote() async {
    try {
      final quote = await CryptoMintRepo.getFeeQuote();
      if (mounted) {
        setState(() => _cryptoFeeQuote = quote);
      }
    } catch (_) {
      // Silent — the fee shows as "--" and the real quote is still
      // fetched (and its failure surfaced) when the user taps Pay Now.
    }
  }

  /// Bounded poll (~3 min); falls back to `pending` if still not terminal.
  Future<CryptoMintPayment> _pollCryptoPaymentUntilTerminal(
      String nftId) async {
    const maxAttempts = 90;
    const interval = Duration(seconds: 2);
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      await Future.delayed(interval);
      if (!mounted) break;
      try {
        final payment = await CryptoMintRepo.getPurchaseStatus(nftId);
        if (payment.status.isTerminal) return payment;
      } catch (_) {
        // transient; keep polling until the deadline
      }
    }
    return CryptoMintPayment(
      paymentId: nftId,
      status: CryptoMintPaymentStatus.pending,
    );
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
        _cryptoStatusMessage = 'Starting payment...';
      });
      try {
        final intent = await CryptoMintRepo.purchase(
          nft.id,
          walletAddress: address,
        );
        if (intent.clientSecret == null || intent.clientSecret!.isEmpty) {
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
            await _pollCryptoPaymentUntilTerminal(nft.id);
        if (!mounted) return;

        if (finalPayment.status.isSuccess) {
          InjectionHelper.snackBar.showSuccess(l10n.nftPurchasedMessage);
          context.pop(true);
        } else if (!finalPayment.status.isTerminal) {
          InjectionHelper.snackBar
              .showError('Still processing. Check My NFTs shortly — it will appear once minting completes.');
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

  // ---------------------------------------------------------------------------
  // Formatting
  // ---------------------------------------------------------------------------

  static String _currencySymbol(String? currency) {
    final code = (currency ?? 'EUR').toUpperCase();
    return switch (code) {
      'EUR' => '€',
      'USD' => r'$',
      'GBP' => '£',
      _ => '$code ',
    };
  }

  static String _money(double amount, String? currency) =>
      '${_currencySymbol(currency)}${amount.toStringAsFixed(2)}';

  String _formattedTotal() {
    final nft = widget.nft;
    if (nft != null) {
      if (nft.price == null) return '--';
      final amount =
          (_discountedTotalMinor ?? (nft.price! * 100).round()) / 100;
      return _money(amount, nft.currency);
    }
    final total = _cart?.total ?? 0;
    if (total <= 0) return '€0.00';
    final amount = (_discountedTotalMinor ?? (total * 100).round()) / 100;
    return _money(amount, _cart?.currency);
  }

  static String _cardTitle(SavedCard card) {
    final brand = card.brand;
    final brandLabel = brand == null || brand.isEmpty
        ? 'Card'
        : '${brand[0].toUpperCase()}${brand.substring(1)}';
    final last4 = card.last4;
    return last4 == null ? brandLabel : '$brandLabel •••• $last4';
  }

  static String _cardExpiry(SavedCard card) {
    final m = int.tryParse(card.expMonth ?? '');
    final y = int.tryParse(card.expYear ?? '');
    if (m == null || y == null) return '';
    return '${m.toString().padLeft(2, '0')}/${(y % 100).toString().padLeft(2, '0')}';
  }

  String _bitcoinIcon() => ColorSet.isDarkMode
      ? Assets.svg.icBitcoinDark.path
      : Assets.svg.icBitcoin.path;

  String _cardIcon() =>
      ColorSet.isDarkMode ? Assets.svg.icCardDark.path : Assets.svg.icCard.path;

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (widget.isPopup) {
      return _buildPopup(context);
    }

    return WidgetByDevice(
      tablet: _buildTablet(),
      phone: Scaffold(
        backgroundColor: ColorSet.bg2Color,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                _buildHeader(),
                const Gap(22),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return MobileHeader(
      label: 'Cart',
      actions: [
        if (_items.isNotEmpty)
          TextButton(
            onPressed: _confirmClearCart,
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
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
              _buildHeader(),
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

  /// iOS PaymentView_iPad: a rounded card ("Cart" title + close button) over
  /// a dimmed backdrop — not a full page.
  Widget _buildPopup(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: math.min(screenSize.width - 32, 750),
        maxHeight: math.min(screenSize.height - 32, 750),
      ),
      // iOS bgColor (card surface) is Android's bg3Color — the two ColorSet
      // names are swapped between the apps.
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
        decoration: BoxDecoration(
          color: ColorSet.bg3Color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(width: 40),
                Expanded(
                  child: Text(
                    'Cart',
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleLargeBold
                        .copyWith(fontSize: 20, color: ColorSet.textColor),
                  ),
                ),
                AppRoundedIconButton(
                  assetPath: IconSet.closeIcon,
                  iconSize: 20,
                  semanticLabel: 'Close',
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Gap(16),
            Flexible(child: _buildPopupContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOrError() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: ColorSet.darkBlueColor),
      );
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_loadError!,
              style: context.textTheme.bodyMedium, textAlign: TextAlign.center),
          const Gap(16),
          AppButton.primary(
            label: AppLocalizations.of(context)!.retry,
            onPressed: _loadData,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Phone content (iOS PaymentView_iPhone)
  // ---------------------------------------------------------------------------

  Widget _buildContent() {
    if (_isLoading || _loadError != null) return _buildLoadingOrError();

    final nft = widget.nft;
    final balance = _storeCreditBalance;
    return RefreshIndicator(
      onRefresh: () => _loadData(silent: true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_cartError != null) ...[
              _errorText(_cartError!),
              const Gap(12),
            ],
            if (nft == null && _items.isEmpty) _buildEmptyCart(),
            _buildTotals(),
            const Gap(22),
            if (balance != null) ...[
              _buildStoreCreditCard(balance),
              const Gap(20),
            ],
            _buildDiscountRow(),
            if (_discountMessage != null) ...[
              const Gap(8),
              _discountMessageText(),
            ],
            const Gap(20),
            if (_items.isNotEmpty) ...[
              _buildCartItemsBox(),
              const Gap(20),
            ],
            _buildHeroCardPanel(),
            const Gap(20),
            _buildPayWithRow(),
            const Gap(20),
            if (nft != null && _payWithCrypto) ...[
              _buildCryptoSection(),
              const Gap(20),
            ],
            _networkFeeNote(),
            const Gap(10),
            if (!_payWithCrypto)
              _buildBlackButton(
                label: AppLocalizations.of(context)!.paymentAddNewCardLabel,
                icon: Icons.add,
                onPressed: () => context.push(AppRoutes.addCard),
              ),
            const Gap(10),
            _buildBlackButton(
              label: AppLocalizations.of(context)!.paymentPayNowLabel,
              isLoading: _isSubmitting,
              onPressed: nft == null || _isSubmitting ? null : _handlePayNow,
            ),
            for (final card in _cards) _buildSavedCardRow(card),
            const Gap(20),
            Divider(height: 1, color: ColorSet.profileBorderColor),
          ],
        ),
      ),
    );
  }

  Widget _errorText(String message) => Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      );

  Widget _discountMessageText() => Text(
        _discountMessage!,
        style: TextStyle(
          color: _appliedDiscountCode == null ? Colors.red : Colors.green,
          fontSize: 12,
        ),
      );

  Widget _networkFeeNote() => SizedBox(
        width: double.infinity,
        child: Text(
          'Your wallet or payment network may charge a separate network fee for crypto payments.',
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall.copyWith(
            fontSize: context.responsive.isTablet ? 22 : 14,
            color: ColorSet.specialBlueColor,
          ),
        ),
      );

  Widget _buildEmptyCart() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 24),
      child: Column(
        children: [
          Opacity(
            opacity: 0.4,
            child: Image.asset(IconSet.getIcon('buy'), width: 60, height: 60),
          ),
          const Gap(12),
          Text(
            'Your cart is empty',
            style: context.textTheme.titleLargeSemiBold
                .copyWith(fontSize: 18, color: ColorSet.textColor),
          ),
          const Gap(12),
          Text(
            'Add subscriptions or products to get started.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium.copyWith(
              fontSize: 14,
              color: ColorSet.textColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total items',
            style: context.textTheme.titleLarge.copyWith(fontSize: 20)),
        Text(
          '$_itemCount',
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
          _formattedTotal(),
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
        onTap: balance.hasCredit
            ? () => _useStoreCredit.value = !selected
            : null,
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
                        if (expiry != null && balance.hasCredit)
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
                    onChanged: (_, value) {
                      if (balance.hasCredit) _useStoreCredit.value = value;
                    },
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

  Widget _buildDiscountField() {
    return TextField(
      controller: _discountCodeController,
      onChanged: (_) {
        if (_appliedDiscountCode != null || _discountMessage != null) {
          setState(() {
            _appliedDiscountCode = null;
            _discountedTotalMinor = null;
            _discountMessage = null;
          });
        } else {
          // Re-evaluate the Apply button's enabled state.
          setState(() {});
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
      ),
    );
  }

  Widget _buildApplyButton({double? width}) {
    final canApply = !_isApplyingDiscount &&
        _discountCodeController.text.trim().isNotEmpty;
    return SizedBox(
      width: width ?? 76,
      height: 56,
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: ColorSet.revbg3Color,
          foregroundColor: ColorSet.bg2Color,
          disabledBackgroundColor: ColorSet.revbg3Color.withValues(alpha: 0.5),
          disabledForegroundColor: ColorSet.bg2Color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: canApply ? _applyDiscount : null,
        child: Text(
          _isApplyingDiscount ? 'Checking...' : 'Apply',
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildDiscountRow() {
    return Row(
      children: [
        Expanded(child: _buildDiscountField()),
        const Gap(6),
        _buildApplyButton(),
      ],
    );
  }

  Widget _buildCartItemsBox() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          for (var i = 0; i < _items.length; i++) ...[
            _buildCartItemRow(_items[i]),
            if (i < _items.length - 1)
              Divider(height: 1, color: ColorSet.profileBorderColor),
          ],
        ],
      ),
    );
  }

  Widget _buildCartItemRow(CartItem item) {
    final isMutating = _mutatingItemId == item.id;
    final qty = item.quantity ?? 1;
    final unit = item.unitPrice;
    final currency = item.product?.currency ?? _cart?.currency;
    return AnimatedOpacity(
      opacity: isMutating ? 0.5 : 1,
      duration: const Duration(milliseconds: 150),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyLargeSemiBold
                        .copyWith(fontSize: 15, color: ColorSet.textColor),
                  ),
                  if (unit != null) ...[
                    const Gap(4),
                    Text(
                      '${_money(unit, currency)} each',
                      style: context.textTheme.bodySmall.copyWith(
                        fontSize: 12,
                        color: ColorSet.textColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Gap(12),
            if (isMutating)
              const SizedBox(
                width: 90,
                height: 32,
                child: Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: ColorSet.tileFillColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _stepperButton('−', () => _updateQuantity(item, qty - 1)),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 26),
                      child: Text(
                        '$qty',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMediumSemiBold.copyWith(
                            fontSize: 14, color: ColorSet.textColor),
                      ),
                    ),
                    _stepperButton('+', () => _updateQuantity(item, qty + 1)),
                  ],
                ),
              ),
            if (unit != null) ...[
              const Gap(12),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 52),
                child: Text(
                  _money(item.lineTotal, currency),
                  textAlign: TextAlign.right,
                  style: context.textTheme.bodyMediumSemiBold.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: ColorSet.specialBlueColor,
                  ),
                ),
              ),
            ],
            const Gap(12),
            GestureDetector(
              onTap: isMutating ? null : () => _removeItem(item),
              child: Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.red.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepperButton(String symbol, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: Text(
            symbol,
            style: context.textTheme.titleLargeBold
                .copyWith(fontSize: 18, color: ColorSet.textColor),
          ),
        ),
      ),
    );
  }

  Widget _radioDot(bool filled, {double size = 18}) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black),
      ),
      child: filled
          ? Container(
              width: size * 0.55,
              height: size * 0.55,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            )
          : null,
    );
  }

  Widget _masterCardLogo({double width = 40, double height = 25}) =>
      Image.asset(Assets.icons.masterCard.path,
          width: width, height: height, fit: BoxFit.contain);

  /// iOS: the default card + "Card status" in one outlined box.
  Widget _buildHeroCardPanel() {
    final hero = _heroCard;
    final status = hero == null
        ? 'Not Connected'
        : (hero.isDefault == true ? 'Default' : 'Saved');
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _radioDot(hero != null),
                const Gap(10),
                Expanded(
                  child: Text(
                    hero == null ? 'No saved card' : _cardTitle(hero),
                    style: context.textTheme.bodyLarge
                        .copyWith(fontSize: 16, color: ColorSet.textColor),
                  ),
                ),
                _masterCardLogo(),
              ],
            ),
          ),
          Divider(height: 1, color: ColorSet.profileBorderColor),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text('Card status',
                    style: context.textTheme.bodyLarge
                        .copyWith(fontSize: 16, color: ColorSet.textColor)),
                const Spacer(),
                Text(
                  status,
                  style: context.textTheme.bodyMediumSemiBold.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ColorSet.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Bitcoin opens the Coinbase Commerce flow (the only crypto provider for
  /// now); the card icon is the default, already-selected method. For NFT
  /// checkouts bitcoin instead toggles the Solana-mint section below.
  Widget _buildPayWithRow() {
    final nft = widget.nft;
    return Row(
      children: [
        Text('Pay with',
            style: context.textTheme.bodyLarge
                .copyWith(fontSize: 16, color: ColorSet.textColor)),
        const Spacer(),
        GestureDetector(
          onTap: () {
            if (nft == null) {
              CoinbasePaymentPage.open(context);
              return;
            }
            setState(() => _payWithCrypto = !_payWithCrypto);
            if (_payWithCrypto && _cryptoFeeQuote == null) {
              _loadCryptoFeeQuote();
            }
          },
          child: AppSvgImage(assetName: _bitcoinIcon(), width: 28, height: 28),
        ),
        const Gap(14),
        GestureDetector(
          onTap: nft == null
              ? null
              : () => setState(() => _payWithCrypto = false),
          child: AppSvgImage(assetName: _cardIcon(), width: 28, height: 28),
        ),
      ],
    );
  }

  /// Solana mint fee, wallet address field and status — inline below
  /// "Pay with" for NFT checkouts.
  Widget _buildCryptoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppSvgImage(assetName: _bitcoinIcon(), width: 26, height: 26),
            const Gap(10),
            Expanded(
              child: Text(
                _cryptoFeeQuote?.label ?? CryptoMintFeeQuote.defaultLabel,
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

  /// iOS CartSavedCardRowView: radio (tap = set default), brand + last4,
  /// expiry, MasterCard logo, "Default" tag, trash (delete).
  Widget _buildSavedCardRow(SavedCard card) {
    final isMutating = _mutatingCardId == card.id;
    final expiry = _cardExpiry(card);
    return Opacity(
      opacity: isMutating ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: isMutating ? null : () => _setDefaultCard(card),
              child: _radioDot(card.isDefault == true),
            ),
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _cardTitle(card),
                  style: context.textTheme.bodyMedium
                      .copyWith(fontSize: 15, color: ColorSet.textColor),
                ),
                const Gap(4),
                Text(
                  'Expires $expiry',
                  style: context.textTheme.bodySmall
                      .copyWith(fontSize: 12, color: ColorSet.textColor),
                ),
              ],
            ),
            const Gap(8),
            _masterCardLogo(),
            if (card.isDefault == true) ...[
              const Gap(8),
              Text(
                'Default',
                style: context.textTheme.bodyMedium
                    .copyWith(fontSize: 15, color: ColorSet.textColor),
              ),
            ],
            const Spacer(),
            if (isMutating)
              const SizedBox(
                width: 30,
                height: 30,
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              GestureDetector(
                onTap: () => _confirmDeleteCard(card),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child:
                      Image.asset(IconSet.trashIcon, width: 30, height: 30),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlackButton({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
  }) {
    // iOS authBgColor / authTextColor: black-on-white in light, inverted in dark.
    final bg = ColorSet.revbg3Color;
    final fg = ColorSet.bg2Color;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg,
          disabledForegroundColor: fg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        onPressed: onPressed,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: fg),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 24, color: fg),
                    const Gap(6),
                  ],
                  Text(label, style: TextStyle(fontSize: 18, color: fg)),
                ],
              ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tablet popup content (iOS PaymentView_iPad)
  // ---------------------------------------------------------------------------

  Widget _buildPopupContent() {
    if (_isLoading || _loadError != null) return _buildLoadingOrError();

    final balance = _storeCreditBalance;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.amountToPayLabel,
                      style: context.textTheme.bodyMedium
                          .copyWith(fontSize: 14, color: ColorSet.textColor),
                    ),
                    Text(
                      _formattedTotal(),
                      style: context.textTheme.titleLargeBold.copyWith(
                        fontSize: 22,
                        color: ColorSet.specialBlueColor,
                      ),
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: _buildDiscountField(),
              ),
              const Gap(6),
              _buildApplyButton(width: 100),
            ],
          ),
          const Gap(20),
          if (balance != null) ...[
            _buildStoreCreditCard(balance),
            const Gap(20),
          ],
          if (_discountMessage != null) ...[
            _discountMessageText(),
            const Gap(12),
          ],
          if (_cartError != null) ...[
            _errorText(_cartError!),
            const Gap(12),
          ],
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: ColorSet.tileFillColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                _popupHeroCardRow(),
                _popupDivider(),
                _popupSummaryRow(
                  box: '-',
                  title: 'Event payment',
                  titleTrailing: Image.asset(IconSet.ticketsIcon,
                      width: 18, height: 18),
                  subtitle: '$_itemCount item(s)',
                  trailing: _formattedTotal(),
                ),
                _popupDivider(),
                _popupSummaryRow(
                  box: '-',
                  title: 'Cart status',
                  subtitle:
                      _items.isEmpty ? 'No cart items' : 'Ready to review',
                  trailing: _items.isEmpty ? 'Empty' : 'Cart',
                ),
                for (final item in _items) ...[
                  _popupDivider(),
                  _popupSummaryRow(
                    box: '${item.quantity ?? 1}',
                    title: item.displayName,
                    subtitle: item.unitPrice != null
                        ? '${_money(item.unitPrice!, item.product?.currency ?? _cart?.currency)} each'
                        : 'Cart item',
                    trailing: item.unitPrice != null
                        ? _money(item.lineTotal,
                            item.product?.currency ?? _cart?.currency)
                        : '',
                  ),
                ],
                _popupDivider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: _buildPayWithRow(),
                ),
              ],
            ),
          ),
          _networkFeeNote(),
          const Gap(12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: ColorSet.textColor.withValues(alpha: 0.8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 18, color: ColorSet.textColor),
                const Gap(6),
                Text(
                  'Add new card',
                  style: context.textTheme.bodyMedium
                      .copyWith(fontSize: 14, color: ColorSet.textColor),
                ),
              ],
            ),
          ),
          const Gap(20),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 150,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: ColorSet.revbg3Color,
                  foregroundColor: ColorSet.bg2Color,
                  disabledBackgroundColor: ColorSet.revbg3Color,
                  disabledForegroundColor: ColorSet.bg2Color,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    widget.nft == null || _isSubmitting ? null : _handlePayNow,
                child: Text(
                  AppLocalizations.of(context)!.paymentPayNowLabel,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _popupDivider() => Divider(height: 1, color: ColorSet.textColor);

  Widget _popupHeroCardRow() {
    final hero = _heroCard;
    final expiry = hero == null ? '' : _cardExpiry(hero);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _radioDot(hero != null),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hero == null ? 'No saved card' : _cardTitle(hero),
                  style: context.textTheme.bodyMedium
                      .copyWith(fontSize: 15, color: ColorSet.textColor),
                ),
                Text(
                  hero == null ? 'Add a card from profile' : 'Expires $expiry',
                  style: context.textTheme.bodySmall
                      .copyWith(fontSize: 12, color: ColorSet.textColor),
                ),
              ],
            ),
          ),
          _masterCardLogo(),
          const Gap(10),
          Text(
            hero?.isDefault == true ? 'Default' : 'Card',
            style: context.textTheme.bodyMedium
                .copyWith(fontSize: 15, color: ColorSet.textColor),
          ),
        ],
      ),
    );
  }

  Widget _popupSummaryRow({
    required String box,
    required String title,
    required String subtitle,
    required String trailing,
    Widget? titleTrailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 33,
            height: 33,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBCBCBC)),
            ),
            child: Text(
              box,
              style: context.textTheme.titleLargeBold
                  .copyWith(fontSize: 14, color: const Color(0xFFBCBCBC)),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyMedium.copyWith(
                            fontSize: 14, color: ColorSet.textColor),
                      ),
                    ),
                    if (titleTrailing != null) ...[
                      const Gap(6),
                      titleTrailing,
                    ],
                  ],
                ),
                Text(
                  subtitle,
                  style: context.textTheme.bodySmall
                      .copyWith(fontSize: 12, color: ColorSet.textColor),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: context.textTheme.bodySmall
                .copyWith(fontSize: 12, color: ColorSet.textColor),
          ),
        ],
      ),
    );
  }
}
