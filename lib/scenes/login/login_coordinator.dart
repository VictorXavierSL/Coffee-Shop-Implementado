import 'package:design_system/design_system.dart';

import '../../app/app_navigator.dart';
import '../home/home_factory.dart';

abstract interface class LoginCoordinator {
  void goToHome();
  void showError(String message);
}

class DefaultLoginCoordinator implements LoginCoordinator {
  @override
  void goToHome() => AppNavigator.resetTo(HomeFactory.make());

  @override
  void showError(String message) => AppNavigator.showAppMessage(AppMessageFactory.error(message));
}
