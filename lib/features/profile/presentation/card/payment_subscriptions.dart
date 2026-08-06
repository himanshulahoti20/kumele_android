import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/services/payment/google_play_billing_service.dart';
import 'package:kuemele/shared/services/payment/payment_sdk_service.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

enum _BillingCycle { monthly, yearly }

class PaymentSubscriptionsDialog extends StatefulWidget implements BasePage {
  final VoidCallback? onPaySuccess;

  const PaymentSubscriptionsDialog({super.key, this.onPaySuccess});

  @override
  State<PaymentSubscriptionsDialog> createState() =>
      _PaymentSubscriptionsDialogState();

  @override
  String get screenName => 'PaymentSubscriptionsDialog';
}

class _PaymentSubscriptionsDialogState
    extends State<PaymentSubscriptionsDialog> {
  final TextEditingController discountCodeCTRL = TextEditingController();

  List<SubscriptionTier> _tiers = const [];
  List<PaymentHistoryItem> _paymentHistory = const [];
  SubscriptionStatus? _subscriptionStatus;
  _BillingCycle _billingCycle = _BillingCycle.monthly;
  String? _selectedTierId;
  String? _loadError;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _authRequired = false;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionData();
  }

  @override
  void dispose() {
    discountCodeCTRL.dispose();
    super.dispose();
  }

  SubscriptionTier? get _selectedTier {
    if (_tiers.isEmpty) return null;
    for (final tier in _tiers) {
      if (tier.id == _selectedTierId) return tier;
    }
    return _tiers.first;
  }

  String get _billingIntervalValue =>
      _billingCycle == _BillingCycle.yearly ? 'yearly' : 'monthly';

  Future<void> _loadSubscriptionData({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    try {
      final tiers = await Web3Repo.getSubscriptionTiers();
      SubscriptionStatus? status;
      List<PaymentHistoryItem> history = const [];
      var authRequired = !ApiService.hasToken();

      if (!authRequired) {
        try {
          status = await Web3Repo.getSubscriptionStatus();
        } on ApiException catch (e) {
          if (e.statusCode == ApiStatusCode.Unauthorized) {
            authRequired = true;
          } else {
            rethrow;
          }
        }

        try {
          history = await Web3Repo.getPaymentHistory(limit: 5);
        } on ApiException catch (e) {
          if (e.statusCode == ApiStatusCode.Unauthorized) {
            authRequired = true;
          } else {
            rethrow;
          }
        }
      }

      if (!mounted) return;

      setState(() {
        _tiers = tiers;
        _subscriptionStatus = status;
        _paymentHistory = history;
        _authRequired = authRequired;
        _selectedTierId = _resolveSelectedTierId(tiers, status);
        _loadError = null;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.error ?? ApiErrorMessage.APP_API_ERROR;
        _isLoading = false;
      });
      if (silent) {
        InjectionHelper.snackBar.showError(_loadError!);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError = ApiErrorMessage.APP_UNKNOWN_ERROR;
        _isLoading = false;
      });
      if (silent) {
        InjectionHelper.snackBar.showError(_loadError!);
      }
    }
  }

  String? _resolveSelectedTierId(
      List<SubscriptionTier> tiers, SubscriptionStatus? status) {
    if (tiers.isEmpty) return null;
    if (_selectedTierId != null &&
        tiers.any((tier) => tier.id == _selectedTierId)) {
      return _selectedTierId;
    }

    final statusTier = status?.tierName?.trim().toLowerCase();
    if (statusTier != null && statusTier.isNotEmpty) {
      for (final tier in tiers) {
        if (tier.id.toLowerCase() == statusTier ||
            tier.name.toLowerCase() == statusTier) {
          return tier.id;
        }
      }
    }
    return tiers.first.id;
  }

  Future<void> _handleCheckout() async {
    final selectedTier = _selectedTier;
    if (selectedTier == null) {
      InjectionHelper.snackBar.showError('No subscription tier available yet.');
      return;
    }
    if (_authRequired || !ApiService.hasToken()) {
      InjectionHelper.snackBar
          .showError('Please sign in before starting a subscription.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final googleProductId = selectedTier.googleProductId?.trim();
    if (googleProductId != null && googleProductId.isNotEmpty) {
      try {
        final status =
            await GooglePlayBillingService.buySubscription(googleProductId);
        if (status == null) {
          return; // user cancelled the Play Billing sheet
        }
        InjectionHelper.snackBar.showSuccess('Subscription activated');
        widget.onPaySuccess?.call();
        await _loadSubscriptionData(silent: true);
      } catch (e) {
        InjectionHelper.snackBar
            .showError('Purchase failed: ${e.toString()}');
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
      return;
    }

    try {
      final session = await Web3Repo.createSubscription(
        body: CreateSubscriptionRequest(
          tierId: selectedTier.id,
          discountCode: discountCodeCTRL.text.trim(),
        ),
      );

      if (session == null) {
        InjectionHelper.snackBar
            .showError('Could not create the subscription checkout session.');
        return;
      }

      final paidWithStripe = await PaymentSdkService.presentStripePaymentSheet(
        session.raw,
        primaryButtonLabel: 'Subscribe',
      );
      final checkoutUrl = session.checkoutUrl?.trim();
      if (paidWithStripe) {
        InjectionHelper.snackBar.showSuccess('Payment complete');
      } else if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        final uri = Uri.tryParse(checkoutUrl);
        if (uri == null) {
          InjectionHelper.snackBar.show(checkoutUrl);
        } else {
          final opened =
              await launchUrl(uri, mode: LaunchMode.externalApplication);
          if (!opened) {
            InjectionHelper.snackBar.show(checkoutUrl);
          }
        }
        InjectionHelper.snackBar.showSuccess('Checkout started');
      } else {
        InjectionHelper.snackBar.showSuccess(session.status == 'active'
            ? 'Subscription activated'
            : 'Subscription created');
      }

      widget.onPaySuccess?.call();
      await _loadSubscriptionData(silent: true);
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _handleCancelSubscription() async {
    if (_authRequired || !ApiService.hasToken()) {
      InjectionHelper.snackBar
          .showError('Please sign in to manage a subscription.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final success = await Web3Repo.cancelSubscription(
        body: const CancelSubscriptionRequest(cancelImmediately: false),
      );
      if (!success) {
        InjectionHelper.snackBar
            .showError('Unable to cancel subscription right now.');
        return;
      }
      InjectionHelper.snackBar
          .showSuccess('Subscription cancellation requested');
      await _loadSubscriptionData(silent: true);
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _handleResumeSubscription() async {
    if (_authRequired || !ApiService.hasToken()) {
      InjectionHelper.snackBar
          .showError('Please sign in to manage a subscription.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final success = await Web3Repo.resumeSubscription();
      if (!success) {
        InjectionHelper.snackBar
            .showError('Unable to resume subscription right now.');
        return;
      }
      InjectionHelper.snackBar.showSuccess('Subscription resumed');
      await _loadSubscriptionData(silent: true);
    } on ApiException catch (e) {
      InjectionHelper.snackBar
          .showError(e.error ?? ApiErrorMessage.APP_API_ERROR);
    } catch (_) {
      InjectionHelper.snackBar.showError(ApiErrorMessage.APP_UNKNOWN_ERROR);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _openCryptoOptions() async {
    InjectionHelper.snackBar.show(
        'Crypto payments are still being wired to the live checkout flow.');
  }

  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: _buildTablet(context),
      phone: Scaffold(
        backgroundColor: ColorSet.bg3Color,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                const MobileHeader(label: 'Payment'),
                const Gap(22),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTablet(BuildContext context) {
    return Center(
      child: Container(
        height: 730,
        width: 640,
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
        decoration: BoxDecoration(
          color: ColorSet.bg3Color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 29),
                Text('Payment',
                    style: context.textTheme.titleLargeBold
                        .copyWith(fontWeight: FontWeight.w700)),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Image.asset(IconSet.closeIcon, width: 29, height: 29),
                ),
              ],
            ),
            const Gap(22),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: ColorSet.darkBlueColor,
        ),
      );
    }

    if (_loadError != null && _tiers.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_loadError!,
                style: context.textTheme.bodyMedium.copyWith(fontSize: 15),
                textAlign: TextAlign.center),
            const Gap(16),
            AppButton.primary(
              label: 'Retry',
              onPressed: _loadSubscriptionData,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: ColorSet.darkBlueColor,
      onRefresh: () => _loadSubscriptionData(silent: true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const Gap(16),
            _buildDiscountInput(),
            const Gap(16),
            if (_authRequired) ...[
              _buildAuthBanner(),
              const Gap(16),
            ],
            _buildTierSection(),
            const Gap(16),
            _buildStatusCard(),
            const Gap(16),
            _buildPaymentHistory(),
            const Gap(16),
            _buildSupportActions(),
            const Gap(16),
            _buildPrimaryButton(),
            const Gap(24),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final tier = _selectedTier;
    final amount = tier?.priceForInterval(_billingIntervalValue);
    final currency = tier?.currency ?? 'EUR';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ColorSet.bg7Color,
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amount to pay', style: context.textTheme.bodyMedium),
          const Gap(6),
          Text(
              amount == null
                  ? 'Select a subscription'
                  : _formatPrice(amount, currency),
              style: context.textTheme.titleLargeBold.copyWith(
                  color: ColorSet.lightBlueColor, fontWeight: FontWeight.w700)),
          if (tier != null) ...[
            const Gap(6),
            Text(
                '${tier.name} plan • ${_billingCycle == _BillingCycle.yearly ? 'Yearly' : 'Monthly'} billing',
                style: context.textTheme.bodyMedium
                    .copyWith(color: ColorSet.color525252)),
          ],
        ],
      ),
    );
  }

  Widget _buildDiscountInput() {
    return Row(
      children: [
        Expanded(
          child: KumeleTextField(
            controller: discountCodeCTRL,
            borderRadius: 5,
            hintText: 'Enter discount code',
          ),
        ),
        const Gap(6),
        GestureDetector(
          onTap: () {
            InjectionHelper.snackBar.show(
              discountCodeCTRL.text.trim().isEmpty
                  ? 'Add a discount code first.'
                  : 'Discount code will be validated when checkout starts.',
            );
          },
          child: Container(
            width: 100,
            height: 48,
            decoration: BoxDecoration(
              color: ColorSet.revertBgColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text('Apply',
                  style: context.textTheme.bodyLarge
                      .copyWith(color: ColorSet.bg3Color)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorSet.home2ndCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorSet.profileBorderColor),
      ),
      child: Text(
          'You can review subscription plans now, but you need to sign in before checkout, cancellation, or payment history will work.',
          style: context.textTheme.bodyMedium
              .copyWith(color: ColorSet.color525252)),
    );
  }

  Widget _buildTierSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subscription plans',
              style: context.textTheme.bodyLargeBold
                  .copyWith(fontWeight: FontWeight.w700)),
          const Gap(12),
          _buildBillingCyclePicker(),
          const Gap(16),
          if (_tiers.isEmpty)
            Text('No subscription tiers are available right now.',
                style: context.textTheme.bodyMedium
                    .copyWith(color: ColorSet.color525252))
          else
            Column(
              children: _tiers.map((tier) => _buildTierTile(tier)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildBillingCyclePicker() {
    return Row(
      children: [
        Expanded(
          child: _buildCycleChip(
            label: 'Monthly',
            selected: _billingCycle == _BillingCycle.monthly,
            onTap: () {
              setState(() {
                _billingCycle = _BillingCycle.monthly;
              });
            },
          ),
        ),
        const Gap(10),
        Expanded(
          child: _buildCycleChip(
            label: 'Yearly',
            selected: _billingCycle == _BillingCycle.yearly,
            onTap: () {
              setState(() {
                _billingCycle = _BillingCycle.yearly;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCycleChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? ColorSet.darkBlueColor : ColorSet.bg3Color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected
                  ? ColorSet.darkBlueColor
                  : ColorSet.profileBorderColor),
        ),
        child: Center(
          child: Text(label,
              style: context.textTheme.bodyMediumSemiBold.copyWith(
                  color: selected ? ColorSet.bg2Color : ColorSet.textColor,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _buildTierTile(SubscriptionTier tier) {
    final selected = tier.id == _selectedTierId;
    final price = tier.priceForInterval(_billingIntervalValue);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTierId = tier.id;
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? ColorSet.homeMainCardColor : ColorSet.bg3Color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected
                  ? ColorSet.darkBlueColor
                  : ColorSet.profileBorderColor,
              width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFFBCBCBC), width: 2),
                  ),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? ColorSet.darkBlueColor
                            : Colors.transparent,
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(tier.name,
                                style: context.textTheme.bodyLargeBold
                                    .copyWith(fontWeight: FontWeight.w700)),
                          ),
                          if (tier.isPopular)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: ColorSet.specialYellowColor,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text('Popular',
                                  style: context.textTheme.bodySmallBold
                                      .copyWith(fontWeight: FontWeight.w700)),
                            ),
                        ],
                      ),
                      const Gap(6),
                      Text(tier.description,
                          style: context.textTheme.bodyMedium
                              .copyWith(color: ColorSet.color525252)),
                      const Gap(10),
                      Text(
                          price == null
                              ? 'Price unavailable'
                              : _formatPrice(price, tier.currency ?? 'EUR'),
                          style: context.textTheme.bodyLargeBold.copyWith(
                              color: ColorSet.lightBlueColor,
                              fontWeight: FontWeight.w700)),
                      if (tier.features.isNotEmpty) ...[
                        const Gap(10),
                        ...tier.features.take(4).map(
                              (feature) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text('• $feature',
                                    style: context.textTheme.bodySmall.copyWith(
                                        color: ColorSet.color525252,
                                        fontSize: 13)),
                              ),
                            ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final status = _subscriptionStatus;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Current subscription',
              style: context.textTheme.bodyLargeBold
                  .copyWith(fontWeight: FontWeight.w700)),
          const Gap(12),
          if (_authRequired)
            Text('Sign in to check your active subscription status.',
                style: context.textTheme.bodyMedium
                    .copyWith(color: ColorSet.color525252))
          else if (status == null)
            Text('No active subscription found yet.',
                style: context.textTheme.bodyMedium
                    .copyWith(color: ColorSet.color525252))
          else ...[
            _buildStatusRow('Status', _beautifyStatus(status.status)),
            const Gap(8),
            _buildStatusRow('Plan', status.tierName ?? 'Unknown'),
            const Gap(8),
            _buildStatusRow(
                'Renews / ends', _formatDate(status.currentPeriodEnd)),
            const Gap(8),
            _buildStatusRow(
              'Cancellation',
              status.cancelAtPeriodEnd ? 'Scheduled for period end' : 'Active',
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: AppButton.primary(
                    label: status.cancelAtPeriodEnd
                        ? 'Resume subscription'
                        : 'Cancel at period end',
                    fullWidth: true,
                    onPressed: _isSubmitting
                        ? null
                        : status.cancelAtPeriodEnd
                            ? _handleResumeSubscription
                            : _handleCancelSubscription,
                    backgroundColor: status.cancelAtPeriodEnd
                        ? ColorSet.darkBlueColor
                        : ColorSet.revertBgColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: context.textTheme.bodyMedium
                  .copyWith(color: ColorSet.color525252)),
        ),
        const Gap(12),
        Expanded(
          child: Text(value,
              style: context.textTheme.bodyMediumSemiBold
                  .copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right),
        ),
      ],
    );
  }

  Widget _buildPaymentHistory() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent payments',
              style: context.textTheme.bodyLargeBold
                  .copyWith(fontWeight: FontWeight.w700)),
          const Gap(12),
          if (_authRequired)
            Text('Payment history becomes available after sign in.',
                style: context.textTheme.bodyMedium
                    .copyWith(color: ColorSet.color525252))
          else if (_paymentHistory.isEmpty)
            Text('No payment history found yet.',
                style: context.textTheme.bodyMedium
                    .copyWith(color: ColorSet.color525252))
          else
            Column(
              children: _paymentHistory
                  .map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ColorSet.bg3Color,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorSet.profileBorderColor),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    item.description?.isNotEmpty == true
                                        ? item.description!
                                        : 'Payment ${item.id}',
                                    style: context.textTheme.bodyMediumSemiBold
                                        .copyWith(fontWeight: FontWeight.w600)),
                                const Gap(4),
                                Text(
                                    '${item.provider ?? 'Provider unknown'} • ${_beautifyStatus(item.status)}',
                                    style: context.textTheme.bodySmall.copyWith(
                                        color: ColorSet.color525252,
                                        fontSize: 13)),
                              ],
                            ),
                          ),
                          const Gap(12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  item.amount == null
                                      ? '--'
                                      : _formatPrice(
                                          item.amount!, item.currency ?? 'EUR'),
                                  style: context.textTheme.bodyMediumBold
                                      .copyWith(fontWeight: FontWeight.w700)),
                              const Gap(4),
                              Text(_formatDate(item.createdAt),
                                  style: context.textTheme.bodySmall
                                      .copyWith(color: ColorSet.color525252)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSupportActions() {
    return Column(
      children: [
        AppButton.primary(
          label: 'Refresh details',
          fullWidth: true,
          onPressed:
              _isSubmitting ? null : () => _loadSubscriptionData(silent: true),
          backgroundColor: ColorSet.home3rdCardColor,
          foregroundColor: ColorSet.textColor,
        ),
        const Gap(12),
        AppButton.primary(
          label: 'Crypto payment options',
          iconAsset: IconSet.crypto,
          fullWidth: true,
          onPressed: _isSubmitting ? null : _openCryptoOptions,
          backgroundColor: ColorSet.revertTileFillColor,
        ),
      ],
    );
  }

  Widget _buildPrimaryButton() {
    final hasTier = _selectedTier != null;

    return AppButton.primary(
      label: _authRequired ? 'Sign in to subscribe' : 'Continue to checkout',
      fullWidth: true,
      isLoading: _isSubmitting,
      onPressed: _isSubmitting || !hasTier ? null : _handleCheckout,
    );
  }

  String _formatPrice(double amount, String currency) {
    final normalized = currency.trim().toUpperCase();
    final value = amount.toStringAsFixed(2);
    switch (normalized) {
      case 'EUR':
        return 'EUR $value';
      case 'USD':
        return 'USD $value';
      default:
        return '$value $normalized'.trim();
    }
  }

  String _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) return '--';
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    return DateFormat('dd MMM yyyy').format(date.toLocal());
  }

  String _beautifyStatus(String? value) {
    if (value == null || value.trim().isEmpty) return 'Unknown';
    final formatted = value.replaceAll('_', ' ').trim();
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}

void showPaymentSubscriptionsDialog(BuildContext context) {
  showDialog(
    barrierColor: ColorSet.bcColor,
    context: context,
    builder: (BuildContext context) {
      return const PaymentSubscriptionsDialog();
    },
  );
}
