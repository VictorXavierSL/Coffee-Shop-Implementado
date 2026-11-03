import '../models/models.dart';

/// Guarda a sessão do usuário logado.
///
/// Contrato (interface) para poder trocar a implementação: em memória hoje,
/// `shared_preferences` / `flutter_secure_storage` num app de produção.
abstract interface class SessionStore {
  String? get token;
  User? get user;
  bool get hasSession;

  void save(Session session);
  void updateUser(User user);

  /// Logout: apaga tudo; o login é reconstruído do zero.
  void clear();
}

/// Implementação em memória: um dicionário acessado por uma "chave salva".
///
/// É o mecanismo visto em aula: se a chave [sessionKey] existe no
/// dicionário, o login já foi feito e o app vai direto para a Home.
class InMemorySessionStore implements SessionStore {
  static const sessionKey = 'coffee.session';

  final Map<String, Session> _storage = {};

  Session? get _session => _storage[sessionKey];

  @override
  String? get token => _session?.token;

  @override
  User? get user => _session?.user;

  @override
  bool get hasSession => _storage.containsKey(sessionKey);

  @override
  void save(Session session) => _storage[sessionKey] = session;

  @override
  void updateUser(User user) {
    final current = _session;
    if (current != null) _storage[sessionKey] = Session(token: current.token, user: user);
  }

  @override
  void clear() => _storage.remove(sessionKey);
}
