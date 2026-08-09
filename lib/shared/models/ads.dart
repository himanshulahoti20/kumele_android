import 'dart:math';

String _generateImpressionId() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
  bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant
  String hex(int start, int end) =>
      bytes.sublist(start, end).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex(0, 4)}-${hex(4, 6)}-${hex(6, 8)}-${hex(8, 10)}-${hex(10, 16)}';
}

class AdItem {
  final String id;
  final String campaignId;
  final String title;
  final String? body;
  final String? mediaUrl;
  final String mediaType;
  final String destinationType;
  final String? destinationId;
  final String? destinationUrl;
  final String moderationStatus;
  final String createdAt;

  /// Not sent by the backend — generated once per fetched impression and
  /// reused on the follow-up `trackAd` call so impressions correlate with
  /// clicks/conversions server-side.
  final String impressionId;

  AdItem({
    required this.id,
    required this.campaignId,
    required this.title,
    this.body,
    this.mediaUrl,
    required this.mediaType,
    required this.destinationType,
    this.destinationId,
    this.destinationUrl,
    required this.moderationStatus,
    required this.createdAt,
    String? impressionId,
  }) : impressionId = impressionId ?? _generateImpressionId();

  factory AdItem.fromJson(Map<String, dynamic> json) {
    return AdItem(
      id: json['id']?.toString() ?? '',
      campaignId: (json['campaignId'] ?? json['campaign_id'])?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString(),
      mediaUrl: (json['mediaUrl'] ?? json['media_url'])?.toString(),
      mediaType: (json['mediaType'] ?? json['media_type'])?.toString() ?? '',
      destinationType:
          (json['destinationType'] ?? json['destination_type'])?.toString() ??
              '',
      destinationId:
          (json['destinationId'] ?? json['destination_id'])?.toString(),
      destinationUrl:
          (json['destinationUrl'] ?? json['destination_url'])?.toString(),
      moderationStatus:
          (json['moderationStatus'] ?? json['moderation_status'])?.toString() ??
              '',
      createdAt: (json['createdAt'] ?? json['created_at'])?.toString() ?? '',
    );
  }
}

class FetchedAds {
  const FetchedAds({this.ads = const [], required this.raw});

  final List<AdItem> ads;
  final Map<String, dynamic> raw;

  factory FetchedAds.fromJson(Map<String, dynamic> json) {
    final adsJson =
        json['firstPartyAds'] ?? json['ads'] ?? json['data'];
    if (adsJson is List) {
      return FetchedAds(
        ads: adsJson
            .whereType<Map>()
            .map((item) => AdItem.fromJson(item.cast<String, dynamic>()))
            .toList(),
        raw: json,
      );
    }

    final singleAd = json['firstPartyAd'];
    if (singleAd is Map) {
      return FetchedAds(
        ads: [AdItem.fromJson(singleAd.cast<String, dynamic>())],
        raw: json,
      );
    }

    return FetchedAds(ads: const [], raw: json);
  }
}

class TrackAdRequest {
  const TrackAdRequest({
    required this.adId,
    required this.eventType,
    this.campaignId,
    this.impressionId,
    this.placement = 'FEED',
    this.hobbyContext,
  });

  final String adId;
  final String eventType;
  final String? campaignId;
  final String? impressionId;
  final String placement;
  final String? hobbyContext;

  Map<String, dynamic> toJson() {
    return {
      'adId': adId,
      'eventType': eventType,
      'placement': placement,
      if (campaignId != null) 'campaignId': campaignId,
      if (impressionId != null) 'impressionId': impressionId,
      if (hobbyContext != null) 'hobbyContext': hobbyContext,
    };
  }
}
