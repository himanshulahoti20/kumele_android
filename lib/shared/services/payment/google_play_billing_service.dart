import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';

/// Google Play Billing purchase flow for subscriptions, mirroring the native
/// iOS app's StoreKit flow: query the product, launch the platform purchase
/// sheet, then hand the purchase token to the backend to verify and derive
/// the tier/expiry.
///
/// Play subscriptions are structured as one parent product containing
/// multiple base plans (e.g. "kumele_premium" with "basic-monthly",
/// "premium-monthly", "vip-monthly") rather than one purchasable product id
/// per tier, so [productId] must be the parent product and [basePlanId]
/// selects which base plan's offer to purchase.
///
/// The backend's verify endpoint is idempotent on purchaseToken and is meant
/// to be called from three places: an initial purchase, a user-triggered
/// restore, and app-start reconciliation (a purchase Play processed while
/// the app wasn't around to see the stream event). [initialize] covers the
/// last one by listening for the app's lifetime — Play redelivers any
/// undelivered purchase to the first listener that subscribes.
class GooglePlayBillingService {
  GooglePlayBillingService._();

  static final InAppPurchase _iap = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;

  // ponytail: single global pending slot, only one purchase can be in
  // flight from the UI at a time (the buy button is disabled while
  // submitting). A map keyed by productId would be needed if that stops
  // being true.
  static Completer<SubscriptionStatus?>? _pendingCompleter;
  static String? _pendingProductId;

  /// Starts listening for purchase updates for the app's lifetime. Safe to
  /// call multiple times. Call once at app start so purchases completed
  /// while the app was killed/backgrounded get verified as soon as Play
  /// redelivers them.
  static void initialize() {
    if (_subscription != null) return;
    _subscription =
        _iap.purchaseStream.listen(_handlePurchaseUpdates, onError: (_) {});
  }

  /// Re-queries Google Play for the user's owned entitlements and redelivers
  /// them through the same purchase stream, each verified with the backend.
  static Future<void> restorePurchases() async {
    initialize();
    await _iap.restorePurchases();
  }

  static Future<SubscriptionStatus?> buySubscription(
    String productId, {
    String? basePlanId,
  }) async {
    debugPrint(
        '[GPB] buySubscription tapped: productId=$productId basePlanId=$basePlanId');
    initialize();

    if (!await _iap.isAvailable()) {
      debugPrint('[GPB] Play Billing unavailable on this device');
      throw StateError('Google Play Billing is not available on this device.');
    }

    final response = await _iap.queryProductDetails({productId});
    debugPrint(
        '[GPB] queryProductDetails($productId) -> found=${response.productDetails.length} '
        'notFound=${response.notFoundIDs} error=${response.error}');
    if (response.error != null || response.productDetails.isEmpty) {
      throw StateError(
          'Subscription product "$productId" is not available on Google Play.');
    }

    final offers = response.productDetails.whereType<GooglePlayProductDetails>();
    debugPrint('[GPB] offers for $productId: '
        '${offers.map((o) => o.productDetails.subscriptionOfferDetails?[o.subscriptionIndex ?? -1].basePlanId).toList()}');
    final selected = basePlanId == null
        ? offers.first
        : offers.firstWhere(
            (offer) {
              final index = offer.subscriptionIndex;
              final details = offer.productDetails.subscriptionOfferDetails;
              if (index == null || details == null) return false;
              return details[index].basePlanId == basePlanId;
            },
            orElse: () => throw StateError(
                'Base plan "$basePlanId" was not found for product "$productId".'),
          );
    debugPrint('[GPB] selected offerToken=${selected.offerToken}');

    _pendingCompleter = Completer<SubscriptionStatus?>();
    _pendingProductId = productId;

    await _iap.buyNonConsumable(
      purchaseParam: GooglePlayPurchaseParam(
        productDetails: selected,
        offerToken: selected.offerToken,
      ),
    );
    debugPrint('[GPB] buyNonConsumable launched for $productId, awaiting purchaseStream');

    return _pendingCompleter!.future;
  }

  static Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchases,
  ) async {
    debugPrint('[GPB] purchaseStream event: ${purchases.length} update(s), '
        'pending=$_pendingProductId');
    for (final purchase in purchases) {
      debugPrint('[GPB]   productID="${purchase.productID}" '
          'status=${purchase.status} purchaseID=${purchase.purchaseID}');
      switch (purchase.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.error:
          // On Android, a cancel/error with no actual Purchase object comes
          // back with productID == '' (see in_app_purchase_android's
          // handling of an empty purchases list), so it can't be matched by
          // id — resolve whatever's currently pending instead.
          debugPrint('[GPB]   -> error: ${purchase.error}');
          _completePending(purchase.productID,
              error: purchase.error ?? StateError('Purchase failed.'),
              matchAnyPending: true);
          break;
        case PurchaseStatus.canceled:
          debugPrint('[GPB]   -> user canceled');
          _completePending(purchase.productID,
              status: null, matchAnyPending: true);
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (!ApiService.hasToken()) {
            debugPrint('[GPB]   -> purchased but no auth token yet, deferring');
            break;
          }
          try {
            debugPrint('[GPB]   -> verifying with backend: '
                'productId=${purchase.productID} token=${purchase.verificationData.serverVerificationData}');
            final status = await Web3Repo.verifyGooglePurchase(
              productId: purchase.productID,
              purchaseToken: purchase.verificationData.serverVerificationData,
            );
            debugPrint('[GPB]   -> verify response: isActive=${status?.isActive} '
                'tierName=${status?.tierName}');
            if (purchase.pendingCompletePurchase) {
              await _iap.completePurchase(purchase);
              debugPrint('[GPB]   -> completePurchase called');
            }
            _completePending(purchase.productID, status: status);
          } catch (e) {
            debugPrint('[GPB]   -> verify failed: $e');
            _completePending(purchase.productID, error: e);
          }
          break;
      }
    }
  }

  static void _completePending(
    String productId, {
    SubscriptionStatus? status,
    Object? error,
    bool matchAnyPending = false,
  }) {
    if (_pendingCompleter == null) return;
    if (!matchAnyPending && _pendingProductId != productId) return;
    debugPrint('[GPB] resolving pending completer for $_pendingProductId '
        '(event productId="$productId"): ${error != null ? 'error=$error' : 'status=${status?.isActive}'}');
    if (error != null) {
      _pendingCompleter!.completeError(error);
    } else {
      _pendingCompleter!.complete(status);
    }
    _pendingCompleter = null;
    _pendingProductId = null;
  }
}
