import 'package:flutter/widgets.dart';

import '../../app/app_dependencies.dart';
import 'order_tracking_coordinator.dart';
import 'order_tracking_server.dart';
import 'order_tracking_view.dart';
import 'order_tracking_view_model.dart';

abstract final class OrderTrackingFactory {
  static Widget make(String orderId) {
    final deps = AppDependencies.instance;
    final server = DefaultOrderTrackingServer(orderRepository: deps.orderRepository);
    final coordinator = DefaultOrderTrackingCoordinator();
    final viewModel = OrderTrackingViewModel(
      orderId: orderId,
      server: server,
      coordinator: coordinator,
    );
    return OrderTrackingView(viewModel: viewModel);
  }
}
