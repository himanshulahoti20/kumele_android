import 'package:kuemele/shared/models/commerce_models.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class CommerceRepo extends ApiService {
  static Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
  }) async {
    final api = GeneratedApiOperations.getProducts;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      params: {'page': page, 'limit': limit},
      useAuthenHeader: api.requiresAuth,
    );
    return ApiService.handleResponse<List<ProductModel>>(() =>
            ApiService.extractList(response)
                .whereType<Map>()
                .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
                .toList()) ??
        [];
  }

  static Future<ProductModel?> getProduct(String idOrSlug) async {
    final api = GeneratedApiOperations.getProduct;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'idOrSlug': idOrSlug},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      useAuthenHeader: api.requiresAuth,
    );
    return ApiService.handleResponse<ProductModel?>(() {
      final data = ApiService.extractMap(response);
      return data.isEmpty ? null : ProductModel.fromJson(data);
    });
  }

  static Future<CartModel> getCart() async {
    final api = GeneratedApiOperations.getCart;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<CartModel>(
          () => CartModel.fromJson(ApiService.extractMap(response)),
        ) ??
        CartModel.empty;
  }

  /// [productId] must be a real `/products` catalog UUID — event-plan/capacity
  /// tier IDs are not valid products and the backend rejects them.
  static Future<CartModel> addToCart({
    required String productId,
    int quantity = 1,
  }) async {
    final api = GeneratedApiOperations.addToCart;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {'productId': productId, 'quantity': quantity},
    );
    return ApiService.handleResponse<CartModel>(
          () => CartModel.fromJson(ApiService.extractMap(response)),
        ) ??
        CartModel.empty;
  }

  static Future<CartModel> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    final api = GeneratedApiOperations.updateCartItem;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': itemId},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      body: {'quantity': quantity},
    );
    return ApiService.handleResponse<CartModel>(
          () => CartModel.fromJson(ApiService.extractMap(response)),
        ) ??
        CartModel.empty;
  }

  static Future<CartModel> removeFromCart(String itemId) async {
    final api = GeneratedApiOperations.removeFromCart;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': itemId},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<CartModel>(
          () => CartModel.fromJson(ApiService.extractMap(response)),
        ) ??
        CartModel.empty;
  }

  static Future<CartModel> clearCart() async {
    final api = GeneratedApiOperations.clearCart;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<CartModel>(
          () => CartModel.fromJson(ApiService.extractMap(response)),
        ) ??
        CartModel.empty;
  }

  /// Shape is not fixed by the backend (string | array | object) — callers
  /// search the raw tree for a matching code, same as the iOS client does.
  static Future<dynamic> getRewardDiscounts() async {
    final api = GeneratedApiOperations.getRewardDiscounts;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );
    return ApiService.handleResponse<dynamic>(() => response);
  }

  static Future<Map<String, dynamic>> validateDiscount({
    required String code,
    required String productType,
    required int amountMinor,
  }) async {
    final api = GeneratedApiOperations.validateDiscount;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {
        'code': code,
        'productType': productType,
        'amountMinor': amountMinor,
      },
    );
    return ApiService.handleResponse<Map<String, dynamic>>(
          () => ApiService.extractMap(response),
        ) ??
        {};
  }
}
