import 'package:flutter/widgets.dart';

import '../../app/app_dependencies.dart';
import 'home_coordinator.dart';
import 'home_server.dart';
import 'home_view.dart';
import 'home_view_model.dart';

abstract final class HomeFactory {
  static Widget make() {
    final deps = AppDependencies.instance;
    final server = DefaultHomeServer(
      catalogRepository: deps.catalogRepository,
      authRepository: deps.authRepository,
    );
    final coordinator = DefaultHomeCoordinator();
    final viewModel = HomeViewModel(
      server: server,
      coordinator: coordinator,
      cartStore: deps.cartStore,
      favoritesStore: deps.favoritesStore,
      themeController: deps.themeController,
    );
    return HomeView(viewModel: viewModel);
  }
}
