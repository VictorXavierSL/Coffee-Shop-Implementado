import '../session/session_store.dart';
import 'api_client.dart';

/// Decorator: acrescenta `Authorization: Bearer <token>` em toda requisição,
/// lendo o token salvo no [SessionStore]. Os repositórios não precisam
/// saber que existe autenticação.
class AuthorizedApiClient implements ApiClient {
  AuthorizedApiClient({required ApiClient inner, required SessionStore sessionStore})
      : _inner = inner,
        _sessionStore = sessionStore;

  final ApiClient _inner;
  final SessionStore _sessionStore;

  @override
  Future<ApiResponse> send(ApiRequest request) {
    final token = _sessionStore.token;
    final authorized =
        token == null ? request : request.withHeader('Authorization', 'Bearer $token');
    return _inner.send(authorized);
  }
}
