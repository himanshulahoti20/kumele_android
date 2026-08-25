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

  test('store credit uses minor units and preserves its expiry', () {
    final balance = StoreCreditBalance.fromJson({
      'amountMinor': 2499,
      'currency': 'EUR',
      'expiresAt': '2026-10-17T00:00:00.000Z',
    });

    expect(balance.amount, 24.99);
    expect(balance.hasCredit, isTrue);
    expect(balance.expiryDate, DateTime.utc(2026, 10, 17));
  });

  test('event payment sends the exact store-credit flag', () {
    final request = CreateEventPaymentRequest(
      eventId: 'event-123',
      useStoreCredit: true,
    );

    expect(request.toJson(), {
      'eventId': 'event-123',
      'useStoreCredit': true,
    });
  });

  test('NFT PayPal checkout keeps discount and store-credit choices', () {
    final request = CreateEventPaymentRequest(
      nftId: 'nft-123',
      discountCode: 'SAVE10',
      useStoreCredit: true,
    );

    expect(request.toJson(), {
      'nftId': 'nft-123',
      'discountCode': 'SAVE10',
      'useStoreCredit': true,
    });
  });
}
