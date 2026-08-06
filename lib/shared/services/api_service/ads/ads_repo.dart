import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class AdsRepo extends ApiService {
  static Future<FetchedAds?> fetchAds({
    String placement = 'HOME',
    int limit = 1,
  }) async {
    final api = GeneratedApiOperations.fetchAds;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      params: {
        'placement': placement,
        'limit': limit,
      },
    );
    return ApiService.handleResponse<FetchedAds?>(
      () => FetchedAds.fromJson(ApiService.extractMap(response)),
    );
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

  static Future<AdCampaign?> createCampaign({required CreateCampaignRequest body}) async {
    final api = GeneratedApiOperations.createAdCampaign;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: body.toJson(),
    );
    return ApiService.handleResponse<AdCampaign?>(() {
      final data = ApiService.extractMap(response);
      return AdCampaign.fromJson(data);
    });
  }

  static Future<List<AdCampaign>> getMyCampaigns() async {
    final api = GeneratedApiOperations.listAdCampaigns;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<List<AdCampaign>>(() {
          final items = ApiService.extractList(response);
          return items
              .whereType<Map>()
              .map((item) => AdCampaign.fromJson(item.cast<String, dynamic>()))
              .toList();
        }) ??
        [];
  }

  static Future<CampaignDetail?> getCampaignById(String id) async {
    final api = GeneratedApiOperations.getAdCampaign;
    final path = GeneratedApiOperations.resolvePath(api, pathValues: {'id': id});
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<CampaignDetail?>(
      () => CampaignDetail.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<AdCampaign?> updateCampaign({
    required String id,
    required UpdateCampaignRequest body,
  }) async {
    final api = GeneratedApiOperations.updateAdCampaign;
    final path = GeneratedApiOperations.resolvePath(api, pathValues: {'id': id});
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      body: body.toJson(),
    );
    return ApiService.handleResponse<AdCampaign?>(() {
      final data = ApiService.extractMap(response);
      return AdCampaign.fromJson(data['campaign'] is Map ? (data['campaign'] as Map).cast<String, dynamic>() : data);
    });
  }

  static Future<AdItem?> createAd({required CreateAdRequest body}) async {
    final api = GeneratedApiOperations.createAd;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: body.toJson(),
    );
    return ApiService.handleResponse<AdItem?>(() {
      final data = ApiService.extractMap(response);
      return AdItem.fromJson(data);
    });
  }

  static Future<AdDetail?> getAdById(String id) async {
    final api = GeneratedApiOperations.getAd;
    final path = GeneratedApiOperations.resolvePath(api, pathValues: {'id': id});
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<AdDetail?>(
      () => AdDetail.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<AdItem?> updateAd({
    required String id,
    required UpdateAdRequest body,
  }) async {
    final api = GeneratedApiOperations.updateAd;
    final path = GeneratedApiOperations.resolvePath(api, pathValues: {'id': id});
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      body: body.toJson(),
    );
    return ApiService.handleResponse<AdItem?>(() {
      final data = ApiService.extractMap(response);
      return AdItem.fromJson(data['ad'] is Map ? (data['ad'] as Map).cast<String, dynamic>() : data);
    });
  }

  static Future<bool> deleteAd(String id) async {
    final api = GeneratedApiOperations.deleteAd;
    final path = GeneratedApiOperations.resolvePath(api, pathValues: {'id': id});
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }
}
