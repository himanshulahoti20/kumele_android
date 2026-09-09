import 'package:kuemele/shared/components/rating.dart';

/// A single written review from `GET /events/{id}/ratings`.
class EventReview {
  const EventReview({
    required this.id,
    required this.reviewerName,
    this.reviewerAvatar,
    this.dateLabel,
    this.comment = '',
  });

  final String id;
  final String reviewerName;
  final String? reviewerAvatar;
  final String? dateLabel;
  final String comment;

  factory EventReview.fromJson(Map<String, dynamic> json) {
    final reviewer = json['user'] ?? json['reviewer'] ?? json['guest'];
    final reviewerMap = reviewer is Map ? reviewer : const {};

    return EventReview(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      reviewerName: _firstNonEmpty([
            json['reviewerName'],
            json['userName'],
            json['user_name'],
            reviewerMap['fullname'],
            reviewerMap['name'],
            reviewerMap['displayName'],
          ]) ??
          'Guest',
      reviewerAvatar: _firstNonEmpty([
        json['reviewerAvatar'],
        json['avatar'],
        reviewerMap['avatar'],
        reviewerMap['profilePicture'],
      ]),
      dateLabel: _firstNonEmpty([
        json['createdAt'],
        json['created_at'],
        json['date'],
      ]),
      comment: _firstNonEmpty([json['comment'], json['review']]) ?? '',
    );
  }

  static String? _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty) return text;
    }
    return null;
  }
}

/// Parses `GET /events/{id}/ratings/summary` into the per-category map
/// `RARatingSummary` expects. The backend's exact field names for this
/// "advanced summary" endpoint aren't documented, so this tries every
/// naming convention the same categories appear under elsewhere in this
/// API (`EventsRepo.rateEvent`'s submit body uses these exact camelCase
/// keys), plus a couple of likely nesting spots.
Map<RatingType, double> parseRatingBreakdown(Map<String, dynamic>? summary) {
  if (summary == null) return const {};

  final nested = summary['averages'] ?? summary['subRatings'] ?? summary['breakdown'];
  final source = nested is Map ? Map<String, dynamic>.from(nested) : summary;

  double? read(List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value is num) return value.toDouble();
      final parsed = double.tryParse(value?.toString() ?? '');
      if (parsed != null) return parsed;
    }
    return null;
  }

  final result = <RatingType, double>{};
  final communication = read(['communication']);
  if (communication != null) result[RatingType.communication] = communication;
  final respect = read(['respect']);
  if (respect != null) result[RatingType.respect] = respect;
  final professionalism = read(['professionalism', 'professional']);
  if (professionalism != null) result[RatingType.professional] = professionalism;
  final atmosphere = read(['atmosphere']);
  if (atmosphere != null) result[RatingType.atmosphere] = atmosphere;
  final valueForMoney = read(['valueForMoney', 'value_for_money', 'value']);
  if (valueForMoney != null) result[RatingType.value] = valueForMoney;
  return result;
}
