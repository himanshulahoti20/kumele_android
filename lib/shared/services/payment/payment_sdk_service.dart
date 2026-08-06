import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:kuemele/shared/services/api_service/api_config.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentSdkService {
  PaymentSdkService._();

  static Future<bool> presentStripePaymentSheet(
    Map<String, dynamic> payload, {
    String merchantDisplayName = 'Kumele',
    String? primaryButtonLabel,
  }) async {
    final paymentSecret = _stringValue(
      payload,
      const [
        'paymentIntentClientSecret',
        'payment_intent_client_secret',
        'clientSecret',
        'client_secret',
      ],
    );
    final setupSecret = _stringValue(
      payload,
      const [
        'setupIntentClientSecret',
        'setup_intent_client_secret',
        'setupClientSecret',
        'setup_client_secret',
      ],
    );

    if ((paymentSecret == null || paymentSecret.isEmpty) &&
        (setupSecret == null || setupSecret.isEmpty)) {
      return false;
    }

    final publishableKey = _stringValue(
      payload,
      const ['publishableKey', 'publishable_key'],
    );
    if (publishableKey != null && publishableKey.isNotEmpty) {
      Stripe.publishableKey = publishableKey;
      await Stripe.instance.applySettings();
    } else if (ApiConfig.stripePublishableKey.isEmpty) {
      return false;
    }

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentSecret,
        setupIntentClientSecret: setupSecret,
        customerId: _stringValue(payload, const ['customerId', 'customer_id']),
        customerEphemeralKeySecret: _stringValue(
          payload,
          const ['ephemeralKey', 'ephemeral_key', 'ephemeralKeySecret'],
        ),
        merchantDisplayName: merchantDisplayName,
        primaryButtonLabel: primaryButtonLabel,
        style: ThemeMode.system,
      ),
    );
    await Stripe.instance.presentPaymentSheet();
    return true;
  }

  static Future<bool> presentPayPalCheckout({
    required BuildContext context,
    required num amount,
    required String currency,
    required String description,
  }) async {
    if (ApiConfig.paypalClientId.isEmpty ||
        ApiConfig.paypalSecretKey.isEmpty ||
        amount <= 0) {
      return false;
    }

    final completed = Completer<bool>();
    final total = amount.toStringAsFixed(2);
    final transactions = [
      {
        'amount': {
          'total': total,
          'currency': currency,
          'details': {
            'subtotal': total,
            'shipping': '0',
            'shipping_discount': 0,
          },
        },
        'description': description,
        'item_list': {
          'items': [
            {
              'name': description,
              'quantity': 1,
              'price': total,
              'currency': currency,
            },
          ],
        },
      },
    ];

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (_) => PaypalCheckoutView(
          sandboxMode: ApiConfig.paypalSandboxMode,
          clientId: ApiConfig.paypalClientId,
          secretKey: ApiConfig.paypalSecretKey,
          transactions: transactions,
          note: description,
          onSuccess: (_) {
            if (!completed.isCompleted) completed.complete(true);
            Navigator.of(context, rootNavigator: true).pop();
          },
          onCancel: () {
            if (!completed.isCompleted) completed.complete(false);
            Navigator.of(context, rootNavigator: true).pop();
          },
          onError: (_) {
            if (!completed.isCompleted) completed.complete(false);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ),
    );

    if (!completed.isCompleted) completed.complete(false);
    return completed.future;
  }

  static Future<bool> presentPayPalApprovalUrl({
    required BuildContext context,
    required String approvalUrl,
    required String orderId,
  }) async {
    final approvalUri = Uri.tryParse(approvalUrl);
    if (approvalUri == null) return false;

    final completed = Completer<bool>();
    late final WebViewController controller;
    var firstUrl = true;

    void finish(bool value) {
      if (!completed.isCompleted) completed.complete(value);
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) navigator.pop();
    }

    bool approved(Uri uri) {
      final value = uri.toString().toLowerCase();
      if (value.contains('cancel')) return false;
      final hasOrder = value.contains(orderId.toLowerCase()) ||
          uri.queryParameters['token'] == orderId;
      return hasOrder &&
          (uri.queryParameters.containsKey('PayerID') ||
              uri.queryParameters.containsKey('payerId') ||
              value.contains('success') ||
              value.contains('approved') ||
              value.contains('return'));
    }

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            if (uri == null) return NavigationDecision.navigate;
            final value = request.url.toLowerCase();
            if (!firstUrl && value.contains('cancel')) {
              finish(false);
              return NavigationDecision.prevent;
            }
            if (!firstUrl && approved(uri)) {
              finish(true);
              return NavigationDecision.prevent;
            }
            firstUrl = false;
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(approvalUri);

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('PayPal'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => finish(false),
            ),
          ),
          body: WebViewWidget(controller: controller),
        ),
      ),
    );

    if (!completed.isCompleted) completed.complete(false);
    return completed.future;
  }

  static String? _stringValue(Map<String, dynamic> payload, List<String> keys) {
    for (final key in keys) {
      final value = payload[key];
      if (value != null) return value.toString();
    }

    for (final value in payload.values) {
      if (value is Map) {
        final nested = _stringValue(Map<String, dynamic>.from(value), keys);
        if (nested != null && nested.isNotEmpty) return nested;
      }
    }
    return null;
  }
}
