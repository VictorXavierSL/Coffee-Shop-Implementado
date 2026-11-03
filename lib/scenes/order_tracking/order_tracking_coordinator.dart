import 'package:design_system/design_system.dart';

import '../../app/app_navigator.dart';
import '../home/home_factory.dart';

abstract interface class OrderTrackingCoordinator {
  void goToHome();
  void showMessage(AppMessageViewModel message);
}

class DefaultOrderTrackingCoordinator implements OrderTrackingCoordinator {
  @override
  void goToHome() => AppNavigator.resetTo(HomeFactory.make());

  @override
  void showMessage(AppMessageViewModel message) => AppNavigator.showAppMessage(message);
}
