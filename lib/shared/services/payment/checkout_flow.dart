import 'package:flutter/material.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/services/payment/payment_sdk_service.dart';

/// "Pay via Stripe, else fall back to PayPal" — the same cascade used for
/// event-creation payments, guest ticket purchases, and NFT checkout. PayPal
/// is only started when Stripe cannot be presented; once Stripe is presented,
/// failures are returned to the caller so a completed card payment can never
/// accidentally start a second charge through another provider.
class CheckoutFlow {
  CheckoutFlow._();

  static Future<void> payStripeThenPayPal({
    required BuildContext context,
    required Future<Map<String, dynamic>> Function() createStripePayment,
    required Future<PayPalOrder?> Function() createPayPalOrder,
    String primaryButtonLabel = 'Pay now',
  }) async {
    final payment = await createStripePayment();
    if (payment['requiresPayment'] == false) {
      // Store credit (or a discount) covered the full amount server-side —
      // already settled, no Stripe leg to present.
      return;
    }
    if (payment.isNotEmpty &&
        await PaymentSdkService.presentStripePaymentSheet(
          payment,
          primaryButtonLabel: primaryButtonLabel,
        )) {
      final paymentIntentId = _stripePaymentIntentId(payment);
      if (paymentIntentId == null) {
        throw Exception('No Stripe payment intent returned.');
      }
      await Web3Repo.confirmStripePayment(paymentIntentId);
      return;
    }

    if (!context.mounted) throw Exception('Payment was not completed.');
    final order = await createPayPalOrder();
    if (order?.requiresPayment == false) return;
    final orderId = order?.orderId;
    final approvalUrl = order?.approvalUrl;
    if (orderId == null ||
        orderId.isEmpty ||
        approvalUrl == null ||
        approvalUrl.isEmpty) {
      throw Exception('No payment approval URL returned.');
    }

    if (!context.mounted ||
        !await PaymentSdkService.presentPayPalApprovalUrl(
          context: context,
          approvalUrl: approvalUrl,
          orderId: orderId,
        )) {
      throw Exception('PayPal payment was not approved.');
    }

    final capture = await Web3Repo.capturePayPalOrder(orderId);
    final status = capture['status']?.toString().toUpperCase();
    if (status != null && status != 'COMPLETED') {
      throw Exception('PayPal payment was not completed.');
    }
  }

  static String? _stripePaymentIntentId(Map<String, dynamic> payload) {
    final clientSecret = payload['clientSecret']?.toString() ??
        payload['client_secret']?.toString() ??
        payload['paymentIntentClientSecret']?.toString() ??
        payload['payment_intent_client_secret']?.toString();
    final marker = clientSecret?.indexOf('_secret_') ?? -1;
    if (clientSecret != null && marker > 0) {
      return clientSecret.substring(0, marker);
    }
    return payload['paymentIntentId']?.toString() ??
        payload['payment_intent_id']?.toString();
  }
}
