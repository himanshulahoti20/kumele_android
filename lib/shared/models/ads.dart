class AdCampaign {
  final String id;
  final String ownerId;
  final String name;
  final String status;
  final int? dailyImpressionCap;
  final String createdAt;
  final String updatedAt;

  const AdCampaign({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.status,
    this.dailyImpressionCap,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdCampaign.fromJson(Map<String, dynamic> json) {
    return AdCampaign(
      id: json['id']?.toString() ?? '',
      ownerId: json['ownerId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      dailyImpressionCap: (json['dailyImpressionCap'] as num?)?.toInt(),
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }
}

class CreateCampaignRequest {
  final String name;
  final int? dailyImpressionCap;

  const CreateCampaignRequest({
    required this.name,
    this.dailyImpressionCap,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (dailyImpressionCap != null) 'dailyImpressionCap': dailyImpressionCap,
    };
  }
}

class UpdateCampaignRequest {
  final String? name;
  final String? status;
  final int? dailyImpressionCap;

  const UpdateCampaignRequest({
    this.name,
    this.status,
    this.dailyImpressionCap,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (dailyImpressionCap != null) 'dailyImpressionCap': dailyImpressionCap,
    };
  }
}

class CreateAdRequest {
  final String campaignId;
  final String title;
  final String? body;
  final String? mediaUrl;
  final String mediaType;
  final String destinationType;
  final String? destinationId;
  final String? destinationUrl;
  final List<String>? targetHobbies;
  final List<String>? targetLocations;
  final List<String>? targetLanguages;
  final int? targetAgeMin;
  final int? targetAgeMax;
  final String? targetGender;

  const CreateAdRequest({
    required this.campaignId,
    required this.title,
    this.body,
    this.mediaUrl,
    required this.mediaType,
    required this.destinationType,
    this.destinationId,
    this.destinationUrl,
    this.targetHobbies,
    this.targetLocations,
    this.targetLanguages,
    this.targetAgeMin,
    this.targetAgeMax,
    this.targetGender,
  });

  Map<String, dynamic> toJson() {
    return {
      'campaignId': campaignId,
      'title': title,
      if (body != null) 'body': body,
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'destinationType': destinationType,
      if (destinationId != null) 'destinationId': destinationId,
      if (destinationUrl != null) 'destinationUrl': destinationUrl,
      if (targetHobbies != null) 'targetHobbies': targetHobbies,
      if (targetLocations != null) 'targetLocations': targetLocations,
      if (targetLanguages != null) 'targetLanguages': targetLanguages,
      if (targetAgeMin != null) 'targetAgeMin': targetAgeMin,
      if (targetAgeMax != null) 'targetAgeMax': targetAgeMax,
      if (targetGender != null) 'targetGender': targetGender,
    };
  }
}

class UpdateAdRequest {
  final String? title;
  final String? body;
  final String? mediaUrl;
  final String? mediaType;
  final String? destinationType;
  final String? destinationId;
  final String? destinationUrl;
  final List<String>? targetHobbies;
  final List<String>? targetLocations;
  final List<String>? targetLanguages;
  final int? targetAgeMin;
  final int? targetAgeMax;
  final String? targetGender;

  const UpdateAdRequest({
    this.title,
    this.body,
    this.mediaUrl,
    this.mediaType,
    this.destinationType,
    this.destinationId,
    this.destinationUrl,
    this.targetHobbies,
    this.targetLocations,
    this.targetLanguages,
    this.targetAgeMin,
    this.targetAgeMax,
    this.targetGender,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
      if (mediaType != null) 'mediaType': mediaType,
      if (destinationType != null) 'destinationType': destinationType,
      if (destinationId != null) 'destinationId': destinationId,
      if (destinationUrl != null) 'destinationUrl': destinationUrl,
      if (targetHobbies != null) 'targetHobbies': targetHobbies,
      if (targetLocations != null) 'targetLocations': targetLocations,
      if (targetLanguages != null) 'targetLanguages': targetLanguages,
      if (targetAgeMin != null) 'targetAgeMin': targetAgeMin,
      if (targetAgeMax != null) 'targetAgeMax': targetAgeMax,
      if (targetGender != null) 'targetGender': targetGender,
    };
  }
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
      campaignId:
          (json['campaignId'] ?? json['campaign_id'])?.toString() ?? '',
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
          (json['moderationStatus'] ?? json['moderation_status'])
                  ?.toString() ??
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
    this.placement = 'HOME',
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

class CampaignDetail {
  final AdCampaign? campaign;
  final List<AdItem> ads;
  final Map<String, dynamic> raw;

  const CampaignDetail({
    required this.raw,
    this.campaign,
    this.ads = const [],
  });

  factory CampaignDetail.fromJson(Map<String, dynamic> json) {
    final campaignJson = json['campaign'];
    final adsJson = json['ads'];
    return CampaignDetail(
      campaign: campaignJson is Map<String, dynamic>
          ? AdCampaign.fromJson(campaignJson)
          : campaignJson is Map
              ? AdCampaign.fromJson(campaignJson.cast<String, dynamic>())
              : (json['id'] != null ? AdCampaign.fromJson(json) : null),
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

class AdDetail {
  final AdItem ad;
  final Map<String, dynamic> stats;
  final Map<String, dynamic> raw;

  const AdDetail({
    required this.ad,
    required this.raw,
    this.stats = const {},
  });

  factory AdDetail.fromJson(Map<String, dynamic> json) {
    final adJson = json['ad'];
    final statsJson = json['stats'];
    return AdDetail(
      ad: adJson is Map<String, dynamic>
          ? AdItem.fromJson(adJson)
          : adJson is Map
              ? AdItem.fromJson(adJson.cast<String, dynamic>())
              : AdItem.fromJson(json),
      stats: statsJson is Map<String, dynamic>
          ? statsJson
          : statsJson is Map
              ? statsJson.cast<String, dynamic>()
              : const {},
      raw: json,
    );
  }
}
