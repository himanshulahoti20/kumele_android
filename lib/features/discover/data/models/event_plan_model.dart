class EventPlanModel {
  const EventPlanModel({
    required this.minGuests,
    required this.maxGuests,
    required this.priceEur,
    required this.currency,
    this.listPriceEur,
    this.includedInSubscription = false,
    this.entitlementSource,
  });

  final int minGuests;
  final int maxGuests;
  final num priceEur;
  final String currency;

  /// Standard price before any entitlement is applied. Null when the
  /// backend doesn't send one (falls back to [priceEur] for display).
  final num? listPriceEur;

  /// Whether this tier is currently free/discounted because of the
  /// signed-in user's subscription (one-time-free-per-period benefit).
  final bool includedInSubscription;

  /// Where the entitlement came from (e.g. subscription vs a past
  /// purchase), when [includedInSubscription] is true.
  final String? entitlementSource;

  factory EventPlanModel.fromJson(Map<String, dynamic> json) {
    return EventPlanModel(
      minGuests: _asInt(json['minGuests'] ?? json['min_guests'] ?? json['min']),
      maxGuests: _asInt(json['maxGuests'] ?? json['max_guests'] ?? json['max']),
      priceEur: _asNum(json['priceEur'] ?? json['price_eur'] ?? json['price']),
      currency: (json['currency'] ?? 'EUR').toString(),
      listPriceEur: _asNullableNum(
        json['listPriceEur'] ?? json['list_price_eur'],
      ),
      includedInSubscription: json['includedInSubscription'] == true ||
          json['included_in_subscription'] == true,
      entitlementSource:
          (json['entitlementSource'] ?? json['entitlement_source'])
              ?.toString(),
    );
  }

  String get guestRangeLabel => '$minGuests-$maxGuests guests';

  String get priceLabel {
    if (priceEur == 0) return 'Free';
    final symbol = currency.toUpperCase() == 'EUR' ? '€' : '$currency ';
    return '$symbol${priceEur.toStringAsFixed(priceEur % 1 == 0 ? 0 : 2)}';
  }

  /// The struck-through original price, shown alongside [priceLabel] only
  /// when a real discount/entitlement is in effect.
  String? get listPriceLabel {
    final list = listPriceEur;
    if (list == null || list == priceEur) return null;
    final symbol = currency.toUpperCase() == 'EUR' ? '€' : '$currency ';
    return '$symbol${list.toStringAsFixed(list % 1 == 0 ? 0 : 2)}';
  }
}

class EventPlanQuoteModel {
  const EventPlanQuoteModel({
    required this.requiresPayment,
    required this.priceEur,
    required this.currency,
    this.listPriceEur,
    this.includedInSubscription = false,
    this.entitlementSource,
  });

  final bool requiresPayment;
  final num priceEur;
  final String currency;
  final num? listPriceEur;
  final bool includedInSubscription;
  final String? entitlementSource;

  factory EventPlanQuoteModel.fromJson(Map<String, dynamic> json) {
    return EventPlanQuoteModel(
      requiresPayment: json['requiresPayment'] == true ||
          json['requires_payment'] == true,
      priceEur: _asNum(json['priceEur'] ?? json['price_eur'] ?? json['price']),
      currency: (json['currency'] ?? 'EUR').toString(),
      listPriceEur: _asNullableNum(
        json['listPriceEur'] ?? json['list_price_eur'],
      ),
      includedInSubscription: json['includedInSubscription'] == true ||
          json['included_in_subscription'] == true,
      entitlementSource:
          (json['entitlementSource'] ?? json['entitlement_source'])
              ?.toString(),
    );
  }

  String get label {
    if (!requiresPayment || priceEur == 0) return 'Current price: Free';
    final symbol = currency.toUpperCase() == 'EUR' ? '€' : '$currency ';
    return 'Current price: $symbol${priceEur.toStringAsFixed(priceEur % 1 == 0 ? 0 : 2)}';
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

num _asNum(dynamic value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}

num? _asNullableNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  return num.tryParse(value.toString());
}
