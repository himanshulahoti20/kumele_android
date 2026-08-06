import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';

/// Google Play Billing purchase flow for subscriptions, mirroring the native
/// iOS app's StoreKit flow: query the product, launch the platform purchase
/// sheet, then hand the purchase token to the backend to verify and derive
/// the tier/expiry.
class GooglePlayBillingService {
  GooglePlayBillingService._();

  static final InAppPurchase _iap = InAppPurchase.instance;

  static Future<SubscriptionStatus?> buySubscription(String productId) async {
    if (!await _iap.isAvailable()) {
      throw StateError('Google Play Billing is not available on this device.');
    }

    final response = await _iap.queryProductDetails({productId});
    if (response.error != null || response.productDetails.isEmpty) {
      throw StateError(
          'Subscription product "$productId" is not available on Google Play.');
    }

    final completer = Completer<SubscriptionStatus?>();
    late StreamSubscription<List<PurchaseDetails>> subscription;
    subscription = _iap.purchaseStream.listen((purchases) async {
      for (final purchase in purchases) {
        if (purchase.productID != productId) continue;
        switch (purchase.status) {
          case PurchaseStatus.pending:
            break;
          case PurchaseStatus.error:
            if (!completer.isCompleted) {
              completer.completeError(purchase.error ?? StateError('Purchase failed.'));
            }
            await subscription.cancel();
            break;
          case PurchaseStatus.canceled:
            if (!completer.isCompleted) completer.complete(null);
            await subscription.cancel();
            break;
          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            try {
              final status = await Web3Repo.verifyGooglePurchase(
                productId: purchase.productID,
                purchaseToken: purchase.verificationData.serverVerificationData,
              );
              if (purchase.pendingCompletePurchase) {
                await _iap.completePurchase(purchase);
              }
              if (!completer.isCompleted) completer.complete(status);
            } catch (e) {
              if (!completer.isCompleted) completer.completeError(e);
            }
            await subscription.cancel();
            break;
        }
      }
    }, onError: (Object error) {
      if (!completer.isCompleted) completer.completeError(error);
    });

    await _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: response.productDetails.first),
    );

    return completer.future;
  }
}
