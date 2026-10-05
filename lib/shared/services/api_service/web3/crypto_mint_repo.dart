import 'package:kuemele/shared/models/crypto_mint_models.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';

/// Paid Solana NFT mint through the Kumele API only (no worker, no RPC):
/// quote -> `POST /nfts/{id}/purchase` (Stripe client data) -> Payment Sheet
/// -> poll `GET /nfts/{id}/purchase/status`. Ownership starts only on a
/// minted/owned status.
class CryptoMintRepo {
  CryptoMintRepo._();

  static Future<CryptoMintFeeQuote> getFeeQuote({
    String operation = 'nft_mint',
    String chain = 'solana',
    int quantity = 1,
  }) async {
    final response = await ApiService.callRequest(
      RequestMethod.GET,
      '/web3/fees/quote',
      'CryptoMintRepo_getFeeQuote',
      params: {'operation': operation, 'chain': chain, 'quantity': quantity},
      useAuthenHeader: false,
    );
    return ApiService.handleResponse<CryptoMintFeeQuote>(
          () => CryptoMintFeeQuote.fromJson(ApiService.extractMap(response)),
        ) ??
        const CryptoMintFeeQuote(feeAmount: 0, currency: 'EUR');
  }

  /// Returns the payload (with `clientSecret`) for
  /// [PaymentSdkService.presentStripePaymentSheet].
  static Future<CryptoMintPayment> purchase(
    String nftId, {
    String? walletAddress,
  }) async {
    final response = await ApiService.callRequest(
      RequestMethod.POST,
      '/nfts/$nftId/purchase',
      'CryptoMintRepo_purchase',
      body: {
        if (walletAddress != null && walletAddress.isNotEmpty)
          'walletAddress': walletAddress,
      },
    );
    return ApiService.handleResponse<CryptoMintPayment>(
          () => CryptoMintPayment.fromJson(ApiService.extractMap(response)),
        ) ??
        const CryptoMintPayment(
          paymentId: '',
          status: CryptoMintPaymentStatus.unknown,
        );
  }

  static Future<CryptoMintPayment> getPurchaseStatus(String nftId) async {
    final response = await ApiService.callRequest(
      RequestMethod.GET,
      '/nfts/$nftId/purchase/status',
      'CryptoMintRepo_getPurchaseStatus',
    );
    return ApiService.handleResponse<CryptoMintPayment>(
          () => CryptoMintPayment.fromJson(ApiService.extractMap(response)),
        ) ??
        CryptoMintPayment(
          paymentId: nftId,
          status: CryptoMintPaymentStatus.unknown,
        );
  }
}
