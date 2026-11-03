import 'package:flutter/widgets.dart';

import '../../app/app_dependencies.dart';
import 'login_coordinator.dart';
import 'login_server.dart';
import 'login_view.dart';
import 'login_view_model.dart';

abstract final class LoginFactory {
  static Widget make() {
    final deps = AppDependencies.instance;
    final server = DefaultLoginServer(authRepository: deps.authRepository);
    final coordinator = DefaultLoginCoordinator();
    final viewModel = LoginViewModel(server: server, coordinator: coordinator);
    return LoginView(viewModel: viewModel);
  }
}
