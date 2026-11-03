import 'package:design_system/design_system.dart';

import 'onboarding_coordinator.dart';

class OnboardingViewModel {
  OnboardingViewModel({required OnboardingCoordinator coordinator}) : _coordinator = coordinator;

  final OnboardingCoordinator _coordinator;

  final String imageSource = 'assets/images/onboarding.png';
  final String title = 'Apaixone-se por café em puro deleite!';
  final String message =
      'Bem-vindo ao nosso cantinho do café, onde cada xícara é uma delícia feita para você.';

  ActionButtonViewModel get startButton =>
      ActionButtonFactory.primary(label: 'Começar', onPressed: getStarted);

  void getStarted() => _coordinator.goToLogin();
}
