import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/components/radio.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/commerce/commerce_repo.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/services/payment/google_play_billing_service.dart';
import 'package:kuemele/shared/services/payment/payment_sdk_service.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/core/service_locator.dart';

enum _PayMethod { card, crypto }

class CartCheckoutPage extends StatefulWidget implements BasePage {
  const CartCheckoutPage({super.key});

  @override
  State<CartCheckoutPage> createState() => _CartCheckoutPageState();

  @override
  String get screenName => 'CartCheckoutPage';
}

class _CartCheckoutPageState extends State<CartCheckoutPage> {
  final TextEditingController _discountCodeCTRL = TextEditingController();

  List<SavedCard> _cards = const [];
  List<SubscriptionTier> _tiers = const [];
  String? _selectedCardId;
  String? _selectedTierId;
  _PayMethod _payMethod = _PayMethod.card;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isValidatingDiscount = false;
  String? _loadError;

  /// Set once `_handleApplyDiscount` validates the code currently in
  /// [_discountCodeCTRL] — cleared whenever the text changes so a stale
  /// discount can't silently apply to an edited code.
  String? _appliedDiscountCode;
  double? _discountAmount;

  @override
  void initState() {
    super.initState();
    _loadData();
    _discountCodeCTRL.addListener(_onDiscountCodeChanged);
  }

  void _onDiscountCodeChanged() {
    if (_appliedDiscountCode != null &&
        _appliedDiscountCode != _discountCodeCTRL.text.trim()) {
      setState(() {
        _appliedDiscountCode = null;
        _discountAmount = null;
      });
    }
  }

  @override
  void dispose() {
    _discountCodeCTRL.removeListener(_onDiscountCodeChanged);
    _discountCodeCTRL.dispose();
    super.dispose();
  }

  SubscriptionTier? get _selectedTier {
    if (_tiers.isEmpty) return null;
    for (final tier in _tiers) {
      if (tier.id == _selectedTierId) return tier;
    }
    return _tiers.first;
  }

  double? get _amountToPay {
    final base = _selectedTier?.priceForInterval('monthly');
    if (base == null) return null;
    if (_appliedDiscountCode != _discountCodeCTRL.text.trim() ||
        _discountAmount == null) {
      return base;
    }
    final discounted = base - _discountAmount!;
    return discounted < 0 ? 0 : discounted;
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final cards = await Web3Repo.listSavedCards();
      final tiers = await Web3Repo.getSubscriptionTiers();
      if (!mounted) return;

      setState(() {
        _cards = cards;
        _tiers = tiers;
        _selectedCardId = cards.isEmpty
            ? null
            : cards
                .firstWhere((c) => c.isDefault == true,
                    orElse: () => cards.first)
                .id;
        _selectedTierId = tiers.isNotEmpty ? tiers.first.id : null;
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
    final tier = _selectedTier;
    debugPrint('[GPB] plan tapped: id=${tier?.id} name=${tier?.name} '
        'googleProductId=${tier?.googleProductId} '
        'googleBasePlanId=${tier?.googleBasePlanId}');
    if (tier == null) {
      InjectionHelper.snackBar
          .showError(AppLocalizations.of(context)!.noSubscriptionTierAvailable);
      return;
    }
    if (!ApiService.hasToken()) {
      InjectionHelper.snackBar
          .showError(AppLocalizations.of(context)!.signInBeforeSubscription);
      return;
    }

    if (_payMethod == _PayMethod.crypto) {
      InjectionHelper.snackBar.show(
        'Crypto payments are still being wired to the live checkout flow.',
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final l10n = AppLocalizations.of(context)!;
    final subscriptionActivatedMessage = l10n.subscriptionActivatedMessage;
    final subscriptionCheckoutSessionFailed =
        l10n.subscriptionCheckoutSessionFailed;
    final paymentCompleteShort = l10n.paymentCompleteShort;
    final subscriptionCreatedMessage = l10n.subscriptionCreatedMessage;
    final googleProductId = tier.googleProductId?.trim();
    try {
      if (googleProductId != null && googleProductId.isNotEmpty) {
        final status = await GooglePlayBillingService.buySubscription(
          googleProductId,
          basePlanId: tier.googleBasePlanId,
        );
        if (status == null) return; // user cancelled the Play Billing sheet
        InjectionHelper.snackBar.showSuccess(subscriptionActivatedMessage);
        await _loadData();
        return;
      }

      final session = await Web3Repo.createSubscription(
        body: CreateSubscriptionRequest(
          tierId: tier.id,
          discountCode: _discountCodeCTRL.text.trim(),
        ),
      );

      if (session == null) {
        InjectionHelper.snackBar.showError(subscriptionCheckoutSessionFailed);
        return;
      }

      final paidWithStripe =
          await PaymentSdkService.presentStripePaymentSheet(session.raw);
      if (paidWithStripe) {
        InjectionHelper.snackBar.showSuccess(paymentCompleteShort);
      } else {
        InjectionHelper.snackBar.showSuccess(session.status == 'active'
            ? subscriptionActivatedMessage
            : subscriptionCreatedMessage);
      }
      await _loadData();
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _handleApplyDiscount() async {
    final code = _discountCodeCTRL.text.trim();
    if (code.isEmpty) {
      InjectionHelper.snackBar
          .show(AppLocalizations.of(context)!.paymentDiscountCodeEmptyMessage);
      return;
    }

    final baseAmount = _selectedTier?.priceForInterval('monthly');
    if (baseAmount == null) {
      InjectionHelper.snackBar
          .showError(AppLocalizations.of(context)!.noSubscriptionTierAvailable);
      return;
    }

    setState(() => _isValidatingDiscount = true);
    try {
      final result = await CommerceRepo.validateDiscount(
        code: code,
        productType: 'SUBSCRIPTION',
        amountMinor: (baseAmount * 100).round(),
      );
      if (!mounted) return;

      final isValid = result['valid'] ?? result['isValid'];
      final discountMinor =
          result['discountAmountMinor'] ?? result['discountAmount'];
      if (isValid == false || discountMinor == null) {
        setState(() {
          _appliedDiscountCode = null;
          _discountAmount = null;
        });
        InjectionHelper.snackBar.showError(
          result['message']?.toString() ??
              AppLocalizations.of(context)!
                  .paymentDiscountCodeValidationMessage,
        );
        return;
      }

      setState(() {
        _appliedDiscountCode = code;
        _discountAmount = (discountMinor as num) / 100;
      });
      InjectionHelper.snackBar.showSuccess(
        'Discount applied: -\$${_discountAmount!.toStringAsFixed(2)}',
      );
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    } finally {
      if (mounted) setState(() => _isValidatingDiscount = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: _buildTablet(),
      phone: Scaffold(
        backgroundColor: ColorSet.bgColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                MobileHeader(
                    label: AppLocalizations.of(context)!.paymentDialogTitle),
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
      backgroundColor: ColorSet.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            children: [
              MobileHeader(
                  label: AppLocalizations.of(context)!.paymentDialogTitle),
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.amountToPayLabel,
              style: context.textTheme.bodyMedium
                  .copyWith(color: ColorSet.color525252)),
          const Gap(6),
          Text(
            _amountToPay == null
                ? '--'
                : '\$${_amountToPay!.toStringAsFixed(2)}',
            style: context.textTheme.heading2.copyWith(
              color: ColorSet.lightBlueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(20),
          Row(
            children: [
              Expanded(
                child: KumeleTextField(
                  controller: _discountCodeCTRL,
                  borderRadius: 8,
                  hintText: AppLocalizations.of(context)!.enterDiscountCodeHint,
                  fillColor: ColorSet.tileFillColor,
                ),
              ),
              const Gap(8),
              GestureDetector(
                onTap: _isValidatingDiscount
                    ? null
                    : () => unawaited(_handleApplyDiscount()),
                child: Container(
                  width: 88,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorSet.revertBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isValidatingDiscount
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ColorSet.bgColor,
                          ),
                        )
                      : Text(AppLocalizations.of(context)!.paymentApplyLabel,
                          style: context.textTheme.bodyLargeBold
                              .copyWith(color: ColorSet.bgColor)),
                ),
              ),
            ],
          ),
          _buildCardAndItemsSection(),
          const Gap(24),
          AppButton.primary(
            label: AppLocalizations.of(context)!.paymentAddNewCardLabel,
            fullWidth: true,
            backgroundColor: ColorSet.revertBgColor,
            foregroundColor: ColorSet.bgColor,
            icon: Icons.add,
            onPressed: () => context.push(AppRoutes.addCard),
          ),
          const Gap(12),
          AppButton.primary(
            label: AppLocalizations.of(context)!.paymentPayNowLabel,
            fullWidth: true,
            isLoading: _isSubmitting,
            backgroundColor: ColorSet.revertBgColor,
            foregroundColor: ColorSet.bgColor,
            onPressed:
                _isSubmitting || _selectedTier == null ? null : _handlePayNow,
          ),
          const Gap(24),
        ],
      ),
    );
  }

  Widget _buildCardAndItemsSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorSet.profileBorderColor),
      ),
      child: Column(
        children: [
          if (_cards.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(context)!.noResults,
                style: context.textTheme.bodyMedium
                    .copyWith(color: ColorSet.color525252),
              ),
            )
          else
            for (final card in _cards) ...[
              _buildCardRow(card),
              if (card != _cards.last)
                Divider(height: 1, color: ColorSet.profileBorderColor),
            ],
          Divider(height: 1, color: ColorSet.profileBorderColor),
          if (_tiers.isNotEmpty) ...[
            _buildTierLineItem(_tiers.first),
            Divider(height: 1, color: ColorSet.profileBorderColor),
          ],
          _buildPayWithRow(),
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

  Widget _buildTierLineItem(SubscriptionTier tier) {
    final price = tier.priceForInterval('monthly');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Image.asset(IconSet.ticketsIcon, width: 20, height: 20),
          const Gap(10),
          Expanded(
            child: Text(tier.name, style: context.textTheme.bodyLarge),
          ),
          Text(
            price == null
                ? '--'
                : '${(tier.currency ?? 'USD').toUpperCase()} ${price.toStringAsFixed(2)}',
            style: context.textTheme.bodyLargeBold,
          ),
        ],
      ),
    );
  }

  Widget _buildPayWithRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Text(AppLocalizations.of(context)!.paymentPayWithLabel,
              style: context.textTheme.bodyLarge),
          const Spacer(),
          _buildPayMethodIcon(
            method: _PayMethod.crypto,
            assetPath: IconSet.crypto,
          ),
          const Gap(10),
          _buildPayMethodIcon(
            method: _PayMethod.card,
            assetPath: IconSet.cardLogoIcon,
          ),
        ],
      ),
    );
  }

  Widget _buildPayMethodIcon({
    required _PayMethod method,
    required String assetPath,
  }) {
    final selected = _payMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _payMethod = method),
      child: Container(
        width: 40,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? ColorSet.revertBgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Image.asset(assetPath, width: 22, height: 22),
      ),
    );
  }
}
