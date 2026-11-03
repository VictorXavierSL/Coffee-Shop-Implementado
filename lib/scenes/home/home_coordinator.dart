import 'package:design_system/design_system.dart';

import '../../app/app_navigator.dart';
import '../login/login_factory.dart';
import '../order/order_factory.dart';
import '../product_detail/product_detail_factory.dart';

abstract interface class HomeCoordinator {
  void goToProductDetail(String productId);
  void goToOrder();
  void goToLogin();
  void showMessage(AppMessageViewModel message);
}

class DefaultHomeCoordinator implements HomeCoordinator {
  @override
  void goToProductDetail(String productId) =>
      AppNavigator.push<void>(ProductDetailFactory.make(productId));

  @override
  void goToOrder() => AppNavigator.push<void>(OrderFactory.make());

  @override
  void goToLogin() => AppNavigator.resetTo(LoginFactory.make());

  @override
  void showMessage(AppMessageViewModel message) => AppNavigator.showAppMessage(message);
}
