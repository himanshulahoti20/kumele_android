class MonthlyStats {
  const MonthlyStats({
    required this.year,
    required this.months,
  });

  final int year;
  final List<MonthlyStatMonth> months;

  factory MonthlyStats.fromJson(Map<String, dynamic> json) {
    final monthsJson = json['months'];
    return MonthlyStats(
      year: _asInt(json['year']) ?? DateTime.now().year,
      months: monthsJson is List
          ? monthsJson
              .whereType<Map>()
              .map((item) =>
                  MonthlyStatMonth.fromJson(item.cast<String, dynamic>()))
              .toList()
          : const [],
    );
  }

  num get totalMoneyEarned {
    return months.fold<num>(0, (sum, month) => sum + month.value);
  }
}

class MonthlyStatMonth {
  const MonthlyStatMonth({
    required this.label,
    required this.value,
    this.events = const [],
  });

  final String label;
  final num value;
  final List<MonthlyStatEvent> events;

  factory MonthlyStatMonth.fromJson(Map<String, dynamic> json) {
    final eventsJson = json['events'];
    return MonthlyStatMonth(
      label: (json['label'] ?? json['month'] ?? '').toString(),
      value: _asNum(
        json['value'] ?? json['totalSpendEur'] ?? json['total_spend_eur'],
      ),
      events: eventsJson is List
          ? eventsJson
              .whereType<Map>()
              .map((item) =>
                  MonthlyStatEvent.fromJson(item.cast<String, dynamic>()))
              .toList()
          : const [],
    );
  }
}

class MonthlyStatEvent {
  const MonthlyStatEvent({
    required this.title,
    required this.category,
    required this.value,
    this.icon,
  });

  final String title;
  final String category;
  final num value;
  final String? icon;

  factory MonthlyStatEvent.fromJson(Map<String, dynamic> json) {
    return MonthlyStatEvent(
      title: (json['title'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      value: _asNum(json['price'] ?? json['value']),
      icon: json['icon']?.toString(),
    );
  }
}

class RewardStatus {
  const RewardStatus({
    required this.gold,
    required this.silver,
    required this.bronze,
  });

  final int gold;
  final int silver;
  final int bronze;

  factory RewardStatus.fromJson(Map<String, dynamic> json) {
    // Current live shape: a `badges` array of one entry per tier the user
    // has ever earned (`{"tier": "GOLD", "earnedAt": "..."}`), not a
    // pre-aggregated count — this was rendering "Achieved 0 medals" for
    // every tier regardless of real badges, since neither `medalCounts` nor
    // flat gold/silver/bronze fields exist in that response.
    final badges = json['badges'];
    if (badges is List && badges.isNotEmpty) {
      var gold = 0, silver = 0, bronze = 0;
      for (final badge in badges) {
        if (badge is! Map) continue;
        switch (badge['tier']?.toString().toUpperCase()) {
          case 'GOLD':
            gold++;
          case 'SILVER':
            silver++;
          case 'BRONZE':
            bronze++;
        }
      }
      return RewardStatus(gold: gold, silver: silver, bronze: bronze);
    }

    final medalCounts = json['medalCounts'] as Map<String, dynamic>?;
    return RewardStatus(
      gold: _asInt(medalCounts?['GOLD'] ?? json['gold']) ?? 0,
      silver: _asInt(medalCounts?['SILVER'] ?? json['silver']) ?? 0,
      bronze: _asInt(medalCounts?['BRONZE'] ?? json['bronze']) ?? 0,
    );
  }
}

/// `GET /users/me/stats` — consolidated activity stats for the current
/// user. `hostRating.average` is the fallback for
/// [ExploreHostProfile.overallHostRating] while that host-profile fetch is
/// still loading (there's no completion-rate equivalent here).
/// `eventsAttended` (`events.attended`) mirrors the iOS reference's
/// `userStats.events.attended` — powers the "N guests" chip in the NFT
/// preview overlay. Null if the backend omits the field; that hides the
/// chip rather than showing "0 guests" (matches iOS, which only shows it
/// when a count is available).
class UserActivityStats {
  const UserActivityStats({this.hostRatingAverage, this.eventsAttended});

  final double? hostRatingAverage;
  final int? eventsAttended;

  factory UserActivityStats.fromJson(Map<String, dynamic> json) {
    final hostRating = json['hostRating'];
    final events = json['events'];
    return UserActivityStats(
      hostRatingAverage: hostRating is Map
          ? _asDouble(hostRating['average'])
          : null,
      eventsAttended: events is Map ? _asInt(events['attended']) : null,
    );
  }
}

double? _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '');
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

num _asNum(dynamic value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}
