import 'dart:io' show Platform;

import 'package:flutter_test/flutter_test.dart';
import 'package:kuemele/shared/services/api_service/ads/ads_repo.dart';

void main() {
  test('ads fetch query params match backend contract', () {
    expect(
      AdsRepo.buildFetchAdsParams(
        placement: 'FEED',
        locationKey: 'kolkata_india',
        hobbyContext: '',
        lang: 'en',
        limit: 1,
      ),
      {
        'placement': 'FEED',
        'locationKey': 'kolkata_india',
        'hobbyContext': '',
        'lang': 'en',
        'platform': Platform.isIOS ? 'ios' : 'android',
        'limit': 1,
      },
    );
  });

  test('locationKey formatting matches iOS', () {
    expect(
      AdsRepo.locationKeyFrom(city: ' Kolkata ', country: 'India'),
      'kolkata_india',
    );
    expect(
      AdsRepo.locationKeyFrom(city: 'New York', country: 'United States'),
      'new_york_united_states',
    );
    expect(AdsRepo.locationKeyFrom(city: null, country: null), isEmpty);
    expect(AdsRepo.locationKeyFrom(city: '  ', country: ''), isEmpty);
  });
}
