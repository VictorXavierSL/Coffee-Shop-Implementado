import 'package:core/core.dart';

abstract interface class LaunchServer {
  /// Existe uma sessão salva (a "chave salva")?
  bool get hasSession;

  /// Confirma com a API que o token ainda vale (`GET /me`).
  Future<void> validateSession();

  /// Apaga a sessão local inválida.
  Future<void> discardSession();
}

class DefaultLaunchServer implements LaunchServer {
  DefaultLaunchServer({required AuthRepository authRepository}) : _auth = authRepository;

  final AuthRepository _auth;

  @override
  bool get hasSession => _auth.hasSession;

  @override
  Future<void> validateSession() => _auth.me();

  @override
  Future<void> discardSession() => _auth.logout();
}
