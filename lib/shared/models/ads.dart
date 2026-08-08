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

  const AdItem({
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
  });

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
    final adsJson = json['ads'] ?? json['data'];
    return FetchedAds(
      ads: adsJson is List
          ? adsJson
              .whereType<Map>()
              .map((item) => AdItem.fromJson(item.cast<String, dynamic>()))
              .toList()
          : const [],
      raw: json,
    );
  }
}

class TrackAdRequest {
  const TrackAdRequest({
    required this.adId,
    required this.eventType,
    this.placement = 'FEED',
  });

  final String adId;
  final String eventType;
  final String placement;

  Map<String, dynamic> toJson() {
    return {
      'adId': adId,
      'ad_id': adId,
      'eventType': eventType,
      'event_type': eventType,
      'placement': placement,
    };
  }
}
