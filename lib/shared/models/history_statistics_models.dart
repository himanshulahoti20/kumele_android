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
    return RewardStatus(
      gold: _asInt(json['gold']) ?? 0,
      silver: _asInt(json['silver']) ?? 0,
      bronze: _asInt(json['bronze']) ?? 0,
    );
  }
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
