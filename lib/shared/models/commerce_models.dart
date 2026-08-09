double? _flexDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

int? _flexInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

class ProductModel {
  const ProductModel({
    required this.id,
    this.name,
    this.slug,
    this.description,
    this.price,
    this.currency,
    this.images = const [],
    this.category,
    this.stock,
  });

  final String id;
  final String? name;
  final String? slug;
  final String? description;
  final double? price;
  final String? currency;
  final List<String> images;
  final String? category;
  final int? stock;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] ?? '').toString(),
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      description: json['description']?.toString(),
      price: _flexDouble(json['price']),
      currency: json['currency']?.toString(),
      images: ((json['images'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      category: json['category']?.toString(),
      stock: _flexInt(json['stock']),
    );
  }
}

class CartItem {
  const CartItem({
    required this.id,
    this.productId,
    this.quantity,
    this.product,
  });

  final String id;
  final String? productId;
  final int? quantity;
  final ProductModel? product;

  String get displayName => product?.name ?? 'Item';
  double? get unitPrice => product?.price;
  double get lineTotal => (unitPrice ?? 0) * (quantity ?? 1);

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'];
    return CartItem(
      id: (json['id'] ?? '').toString(),
      productId: (json['productId'] ?? json['product_id'])?.toString(),
      quantity: _flexInt(json['quantity']),
      product: productJson is Map
          ? ProductModel.fromJson(Map<String, dynamic>.from(productJson))
          : null,
    );
  }
}

class CartModel {
  const CartModel({
    this.id,
    this.items = const [],
    this.total,
    this.currency,
  });

  final String? id;
  final List<CartItem> items;
  final double? total;
  final String? currency;

  bool get isEmpty => items.isEmpty;

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id']?.toString(),
      items: ((json['items'] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      total: _flexDouble(json['total']),
      currency: json['currency']?.toString(),
    );
  }

  static const empty = CartModel();
}
