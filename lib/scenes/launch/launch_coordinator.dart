import '../../app/app_navigator.dart';
import '../home/home_factory.dart';
import '../onboarding/onboarding_factory.dart';

abstract interface class LaunchCoordinator {
  void goToOnboarding();
  void goToHome();
}

class DefaultLaunchCoordinator implements LaunchCoordinator {
  @override
  void goToOnboarding() => AppNavigator.resetTo(OnboardingFactory.make());

  @override
  void goToHome() => AppNavigator.resetTo(HomeFactory.make());
}
