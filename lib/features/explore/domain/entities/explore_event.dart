import 'package:kuemele/features/explore/domain/entities/explore_location_details.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/utils/conversion_utils.dart';

class ExploreEvent {
  const ExploreEvent({
    required this.id,
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
    this.minAge,
    this.maxAge,
  });

  final String id;
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
  final ExploreLocationDetails locationDetails;
  final int spotsRemaining;
  final bool isPaid;
  final String price;
  final String currency;
  final int? minAge;
  final int? maxAge;

  String get displayPrice {
    final parsedPrice = ConversionUtils.parseDouble(price) ?? 0;
    if (!isPaid || parsedPrice <= 0) return 'Free';
    return '$price $currency';
  }

  String get displayLocation => locationDetails.displayLocation;

  String? get displayImageUrl {
    for (final value in [eventImageUrl, hostAvatar]) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    }
    return null;
  }

  String get displayTimeRange {
    final start = ConversionUtils.formatDateTime(startsAt, 'H:mm');
    if (endsAt == null) return start;

    final end = ConversionUtils.formatDateTime(endsAt!, 'H:mm');
    return '$start-$end';
  }

  String get displayRelativeStart {
    final diff = startsAt.difference(DateTime.now());

    if (diff.isNegative) return 'Started';
    if (diff.inDays > 0) return 'Start in ${diff.inDays}d';
    if (diff.inHours > 0) return 'Start in ${diff.inHours}hrs';
    if (diff.inMinutes > 0) return 'Start in ${diff.inMinutes}min';
    return 'Starting soon';
  }

  ExploreEventItem toItem() {
    return ExploreEventItem(
      id: id,
      title: title.trim().isEmpty ? '--' : title,
      imagePath: displayImageUrl ?? Assets.icons.create1.path,
      category: ConversionUtils.formatHyphenatedLabel(hobbyKey),
      hostName: hostName.trim().isEmpty ? '--' : hostName,
      hostAvatar: hostAvatar,
      status: status,
      time: displayTimeRange.trim().isEmpty ? '--' : displayTimeRange,
      price: displayPrice.trim().isEmpty ? '--' : displayPrice,
      guests: '$spotsRemaining spots left',
      startTime:
          displayRelativeStart.trim().isEmpty ? '--' : displayRelativeStart,
      location: displayLocation,
    );
  }

  static List<ExploreEventItem> toItems(List<ExploreEvent> events) {
    return events.map((event) => event.toItem()).toList();
  }
}
