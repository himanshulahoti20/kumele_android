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
  final String? destinationUrlIos;
  final String? destinationUrlAndroid;

  /// Real button text from the backend (e.g. "Install now"). Falls back to
  /// a [destinationType]-derived label when absent.
  final String? ctaLabel;
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
    this.destinationUrlIos,
    this.destinationUrlAndroid,
    this.ctaLabel,
    required this.moderationStatus,
    required this.createdAt,
    String? impressionId,
  }) : impressionId = impressionId ?? _generateImpressionId();

  /// The link the CTA button/tap should open: the Android-specific store
  /// link when present, else the generic [destinationUrl].
  String? get resolvedDestinationUrl =>
      _nonEmpty(destinationUrlAndroid) ?? _nonEmpty(destinationUrl);

  /// A separate plain website link an app-install ad may carry alongside
  /// its store link, shown only when it's distinct from the CTA target.
  String? get secondaryLinkUrl {
    final secondary = _nonEmpty(destinationUrl);
    final primary = resolvedDestinationUrl;
    if (secondary == null || primary == null || secondary == primary) {
      return null;
    }
    return secondary;
  }

  String resolvedCtaLabel(String Function(String destinationType) fallback) {
    final label = _nonEmpty(ctaLabel);
    return label ?? fallback(destinationType);
  }

  static String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

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
      destinationUrlIos: (json['destinationUrlIos'] ??
              json['destination_url_ios'])
          ?.toString(),
      destinationUrlAndroid: (json['destinationUrlAndroid'] ??
              json['destination_url_android'])
          ?.toString(),
      ctaLabel: (json['ctaLabel'] ?? json['cta_label'])?.toString(),
      moderationStatus:
          (json['moderationStatus'] ?? json['moderation_status'])?.toString() ??
              '',
      createdAt: (json['createdAt'] ?? json['created_at'])?.toString() ?? '',
    );
  }
}

class FetchedAds {
  const FetchedAds({
    this.ads = const [],
    required this.raw,
    this.fromSingleAd = false,
  });

  final List<AdItem> ads;
  final Map<String, dynamic> raw;

  /// True when the backend answered with the singular `first_party_ad`
  /// (one random ad, `limit` ignored) rather than an array.
  final bool fromSingleAd;

  factory FetchedAds.fromJson(Map<String, dynamic> json) {
    // Matches iOS's AdFetchResponse.fetchedAds priority exactly: an EMPTY
    // array under `firstPartyAds`/`ads` must fall through to the next
    // source, not short-circuit with zero ads — the backend can send an
    // empty `ads: []` alongside the real ad under `first_party_ad`.
    List<AdItem>? asNonEmptyAdList(dynamic value) {
      if (value is! List) return null;
      final items = value
          .whereType<Map>()
          .map((item) => AdItem.fromJson(item.cast<String, dynamic>()))
          .toList();
      return items.isEmpty ? null : items;
    }

    final firstPartyAds = asNonEmptyAdList(
      json['firstPartyAds'] ?? json['first_party_ads'],
    );
    if (firstPartyAds != null) {
      return FetchedAds(ads: firstPartyAds, raw: json);
    }

    final ads = asNonEmptyAdList(json['ads'] ?? json['data']);
    if (ads != null) {
      return FetchedAds(ads: ads, raw: json);
    }

    final singleAd = json['firstPartyAd'] ?? json['first_party_ad'];
    if (singleAd is Map) {
      return FetchedAds(
        ads: [AdItem.fromJson(singleAd.cast<String, dynamic>())],
        raw: json,
        fromSingleAd: true,
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
