/// Fee quote for a crypto/NFT-mint operation from `GET
/// /web3/fees/quote?operation=...&chain=...&quantity=...`. [expiresAt] is
/// short-lived — fetch a fresh quote immediately before creating a payment
/// intent with [quoteId], never reuse a cached one.
class CryptoMintFeeQuote {
  const CryptoMintFeeQuote({
    required this.feeAmount,
    required this.currency,
    this.quoteId = '',
    this.label = defaultLabel,
    this.expiresAt,
  });

  static const defaultLabel = 'Blockchain processing fee';

  final String quoteId;
  final num feeAmount;
  final String currency;
  final String label;
  final DateTime? expiresAt;

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  /// `estimated_fee_minor` is EUR cents.
  factory CryptoMintFeeQuote.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;
    final minor = data['estimated_fee_minor'] ?? data['estimatedFeeMinor'];
    final eur = data['feeEur'] ?? data['fee'] ?? data['fee_amount'] ?? data['feeAmount'];
    return CryptoMintFeeQuote(
      quoteId: (data['quoteId'] ?? data['quote_id'])?.toString() ?? '',
      feeAmount: minor != null ? _asNum(minor) / 100 : _asNum(eur),
      currency: (data['currency'] ?? 'EUR').toString(),
      label: (data['label'] ?? '').toString().trim().isEmpty
          ? defaultLabel
          : data['label'].toString(),
      expiresAt: DateTime.tryParse(
        (data['expiresAt'] ?? data['expires_at'] ?? '').toString(),
      ),
    );
  }

  String get feeLabel {
    final symbol = currency.toUpperCase() == 'EUR' ? '€' : '$currency ';
    return '$symbol${feeAmount.toStringAsFixed(2)}';
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
      case 'OWNED':
        return CryptoMintPaymentStatus.minted;
      case 'FAILED':
        return CryptoMintPaymentStatus.failed;
      case 'REFUNDED':
        return CryptoMintPaymentStatus.refunded;
      case 'CANCELED':
      case 'CANCELLED':
        return CryptoMintPaymentStatus.failed;
      default:
        // Unknown strings (incl. SUCCEEDED/PROCESSING) keep polling.
        return CryptoMintPaymentStatus.pending;
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
    this.requiresPayment = true,
    this.mintAddress,
    this.transactionSignature,
    this.raw = const {},
  });

  final String paymentId;
  final CryptoMintPaymentStatus status;
  final String? clientSecret;

  /// False when store credit covered the whole purchase (no Stripe intent).
  final bool requiresPayment;
  final String? mintAddress;
  final String? transactionSignature;
  final Map<String, dynamic> raw;

  factory CryptoMintPayment.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return CryptoMintPayment(
      paymentId:
          (data['paymentIntentId'] ??
                  data['payment_intent_id'] ??
                  data['paymentId'] ??
                  data['payment_id'] ??
                  data['id'])
              ?.toString() ??
              '',
      // Ownership begins only once the backend reports the mint done.
      status: data['owned'] == true
          ? CryptoMintPaymentStatus.minted
          : CryptoMintPaymentStatus.fromRaw(
              (data['mintStatus'] ?? data['mint_status'] ?? data['status'])
                  ?.toString(),
            ),
      clientSecret: (data['clientSecret'] ??
              data['client_secret'] ??
              data['paymentIntentClientSecret'])
          ?.toString(),
      requiresPayment: data['requiresPayment'] != false,
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
