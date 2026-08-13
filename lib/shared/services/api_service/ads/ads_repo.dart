import 'dart:ui' as ui;

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
    String placement = 'FEED',
    String? locationKey,
    String hobbyContext = '',
    String? lang,
    int limit = 1,
  }) async {
    final api = GeneratedApiOperations.fetchAds;
    final user = getIt.isRegistered<ProfileCubit>()
        ? getIt<ProfileCubit>().userData
        : null;
    final params = buildFetchAdsParams(
      placement: placement,
      locationKey: locationKey ??
          locationKeyFrom(city: user?.city, country: user?.country),
      hobbyContext: hobbyContext,
      lang: lang ?? ui.PlatformDispatcher.instance.locale.languageCode,
      limit: limit,
    );
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

  static Map<String, dynamic> buildFetchAdsParams({
    String placement = 'FEED',
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
      'limit': limit,
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

  static Future<bool> trackAd(TrackAdRequest body) async {
    final api = GeneratedApiOperations.trackAd;
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: body.toJson(),
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }
}
