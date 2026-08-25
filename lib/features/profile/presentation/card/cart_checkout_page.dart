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
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/commerce/commerce_repo.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/services/payment/checkout_flow.dart';
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
  String? _appliedDiscountCode;
  int? _discountedTotalMinor;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isApplyingDiscount = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _useStoreCredit.dispose();
    _discountCodeController.dispose();
    super.dispose();
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

    setState(() => _isSubmitting = true);
    final l10n = AppLocalizations.of(context)!;
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
            color: const Color(0xFF078CF2),
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
            color: const Color(0xFF078CF2),
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
