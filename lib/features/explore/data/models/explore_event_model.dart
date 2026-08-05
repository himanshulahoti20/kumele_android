import 'package:kuemele/features/explore/data/models/explore_location_details_model.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event.dart';
import 'package:kuemele/shared/utils/conversion_utils.dart';

class ExploreEventModel {
  const ExploreEventModel({
    required this.eventId,
    required this.title,
    this.hobbyKey,
    required this.eventDate,
    required this.startsAt,
    this.endsAt,
    required this.hostId,
    required this.hostName,
    this.hostAvatar,
    this.eventImageUrl,
    this.status,
    required this.locationDetails,
    required this.spotsRemaining,
    required this.isPaid,
    required this.price,
    required this.currency,
  });

  final String eventId;
  final String title;
  final String? hobbyKey;
  final DateTime eventDate;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String hostId;
  final String hostName;
  final String? hostAvatar;
  final String? eventImageUrl;
  final String? status;
  final ExploreLocationDetailsModel locationDetails;
  final int spotsRemaining;
  final bool isPaid;
  final String price;
  final String currency;

  factory ExploreEventModel.fromJson(Map<String, dynamic> json) {
    final eventDateRaw =
        (json['event_date'] ?? json['starts_at'] ?? '').toString();
    final startsAtRaw =
        (json['starts_at'] ?? json['event_date'] ?? '').toString();

    return ExploreEventModel(
      eventId: json['event_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      hobbyKey: json['hobby_key']?.toString(),
      eventDate: DateTime.tryParse(eventDateRaw) ?? DateTime.now(),
      startsAt: DateTime.tryParse(startsAtRaw) ??
          DateTime.tryParse(eventDateRaw) ??
          DateTime.now(),
      endsAt: ConversionUtils.parseDateTime(json['ends_at']),
      hostId: json['host_id']?.toString() ?? '',
      hostName: json['host_name']?.toString() ?? '',
      hostAvatar: json['host_avatar']?.toString(),
      eventImageUrl: json['event_image_url']?.toString(),
      status: json['status']?.toString(),
      locationDetails: ExploreLocationDetailsModel.fromJson(
        _asMap(json['location_details']),
      ),
      spotsRemaining: ConversionUtils.parseInt(json['spots_remaining']),
      isPaid: json['is_paid'] == true,
      price: json['price']?.toString() ?? '0',
      currency: json['currency']?.toString() ?? 'EUR',
    );
  }

  ExploreEvent toEntity() {
    return ExploreEvent(
      id: eventId,
      title: title,
      hobbyKey: hobbyKey,
      eventDate: eventDate,
      startsAt: startsAt,
      endsAt: endsAt,
      hostId: hostId,
      hostName: hostName,
      hostAvatar: hostAvatar,
      eventImageUrl: eventImageUrl,
      status: status,
      locationDetails: locationDetails.toEntity(),
      spotsRemaining: spotsRemaining,
      isPaid: isPaid,
      price: price,
      currency: currency,
    );
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}
