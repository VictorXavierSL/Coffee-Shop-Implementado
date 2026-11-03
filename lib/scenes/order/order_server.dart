import 'package:core/core.dart';

abstract interface class OrderServer {
  /// Endereço salvo no perfil do usuário.
  Address? get defaultAddress;

  /// `POST /orders/quote`
  Future<PriceSummary> quote({required DeliveryType deliveryType, required List<CartItem> items});

  /// `POST /orders`
  Future<Order> place({
    required DeliveryType deliveryType,
    required List<CartItem> items,
    required String paymentMethod,
    Address? address,
  });
}

class DefaultOrderServer implements OrderServer {
  DefaultOrderServer({
    required OrderRepository orderRepository,
    required AuthRepository authRepository,
  })  : _orders = orderRepository,
        _auth = authRepository;

  final OrderRepository _orders;
  final AuthRepository _auth;

  @override
  Address? get defaultAddress => _auth.currentUser?.address;

  @override
  Future<PriceSummary> quote({required DeliveryType deliveryType, required List<CartItem> items}) =>
      _orders.quote(deliveryType: deliveryType, items: items);

  @override
  Future<Order> place({
    required DeliveryType deliveryType,
    required List<CartItem> items,
    required String paymentMethod,
    Address? address,
  }) {
    return _orders.place(
      deliveryType: deliveryType,
      items: items,
      paymentMethod: paymentMethod,
      address: address,
    );
  }
}
