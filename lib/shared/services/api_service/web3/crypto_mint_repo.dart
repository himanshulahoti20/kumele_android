import 'package:kuemele/shared/models/crypto_mint_models.dart';
import 'package:kuemele/shared/services/api_service/api_config.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';

/// The paid Solana NFT-mint flow, served by a separate worker
/// ([ApiConfig.cryptoMintBaseUrl]) from the main Kumele API:
/// quote -> payment intent -> Stripe card confirm -> poll status.
///
/// The frontend never touches a Solana key — it only collects the
/// destination wallet address and pays by card; the worker mints on its
/// webhook once Stripe confirms.
class CryptoMintRepo {
  CryptoMintRepo._();

  /// Fetch a fresh fee quote. [quoteId] expires quickly, so call this
  /// immediately before [createPaymentIntent] rather than caching it.
  static Future<CryptoMintFeeQuote> getFeeQuote({
    String operation = 'nft_mint',
    String chain = 'solana',
    int quantity = 1,
  }) async {
    final response = await ApiService.callRequest(
      RequestMethod.GET,
      '${ApiConfig.cryptoMintBaseUrl}/web3/fees/quote',
      'CryptoMintRepo_getFeeQuote',
      params: {
        'operation': operation,
        'chain': chain,
        'quantity': quantity,
      },
    );
    return ApiService.handleResponse<CryptoMintFeeQuote>(
          () => CryptoMintFeeQuote.fromJson(ApiService.extractMap(response)),
        ) ??
        const CryptoMintFeeQuote(quoteId: '', feeAmount: 0, currency: 'EUR');
  }

  /// Creates the Stripe payment intent for the quoted mint. Returns the
  /// payload (with `clientSecret`) for [PaymentSdkService.presentStripePaymentSheet].
  static Future<CryptoMintPayment> createPaymentIntent({
    required String quoteId,
    required String ownerAddress,
    required String name,
    String? metadataUri,
  }) async {
    final response = await ApiService.callRequest(
      RequestMethod.POST,
      '${ApiConfig.cryptoMintBaseUrl}/payments/intent',
      'CryptoMintRepo_createPaymentIntent',
      body: {
        'quoteId': quoteId,
        'ownerAddress': ownerAddress,
        'name': name,
        if (metadataUri != null && metadataUri.isNotEmpty)
          'metadataUri': metadataUri,
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

  /// Polls the current mint/payment status
  /// (AWAITING_PAYMENT -> PENDING -> MINTING -> MINTED/FAILED/REFUNDED).
  static Future<CryptoMintPayment> getPaymentStatus(String paymentId) async {
    final response = await ApiService.callRequest(
      RequestMethod.GET,
      '${ApiConfig.cryptoMintBaseUrl}/payments/$paymentId',
      'CryptoMintRepo_getPaymentStatus',
    );
    return ApiService.handleResponse<CryptoMintPayment>(
          () => CryptoMintPayment.fromJson(ApiService.extractMap(response)),
        ) ??
        CryptoMintPayment(
          paymentId: paymentId,
          status: CryptoMintPaymentStatus.unknown,
        );
  }
}
