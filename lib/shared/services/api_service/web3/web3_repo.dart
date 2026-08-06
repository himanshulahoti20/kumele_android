import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/features/discover/data/models/event_plan_model.dart';
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
              .map((item) =>
                  SubscriptionTier.fromJson(item.cast<String, dynamic>()))
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
      () =>
          SubscriptionCheckoutSession.fromJson(ApiService.extractMap(response)),
    );
  }

  // ponytail: /subscriptions/google/verify isn't in the backend's OpenAPI spec
  // yet (only /subscriptions/apple/verify exists) so it can't go through the
  // generated catalog; path/body mirror the Apple verify shape. Confirm with
  // backend and regenerate the catalog once they add the real route.
  static Future<SubscriptionStatus?> verifyGooglePurchase({
    required String productId,
    required String purchaseToken,
  }) async {
    final response = await ApiService.callRequest(
      RequestMethod.POST,
      '/subscriptions/google/verify',
      'SubscriptionsController_verifyGoogle_v1',
      body: {'productId': productId, 'purchaseToken': purchaseToken},
    );
    return ApiService.handleResponse<SubscriptionStatus?>(
      () => SubscriptionStatus.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<bool> cancelSubscription(
      {CancelSubscriptionRequest? body}) async {
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
              .map((item) =>
                  PaymentHistoryItem.fromJson(item.cast<String, dynamic>()))
              .toList();
        }) ??
        [];
  }

  static Future<Map<String, dynamic>> createCardSetupIntent() async {
    final api = GeneratedApiOperations.createCardSetupIntent;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<Map<String, dynamic>>(
          () => ApiService.extractMap(response),
        ) ??
        const {};
  }

  static Future<List<TicketItem>> getMyTickets() async {
    final api = GeneratedApiOperations.getMyTickets;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<List<TicketItem>>(
          () => TicketItem.listFromResponse(response),
        ) ??
        [];
  }

  static Future<List<EventPlanModel>> getEventPlans() async {
    final response = await ApiService.callRequest(
      RequestMethod.GET,
      '/event-plans',
      'EventPlansController_listPlans_v1',
      useAuthenHeader: false,
    );
    return ApiService.handleResponse<List<EventPlanModel>>(() {
          final items = ApiService.extractList(response);
          return items
              .whereType<Map>()
              .map((item) =>
                  EventPlanModel.fromJson(item.cast<String, dynamic>()))
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
    return ApiService.handleResponse<Map<String, dynamic>>(
            () => ApiService.extractMap(response)) ??
        const {};
  }

  static Future<Map<String, dynamic>> createEventCreationPayment(
    String eventId,
  ) async {
    final api = GeneratedApiOperations.createEventCreationPayment;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'eventId': eventId},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<Map<String, dynamic>>(
          () => ApiService.extractMap(response),
        ) ??
        const {};
  }

  static Future<Map<String, dynamic>> confirmStripePayment(
    String paymentIntentId,
  ) async {
    final api = GeneratedApiOperations.confirmPayment;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'paymentIntentId': paymentIntentId},
    );
    return ApiService.handleResponse<Map<String, dynamic>>(
          () => ApiService.extractMap(response),
        ) ??
        const {};
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

  static Future<PayPalOrder?> createPayPalEventCreationOrder(
    String eventId,
  ) async {
    final api = GeneratedApiOperations.createPayPalEventCreationOrder;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'eventId': eventId},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<PayPalOrder?>(
      () => PayPalOrder.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<Map<String, dynamic>> capturePayPalOrder(String orderId) async {
    final api = GeneratedApiOperations.capturePayPalOrder;
    final path = GeneratedApiOperations.resolvePath(api,
        pathValues: {'orderId': orderId});
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<Map<String, dynamic>>(
            () => ApiService.extractMap(response)) ??
        const {};
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
          return NftItem.listFromResponse(response);
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
          return NftItem.listFromResponse(response);
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
          return NftItem.listFromResponse(response);
        }) ??
        [];
  }

  static Future<NftActionResult?> claimNft(String id) async {
    final api = GeneratedApiOperations.claimNft;
    final path =
        GeneratedApiOperations.resolvePath(api, pathValues: {'id': id});
    final response = await ApiService.callRequest(
        api.method.toRequestMethod(), path, api.operationId);
    return ApiService.handleResponse<NftActionResult?>(
      () => NftActionResult.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<NftActionResult?> purchaseNft(String id) async {
    final api = GeneratedApiOperations.purchaseNft;
    final path =
        GeneratedApiOperations.resolvePath(api, pathValues: {'id': id});
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
