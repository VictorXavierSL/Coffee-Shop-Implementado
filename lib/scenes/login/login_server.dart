import 'package:core/core.dart';

/// Protocolo do servidor da cena de login.
abstract interface class LoginServer {
  /// `POST /auth/login`. Lança [ApiException] em caso de erro.
  Future<User> login({required String email, required String password});
}

class DefaultLoginServer implements LoginServer {
  DefaultLoginServer({required AuthRepository authRepository}) : _auth = authRepository;

  final AuthRepository _auth;

  @override
  Future<User> login({required String email, required String password}) async {
    final session = await _auth.login(email: email, password: password);
    return session.user;
  }
}
