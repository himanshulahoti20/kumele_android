class AimlModerationResult {
  const AimlModerationResult({
    required this.decision,
    required this.labels,
    required this.confidence,
  });

  factory AimlModerationResult.fromJson(Map<dynamic, dynamic> json) {
    return AimlModerationResult(
      decision: json['decision']?.toString() ?? 'allow',
      labels: (json['labels'] as List? ?? const [])
          .map((value) => value.toString())
          .toList(),
      confidence: _toDouble(json['confidence']),
    );
  }

  final String decision;
  final List<String> labels;
  final double confidence;

  bool get needsReview => decision.toLowerCase() == 'review';
}

class AimlAttendancePrediction {
  const AimlAttendancePrediction({
    required this.predictedAttendance,
    required this.confidence,
    this.low,
    this.high,
  });

  factory AimlAttendancePrediction.fromJson(Map<dynamic, dynamic> json) {
    final interval = json['confidence_interval'];
    return AimlAttendancePrediction(
      predictedAttendance: _toInt(json['predicted_attendance']),
      confidence: _toDouble(json['confidence']),
      low: interval is Map ? _toInt(interval['low']) : null,
      high: interval is Map ? _toInt(interval['high']) : null,
    );
  }

  final int predictedAttendance;
  final double confidence;
  final int? low;
  final int? high;

  String get label {
    final range = low != null && high != null ? ' ($low-$high)' : '';
    return '$predictedAttendance guests$range';
  }
}

class AimlPricingAdvice {
  const AimlPricingAdvice({
    required this.optimalTier,
    required this.predictedRevenue,
    required this.confidence,
    required this.recommendedPrices,
  });

  factory AimlPricingAdvice.fromJson(Map<dynamic, dynamic> json) {
    return AimlPricingAdvice(
      optimalTier: json['optimal_tier']?.toString() ?? '',
      predictedRevenue: _toInt(json['predicted_revenue']),
      confidence: _toDouble(json['confidence']),
      recommendedPrices: (json['recommended_prices'] as List? ?? const [])
          .whereType<Map>()
          .map(AimlRecommendedPrice.fromJson)
          .toList(),
    );
  }

  final String optimalTier;
  final int predictedRevenue;
  final double confidence;
  final List<AimlRecommendedPrice> recommendedPrices;

  String get label {
    AimlRecommendedPrice? tier;
    for (final price in recommendedPrices) {
      if (price.tier == optimalTier) {
        tier = price;
        break;
      }
    }
    final price = tier == null ? '' : ' at ${tier.price}';
    return '$optimalTier$price';
  }
}

class AimlRecommendedPrice {
  const AimlRecommendedPrice({
    required this.tier,
    required this.price,
    required this.expectedAttendance,
  });

  factory AimlRecommendedPrice.fromJson(Map<dynamic, dynamic> json) {
    return AimlRecommendedPrice(
      tier: json['tier']?.toString() ?? '',
      price: _toInt(json['price']),
      expectedAttendance: _toInt(json['expected_attendance']),
    );
  }

  final String tier;
  final int price;
  final int expectedAttendance;
}

class AimlRewardsSuggestion {
  const AimlRewardsSuggestion({
    required this.nextStatusTarget,
    required this.nextCriteria,
    required this.availableDiscounts,
  });

  factory AimlRewardsSuggestion.fromJson(Map<dynamic, dynamic> json) {
    final progress = json['progress'];
    return AimlRewardsSuggestion(
      nextStatusTarget: progress is Map
          ? progress['next_status_target']?.toString() ?? ''
          : '',
      nextCriteria:
          progress is Map ? progress['next_criteria']?.toString() ?? '' : '',
      availableDiscounts: (json['available_discounts'] as List? ?? const [])
          .whereType<Map>()
          .map(AimlAvailableDiscount.fromJson)
          .toList(),
    );
  }

  final String nextStatusTarget;
  final String nextCriteria;
  final List<AimlAvailableDiscount> availableDiscounts;

  String get label {
    if (availableDiscounts.isNotEmpty) {
      final discount = availableDiscounts.first;
      return '${discount.discountValue} ${discount.statusLevel} reward available';
    }
    if (nextCriteria.isNotEmpty) return nextCriteria;
    if (nextStatusTarget.isNotEmpty) return 'Next target: $nextStatusTarget';
    return '';
  }
}

class AimlAvailableDiscount {
  const AimlAvailableDiscount({
    required this.discountValue,
    required this.statusLevel,
  });

  factory AimlAvailableDiscount.fromJson(Map<dynamic, dynamic> json) {
    return AimlAvailableDiscount(
      discountValue: json['discount_value']?.toString() ?? '',
      statusLevel: json['status_level']?.toString() ?? '',
    );
  }

  final String discountValue;
  final String statusLevel;
}

class AimlHobbyRecommendation {
  const AimlHobbyRecommendation({required this.hobby, required this.score});

  factory AimlHobbyRecommendation.fromJson(Map<dynamic, dynamic> json) {
    return AimlHobbyRecommendation(
      hobby: json['hobby']?.toString() ?? '',
      score: _toDouble(json['score']),
    );
  }

  final String hobby;
  final double score;
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.round();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
