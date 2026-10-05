import 'package:flutter_test/flutter_test.dart';
import 'package:kuemele/shared/models/crypto_mint_models.dart';
import 'package:kuemele/shared/models/ads.dart';

void main() {
  test('fee quote reads estimated_fee_minor as cents with backend label', () {
    final q = CryptoMintFeeQuote.fromJson({
      'data': {'estimated_fee_minor': 123, 'currency': 'EUR', 'label': 'Fee X'},
    });
    expect(q.feeAmount, 1.23);
    expect(q.feeLabel, '€1.23');
    expect(q.label, 'Fee X');
    expect(CryptoMintFeeQuote.fromJson({'estimated_fee_minor': 50}).label,
        CryptoMintFeeQuote.defaultLabel);
  });

  test('only minted/owned counts as success', () {
    expect(CryptoMintPaymentStatus.fromRaw('owned').isSuccess, isTrue);
    expect(CryptoMintPaymentStatus.fromRaw('MINTED').isSuccess, isTrue);
    expect(CryptoMintPaymentStatus.fromRaw('PENDING').isSuccess, isFalse);
    expect(CryptoMintPaymentStatus.fromRaw('succeeded').isSuccess, isFalse);
  });

  test('non-BACKEND ad_source is dropped, missing source still renders', () {
    final ad = {'id': 'a1', 'title': 't'};
    expect(
      FetchedAds.fromJson({'ad_source': 'GOOGLE', 'ads': [ad]}).ads,
      isEmpty,
    );
    expect(
      FetchedAds.fromJson({'ad_source': 'BACKEND', 'ads': [ad]}).ads,
      hasLength(1),
    );
    expect(FetchedAds.fromJson({'ads': [ad]}).ads, hasLength(1));
  });
}
