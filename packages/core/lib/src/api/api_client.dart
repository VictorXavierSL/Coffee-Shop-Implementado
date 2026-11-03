import 'package:flutter/foundation.dart';

import '../models/models.dart';

enum HttpMethod { get, post, put, delete }

/// Requisição no formato HTTP — o mesmo descrito em `docs/API.md`.
@immutable
class ApiRequest {
  const ApiRequest({
    required this.method,
    required this.path,
    this.query = const {},
    this.headers = const {},
    this.body,
  });

  final HttpMethod method;
  final String path;
  final Map<String, String> query;
  final Map<String, String> headers;
  final Json? body;

  ApiRequest withHeader(String name, String value) => ApiRequest(
        method: method,
        path: path,
        query: query,
        headers: {...headers, name: value},
        body: body,
      );

  @override
  String toString() => '${method.name.toUpperCase()} $path';
}

@immutable
class ApiResponse {
  const ApiResponse(this.statusCode, [this.body]);

  final int statusCode;
  final Json? body;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

/// Erro de API padronizado: `{ "error": { "code": "...", "message": "..." } }`.
class ApiException implements Exception {
  const ApiException({required this.statusCode, required this.code, required this.message});

  factory ApiException.fromResponse(ApiResponse response) {
    final error = response.body?['error'] as Json?;
    return ApiException(
      statusCode: response.statusCode,
      code: error?['code'] as String? ?? 'unknown_error',
      message: error?['message'] as String? ?? 'Erro inesperado (${response.statusCode}).',
    );
  }

  static const network = ApiException(
    statusCode: 0,
    code: 'network_error',
    message: 'Sem conexão. Verifique sua internet.',
  );

  final int statusCode;
  final String code;
  final String message;

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => 'ApiException($statusCode, $code): $message';
}

/// PROTOCOLO do servidor (Strategy).
///
/// O app inteiro depende só deste contrato. Hoje a implementação é o
/// [MockApiClient]; para usar um backend real basta criar um
/// `HttpApiClient implements ApiClient` e trocá-lo em `AppDependencies`.
abstract interface class ApiClient {
  Future<ApiResponse> send(ApiRequest request);
}

/// Atalhos de uso: `client.get('/products')`, `client.post('/auth/login', body)`.
extension ApiClientX on ApiClient {
  Future<Json?> get(String path, {Map<String, String> query = const {}}) =>
      _expect(ApiRequest(method: HttpMethod.get, path: path, query: query));

  Future<Json?> post(String path, [Json? body]) =>
      _expect(ApiRequest(method: HttpMethod.post, path: path, body: body));

  Future<Json?> put(String path, [Json? body]) =>
      _expect(ApiRequest(method: HttpMethod.put, path: path, body: body));

  Future<Json?> _expect(ApiRequest request) async {
    final ApiResponse response;
    try {
      response = await send(request);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException.network;
    }
    if (!response.isSuccess) throw ApiException.fromResponse(response);
    return response.body;
  }
}
