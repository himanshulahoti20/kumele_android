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
    final eventDateRaw = (json['eventDate'] ??
            json['event_date'] ??
            json['startsAt'] ??
            json['starts_at'] ??
            '')
        .toString();
    final startsAtRaw = (json['startsAt'] ??
            json['starts_at'] ??
            json['eventDate'] ??
            json['event_date'] ??
            '')
        .toString();

    return ExploreEventModel(
      eventId:
          (json['eventId'] ?? json['event_id'] ?? json['id'])?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      hobbyKey: (json['hobbyKey'] ?? json['hobby_key'])?.toString(),
      eventDate: DateTime.tryParse(eventDateRaw) ?? DateTime.now(),
      startsAt: DateTime.tryParse(startsAtRaw) ??
          DateTime.tryParse(eventDateRaw) ??
          DateTime.now(),
      endsAt: ConversionUtils.parseDateTime(json['endsAt'] ?? json['ends_at']),
      hostId: (json['hostId'] ?? json['host_id'])?.toString() ?? '',
      hostName: (json['hostName'] ?? json['host_name'])?.toString() ?? '',
      hostAvatar: (json['hostAvatar'] ?? json['host_avatar'])?.toString(),
      eventImageUrl: _parseImageUrl(json),
      status: json['status']?.toString(),
      locationDetails: ExploreLocationDetailsModel.fromJson(
        _asMap(json['locationDetails'] ?? json['location_details'] ?? json),
      ),
      spotsRemaining: ConversionUtils.parseInt(
        json['spotsRemaining'] ?? json['spots_remaining'],
      ),
      isPaid: json['isPaid'] == true || json['is_paid'] == true,
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

  /// Backend alias priority: cover_image -> event_images[0] -> event_image_url -> image.
  static String? _parseImageUrl(Map<String, dynamic> json) {
    final coverImage = (json['coverImage'] ?? json['cover_image'])?.toString();
    if (coverImage != null && coverImage.isNotEmpty) return coverImage;

    final images = json['eventImages'] ?? json['event_images'];
    if (images is List && images.isNotEmpty) {
      final first = images.first?.toString();
      if (first != null && first.isNotEmpty) return first;
    }

    final eventImageUrl =
        (json['eventImageUrl'] ?? json['event_image_url'])?.toString();
    if (eventImageUrl != null && eventImageUrl.isNotEmpty) return eventImageUrl;

    final image = json['image']?.toString();
    if (image != null && image.isNotEmpty) return image;

    return null;
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}
