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

  static Future<List<SavedCard>> listSavedCards() async {
    final api = GeneratedApiOperations.listSavedCards;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<List<SavedCard>>(
          () => SavedCard.listFromResponse(response),
        ) ??
        [];
  }

  /// Persists a card to the user's profile after the Stripe SetupIntent for
  /// it has been confirmed client-side. Must be called after
  /// `presentStripePaymentSheet` succeeds — the SetupIntent alone does not
  /// save the card server-side.
  static Future<bool> saveCard(String setupIntentId) async {
    final api = GeneratedApiOperations.saveCard;
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'setupIntentId': setupIntentId},
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<bool> deleteCard(String cardId) async {
    final api = GeneratedApiOperations.deleteCard;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': cardId},
    );
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<bool> setDefaultCard(String cardId) async {
    final api = GeneratedApiOperations.setDefaultCard;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': cardId},
    );
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<EscrowStatus?> getEscrowStatus(String paymentId) async {
    final api = GeneratedApiOperations.getEscrowStatus;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': paymentId},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<EscrowStatus?>(
      () => EscrowStatus.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<PayPalOrder?> getPayPalOrderStatus(String orderId) async {
    final api = GeneratedApiOperations.getPayPalOrderStatus;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'orderId': orderId},
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

  /// Mints a PayPal Vault Setup Token for linking a host's PayPal account
  /// (the "Connect Escrow Account" flow). PayPal's v3 Vault Setup Token API
  /// standardly returns a `links` array with a `rel: "approve"` entry
  /// Real, confirmed-live host payout-account link flow (superseding an
  /// earlier vault/setup-token attempt at this same feature). This is a
  /// two-call OAuth-style handshake, not a single round trip:
  /// 1. [getPayPalConnectLoginUrl] (`GET /payments/paypal/connect`) starts
  ///    it, returning PayPal's login URL for [redirectUri].
  /// 2. The webview intercepts the browser-facing redirect landing page
  ///    (`/payments/paypal-connect-callback`, PayPal's registered
  ///    `redirect_uri`) before it loads and reads `code`/`error` off it.
  /// 3. [finishPayPalConnect] (`POST /payments/paypal/connect/callback`)
  ///    must then be called explicitly with that `code` — this is the call
  ///    that actually persists the linked account server-side. Skipping it
  ///    (treating step 2 alone as "connected") is exactly the bug this flow
  ///    replaces: reading the code client-side told the backend nothing.
  ///
  /// [redirectUri] must be the exact literal URL registered as this app's
  /// PayPal redirect_uri (`http://84.247.131.180/api/v1/payments/paypal-connect-callback`,
  /// per the backend team) — PayPal requires an exact match, so it is not
  /// derived from [ApiConfig.baseUrl].
  static const String paypalConnectRedirectUri =
      'http://84.247.131.180/api/v1/payments/paypal-connect-callback';

  static Future<String?> getPayPalConnectLoginUrl() async {
    final response = await ApiService.callRequest(
      RequestMethod.GET,
      '/payments/paypal/connect',
      'PaymentsController_getPayPalConnectUrl_v1',
      params: {'redirectUri': paypalConnectRedirectUri},
    );
    final json = ApiService.handleResponse<Map<String, dynamic>>(
      () => ApiService.extractMap(response),
    );
    if (json == null) return null;

    for (final key in [
      'authorizeUrl',
      'url',
      'loginUrl',
      'redirectUrl',
      'authUrl',
      'connectUrl',
    ]) {
      final value = json[key]?.toString();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  /// The call that actually persists the linked PayPal account server-side.
  /// Returns the linked account's email/identifier on success, null on
  /// failure — callers must only treat the connection as real once this
  /// returns non-null, not merely after the webview reaches the callback URL.
  static Future<String?> finishPayPalConnect({
    required String code,
    String redirectUri = paypalConnectRedirectUri,
  }) async {
    final response = await ApiService.callRequest(
      RequestMethod.POST,
      '/payments/paypal/connect/callback',
      'PaymentsController_finishPayPalConnect_v1',
      body: {'code': code, 'redirectUri': redirectUri},
    );
    final json = ApiService.handleResponse<Map<String, dynamic>>(
      () => ApiService.extractMap(response),
    );
    if (json == null) return null;

    final account = json['connectedAccount'];
    final accountJson = account is Map ? account : json;
    for (final key in [
      'paypalEmail',
      'email',
      'accountId',
      'paypalPayerId',
      'payerId',
      'id',
    ]) {
      final value = accountJson[key]?.toString();
      if (value != null && value.isNotEmpty) return value;
    }
    return 'PayPal';
  }

  static Future<bool> disconnectPayPal() async {
    await ApiService.callRequest(
      RequestMethod.DELETE,
      '/payments/paypal/connect',
      'PaymentsController_disconnectPayPal_v1',
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
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
