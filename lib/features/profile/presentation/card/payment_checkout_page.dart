import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
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
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
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
    return status != null && status.isActive && status.matchesTier(tier);
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
        InjectionHelper.snackBar.showSuccess(l10n.subscriptionActivatedMessage);
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
        backgroundColor: ColorSet.bg3Color,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                MobileHeader(
                    label: AppLocalizations.of(context)!.removeCardTitle),
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
      backgroundColor: ColorSet.bg3Color,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            children: [
              MobileHeader(
                  label: AppLocalizations.of(context)!.removeCardTitle),
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
            const Gap(20),
            Divider(height: 1, color: ColorSet.color525252),
            const Gap(32),
            _buildEscrowSection(),
            const Gap(32),
            Divider(height: 1, color: ColorSet.color525252),
            const Gap(38),
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

    return Column(
      children: [
        for (final card in _cards) _buildCardRow(card),
      ],
    );
  }

  Widget _buildCardRow(SavedCard card) {
    final selected = card.id == _selectedCardId;
    final isDeleting = card.id == _deletingCardId;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
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
                      Flexible(
                        child: Text(
                          '•••• •••• •••• ${card.last4 ?? '••••'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyMedium.copyWith(
                            color: ColorSet.profileSubTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Gap(6),
                      Image.asset(IconSet.cardLogoIcon, width: 32, height: 20),
                      const Gap(6),
                      Text(
                        AppLocalizations.of(context)!.paymentMasterCardLabel,
                        style: context.textTheme.bodySmall.copyWith(
                          color: ColorSet.profileSubTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (card.expMonth != null && card.expYear != null) ...[
                    const Gap(2),
                    Text(
                      AppLocalizations.of(context)!.paymentCardExpiresLabel(
                          '${card.expMonth}/${card.expYear}'),
                      style: context.textTheme.bodySmall
                          .copyWith(color: ColorSet.profileSubTextColor),
                    ),
                  ],
                ],
              ),
            ),
          ),
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
                width: 150,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorSet.textColor,
                  borderRadius: BorderRadius.circular(8),
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
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(IconSet.paypalIcon, height: 20),
                          const Gap(10),
                          Text(
                            AppLocalizations.of(context)!.paymentPayPalLabel,
                            style: context.textTheme.bodyMedium.copyWith(
                              color: ColorSet.bg2Color,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const Gap(12),
            Image.asset(
              _paypalStatus.isConnected
                  ? IconSet.paypalConnectedIcon
                  : IconSet.paypalNotConnectedIcon,
              width: 48,
              height: 48,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubscriptionsSection() {
    final recurringTiers = _tiers.where((tier) {
      final name = tier.name.toLowerCase();
      return !name.contains('event ad') && !name.contains('location change');
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context)!.subscriptionsTitle,
          textAlign: TextAlign.center,
          style: context.textTheme.titleLargeBold.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(30),
        if (recurringTiers.isEmpty)
          Text(AppLocalizations.of(context)!.paymentNoTiersMessage,
              style: context.textTheme.bodyMedium
                  .copyWith(color: ColorSet.color525252))
        else
          Column(
            children:
                recurringTiers.map((tier) => _buildTierCard(tier)).toList(),
          ),
      ],
    );
  }

  Widget _buildTierCard(SubscriptionTier tier) {
    final active = _isTierActive(tier);
    final isPending = _pendingTierId == tier.id;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 15),
      decoration: BoxDecoration(
        color: active ? ColorSet.specialYellowColor : ColorSet.home2ndCardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSvgImage(
                assetName: SVGAsset.icon_crown,
                width: 40,
                height: 40,
                color: active ? Colors.black : ColorSet.textColor,
              ),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tier.name,
                            style: context.textTheme.titleLargeBold.copyWith(
                              color: active ? Colors.black : ColorSet.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Gap(5),
                        Text(
                          _formatTierPrice(tier),
                          style: context.textTheme.titleLargeBold.copyWith(
                            color: active
                                ? const Color(0xFF0057FF)
                                : ColorSet.specialYellowColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    if (active) ...[
                      const Gap(2),
                      Text(
                        AppLocalizations.of(context)!.active,
                        style: context.textTheme.bodyMediumSemiBold.copyWith(
                          color: const Color(0xFF0057FF),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    if (tier.description.isNotEmpty) ...[
                      const Gap(5),
                      Text(
                        tier.description,
                        style: context.textTheme.bodyLarge.copyWith(
                          color: active
                              ? Colors.black
                              : ColorSet.profileSubTextColor,
                          fontSize: 17,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const Gap(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 46),
            child: AppButton(
              label: active
                  ? AppLocalizations.of(context)!.deactivateLabel
                  : AppLocalizations.of(context)!.activateLabel,
              height: 44,
              fontSize: 16,
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(8),
              isLoading: isPending,
              backgroundColor: active || ColorSet.isDarkMode
                  ? const Color(0xFFF4F4F4)
                  : Colors.black,
              foregroundColor:
                  active || ColorSet.isDarkMode ? Colors.black : Colors.white,
              onPressed: isPending
                  ? null
                  : active
                      ? () => _handleDeactivateTier(tier)
                      : () => _handleActivateTier(tier),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTierPrice(SubscriptionTier tier) {
    final price = tier.price ?? tier.priceMonthly ?? tier.priceYearly;
    if (price == null) return '--';
    final currency = (tier.currency ?? 'USD').toUpperCase();
    final symbol = switch (currency) {
      'EUR' => '€',
      'USD' => r'$',
      'GBP' => '£',
      _ => '$currency ',
    };
    return '$symbol${price.toStringAsFixed(2)}';
  }
}
