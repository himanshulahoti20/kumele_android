class SubscriptionTier {
  final String id;
  final String name;
  final String description;
  final double? price;
  final double? priceMonthly;
  final double? priceYearly;
  final String? currency;
  final String? interval;
  final List<String> features;
  final bool isPopular;
  final Map<String, dynamic> entitlements;
  final String? googleProductId;
  final Map<String, dynamic> raw;

  const SubscriptionTier({
    required this.id,
    required this.name,
    required this.description,
    required this.features,
    required this.raw,
    this.price,
    this.priceMonthly,
    this.priceYearly,
    this.currency,
    this.interval,
    this.isPopular = false,
    this.entitlements = const {},
    this.googleProductId,
  });

  factory SubscriptionTier.fromJson(Map<String, dynamic> json) {
    final featureValues =
        json['features'] is List ? (json['features'] as List) : const [];
    final monthlyPrice =
        _asDouble(json['priceMonthly'] ?? json['monthlyPrice']);
    final yearlyPrice = _asDouble(json['priceYearly'] ?? json['yearlyPrice']);
    return SubscriptionTier(
      id: (json['id'] ?? json['tierId'] ?? json['slug'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? 'Tier').toString(),
      description: (json['description'] ?? json['subtitle'] ?? '').toString(),
      price: _asDouble(json['price']) ?? monthlyPrice ?? yearlyPrice,
      priceMonthly: monthlyPrice,
      priceYearly: yearlyPrice,
      currency: (json['currency'] ?? json['currencyCode'])?.toString(),
      interval: (json['interval'] ?? json['billingInterval'])?.toString(),
      features: featureValues.map((item) => item.toString()).toList(),
      isPopular: (json['isPopular'] ?? json['popular'] ?? false) == true,
      googleProductId: (json['googleProductId'] ??
              json['playProductId'] ??
              json['androidProductId'])
          ?.toString(),
      entitlements: json['entitlements'] is Map<String, dynamic>
          ? json['entitlements'] as Map<String, dynamic>
          : json['entitlements'] is Map
              ? (json['entitlements'] as Map).cast<String, dynamic>()
              : const {},
      raw: json,
    );
  }

  double? priceForInterval(String billingInterval) {
    return billingInterval == 'yearly'
        ? (priceYearly ?? priceMonthly ?? price)
        : (priceMonthly ?? price ?? priceYearly);
  }
}

class SubscriptionStatus {
  final bool isActive;
  final String? status;
  final String? tierName;
  final String? currentPeriodEnd;
  final bool cancelAtPeriodEnd;
  final Map<String, dynamic> raw;

  const SubscriptionStatus({
    required this.isActive,
    required this.cancelAtPeriodEnd,
    required this.raw,
    this.status,
    this.tierName,
    this.currentPeriodEnd,
  });

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      isActive: (json['isActive'] ??
              json['active'] ??
              json['hasActiveSubscription'] ??
              json['status'] == 'active') ==
          true,
      status: json['status']?.toString(),
      tierName: (json['tierName'] ?? json['tier'] ?? json['plan'])?.toString(),
      currentPeriodEnd:
          (json['currentPeriodEnd'] ?? json['expiresAt'] ?? json['periodEnd'])
              ?.toString(),
      cancelAtPeriodEnd: (json['cancelAtPeriodEnd'] ?? false) == true,
      raw: json,
    );
  }
}

double? _asDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

class CreateSubscriptionRequest {
  final String tierId;
  final String? discountCode;

  const CreateSubscriptionRequest({
    required this.tierId,
    this.discountCode,
  });

  Map<String, dynamic> toJson() => {
        'tierId': tierId,
        if (discountCode != null && discountCode!.isNotEmpty)
          'discountCode': discountCode,
      };
}

class CancelSubscriptionRequest {
  final String? reason;
  final bool? cancelImmediately;

  const CancelSubscriptionRequest({
    this.reason,
    this.cancelImmediately,
  });

  Map<String, dynamic> toJson() => {
        if (reason != null && reason!.isNotEmpty) 'reason': reason,
        if (cancelImmediately != null) 'cancelImmediately': cancelImmediately,
      };
}

class SubscriptionCheckoutSession {
  final String? checkoutUrl;
  final String? sessionId;
  final String? status;
  final Map<String, dynamic> raw;

  const SubscriptionCheckoutSession({
    required this.raw,
    this.checkoutUrl,
    this.sessionId,
    this.status,
  });

  factory SubscriptionCheckoutSession.fromJson(Map<String, dynamic> json) {
    return SubscriptionCheckoutSession(
      checkoutUrl: (json['checkoutUrl'] ?? json['url'] ?? json['checkout_url'])
          ?.toString(),
      sessionId: (json['sessionId'] ?? json['id'])?.toString(),
      status: json['status']?.toString(),
      raw: json,
    );
  }
}

class CreateEventPaymentRequest {
  final String eventId;
  final String? discountCode;
  final String? rewardDiscountId;

  const CreateEventPaymentRequest({
    required this.eventId,
    this.discountCode,
    this.rewardDiscountId,
  });

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        if (discountCode != null && discountCode!.isNotEmpty)
          'discountCode': discountCode,
        if (rewardDiscountId != null && rewardDiscountId!.isNotEmpty)
          'rewardDiscountId': rewardDiscountId,
      };
}

class PaymentHistoryItem {
  final String id;
  final double? amount;
  final String? currency;
  final String? status;
  final String? provider;
  final String? description;
  final String? createdAt;
  final Map<String, dynamic> raw;

  const PaymentHistoryItem({
    required this.id,
    required this.raw,
    this.amount,
    this.currency,
    this.status,
    this.provider,
    this.description,
    this.createdAt,
  });

  factory PaymentHistoryItem.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryItem(
      id: (json['id'] ?? json['paymentId'] ?? '').toString(),
      amount: (json['amount'] as num?)?.toDouble(),
      currency: (json['currency'] ?? json['currencyCode'])?.toString(),
      status: json['status']?.toString(),
      provider: (json['provider'] ?? json['paymentProvider'])?.toString(),
      description:
          (json['description'] ?? json['title'] ?? json['reason'])?.toString(),
      createdAt: (json['createdAt'] ?? json['date'])?.toString(),
      raw: json,
    );
  }
}

class PayPalOrder {
  final String? orderId;
  final String? approvalUrl;
  final String? status;
  final bool? requiresPayment;
  final int? amountMinor;
  final String? currency;
  final Map<String, dynamic> raw;

  const PayPalOrder({
    required this.raw,
    this.orderId,
    this.approvalUrl,
    this.status,
    this.requiresPayment,
    this.amountMinor,
    this.currency,
  });

  factory PayPalOrder.fromJson(Map<String, dynamic> json) {
    return PayPalOrder(
      orderId: (json['orderId'] ?? json['order_id'] ?? json['id'])?.toString(),
      approvalUrl: (json['approvalUrl'] ??
              json['approval_url'] ??
              json['approveUrl'] ??
              json['approve_url'] ??
              json['url'])
          ?.toString(),
      status: json['status']?.toString(),
      requiresPayment:
          (json['requiresPayment'] ?? json['requires_payment']) as bool?,
      amountMinor:
          ((json['amountMinor'] ?? json['amount_minor']) as num?)?.toInt(),
      currency: json['currency']?.toString(),
      raw: json,
    );
  }
}

class NftItem {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? thumbnailUrl;
  final String? category;
  final String? nftType;
  final double? price;
  final String? currency;
  final bool isOwned;
  final bool isEarned;
  final bool isClaimable;
  final bool isComingSoon;
  final bool isFree;
  final String? freeUnderRewardTier;
  final int? totalSupply;
  final String? rewardType;
  final String? rewardTierRequired;
  final String? tokenId;
  final String? tokenStandard;
  final String? blockchain;
  final String? contractAddress;
  final int? chainId;
  final String? eventId;
  final bool? isActive;
  final Map<String, dynamic> metadata;
  final String? creator;
  final Map<String, dynamic> raw;

  const NftItem({
    required this.id,
    required this.title,
    required this.description,
    required this.isOwned,
    required this.isEarned,
    required this.isClaimable,
    required this.raw,
    this.imageUrl,
    this.thumbnailUrl,
    this.category,
    this.nftType,
    this.price,
    this.currency,
    this.isComingSoon = false,
    this.isFree = false,
    this.freeUnderRewardTier,
    this.totalSupply,
    this.rewardType,
    this.rewardTierRequired,
    this.tokenId,
    this.tokenStandard,
    this.blockchain,
    this.contractAddress,
    this.chainId,
    this.eventId,
    this.isActive,
    this.metadata = const {},
    this.creator,
  });

  factory NftItem.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    return NftItem(
      id: (json['id'] ?? json['_id'] ?? json['nftId'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? 'NFT').toString(),
      description: (json['description'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ??
              json['image_url'] ??
              json['image'] ??
              json['thumbnailUrl'] ??
              json['thumbnail'])
          ?.toString(),
      thumbnailUrl:
          (json['thumbnailUrl'] ?? json['thumbnail_url'] ?? json['thumbnail'])
              ?.toString(),
      category: category is Map
          ? (category['name'] ?? category['slug'] ?? category['id'])?.toString()
          : category?.toString(),
      nftType: (json['nftType'] ?? json['type'])?.toString(),
      price: _asDouble(json['price']),
      currency: (json['currency'] ?? json['currencyCode'])?.toString(),
      isOwned: (json['isOwned'] ?? json['owned'] ?? false) == true,
      isEarned: (json['isEarned'] ?? json['earned'] ?? false) == true,
      isClaimable: (json['isClaimable'] ?? json['claimable'] ?? false) == true,
      isComingSoon:
          (json['isComingSoon'] ?? json['comingSoon'] ?? false) == true,
      isFree: (json['isFree'] ?? json['free'] ?? false) == true,
      freeUnderRewardTier: json['freeUnderRewardTier']?.toString(),
      totalSupply: _asInt(json['totalSupply']),
      rewardType: json['rewardType']?.toString(),
      rewardTierRequired: json['rewardTierRequired']?.toString(),
      tokenId: (json['tokenId'] ?? json['token_id'])?.toString(),
      tokenStandard: (json['tokenStandard'] ?? json['standard'])?.toString(),
      blockchain: (json['blockchain'] ?? json['chain'])?.toString(),
      contractAddress: json['contractAddress']?.toString(),
      chainId: _asInt(json['chainId']),
      eventId: json['eventId']?.toString(),
      isActive: json['isActive'] as bool?,
      metadata: json['metadata'] is Map
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : const {},
      creator:
          (json['creator'] ?? json['creatorName'] ?? json['owner'])?.toString(),
      raw: json,
    );
  }

  static List<NftItem> listFromResponse(dynamic response) {
    final items = _findNftList(response);
    return items
        .whereType<Map>()
        .map((item) => NftItem.fromJson(item.cast<String, dynamic>()))
        .toList();
  }
}

/// Result of a claim/purchase action. `pendingTransactionBase64` is set when
/// the backend returns an on-chain transaction that still needs a wallet
/// signature (see the "Wallet Signature Required" sheet).
class NftActionResult {
  final bool success;
  final String? message;
  final String? pendingTransactionBase64;
  final Map<String, dynamic> raw;

  const NftActionResult({
    required this.success,
    required this.raw,
    this.message,
    this.pendingTransactionBase64,
  });

  factory NftActionResult.fromJson(Map<String, dynamic> json) {
    return NftActionResult(
      success: json['success'] == true || json['ok'] == true || json.isNotEmpty,
      message: json['message']?.toString(),
      pendingTransactionBase64: (json['transaction'] ??
              json['pendingTransaction'] ??
              json['pendingTransactionBase64'] ??
              json['transactionBase64'] ??
              json['tx'] ??
              json['signTransaction'])
          ?.toString(),
      raw: json,
    );
  }
}

class NftScreenData {
  final List<NftItem> owned;
  final List<NftItem> claimable;
  final List<NftItem> marketplace;
  final List<NftItem> exclusive;
  final Map<String, dynamic> raw;

  const NftScreenData({
    required this.owned,
    required this.claimable,
    required this.marketplace,
    required this.exclusive,
    required this.raw,
  });

  factory NftScreenData.fromJson(Map<String, dynamic> json) {
    return NftScreenData(
      owned: NftItem.listFromResponse(
          json['owned'] ?? json['ownedNfts'] ?? json['myNfts']),
      claimable: NftItem.listFromResponse(
        json['claimable'] ?? json['claimableRewards'] ?? json['rewards'],
      ),
      marketplace: NftItem.listFromResponse(
        json['marketplace'] ??
            json['marketplaceNfts'] ??
            json['featuredMarketplace'],
      ),
      exclusive: NftItem.listFromResponse(
        json['exclusive'] ?? json['exclusiveNfts'] ?? json['exclusiveDrops'],
      ),
      raw: json,
    );
  }
}

class TicketItem {
  const TicketItem({
    required this.id,
    required this.status,
    required this.eventTitle,
    required this.eventDateLabel,
    required this.raw,
  });

  final String id;
  final String status;
  final String eventTitle;
  final String eventDateLabel;
  final Map<String, dynamic> raw;

  factory TicketItem.fromJson(Map<String, dynamic> json) {
    final event = json['event'] is Map
        ? Map<String, dynamic>.from(json['event'] as Map)
        : const <String, dynamic>{};
    return TicketItem(
      id: (json['id'] ?? json['ticketId'] ?? json['ticket_id']).toString(),
      status: (json['status'] ?? '').toString(),
      eventTitle: (event['title'] ??
              json['eventTitle'] ??
              json['event_title'] ??
              'Event ticket')
          .toString(),
      eventDateLabel: (event['startsAt'] ??
              event['starts_at'] ??
              json['startsAt'] ??
              json['starts_at'] ??
              json['createdAt'] ??
              json['created_at'] ??
              '')
          .toString(),
      raw: json,
    );
  }

  static List<TicketItem> listFromResponse(dynamic response) {
    final items = _findTicketList(response);
    return items
        .whereType<Map>()
        .map((item) => TicketItem.fromJson(Map<String, dynamic>.from(item)))
        .where((item) => item.id.isNotEmpty)
        .toList();
  }
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

List<dynamic> _findNftList(dynamic value) {
  if (value is List) return value;
  if (value is! Map) return const [];

  final json = Map<String, dynamic>.from(value);
  for (final key in const [
    'data',
    'nfts',
    'items',
    'results',
    'owned',
    'ownedNfts',
    'myNfts',
    'claimable',
    'claimableRewards',
    'rewards',
    'marketplace',
    'marketplaceNfts',
    'featuredMarketplace',
    'exclusive',
    'exclusiveNfts',
    'exclusiveDrops',
  ]) {
    final candidate = json[key];
    if (candidate is List) return candidate;
    if (candidate is Map) {
      final nested = _findNftList(candidate);
      if (nested.isNotEmpty) return nested;
    }
  }
  return const [];
}

List<dynamic> _findTicketList(dynamic value) {
  if (value is List) return value;
  if (value is! Map) return const [];

  final json = Map<String, dynamic>.from(value);
  for (final key in const ['data', 'tickets', 'items', 'results']) {
    final candidate = json[key];
    if (candidate is List) return candidate;
    if (candidate is Map) {
      final nested = _findTicketList(candidate);
      if (nested.isNotEmpty) return nested;
    }
  }
  return const [];
}
