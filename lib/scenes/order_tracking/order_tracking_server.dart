import 'package:core/core.dart';

abstract interface class OrderTrackingServer {
  /// `GET /orders/{id}`
  Future<Order> order(String id);
}

class DefaultOrderTrackingServer implements OrderTrackingServer {
  DefaultOrderTrackingServer({required OrderRepository orderRepository})
      : _orders = orderRepository;

  final OrderRepository _orders;

  @override
  Future<Order> order(String id) => _orders.order(id);
}
