import 'package:design_system/design_system.dart';

import '../../app/app_navigator.dart';
import '../order/order_factory.dart';

abstract interface class ProductDetailCoordinator {
  void back();
  void goToOrder();
  void showMessage(AppMessageViewModel message);
}

class DefaultProductDetailCoordinator implements ProductDetailCoordinator {
  @override
  void back() => AppNavigator.pop<void>();

  /// Substitui o Detail pelo Order: ao voltar do pedido, o usuário cai na Home.
  @override
  void goToOrder() => AppNavigator.replace(OrderFactory.make());

  @override
  void showMessage(AppMessageViewModel message) => AppNavigator.showAppMessage(message);
}
