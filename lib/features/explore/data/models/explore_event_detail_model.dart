import 'package:kuemele/features/explore/data/models/explore_event_rules_model.dart';
import 'package:kuemele/features/explore/data/models/explore_host_profile_model.dart';
import 'package:kuemele/features/explore/data/models/explore_location_details_model.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';

class ExploreEventDetailModel {
  const ExploreEventDetailModel({
    required this.eventId,
    required this.title,
    required this.description,
    required this.hostProfile,
    required this.locationDetails,
    required this.attendeeCount,
    required this.eventImages,
    this.coverImage,
    required this.startsAt,
    this.endsAt,
    required this.capacity,
    required this.spotsRemaining,
    required this.isPaid,
    required this.price,
    required this.currency,
    required this.hobbyNames,
    this.categoryIcon,
    this.averageEventRating,
    this.averageHostRating,
    required this.totalRatings,
    this.eventRules = const ExploreEventRulesModel(),
    this.chatEnabled = true,
    this.status = 'ACTIVE',
  });

  final String eventId;
  final String title;
  final String description;
  final ExploreHostProfileModel hostProfile;
  final ExploreLocationDetailsModel locationDetails;
  final int attendeeCount;
  final List<String> eventImages;
  final String? coverImage;
  final DateTime startsAt;
  final DateTime? endsAt;
  final int capacity;
  final int spotsRemaining;
  final bool isPaid;
  final String price;
  final String currency;
  final List<String> hobbyNames;
  final String? categoryIcon;
  final double? averageEventRating;
  final double? averageHostRating;
  final int totalRatings;
  final ExploreEventRulesModel eventRules;
  final bool chatEnabled;
  final String status;

  factory ExploreEventDetailModel.fromJson(Map<String, dynamic> json) {
    return ExploreEventDetailModel(
      eventId:
          (json['eventId'] ?? json['event_id'] ?? json['id'])?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      hostProfile: ExploreHostProfileModel.fromJson(
        _asMap(json['hostProfile'] ?? json['host_profile'] ?? json['host']),
      ),
      locationDetails: ExploreLocationDetailsModel.fromJson(
        _asMap(json['locationDetails'] ?? json['location_details'] ?? json),
      ),
      attendeeCount: _parseInt(json['attendeeCount'] ?? json['attendee_count']),
      eventImages:
          ((json['eventImages'] ?? json['event_images']) as List<dynamic>? ??
                  [])
              .map((image) => image.toString())
              .toList(),
      coverImage: (json['coverImage'] ?? json['cover_image'])?.toString(),
      startsAt: DateTime.tryParse(
            (json['startsAt'] ?? json['starts_at'] ?? '').toString(),
          ) ??
          DateTime.now(),
      endsAt: _parseDateTime(json['endsAt'] ?? json['ends_at']),
      capacity: _parseInt(json['capacity']),
      spotsRemaining:
          _parseInt(json['spotsRemaining'] ?? json['spots_remaining']),
      isPaid: _parseBool(json['isPaid'] ?? json['is_paid']),
      price: json['price']?.toString() ?? '0',
      currency: json['currency']?.toString() ?? 'EUR',
      hobbyNames: _parseHobbyNames(json['hobbies']),
      categoryIcon: _parseCategoryIcon(json['hobbies']),
      averageEventRating: _parseDouble(
        json['averageEventRating'] ?? json['average_event_rating'],
      ),
      averageHostRating: _parseDouble(
        json['averageHostRating'] ?? json['average_host_rating'],
      ),
      totalRatings: _parseInt(json['totalRatings'] ?? json['total_ratings']),
      eventRules: ExploreEventRulesModel.fromJson(
        _asMap(json['eventRules'] ?? json['event_rules']),
      ),
      chatEnabled: _parseBool(
        json['chatEnabled'] ?? json['chat_enabled'],
        fallback: true,
      ),
      status: json['status']?.toString() ?? 'ACTIVE',
    );
  }

  ExploreEventDetail toEntity() {
    return ExploreEventDetail(
      id: eventId,
      title: title,
      description: description,
      hostProfile: hostProfile.toEntity(),
      locationDetails: locationDetails.toEntity(),
      attendeeCount: attendeeCount,
      eventImages: eventImages,
      coverImage: coverImage,
      startsAt: startsAt,
      endsAt: endsAt,
      capacity: capacity,
      spotsRemaining: spotsRemaining,
      isPaid: isPaid,
      price: price,
      currency: currency,
      hobbyNames: hobbyNames,
      categoryIcon: categoryIcon,
      averageEventRating: averageEventRating,
      averageHostRating: averageHostRating,
      totalRatings: totalRatings,
      eventRules: eventRules.toEntity(),
      chatEnabled: chatEnabled,
      status: status,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _parseBool(dynamic value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return fallback;
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const {};
  }

  static List<String> _parseHobbyNames(dynamic hobbies) {
    if (hobbies is! List) return const [];

    return hobbies
        .map((item) {
          if (item is! Map<String, dynamic>) return null;
          final hobby = item['hobby'];
          if (hobby is Map<String, dynamic>) {
            return hobby['name'] as String?;
          }
          return item['name'] as String?;
        })
        .whereType<String>()
        .where((name) => name.isNotEmpty)
        .toList();
  }

  static String? _parseCategoryIcon(dynamic hobbies) {
    if (hobbies is! List || hobbies.isEmpty) return null;
    final firstItem = hobbies.first;
    if (firstItem is! Map<String, dynamic>) return null;
    final hobby = firstItem['hobby'];
    if (hobby is! Map<String, dynamic>) return null;
    final category = hobby['category'];
    if (category is! Map<String, dynamic>) return null;
    return category['icon'] as String?;
  }
}
