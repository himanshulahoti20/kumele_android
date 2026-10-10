import 'dart:io' show Platform;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:kuemele/core/get_it.dart';
import 'package:kuemele/features/profile/cubit/profile_cubit.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class AdsRepo extends ApiService {
  static Future<void> fetchCampaigns({int page = 1, int limit = 20}) async {
    await ApiService.callRequest(
      RequestMethod.GET,
      '/ads/campaigns',
      'AdsController_listCampaigns_v1',
      params: {'page': page, 'limit': limit},
    );
  }

  static Future<FetchedAds?> fetchAds({
    String placement = 'EVENT_DECISION',
    String? locationKey,
    String hobbyContext = '',
    String? lang,
    int limit = 1,
  }) async {
    final profile =
        getIt.isRegistered<ProfileCubit>() ? getIt<ProfileCubit>() : null;
    // Every ad surface routes through here, so one gate covers them all.
    if (profile?.entitlements.adFree == true) {
      return const FetchedAds(raw: <String, dynamic>{});
    }
    final api = GeneratedApiOperations.fetchAds;
    final user = profile?.userData;
    final params = buildFetchAdsParams(
      placement: placement,
      locationKey: locationKey ??
          locationKeyFrom(city: user?.city, country: user?.country),
      hobbyContext: hobbyContext,
      lang: lang ?? ui.PlatformDispatcher.instance.locale.languageCode,
      limit: limit,
    );

    Future<FetchedAds?> fetchOnce() async {
      final response = await ApiService.callRequest(
        api.method.toRequestMethod(),
        api.path,
        api.operationId,
        params: params,
      );
      return ApiService.handleResponse<FetchedAds?>(
        () => FetchedAds.fromJson(ApiService.extractMap(response)),
      );
    }

    final first = await fetchOnce();
    if (first == null) return null;

    // Matches iOS AdService.fetch: the backend ignores `limit` and returns a
    // single *random* `first_party_ad` per call, which starved the 6+6
    // Home/Notification rails. Top up with one parallel batch of 2x`limit`
    // calls, deduped by id: with a pool of ~6 ads, 20 draws collect all of
    // them practically every time, so the count no longer varies between
    // loads or platforms. Sorted by id so the top/bottom rail split is
    // stable too. Impressions are tracked separately via `/ads/track`, so
    // extra fetches don't inflate them.
    if (limit <= 1 || first.ads.length != 1 || !first.fromSingleAd) {
      return first;
    }

    final extra = await Future.wait([
      for (var i = 0; i < limit * 2; i++)
        fetchOnce().then((r) => r?.ads ?? const <AdItem>[]).catchError(
              (_) => const <AdItem>[],
            ),
    ]);

    final seen = <String>{};
    final merged = [
      for (final ad in [...first.ads, ...extra.expand((e) => e)])
        if (seen.add(ad.id)) ad,
    ]..sort((a, b) => a.id.compareTo(b.id));

    return FetchedAds(
      ads: merged.take(limit).toList(),
      raw: first.raw,
      fromSingleAd: true,
    );
  }

  static Map<String, dynamic> buildFetchAdsParams({
    String placement = 'EVENT_DECISION',
    String locationKey = '',
    String hobbyContext = '',
    String lang = 'en',
    int limit = 1,
  }) {
    return {
      'placement': placement,
      'locationKey': locationKey,
      'hobbyContext': hobbyContext,
      'lang': lang,
      'platform': Platform.isIOS ? 'ios' : 'android',
      // Backend cap, confirmed live (same as iOS AdService).
      'limit': limit > 20 ? 20 : limit,
    };
  }

  static String locationKeyFrom({String? city, String? country}) {
    final value = [city, country]
        .whereType<String>()
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .join('_')
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return value;
  }

  static final Set<String> _trackedEvents = {};

  /// One `view` and one `click` per server-issued impression, app-wide —
  /// rebuilds and remounts can't double-count. False when there's no
  /// impression ID (`/ads/track` rejects client-made ones) or it's a repeat.
  static bool shouldTrack(String eventType, String? impressionId) {
    if (impressionId == null || impressionId.isEmpty) return false;
    return _trackedEvents.add('$eventType-$impressionId');
  }

  @visibleForTesting
  static void resetTrackedEvents() => _trackedEvents.clear();

  static Future<bool> trackAd(TrackAdRequest body) async {
    if (!shouldTrack(body.eventType, body.impressionId)) return false;
    final json = body.toJson();
    if (body.hobbyContext == null && getIt.isRegistered<ProfileCubit>()) {
      final hobbyContext = await getIt<ProfileCubit>().loadHobbyContext();
      if (hobbyContext.isNotEmpty) json['hobbyContext'] = hobbyContext;
    }
    final api = GeneratedApiOperations.trackAd;
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: json,
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }
}
