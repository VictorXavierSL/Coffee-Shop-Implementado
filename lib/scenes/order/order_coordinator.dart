import 'package:design_system/design_system.dart';

import '../../app/app_navigator.dart';
import '../order_tracking/order_tracking_factory.dart';

abstract interface class OrderCoordinator {
  void back();
  void goToTracking(String orderId);
  void showMessage(AppMessageViewModel message);
}

class DefaultOrderCoordinator implements OrderCoordinator {
  @override
  void back() => AppNavigator.pop<void>();

  @override
  void goToTracking(String orderId) => AppNavigator.replace(OrderTrackingFactory.make(orderId));

  @override
  void showMessage(AppMessageViewModel message) => AppNavigator.showAppMessage(message);
}
