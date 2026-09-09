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
  final SubscriptionEntitlements entitlements;
  final String? googleProductId;
  final String? googleBasePlanId;
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
    this.entitlements = SubscriptionEntitlements.none,
    this.googleProductId,
    this.googleBasePlanId,
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
      googleBasePlanId:
          (json['googleBasePlanId'] ?? json['playBasePlanId'])?.toString(),
      entitlements: SubscriptionEntitlements.fromJson(
        json['entitlements'] is Map
            ? (json['entitlements'] as Map).cast<String, dynamic>()
            : null,
      ),
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
  final String? tierId;
  final String? tierName;
  final String? currentPeriodEnd;
  final bool cancelAtPeriodEnd;

  /// Fallback only: the live API embeds a partial entitlements subset here
  /// (observed: eventsPerMonth/exclusiveEvents/priorityMatching, missing
  /// adFree/unlimitedLocationChange/freeGuestInvite even when the tier
  /// grants them). [ProfileCubit.entitlements] prefers matching [tierId]/
  /// [tierName] against the fetched tier list, and only falls back to this
  /// when no tier match is found.
  final SubscriptionEntitlements? entitlements;
  final Map<String, dynamic> raw;

  const SubscriptionStatus({
    required this.isActive,
    required this.cancelAtPeriodEnd,
    required this.raw,
    this.status,
    this.tierId,
    this.tierName,
    this.currentPeriodEnd,
    this.entitlements,
  });

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      isActive: (json['isActive'] ??
              json['active'] ??
              json['hasActiveSubscription'] ??
              json['status']?.toString().toUpperCase() == 'ACTIVE') ==
          true,
      status: json['status']?.toString(),
      // Live API calls the tier slug "tier" (e.g. "basic") and the display
      // name "planName" (e.g. "Basic") — tierId/tierName kept as fallbacks
      // in case the shape changes.
      tierId: (json['tierId'] ?? json['planId'] ?? json['tier'])?.toString(),
      tierName:
          (json['planName'] ?? json['tierName'] ?? json['plan'] ?? json['tier'])
              ?.toString(),
      currentPeriodEnd:
          (json['currentPeriodEnd'] ?? json['expiresAt'] ?? json['periodEnd'])
              ?.toString(),
      cancelAtPeriodEnd: (json['cancelAtPeriodEnd'] ?? false) == true,
      entitlements: json['entitlements'] is Map
          ? SubscriptionEntitlements.fromJson(
              (json['entitlements'] as Map).cast<String, dynamic>())
          : null,
      raw: json,
    );
  }

  /// Whether [tier] is the plan this status refers to — matches [tierId]
  /// first (falling back to [tierName]) against the tier's own `id`/`name`,
  /// case-insensitively. The two APIs don't share a key format (the status
  /// endpoint has been observed returning a slug like "basic" where the
  /// tiers endpoint's `id` is a UUID and `name` is "Basic Plan"), so this
  /// checks both tier fields rather than assuming one will match.
  bool matchesTier(SubscriptionTier tier) {
    final key = (tierId ?? tierName)?.trim().toLowerCase();
    if (key == null || key.isEmpty) return false;
    return tier.id.toLowerCase() == key ||
        tier.name.trim().toLowerCase() == key;
  }
}

/// Perks unlocked by a subscription tier. Fields default to the "no
/// subscription" baseline, so an unsubscribed user's effective entitlements
/// are just [SubscriptionEntitlements.none].
class SubscriptionEntitlements {
  final int? eventsPerMonth;
  final bool priorityMatching;
  final bool exclusiveEvents;
  final bool adFree;
  final bool unlimitedLocationChange;
  final String? freeGuestInvite;

  const SubscriptionEntitlements({
    this.eventsPerMonth,
    this.priorityMatching = false,
    this.exclusiveEvents = false,
    this.adFree = false,
    this.unlimitedLocationChange = false,
    this.freeGuestInvite,
  });

  static const none = SubscriptionEntitlements();

  bool get hasUnlimitedEvents => eventsPerMonth == null || eventsPerMonth! < 0;

  factory SubscriptionEntitlements.fromJson(Map<String, dynamic>? json) {
    if (json == null) return none;
    return SubscriptionEntitlements(
      eventsPerMonth: _asInt(json['eventsPerMonth']),
      priorityMatching: json['priorityMatching'] == true,
      exclusiveEvents: json['exclusiveEvents'] == true,
      adFree: json['adFree'] == true,
      unlimitedLocationChange: json['unlimitedLocationChange'] == true,
      freeGuestInvite: json['freeGuestInvite']?.toString(),
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
  final String? eventId;
  final String? nftId;
  final String? discountCode;
  final String? rewardDiscountId;
  final bool useStoreCredit;

  /// Exactly one of [eventId]/[nftId] must be set — [eventId] for a guest
  /// ticket purchase, [nftId] for the PayPal NFT checkout variant.
  const CreateEventPaymentRequest({
    this.eventId,
    this.nftId,
    this.discountCode,
    this.rewardDiscountId,
    this.useStoreCredit = false,
  }) : assert(
          (eventId == null) != (nftId == null),
          'Exactly one of eventId/nftId must be set.',
        );

  Map<String, dynamic> toJson() => {
        if (eventId != null) 'eventId': eventId,
        if (nftId != null) 'nftId': nftId,
        if (discountCode != null && discountCode!.isNotEmpty)
          'discountCode': discountCode,
        if (rewardDiscountId != null && rewardDiscountId!.isNotEmpty)
          'rewardDiscountId': rewardDiscountId,
        if (useStoreCredit) 'useStoreCredit': useStoreCredit,
      };
}

/// `GET /store-credit` balance — spendable credit toward event tickets and
/// NFTs (excluded from subscriptions and from buying store credit itself).
/// A user with no credit gets `amount: 0`, not a 404, but a 404 is still
/// treated as zero by [Web3Repo.getStoreCreditBalance] for callers that hit
/// an account created before this endpoint existed.
class StoreCreditBalance {
  final double amount;
  final int amountMinor;
  final String currency;
  final String? expiresAt;
  final Map<String, dynamic> raw;

  const StoreCreditBalance({
    required this.amount,
    required this.amountMinor,
    required this.currency,
    required this.raw,
    this.expiresAt,
  });

  static const zero = StoreCreditBalance(
    amount: 0,
    amountMinor: 0,
    currency: 'EUR',
    raw: {},
  );

  bool get hasCredit => amountMinor > 0;

  DateTime? get expiryDate => DateTime.tryParse(expiresAt ?? '');

  factory StoreCreditBalance.fromJson(Map<String, dynamic> json) {
    final minor = json['amountMinor'];
    return StoreCreditBalance(
      amount: _asDouble(json['amount']) ??
          (minor is num ? minor.toDouble() / 100 : 0),
      amountMinor: minor is num ? minor.toInt() : 0,
      currency: (json['currency'] ?? 'EUR').toString(),
      expiresAt: json['expiresAt']?.toString(),
      raw: json,
    );
  }
}

/// One row of the append-only store-credit ledger returned by
/// `GET /store-credit/history` (type: GRANT/PURCHASE/SPEND/REFUND/EXPIRY).
class StoreCreditHistoryItem {
  final String? type;
  final double amount;
  final String? status;
  final String? reference;
  final String? createdAt;
  final Map<String, dynamic> raw;

  const StoreCreditHistoryItem({
    required this.amount,
    required this.raw,
    this.type,
    this.status,
    this.reference,
    this.createdAt,
  });

  factory StoreCreditHistoryItem.fromJson(Map<String, dynamic> json) {
    final minor = json['amountMinor'];
    return StoreCreditHistoryItem(
      type: json['type']?.toString(),
      amount: _asDouble(json['amount']) ??
          (minor is num ? minor.toDouble() / 100 : 0),
      status: json['status']?.toString(),
      reference: json['reference']?.toString(),
      createdAt: (json['createdAt'] ?? json['date'])?.toString(),
      raw: json,
    );
  }
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

/// `GET /payments/paypal/connect/status` — the live escrow-account link
/// status, e.g. `{ connected: false }` or
/// `{ connected: true, paypalPayerId: "...", paypalEmail: "..." }`.
class PayPalConnectStatus {
  final bool connected;
  final String? paypalPayerId;
  final String? paypalEmail;

  const PayPalConnectStatus({
    required this.connected,
    this.paypalPayerId,
    this.paypalEmail,
  });

  static const disconnected = PayPalConnectStatus(connected: false);

  factory PayPalConnectStatus.fromJson(Map<String, dynamic> json) {
    return PayPalConnectStatus(
      connected: json['connected'] == true,
      paypalPayerId: json['paypalPayerId']?.toString(),
      paypalEmail: json['paypalEmail']?.toString(),
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

class SavedCard {
  final String id;
  final String? last4;
  final String? brand;
  final String? expMonth;
  final String? expYear;
  final bool? isDefault;
  final Map<String, dynamic> raw;

  const SavedCard({
    required this.id,
    required this.raw,
    this.last4,
    this.brand,
    this.expMonth,
    this.expYear,
    this.isDefault,
  });

  factory SavedCard.fromJson(Map<String, dynamic> json) {
    return SavedCard(
      id: (json['id'] ?? '').toString(),
      last4: (json['last4'] ?? json['last_4'])?.toString(),
      brand: json['brand']?.toString(),
      expMonth: (json['expMonth'] ?? json['exp_month'])?.toString(),
      expYear: (json['expYear'] ?? json['exp_year'])?.toString(),
      isDefault: (json['isDefault'] ?? json['is_default']) as bool?,
      raw: json,
    );
  }

  static List<SavedCard> listFromResponse(dynamic response) {
    final list = response is List
        ? response
        : response is Map
            ? (response['cards'] ??
                response['items'] ??
                response['data'] ??
                const [])
            : const [];
    if (list is! List) return const [];
    return list
        .whereType<Map>()
        .map((e) => SavedCard.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

class EscrowStatus {
  final String? status;
  final Map<String, dynamic> raw;

  const EscrowStatus({required this.raw, this.status});

  factory EscrowStatus.fromJson(Map<String, dynamic> json) {
    return EscrowStatus(status: json['status']?.toString(), raw: json);
  }
}

class NftItem {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? thumbnailUrl;
  final String? animationUrl;
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
    this.animationUrl,
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
      animationUrl:
          (json['animationUrl'] ?? json['animation_url'])?.toString(),
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

  /// Round-trips via [raw] — the JSON this item was decoded from — rather
  /// than reconstructing from the modeled fields, so caching it (e.g. as
  /// part of a cached [UserModel.featuredNft]) doesn't silently drop
  /// anything the model doesn't expose a field for.
  Map<String, dynamic> toJson() => raw;

  /// Whether [animationUrl] is a real video file the video player can
  /// decode (mp4/mov) rather than an animated image (gif/webp) — the video
  /// player can't decode gif, so those must go through the image loader
  /// instead.
  bool get animationIsVideo {
    // Strip query/fragment first — a real .mp4 served from a signed CDN
    // URL (e.g. "...clip.mp4?token=...") doesn't *end* with .mp4, so the
    // old check misrouted it to the image loader, which can't decode
    // video and just hangs "loading" forever instead of showing anything.
    final url = (animationUrl ?? '').toLowerCase().split('?').first.split('#').first;
    return url.endsWith('.mp4') || url.endsWith('.mov');
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
