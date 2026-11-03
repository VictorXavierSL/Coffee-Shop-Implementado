import 'package:coffee_shop/scenes/launch/launch_coordinator.dart';
import 'package:coffee_shop/scenes/launch/launch_server.dart';
import 'package:coffee_shop/scenes/launch/launch_view_model.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fakes.dart';

/// Cena "invisível" (Launch): decide entre Onboarding e Home.
class FakeLaunchServer implements LaunchServer {
  FakeLaunchServer({required this.hasSession, this.error});

  @override
  final bool hasSession;
  final ApiException? error;
  bool discarded = false;

  @override
  Future<void> validateSession() async {
    if (error != null) throw error!;
  }

  @override
  Future<void> discardSession() async => discarded = true;
}

class FakeLaunchCoordinator implements LaunchCoordinator {
  String? destination;

  @override
  void goToHome() => destination = 'home';

  @override
  void goToOnboarding() => destination = 'onboarding';
}

void main() {
  LaunchViewModel make(FakeLaunchServer server, FakeLaunchCoordinator coordinator) =>
      LaunchViewModel(server: server, coordinator: coordinator, minimumSplash: Duration.zero);

  test('sem sessão salva → Onboarding', () async {
    final coordinator = FakeLaunchCoordinator();
    await make(FakeLaunchServer(hasSession: false), coordinator).start();
    expect(coordinator.destination, 'onboarding');
  });

  test('sessão válida → Home', () async {
    final coordinator = FakeLaunchCoordinator();
    await make(FakeLaunchServer(hasSession: true), coordinator).start();
    expect(coordinator.destination, 'home');
  });

  test('token expirado → descarta sessão e vai para Onboarding', () async {
    final server = FakeLaunchServer(hasSession: true, error: unauthorized);
    final coordinator = FakeLaunchCoordinator();
    await make(server, coordinator).start();
    expect(server.discarded, isTrue);
    expect(coordinator.destination, 'onboarding');
  });
}
