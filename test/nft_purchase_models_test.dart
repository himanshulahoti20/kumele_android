import 'package:flutter_test/flutter_test.dart';
import 'package:kuemele/shared/models/crypto_mint_models.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/web3/crypto_mint_repo.dart';

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

  test('purchase response: Stripe id wins, full credit skips Stripe', () {
    final stripe = CryptoMintPayment.fromJson({
      'data': {
        'requiresPayment': true,
        'paymentId': 'local-1',
        'paymentIntentId': 'pi_123',
        'clientSecret': 'pi_123_secret_x',
        'status': 'AWAITING_PAYMENT',
      },
    });
    expect(stripe.paymentId, 'pi_123');
    expect(stripe.requiresPayment, isTrue);

    final credit = CryptoMintPayment.fromJson({
      'data': {'requiresPayment': false, 'paymentIntentId': 'local-9', 'status': 'PAID'},
    });
    expect(credit.requiresPayment, isFalse);
    expect(credit.paymentId, 'local-9');
    expect(credit.clientSecret, isNull);
    expect(credit.status.isSuccess, isFalse);
  });

  test('Solana wallet address must be 32-44 Base58 characters', () {
    expect(
      CryptoMintRepo.isValidSolanaAddress(
          '7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU'),
      isTrue,
    );
    expect(CryptoMintRepo.isValidSolanaAddress('0xabc'), isFalse);
    expect(CryptoMintRepo.isValidSolanaAddress('a' * 31), isFalse);
    expect(CryptoMintRepo.isValidSolanaAddress('${'1' * 43}O'), isFalse);
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

  test('NFT detail reads token number, QR and creator from nft_details', () {
    // Trimmed live GET /nfts/{id} (2026-10-05): top-level creator is an
    // object/null; display values live under nft_details.
    final nft = NftItem.fromJson({
      'id': 'nft-1',
      'creator': {'id': 'u1'},
      'tokenStandard': 'Metaplex Core',
      'qr_code_url': 'https://api.kumele.com/api/v1/nfts/nft-1/qr',
      'share_url': 'https://kumele.com/user/shop?tab=nfts&nftId=nft-1',
      'nft_details': {
        'token_number': '#17099',
        'blockchain': 'Solana',
        'creator': 'Kumele Studios',
      },
    });
    expect(nft.tokenNumber, '#17099');
    expect(nft.blockchain, 'Solana');
    expect(nft.creator, 'Kumele Studios');
    expect(nft.qrCodeUrl, 'https://api.kumele.com/api/v1/nfts/nft-1/qr');
    expect(nft.shareUrl, 'https://kumele.com/user/shop?tab=nfts&nftId=nft-1');
    expect(nft.tokenStandard, 'Metaplex Core');
  });
}
