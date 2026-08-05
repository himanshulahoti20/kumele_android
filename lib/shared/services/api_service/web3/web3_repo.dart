import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class Web3Repo extends ApiService {
  static Future<List<SubscriptionTier>> getSubscriptionTiers() async {
    final api = GeneratedApiOperations.getSubscriptionTiers;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<List<SubscriptionTier>>(() {
          final items = ApiService.extractList(response);
          return items
              .whereType<Map>()
              .map((item) => SubscriptionTier.fromJson(item.cast<String, dynamic>()))
              .toList();
        }) ??
        [];
  }

  static Future<SubscriptionStatus?> getSubscriptionStatus() async {
    final api = GeneratedApiOperations.getSubscriptionStatus;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<SubscriptionStatus?>(
      () => SubscriptionStatus.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<SubscriptionCheckoutSession?> createSubscription({
    required CreateSubscriptionRequest body,
  }) async {
    final api = GeneratedApiOperations.createSubscription;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: body.toJson(),
    );
    return ApiService.handleResponse<SubscriptionCheckoutSession?>(
      () => SubscriptionCheckoutSession.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<bool> cancelSubscription({CancelSubscriptionRequest? body}) async {
    final api = GeneratedApiOperations.cancelSubscription;
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: body?.toJson() ?? const {},
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<bool> resumeSubscription() async {
    final api = GeneratedApiOperations.resumeSubscription;
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<List<PaymentHistoryItem>> getPaymentHistory({
    int page = 1,
    int limit = 20,
  }) async {
    final api = GeneratedApiOperations.getPaymentHistory;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      params: {'page': page, 'limit': limit},
    );
    return ApiService.handleResponse<List<PaymentHistoryItem>>(() {
          final items = ApiService.extractList(response);
          return items
              .whereType<Map>()
              .map((item) => PaymentHistoryItem.fromJson(item.cast<String, dynamic>()))
              .toList();
        }) ??
        [];
  }

  static Future<Map<String, dynamic>> createEventPayment({
    required CreateEventPaymentRequest body,
  }) async {
    final api = GeneratedApiOperations.createEventPayment;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: body.toJson(),
    );
    return ApiService.handleResponse<Map<String, dynamic>>(() => ApiService.extractMap(response)) ?? const {};
  }

  static Future<PayPalOrder?> createPayPalOrder({
    required CreateEventPaymentRequest body,
  }) async {
    final api = GeneratedApiOperations.createPayPalOrder;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: body.toJson(),
    );
    return ApiService.handleResponse<PayPalOrder?>(
      () => PayPalOrder.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<Map<String, dynamic>> capturePayPalOrder(String orderId) async {
    final api = GeneratedApiOperations.capturePayPalOrder;
    final path = GeneratedApiOperations.resolvePath(api, pathValues: {'orderId': orderId});
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<Map<String, dynamic>>(() => ApiService.extractMap(response)) ?? const {};
  }

  static Future<NftScreenData?> getMyNftScreen() async {
    final api = GeneratedApiOperations.getMyNftScreen;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<NftScreenData?>(
      () => NftScreenData.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<List<NftItem>> getRewardNfts() async {
    final api = GeneratedApiOperations.getRewardNfts;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<List<NftItem>>(() {
          final items = ApiService.extractList(response);
          return items.whereType<Map>().map((item) => NftItem.fromJson(item.cast<String, dynamic>())).toList();
        }) ??
        [];
  }

  static Future<List<NftItem>> getMyNfts({
    int page = 1,
    int limit = 20,
  }) async {
    final api = GeneratedApiOperations.getMyNfts;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      params: {'page': page, 'limit': limit},
    );
    return ApiService.handleResponse<List<NftItem>>(() {
          final items = ApiService.extractList(response);
          return items.whereType<Map>().map((item) => NftItem.fromJson(item.cast<String, dynamic>())).toList();
        }) ??
        [];
  }

  static Future<List<NftItem>> getMarketplaceNfts({
    String? category,
    String? nftType,
    String? search,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
    int page = 1,
    int limit = 20,
  }) async {
    final api = GeneratedApiOperations.getMarketplaceNfts;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      params: {
        if (category != null && category.isNotEmpty) 'category': category,
        if (nftType != null && nftType.isNotEmpty) 'nftType': nftType,
        if (search != null && search.isNotEmpty) 'search': search,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
        'page': page,
        'limit': limit,
      },
      useAuthenHeader: false,
    );
    return ApiService.handleResponse<List<NftItem>>(() {
          final items = ApiService.extractList(response);
          return items.whereType<Map>().map((item) => NftItem.fromJson(item.cast<String, dynamic>())).toList();
        }) ??
        [];
  }

  static Future<NftActionResult?> claimNft(String id) async {
    final api = GeneratedApiOperations.claimNft;
    final path = GeneratedApiOperations.resolvePath(api, pathValues: {'id': id});
    final response = await ApiService.callRequest(api.method.toRequestMethod(), path, api.operationId);
    return ApiService.handleResponse<NftActionResult?>(
      () => NftActionResult.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<NftActionResult?> purchaseNft(String id) async {
    final api = GeneratedApiOperations.purchaseNft;
    final path = GeneratedApiOperations.resolvePath(api, pathValues: {'id': id});
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      body: const {'transactionRef': null, 'walletAddress': null},
    );
    return ApiService.handleResponse<NftActionResult?>(
      () => NftActionResult.fromJson(ApiService.extractMap(response)),
    );
  }
}
