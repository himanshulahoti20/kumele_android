import 'dart:io' show Platform;

import 'package:flutter_test/flutter_test.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/services/api_service/ads/ads_repo.dart';

void main() {
  test('ads fetch query params match backend contract', () {
    expect(
      AdsRepo.buildFetchAdsParams(
        placement: 'HOME',
        locationKey: 'kolkata_india',
        hobbyContext: '',
        lang: 'en',
        limit: 1,
      ),
      {
        'placement': 'HOME',
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

  test('impressionId comes from /ads/fetch, never generated', () {
    final served = AdItem.fromJson({'id': 'a1', 'impressionId': 'imp-1'});
    expect(served.impressionId, 'imp-1');
    expect(AdItem.fromJson({'id': 'a1', 'impression_id': 'imp-2'}).impressionId,
        'imp-2');
    expect(AdItem.fromJson({'id': 'a1'}).impressionId, isNull);
  });

  test('one view and one click per impression; none without an ID', () {
    AdsRepo.resetTrackedEvents();
    expect(AdsRepo.shouldTrack('view', 'imp-1'), isTrue);
    expect(AdsRepo.shouldTrack('view', 'imp-1'), isFalse);
    expect(AdsRepo.shouldTrack('click', 'imp-1'), isTrue);
    expect(AdsRepo.shouldTrack('click', 'imp-1'), isFalse);
    expect(AdsRepo.shouldTrack('view', null), isFalse);
    expect(AdsRepo.shouldTrack('view', ''), isFalse);
  });
}
