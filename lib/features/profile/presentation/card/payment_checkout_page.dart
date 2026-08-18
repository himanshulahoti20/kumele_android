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
import 'package:kuemele/shared/components/radio.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/services/payment/google_play_billing_service.dart';
import 'package:kuemele/shared/services/payment/paypal_connection_service.dart';
import 'package:kuemele/shared/services/payment/payment_sdk_service.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kuemele/core/service_locator.dart';

class PaymentCheckoutPage extends StatefulWidget implements BasePage {
  const PaymentCheckoutPage({super.key});

  @override
  State<PaymentCheckoutPage> createState() => _PaymentCheckoutPageState();

  @override
  String get screenName => 'PaymentCheckoutPage';
}

class _PaymentCheckoutPageState extends State<PaymentCheckoutPage> {
  List<SavedCard> _cards = const [];
  List<SubscriptionTier> _tiers = const [];
  SubscriptionStatus? _subscriptionStatus;
  PayPalConnectionStatus _paypalStatus =
      const PayPalConnectionStatus(isConnected: false);
  String? _selectedCardId;
  String? _deletingCardId;
  String? _pendingTierId;
  bool _isLoading = true;
  bool _isConnectingPayPal = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    try {
      final cards = await Web3Repo.listSavedCards();
      final tiers = await Web3Repo.getSubscriptionTiers();
      final paypalStatus = await PayPalConnectionService.loadStatus();

      SubscriptionStatus? status;
      if (ApiService.hasToken()) {
        try {
          status = await Web3Repo.getSubscriptionStatus();
        } on ApiException catch (e) {
          if (e.statusCode != ApiStatusCode.Unauthorized) rethrow;
        }
      }

      if (!mounted) return;
      setState(() {
        _cards = cards;
        _tiers = tiers;
        _subscriptionStatus = status;
        _paypalStatus = paypalStatus;
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
      if (silent) InjectionHelper.snackBar.showError(_loadError!);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError = ApiErrorMessage.APP_UNKNOWN_ERROR;
        _isLoading = false;
      });
      if (silent) InjectionHelper.snackBar.showError(_loadError!);
    }
  }

  Future<void> _handleSelectCard(SavedCard card) async {
    if (card.id == _selectedCardId) return;
    setState(() => _selectedCardId = card.id);
    try {
      await Web3Repo.setDefaultCard(card.id);
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    }
  }

  Future<void> _handleDeleteCard(SavedCard card) async {
    await AppDialog.confirm<void>(
      context: context,
      width: AppDialogSize.widthFor(context),
      title: AppLocalizations.of(context)!.confirmCardDeletionTitle,
      confirmText: AppLocalizations.of(context)!.delete,
      popOnConfirm: true,
      onConfirmAsync: () => _deleteCard(card.id),
    );
  }

  Future<void> _deleteCard(String cardId) async {
    setState(() => _deletingCardId = cardId);
    try {
      final success = await Web3Repo.deleteCard(cardId);
      if (!success) {
        InjectionHelper.snackBar.showError(ApiErrorMessage.APP_API_ERROR);
        return;
      }
      await _loadData(silent: true);
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    } finally {
      if (mounted) setState(() => _deletingCardId = null);
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
      final loginUrl = await PayPalConnectionService.createLoginUrl();
      if (loginUrl == null) {
        InjectionHelper.snackBar.showError(ApiErrorMessage.APP_API_ERROR);
        return;
      }

      final callbackParams = await PaymentSdkService.presentPayPalConnectFlow(
        loginUrl: loginUrl,
      );
      if (!mounted) return;
      final code = callbackParams?['code'];
      final error = callbackParams?['error'];
      if (callbackParams == null) {
        // User closed the webview before PayPal redirected back — not an
        // error, just a cancelled flow.
      } else if (error != null) {
        InjectionHelper.snackBar.showError(error);
      } else if (code == null || code.isEmpty) {
        InjectionHelper.snackBar.showError(ApiErrorMessage.APP_API_ERROR);
      } else {
        // The webview reaching the callback URL only proves PayPal
        // redirected back with a code — it does NOT mean the account is
        // linked. That only happens once the backend confirms it here.
        final accountId = await Web3Repo.finishPayPalConnect(code: code);
        if (!mounted) return;
        if (accountId == null) {
          InjectionHelper.snackBar.showError(ApiErrorMessage.APP_API_ERROR);
        } else {
          await PayPalConnectionService.markConnected(accountId);
          await InjectionHelper.profileCubit.refreshUserSession();
          final paypalStatus = await PayPalConnectionService.loadStatus();
          if (!mounted) return;
          setState(() => _paypalStatus = paypalStatus);
          InjectionHelper.snackBar.showSuccess(
              AppLocalizations.of(context)!.paypalAccountConnectedMessage);
        }
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

  bool _isTierActive(SubscriptionTier tier) {
    final status = _subscriptionStatus;
    if (status == null || !status.isActive) return false;
    final statusTier = status.tierName?.trim().toLowerCase();
    if (statusTier == null || statusTier.isEmpty) return false;
    return statusTier == tier.id.toLowerCase() ||
        statusTier == tier.name.trim().toLowerCase();
  }

  Future<void> _handleActivateTier(SubscriptionTier tier) async {
    if (!ApiService.hasToken()) {
      InjectionHelper.snackBar
          .showError(AppLocalizations.of(context)!.signInBeforeSubscription);
      return;
    }

    setState(() => _pendingTierId = tier.id);
    final l10n = AppLocalizations.of(context)!;
    try {
      final googleProductId = tier.googleProductId?.trim();
      if (googleProductId != null && googleProductId.isNotEmpty) {
        final status = await GooglePlayBillingService.buySubscription(
          googleProductId,
          basePlanId: tier.googleBasePlanId,
        );
        if (status == null) return; // user cancelled the Play Billing sheet
        InjectionHelper.snackBar
            .showSuccess(l10n.subscriptionActivatedMessage);
        await _loadData(silent: true);
        return;
      }

      final session = await Web3Repo.createSubscription(
        body: CreateSubscriptionRequest(tierId: tier.id),
      );
      if (session == null) {
        InjectionHelper.snackBar
            .showError(l10n.subscriptionCheckoutSessionFailed);
        return;
      }

      final paidWithStripe =
          await PaymentSdkService.presentStripePaymentSheet(session.raw);
      final checkoutUrl = session.checkoutUrl?.trim();
      if (paidWithStripe) {
        InjectionHelper.snackBar.showSuccess(l10n.paymentCompleteShort);
      } else if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        final uri = Uri.tryParse(checkoutUrl);
        if (uri == null) {
          InjectionHelper.snackBar.show(checkoutUrl);
        } else {
          final opened =
              await launchUrl(uri, mode: LaunchMode.externalApplication);
          if (!opened) InjectionHelper.snackBar.show(checkoutUrl);
        }
      } else {
        InjectionHelper.snackBar.showSuccess(session.status == 'active'
            ? l10n.subscriptionActivatedMessage
            : l10n.subscriptionCreatedMessage);
      }
      await _loadData(silent: true);
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    } finally {
      if (mounted) setState(() => _pendingTierId = null);
    }
  }

  Future<void> _handleDeactivateTier(SubscriptionTier tier) async {
    if (!ApiService.hasToken()) {
      InjectionHelper.snackBar
          .showError(AppLocalizations.of(context)!.signInToManageSubscription);
      return;
    }

    final googleProductId = tier.googleProductId?.trim();
    if (googleProductId != null && googleProductId.isNotEmpty) {
      // Google Play (not this backend) owns billing for IAP subscriptions —
      // Play Store policy requires cancellation to go through Play's own
      // management UI, not a custom in-app "cancel" call.
      final uri = Uri.https('play.google.com', '/store/account/subscriptions', {
        'sku': googleProductId,
        'package': 'com.kumele.hobbies',
      });
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && mounted) {
        InjectionHelper.snackBar.showError(ApiErrorMessage.APP_API_ERROR);
      }
      return;
    }

    setState(() => _pendingTierId = tier.id);
    final l10n = AppLocalizations.of(context)!;
    try {
      final success = await Web3Repo.cancelSubscription(
        body: const CancelSubscriptionRequest(cancelImmediately: false),
      );
      if (!success) {
        InjectionHelper.snackBar.showError(l10n.unableToCancelSubscription);
        return;
      }
      InjectionHelper.snackBar
          .showSuccess(l10n.subscriptionCancellationRequested);
      await _loadData(silent: true);
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    } finally {
      if (mounted) setState(() => _pendingTierId = null);
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
                MobileHeader(label: AppLocalizations.of(context)!.removeCardTitle),
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
              MobileHeader(label: AppLocalizations.of(context)!.removeCardTitle),
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

    return RefreshIndicator(
      color: ColorSet.darkBlueColor,
      onRefresh: () => _loadData(silent: true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardsSection(),
            const Gap(12),
            AppButton.primary(
              label: AppLocalizations.of(context)!.paymentAddNewCardLabel,
              fullWidth: true,
              backgroundColor: ColorSet.revertBgColor,
              foregroundColor: ColorSet.bgColor,
              icon: Icons.add,
              onPressed: () => context.push(AppRoutes.addCard),
            ),
            const Gap(28),
            _buildEscrowSection(),
            const Gap(28),
            _buildSubscriptionsSection(),
            const Gap(24),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsSection() {
    if (_cards.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorSet.tileFillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorSet.profileBorderColor),
        ),
        child: Text(
          AppLocalizations.of(context)!.noResults,
          style: context.textTheme.bodyMedium
              .copyWith(color: ColorSet.color525252),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorSet.profileBorderColor),
      ),
      child: Column(
        children: [
          for (final card in _cards) ...[
            _buildCardRow(card),
            if (card != _cards.last)
              Divider(height: 1, color: ColorSet.profileBorderColor),
          ],
        ],
      ),
    );
  }

  Widget _buildCardRow(SavedCard card) {
    final selected = card.id == _selectedCardId;
    final isDeleting = card.id == _deletingCardId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          RARadio(
            onChanged: (value, isSelected) => _handleSelectCard(card),
            value: card.id,
            textSize: size(16),
            radioSize: 20,
            groupValue: selected ? card.id : '',
          ),
          const Gap(10),
          Expanded(
            child: GestureDetector(
              onTap: () => _handleSelectCard(card),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('•••• •••• •••• ${card.last4 ?? '••••'}',
                          style: context.textTheme.bodyLargeBold),
                      const Gap(8),
                      Text(AppLocalizations.of(context)!.paymentMasterCardLabel,
                          style: context.textTheme.bodySmall
                              .copyWith(color: ColorSet.color525252)),
                    ],
                  ),
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
          ),
          Image.asset(IconSet.cardLogoIcon, width: 32, height: 20),
          const Gap(12),
          isDeleting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorSet.darkBlueColor,
                  ),
                )
              : GestureDetector(
                  onTap: () => _handleDeleteCard(card),
                  child: Image.asset(IconSet.trashIcon, width: 22, height: 22),
                ),
        ],
      ),
    );
  }

  Widget _buildEscrowSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(AppLocalizations.of(context)!.connectEscrowAccountLabel,
              style: context.textTheme.bodyLargeBold
                  .copyWith(fontWeight: FontWeight.w700)),
        ),
        const Gap(14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _isConnectingPayPal || _paypalStatus.isConnected
                  ? null
                  : _handleConnectPayPal,
              child: Container(
                width: 160,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorSet.textColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _isConnectingPayPal
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorSet.bgColor,
                        ),
                      )
                    : Image.asset(IconSet.paypalIcon, height: 20),
              ),
            ),
            const Gap(12),
            Image.asset(
              _paypalStatus.isConnected
                  ? IconSet.paypalConnectedIcon
                  : IconSet.paypalNotConnectedIcon,
              width: 40,
              height: 40,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubscriptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.subscriptionsTitle,
            style: context.textTheme.titleLargeBold
                .copyWith(fontWeight: FontWeight.w700)),
        const Gap(14),
        if (_tiers.isEmpty)
          Text(AppLocalizations.of(context)!.paymentNoTiersMessage,
              style: context.textTheme.bodyMedium
                  .copyWith(color: ColorSet.color525252))
        else
          Column(
            children: _tiers.map((tier) => _buildTierCard(tier)).toList(),
          ),
      ],
    );
  }

  Widget _buildTierCard(SubscriptionTier tier) {
    final active = _isTierActive(tier);
    final isPending = _pendingTierId == tier.id;
    final price = tier.price ?? tier.priceMonthly ?? tier.priceYearly;
    final currency = (tier.currency ?? 'USD').toUpperCase();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: active ? ColorSet.specialYellowColor : ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(IconSet.medalIcon, width: 22, height: 22),
              const Gap(10),
              Expanded(
                child: Text(tier.name,
                    style: context.textTheme.bodyLargeBold
                        .copyWith(fontWeight: FontWeight.w700)),
              ),
              Text(
                price == null ? '--' : '$currency ${price.toStringAsFixed(2)}',
                style: context.textTheme.bodyLargeBold.copyWith(
                    color: active ? ColorSet.darkBlueColor : ColorSet.lightBlueColor,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (active) ...[
            const Gap(4),
            Text(AppLocalizations.of(context)!.active,
                style: context.textTheme.bodySmallBold
                    .copyWith(color: ColorSet.darkBlueColor)),
          ],
          if (tier.description.isNotEmpty) ...[
            const Gap(8),
            Text(tier.description,
                style: context.textTheme.bodyMedium.copyWith(
                    color: active ? ColorSet.textColor : ColorSet.color525252)),
          ],
          const Gap(14),
          AppButton.primary(
            label: active
                ? AppLocalizations.of(context)!.deactivateLabel
                : AppLocalizations.of(context)!.activateLabel,
            fullWidth: true,
            isLoading: isPending,
            backgroundColor: active ? ColorSet.bg2Color : ColorSet.textColor,
            foregroundColor: active ? ColorSet.textColor : ColorSet.bgColor,
            onPressed: isPending
                ? null
                : active
                    ? () => _handleDeactivateTier(tier)
                    : () => _handleActivateTier(tier),
          ),
        ],
      ),
    );
  }
}
