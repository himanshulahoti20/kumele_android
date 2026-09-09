/// Fee quote for a crypto/NFT-mint operation from `GET
/// /web3/fees/quote?operation=...&chain=...&quantity=...`. [expiresAt] is
/// short-lived — fetch a fresh quote immediately before creating a payment
/// intent with [quoteId], never reuse a cached one.
class CryptoMintFeeQuote {
  const CryptoMintFeeQuote({
    required this.quoteId,
    required this.feeAmount,
    required this.currency,
    this.expiresAt,
  });

  final String quoteId;
  final num feeAmount;
  final String currency;
  final DateTime? expiresAt;

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  factory CryptoMintFeeQuote.fromJson(Map<String, dynamic> json) {
    return CryptoMintFeeQuote(
      quoteId: (json['quoteId'] ?? json['quote_id'])?.toString() ?? '',
      feeAmount: _asNum(json['fee'] ?? json['feeAmount'] ?? json['fee_amount']),
      currency: (json['currency'] ?? 'EUR').toString(),
      expiresAt: DateTime.tryParse(
        (json['expiresAt'] ?? json['expires_at'] ?? '').toString(),
      ),
    );
  }

  String get feeLabel {
    final symbol = currency.toUpperCase() == 'EUR' ? '€' : '$currency ';
    return '$symbol${feeAmount.toStringAsFixed(feeAmount % 1 == 0 ? 0 : 2)}';
  }
}

enum CryptoMintPaymentStatus {
  awaitingPayment,
  pending,
  minting,
  minted,
  failed,
  refunded,
  unknown;

  static CryptoMintPaymentStatus fromRaw(String? raw) {
    switch ((raw ?? '').toUpperCase()) {
      case 'AWAITING_PAYMENT':
        return CryptoMintPaymentStatus.awaitingPayment;
      case 'PENDING':
        return CryptoMintPaymentStatus.pending;
      case 'MINTING':
        return CryptoMintPaymentStatus.minting;
      case 'MINTED':
        return CryptoMintPaymentStatus.minted;
      case 'FAILED':
        return CryptoMintPaymentStatus.failed;
      case 'REFUNDED':
        return CryptoMintPaymentStatus.refunded;
      default:
        return CryptoMintPaymentStatus.unknown;
    }
  }

  bool get isTerminal =>
      this == CryptoMintPaymentStatus.minted ||
      this == CryptoMintPaymentStatus.failed ||
      this == CryptoMintPaymentStatus.refunded;

  bool get isSuccess => this == CryptoMintPaymentStatus.minted;
}

class CryptoMintPayment {
  const CryptoMintPayment({
    required this.paymentId,
    required this.status,
    this.clientSecret,
    this.mintAddress,
    this.transactionSignature,
    this.raw = const {},
  });

  final String paymentId;
  final CryptoMintPaymentStatus status;
  final String? clientSecret;
  final String? mintAddress;
  final String? transactionSignature;
  final Map<String, dynamic> raw;

  factory CryptoMintPayment.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return CryptoMintPayment(
      paymentId:
          (data['paymentId'] ?? data['payment_id'] ?? data['id'])?.toString() ??
              '',
      status: CryptoMintPaymentStatus.fromRaw(
        (data['status'] ?? '').toString(),
      ),
      clientSecret: (data['clientSecret'] ??
              data['client_secret'] ??
              data['paymentIntentClientSecret'])
          ?.toString(),
      mintAddress: (data['mintAddress'] ?? data['mint_address'])?.toString(),
      transactionSignature:
          (data['transactionSignature'] ?? data['transaction_signature'])
              ?.toString(),
      raw: data,
    );
  }
}

num _asNum(dynamic value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}
