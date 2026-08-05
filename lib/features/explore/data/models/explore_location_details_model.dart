import 'package:kuemele/features/explore/domain/entities/explore_location_details.dart';
import 'package:kuemele/shared/utils/conversion_utils.dart';

class ExploreLocationDetailsModel {
  const ExploreLocationDetailsModel({
    this.address,
    this.displayAddress,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.venueName,
  });

  final String? address;
  final String? displayAddress;
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? venueName;

  factory ExploreLocationDetailsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ExploreLocationDetailsModel();

    return ExploreLocationDetailsModel(
      address: json['address'] as String?,
      displayAddress: json['displayAddress'] as String? ??
          json['display_address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      latitude: ConversionUtils.parseDouble(json['latitude']),
      longitude: ConversionUtils.parseDouble(json['longitude']),
      venueName: json['venueName'] as String? ?? json['venue_name'] as String?,
    );
  }

  ExploreLocationDetails toEntity() {
    return ExploreLocationDetails(
      address: address,
      displayAddress: displayAddress,
      city: city,
      country: country,
      latitude: latitude,
      longitude: longitude,
      venueName: venueName,
    );
  }
}
