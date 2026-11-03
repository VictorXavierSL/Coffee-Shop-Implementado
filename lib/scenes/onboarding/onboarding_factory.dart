import 'package:flutter/widgets.dart';

import 'onboarding_coordinator.dart';
import 'onboarding_view.dart';
import 'onboarding_view_model.dart';

/// Cena sem Server: o onboarding não busca dados, só navega.
abstract final class OnboardingFactory {
  static Widget make() {
    final coordinator = DefaultOnboardingCoordinator();
    final viewModel = OnboardingViewModel(coordinator: coordinator);
    return OnboardingView(viewModel: viewModel);
  }
}
