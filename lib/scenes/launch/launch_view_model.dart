import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

import 'launch_coordinator.dart';
import 'launch_server.dart';

/// "Tela invisível": não tem interação. Só decide para onde o app vai.
///
/// - Há sessão salva e o token é válido → Home.
/// - Não há sessão, ou o token expirou → Onboarding (e depois Login).
class LaunchViewModel extends ChangeNotifier {
  LaunchViewModel({
    required LaunchServer server,
    required LaunchCoordinator coordinator,
    this.minimumSplash = const Duration(milliseconds: 700),
  })  : _server = server,
        _coordinator = coordinator;

  final LaunchServer _server;
  final LaunchCoordinator _coordinator;
  final Duration minimumSplash;

  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    final splash = Future<void>.delayed(minimumSplash);
    final goHome = await _resolveSession();
    await splash;

    goHome ? _coordinator.goToHome() : _coordinator.goToOnboarding();
  }

  Future<bool> _resolveSession() async {
    if (!_server.hasSession) return false;
    try {
      await _server.validateSession();
      return true;
    } on ApiException {
      await _server.discardSession();
      return false;
    }
  }
}
