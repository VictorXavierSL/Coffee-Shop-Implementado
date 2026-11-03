import 'package:flutter/foundation.dart';

/// Modelos de domínio. Cada um sabe se construir a partir do JSON da API
/// (`fromJson`) — o formato está documentado em `docs/API.md`.

typedef Json = Map<String, dynamic>;

@immutable
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.memberSince,
    this.avatarUrl,
    this.address,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime memberSince;
  final Address? address;

  factory User.fromJson(Json json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        avatarUrl: json['avatarUrl'] as String?,
        memberSince: DateTime.parse(json['memberSince'] as String),
        address: json['address'] == null ? null : Address.fromJson(json['address'] as Json),
      );
}

@immutable
class Address {
  const Address({required this.title, required this.line, this.note});

  /// Ex.: "Jl. Kpg Sutoyo".
  final String title;

  /// Ex.: "Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai."
  final String line;
  final String? note;

  factory Address.fromJson(Json json) => Address(
        title: json['title'] as String,
        line: json['line'] as String,
        note: json['note'] as String?,
      );

  Json toJson() => {'title': title, 'line': line, if (note != null) 'note': note};

  Address copyWith({String? note}) => Address(title: title, line: line, note: note ?? this.note);
}

@immutable
class Session {
  const Session({required this.token, required this.user});

  final String token;
  final User user;
}

@immutable
class ProductCategory {
  const ProductCategory({required this.id, required this.name});

  final String id;
  final String name;

  factory ProductCategory.fromJson(Json json) =>
      ProductCategory(id: json['id'] as String, name: json['name'] as String);
}

@immutable
class ProductSize {
  const ProductSize({required this.code, required this.price});

  /// "S", "M" ou "L".
  final String code;
  final double price;

  factory ProductSize.fromJson(Json json) =>
      ProductSize(code: json['code'] as String, price: (json['price'] as num).toDouble());
}

@immutable
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.categoryId,
    required this.rating,
    required this.reviewCount,
    required this.sizes,
    this.imageUrl,
    this.features = const [],
    this.isAvailable = true,
  });

  final String id;
  final String name;
  final String subtitle;
  final String description;
  final String categoryId;
  final double rating;
  final int reviewCount;
  final String? imageUrl;
  final List<ProductSize> sizes;

  /// Códigos de diferenciais: "fast_delivery", "quality_bean", "extra_milk".
  final List<String> features;
  final bool isAvailable;

  /// Preço de vitrine: o do tamanho "M" ou, se não houver, o primeiro.
  double get displayPrice =>
      sizes.firstWhere((s) => s.code == 'M', orElse: () => sizes.first).price;

  double priceFor(String sizeCode) =>
      sizes.firstWhere((s) => s.code == sizeCode, orElse: () => sizes.first).price;

  factory Product.fromJson(Json json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        subtitle: json['subtitle'] as String,
        description: json['description'] as String,
        categoryId: json['categoryId'] as String,
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int,
        imageUrl: json['imageUrl'] as String?,
        sizes: (json['sizes'] as List).cast<Json>().map(ProductSize.fromJson).toList(),
        features: (json['features'] as List? ?? const []).cast<String>(),
        isAvailable: json['isAvailable'] as bool? ?? true,
      );
}

@immutable
class Promotion {
  const Promotion({required this.id, required this.tag, required this.title, this.imageUrl});

  final String id;
  final String tag;
  final String title;
  final String? imageUrl;

  factory Promotion.fromJson(Json json) => Promotion(
        id: json['id'] as String,
        tag: json['tag'] as String,
        title: json['title'] as String,
        imageUrl: json['imageUrl'] as String?,
      );
}

enum DeliveryType {
  deliver('deliver'),
  pickUp('pick_up');

  const DeliveryType(this.apiValue);
  final String apiValue;

  static DeliveryType fromApi(String value) =>
      values.firstWhere((t) => t.apiValue == value, orElse: () => deliver);
}

enum OrderStatus {
  placed('placed'),
  preparing('preparing'),
  onTheWay('on_the_way'),
  delivered('delivered');

  const OrderStatus(this.apiValue);
  final String apiValue;

  /// Quantas das 4 etapas já foram concluídas.
  int get completedSteps => index + 1;

  static OrderStatus fromApi(String value) =>
      values.firstWhere((s) => s.apiValue == value, orElse: () => placed);
}

/// Item do carrinho (estado local do app, ainda não enviado à API).
@immutable
class CartItem {
  const CartItem({required this.product, required this.sizeCode, required this.quantity});

  final Product product;
  final String sizeCode;
  final int quantity;

  /// Chave única: o mesmo produto em tamanhos diferentes são itens diferentes.
  String get key => '${product.id}:$sizeCode';
  double get unitPrice => product.priceFor(sizeCode);
  double get total => unitPrice * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, sizeCode: sizeCode, quantity: quantity ?? this.quantity);

  Json toOrderJson() => {'productId': product.id, 'size': sizeCode, 'quantity': quantity};
}

/// Resumo de valores devolvido por `POST /orders/quote` e dentro do pedido.
@immutable
class PriceSummary {
  const PriceSummary({
    required this.subtotal,
    required this.deliveryFee,
    required this.deliveryFeeOriginal,
    required this.discount,
    required this.total,
    this.discountLabel,
  });

  final double subtotal;
  final double deliveryFee;
  final double deliveryFeeOriginal;
  final double discount;
  final double total;
  final String? discountLabel;

  bool get hasDeliveryDiscount => deliveryFeeOriginal > deliveryFee;

  factory PriceSummary.fromJson(Json json) => PriceSummary(
        subtotal: (json['subtotal'] as num).toDouble(),
        deliveryFee: (json['deliveryFee'] as num).toDouble(),
        deliveryFeeOriginal: (json['deliveryFeeOriginal'] as num).toDouble(),
        discount: (json['discount'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
        discountLabel: json['discountLabel'] as String?,
      );
}

@immutable
class OrderLine {
  const OrderLine({
    required this.productId,
    required this.name,
    required this.size,
    required this.quantity,
    required this.unitPrice,
  });

  final String productId;
  final String name;
  final String size;
  final int quantity;
  final double unitPrice;

  factory OrderLine.fromJson(Json json) => OrderLine(
        productId: json['productId'] as String,
        name: json['name'] as String,
        size: json['size'] as String,
        quantity: json['quantity'] as int,
        unitPrice: (json['unitPrice'] as num).toDouble(),
      );
}

@immutable
class Courier {
  const Courier({required this.name, required this.phone});

  final String name;
  final String phone;

  factory Courier.fromJson(Json json) =>
      Courier(name: json['name'] as String, phone: json['phone'] as String);
}

@immutable
class Order {
  const Order({
    required this.id,
    required this.status,
    required this.deliveryType,
    required this.items,
    required this.summary,
    required this.paymentMethod,
    required this.createdAt,
    required this.estimatedMinutes,
    this.address,
    this.courier,
  });

  final String id;
  final OrderStatus status;
  final DeliveryType deliveryType;
  final Address? address;
  final List<OrderLine> items;
  final PriceSummary summary;
  final String paymentMethod;
  final DateTime createdAt;
  final int estimatedMinutes;
  final Courier? courier;

  factory Order.fromJson(Json json) => Order(
        id: json['id'] as String,
        status: OrderStatus.fromApi(json['status'] as String),
        deliveryType: DeliveryType.fromApi(json['deliveryType'] as String),
        address: json['address'] == null ? null : Address.fromJson(json['address'] as Json),
        items: (json['items'] as List).cast<Json>().map(OrderLine.fromJson).toList(),
        summary: PriceSummary.fromJson(json['summary'] as Json),
        paymentMethod: json['paymentMethod'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        estimatedMinutes: json['estimatedMinutes'] as int,
        courier: json['courier'] == null ? null : Courier.fromJson(json['courier'] as Json),
      );
}
