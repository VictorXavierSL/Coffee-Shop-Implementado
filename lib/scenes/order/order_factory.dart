import 'package:flutter/widgets.dart';

import '../../app/app_dependencies.dart';
import 'order_coordinator.dart';
import 'order_server.dart';
import 'order_view.dart';
import 'order_view_model.dart';

abstract final class OrderFactory {
  static Widget make() {
    final deps = AppDependencies.instance;
    final server = DefaultOrderServer(
      orderRepository: deps.orderRepository,
      authRepository: deps.authRepository,
    );
    final coordinator = DefaultOrderCoordinator();
    final viewModel = OrderViewModel(
      server: server,
      coordinator: coordinator,
      cartStore: deps.cartStore,
    );
    return OrderView(viewModel: viewModel);
  }
}
