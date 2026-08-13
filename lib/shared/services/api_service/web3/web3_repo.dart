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

  static Future<SubscriptionStatus?> verifyGooglePurchase({
    required String productId,
    required String purchaseToken,
  }) async {
    final api = GeneratedApiOperations.verifyGoogleTransaction;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
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
      'EventPlansController_list_v1',
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

  /// Real, confirmed-live host payout-account link flow (superseding an
  /// earlier vault/setup-token attempt at this same feature). This is a
  /// two-call OAuth-style handshake, not a single round trip:
  /// 1. [getPayPalConnectLoginUrl] (`GET /payments/paypal/connect`) starts
  ///    it, returning PayPal's `authorizeUrl` for [redirectUri].
  /// 2. An in-app browser session (`flutter_web_auth_2` — Custom Tabs on
  ///    Android) opens that URL. PayPal redirects to [redirectUri], an HTTPS
  ///    bridge page (PayPal requires HTTPS; a bare-IP/HTTP redirect_uri gets
  ///    rejected before login even shows) which itself immediately redirects
  ///    to `kumele://paypal-connect-callback?code=...`, the scheme
  ///    `flutter_web_auth_2` is watching for — it captures that final URL
  ///    and hands it back without any manual deep-link routing.
  /// 3. [finishPayPalConnect] (`POST /payments/paypal/connect/callback`)
  ///    must then be called explicitly with the `code` from that callback
  ///    URL — this is the call that actually persists the linked account
  ///    server-side. Skipping it (treating step 2 alone as "connected") is
  ///    exactly the bug this flow replaces: reading the code client-side
  ///    told the backend nothing.
  ///
  /// [redirectUri] must be the exact literal URL registered as this app's
  /// PayPal redirect_uri — not derived from [ApiConfig.baseUrl], since
  /// PayPal requires an exact match against what's registered in its app
  /// dashboard.
  static const String paypalConnectRedirectUri =
      'https://kumele-next-js-readiness-handover-2.vercel.app/paypal-connect-callback';

  static Future<String?> getPayPalConnectLoginUrl() async {
    final api = GeneratedApiOperations.getPayPalConnectAuthorizeUrl;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
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
    final api = GeneratedApiOperations.connectPayPalAccount;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
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
    final api = GeneratedApiOperations.disconnectPayPalAccount;
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
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

  /// Free NFTs (per `POST /payments/nft/checkout/:id`'s own docs, "free NFTs
  /// should call POST /nfts/:id/purchase directly"), or to record an
  /// already-completed wallet payment via [transactionRef]/[walletAddress].
  static Future<NftActionResult?> purchaseNft(
    String id, {
    String? transactionRef,
    String? walletAddress,
  }) async {
    final api = GeneratedApiOperations.purchaseNft;
    final path =
        GeneratedApiOperations.resolvePath(api, pathValues: {'id': id});
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      body: {'transactionRef': transactionRef, 'walletAddress': walletAddress},
    );
    return ApiService.handleResponse<NftActionResult?>(
      () => NftActionResult.fromJson(ApiService.extractMap(response)),
    );
  }

  /// Stripe checkout for a paid NFT: returns a clientSecret payload for
  /// [PaymentSdkService.presentStripePaymentSheet]; confirm with
  /// [confirmStripePayment] afterwards to grant ownership.
  static Future<Map<String, dynamic>> createNftPayment(String nftId) async {
    final api = GeneratedApiOperations.createNftPayment;
    final path =
        GeneratedApiOperations.resolvePath(api, pathValues: {'nftId': nftId});
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
}
