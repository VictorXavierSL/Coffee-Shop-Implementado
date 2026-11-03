import 'package:flutter/widgets.dart';

import '../../app/app_dependencies.dart';
import 'launch_coordinator.dart';
import 'launch_server.dart';
import 'launch_view.dart';
import 'launch_view_model.dart';

/// server = Server() → coordinator = Coordinator() →
/// viewModel = ViewModel(server, coordinator) → View(viewModel)
abstract final class LaunchFactory {
  static Widget make() {
    final deps = AppDependencies.instance;
    final server = DefaultLaunchServer(authRepository: deps.authRepository);
    final coordinator = DefaultLaunchCoordinator();
    final viewModel = LaunchViewModel(server: server, coordinator: coordinator);
    return LaunchView(viewModel: viewModel);
  }
}
