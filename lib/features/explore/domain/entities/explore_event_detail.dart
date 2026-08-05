import 'package:kuemele/features/explore/domain/entities/explore_event_rules.dart';
import 'package:kuemele/features/explore/domain/entities/explore_host_profile.dart';
import 'package:kuemele/features/explore/domain/entities/explore_location_details.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/utils/conversion_utils.dart';

class ExploreEventDetail {
  const ExploreEventDetail({
    required this.id,
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
    this.eventRules = const ExploreEventRules(),
    this.chatEnabled = true,
    this.status = 'ACTIVE',
  });

  static const String emptyField = '--';

  final String id;
  final String title;
  final String description;
  final ExploreHostProfile hostProfile;
  final ExploreLocationDetails locationDetails;
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
  final ExploreEventRules eventRules;
  final bool chatEnabled;
  final String status;

  String get hostName {
    final displayName = hostProfile.displayName.trim();
    if (displayName.isNotEmpty) return displayName;

    final parts = [
      hostProfile.firstName,
      hostProfile.lastName,
    ]
        .whereType<String>()
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty);

    return parts.join(' ');
  }

  String get primaryImageUrl =>
      coverImage ?? (eventImages.isNotEmpty ? eventImages.first : null) ?? '';

  String get displayPrice {
    final parsedPrice = double.tryParse(price) ?? 0;
    if (!isPaid || parsedPrice <= 0) return 'Free';
    return '$price $currency';
  }

  String get displayLocation => locationDetails.displayLocation;

  String get primaryHobby => hobbyNames.isNotEmpty ? hobbyNames.first : '';

  bool get hasRatings => totalRatings > 0;

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
    final imageUrl = primaryImageUrl.trim();

    return ExploreEventItem(
      id: id,
      title: _orDash(title),
      imagePath: imageUrl.isNotEmpty ? imageUrl : Assets.icons.create1.path,
      category: _orDash(primaryHobby),
      hostName: _orDash(hostName),
      hostAvatar: hostProfile.avatarUrl,
      time: _orDash(displayTimeRange),
      price: _orDash(displayPrice),
      guests: '$spotsRemaining spots left',
      startTime: _orDash(displayRelativeStart),
      location: displayLocation,
    );
  }

  static String _orDash(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? emptyField : trimmed;
  }
}
