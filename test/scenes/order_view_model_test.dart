import 'package:coffee_shop/scenes/order/order_coordinator.dart';
import 'package:coffee_shop/scenes/order/order_server.dart';
import 'package:coffee_shop/scenes/order/order_view_model.dart';
import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

class FakeOrderServer implements OrderServer {
  final quotes = <DeliveryType>[];
  DeliveryType? placedType;

  @override
  Address? get defaultAddress => testUser.address;

  @override
  Future<PriceSummary> quote({required DeliveryType deliveryType, required List<CartItem> items}) async {
    quotes.add(deliveryType);
    final subtotal = items.fold<double>(0, (s, i) => s + i.total);
    final fee = deliveryType == DeliveryType.deliver ? 1.0 : 0.0;
    return PriceSummary(
      subtotal: subtotal,
      deliveryFee: fee,
      deliveryFeeOriginal: fee * 2,
      discount: fee,
      total: subtotal + fee,
      discountLabel: fee > 0 ? '1 desconto aplicado' : null,
    );
  }

  @override
  Future<Order> place({
    required DeliveryType deliveryType,
    required List<CartItem> items,
    required String paymentMethod,
    Address? address,
  }) async {
    placedType = deliveryType;
    return Order(
      id: 'ord_1',
      status: OrderStatus.placed,
      deliveryType: deliveryType,
      items: const [],
      summary: await quote(deliveryType: deliveryType, items: items),
      paymentMethod: paymentMethod,
      createdAt: DateTime(2026),
      estimatedMinutes: 10,
      address: address,
    );
  }
}

class FakeOrderCoordinator implements OrderCoordinator {
  final events = <String>[];

  @override
  void back() => events.add('back');

  @override
  void goToTracking(String orderId) => events.add('tracking:$orderId');

  @override
  void showMessage(AppMessageViewModel message) => events.add('message');
}

void main() {
  late FakeOrderServer server;
  late FakeOrderCoordinator coordinator;
  late CartStore cart;
  late OrderViewModel vm;

  setUp(() {
    server = FakeOrderServer();
    coordinator = FakeOrderCoordinator();
    cart = CartStore()..add(testProduct());
    vm = OrderViewModel(server: server, coordinator: coordinator, cartStore: cart);
  });

  test(r'resumo igual ao do Figma: $ 4.53 + entrega $ 1.00 (de $ 2.00)', () async {
    await vm.start();

    final rows = vm.summaryRows;
    expect(rows[0].value, r'$ 4.53');
    expect(rows[1].previousValue, r'$ 2.00');
    expect(rows[1].value, r'$ 1.00');
    expect(rows[2].value, r'$ 5.53');
    expect(vm.paymentTile.subtitle, r'$ 5.53');
    expect(vm.discountTile?.title, '1 desconto aplicado');
  });

  test('trocar para Retirar recalcula sem taxa de entrega', () async {
    await vm.start();
    vm.selectDeliveryType(1);
    await Future<void>.delayed(Duration.zero);

    expect(server.quotes.last, DeliveryType.pickUp);
    expect(vm.summaryRows.map((r) => r.label), ['Preço', 'Total']);
  });

  test('stepper altera o carrinho; chegar a zero esvazia a sacola', () async {
    await vm.start();
    final key = cart.items.single.key;

    vm.increment(key);
    expect(cart.count, 2);
    vm.decrement(key);
    vm.decrement(key);
    expect(vm.isEmpty, isTrue);
  });

  test('fazer pedido limpa o carrinho e abre o acompanhamento', () async {
    await vm.start();
    await vm.placeOrder();

    expect(server.placedType, DeliveryType.deliver);
    expect(cart.isEmpty, isTrue);
    expect(coordinator.events, contains('tracking:ord_1'));
  });
}
