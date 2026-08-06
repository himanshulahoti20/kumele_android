import 'package:flutter_test/flutter_test.dart';
import 'package:kuemele/shared/services/api_service/api_config.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog.dart';
import 'package:kuemele/shared/models/web3_models.dart';

void main() {
  test('generated API catalog covers the live backend contract', () {
    expect(
      GeneratedApiCatalog.all,
      hasLength(GeneratedApiCatalog.contractOperationCount),
    );
    expect(
      GeneratedApiCatalog.all.map((descriptor) => descriptor.routeKey).toSet(),
      hasLength(GeneratedApiCatalog.contractOperationCount),
    );
  });

  test('network configuration never falls back to cleartext', () {
    if (ApiConfig.isConfigured) {
      expect(ApiConfig.validate, returnsNormally);
    } else {
      expect(ApiConfig.validate, throwsStateError);
    }
  });

  test('PayPal event creation response keeps capture fields', () {
    final order = PayPalOrder.fromJson({
      'requiresPayment': true,
      'orderId': 'ORDER-123',
      'approvalUrl': 'https://paypal.example/checkout?token=ORDER-123',
      'amountMinor': 999,
      'currency': 'EUR',
    });

    expect(order.requiresPayment, isTrue);
    expect(order.orderId, 'ORDER-123');
    expect(order.approvalUrl, contains('ORDER-123'));
    expect(order.amountMinor, 999);
    expect(order.currency, 'EUR');
  });
}
