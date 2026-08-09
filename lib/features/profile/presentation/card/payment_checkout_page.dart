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
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/services/payment/google_play_billing_service.dart';
import 'package:kuemele/shared/services/payment/paypal_connection_service.dart';
import 'package:kuemele/shared/services/payment/payment_sdk_service.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/core/service_locator.dart';

enum _PayMethod { card, crypto }

class PaymentCheckoutPage extends StatefulWidget implements BasePage {
  const PaymentCheckoutPage({super.key});

  @override
  State<PaymentCheckoutPage> createState() => _PaymentCheckoutPageState();

  @override
  String get screenName => 'PaymentCheckoutPage';
}

class _PaymentCheckoutPageState extends State<PaymentCheckoutPage> {
  final TextEditingController _discountCodeCTRL = TextEditingController();

  List<SavedCard> _cards = const [];
  List<SubscriptionTier> _tiers = const [];
  String? _selectedCardId;
  String? _selectedTierId;
  PayPalConnectionStatus _paypalStatus =
      const PayPalConnectionStatus(isConnected: false);
  _PayMethod _payMethod = _PayMethod.card;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isConnectingPayPal = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
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

  double? get _amountToPay => _selectedTier?.priceForInterval('monthly');

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final cards = await Web3Repo.listSavedCards();
      final tiers = await Web3Repo.getSubscriptionTiers();
      final paypalStatus = await PayPalConnectionService.loadStatus();
      if (!mounted) return;

      setState(() {
        _cards = cards;
        _tiers = tiers;
        _paypalStatus = paypalStatus;
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
        final status =
            await GooglePlayBillingService.buySubscription(googleProductId);
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

  Future<void> _handleConnectPayPal() async {
    if (!ApiService.hasToken()) {
      InjectionHelper.snackBar
          .showError(AppLocalizations.of(context)!.signInBeforeSubscription);
      return;
    }

    setState(() => _isConnectingPayPal = true);
    try {
      final setup = await PayPalConnectionService.createSetup();
      if (setup == null) {
        InjectionHelper.snackBar.showError(ApiErrorMessage.APP_API_ERROR);
        return;
      }

      if (!mounted) return;
      final approved = await PaymentSdkService.presentPayPalApprovalUrl(
        context: context,
        approvalUrl: setup.approvalUrl,
        orderId: setup.setupTokenId,
      );
      if (!mounted) return;
      if (approved) {
        await PayPalConnectionService.markConnected(setup.setupTokenId);
        final paypalStatus = await PayPalConnectionService.loadStatus();
        if (!mounted) return;
        setState(() => _paypalStatus = paypalStatus);
        InjectionHelper.snackBar.showSuccess(
          'PayPal account connected.',
        );
      }
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    } finally {
      if (mounted) setState(() => _isConnectingPayPal = false);
    }
  }

  void _handleApplyDiscount() {
    InjectionHelper.snackBar.show(
      _discountCodeCTRL.text.trim().isEmpty
          ? AppLocalizations.of(context)!.paymentDiscountCodeEmptyMessage
          : AppLocalizations.of(context)!.paymentDiscountCodeValidationMessage,
    );
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
                onTap: _handleApplyDiscount,
                child: Container(
                  width: 88,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorSet.revertBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(AppLocalizations.of(context)!.paymentApplyLabel,
                      style: context.textTheme.bodyLargeBold
                          .copyWith(color: ColorSet.bgColor)),
                ),
              ),
            ],
          ),
          const Gap(20),
          AppButton.primary(
            label: _paypalStatus.isConnected
                ? 'PayPal connected'
                : AppLocalizations.of(context)!.removeCardConnectEscrowLabel,
            fullWidth: true,
            isLoading: _isConnectingPayPal,
            iconAsset: IconSet.paypalIcon,
            backgroundColor: ColorSet.tileFillColor,
            foregroundColor: ColorSet.textColor,
            onPressed: _isConnectingPayPal ? null : _handleConnectPayPal,
          ),
          const Gap(8),
          Text(
            _paypalStatus.isConnected
                ? 'Connected escrow account: ${_paypalStatus.accountId ?? 'PayPal'}'
                : 'Connect PayPal to receive event payments through escrow.',
            style: context.textTheme.bodySmall.copyWith(
              color: _paypalStatus.isConnected
                  ? ColorSet.snackBarSuccessBg
                  : ColorSet.color525252,
            ),
          ),
          const Gap(20),
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
