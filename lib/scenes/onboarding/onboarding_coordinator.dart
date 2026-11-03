import '../../app/app_navigator.dart';
import '../login/login_factory.dart';

abstract interface class OnboardingCoordinator {
  void goToLogin();
}

class DefaultOnboardingCoordinator implements OnboardingCoordinator {
  @override
  void goToLogin() => AppNavigator.push<void>(LoginFactory.make());
}
