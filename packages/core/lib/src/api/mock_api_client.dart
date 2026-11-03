import 'dart:convert';

import '../models/models.dart';
import 'api_client.dart';
import 'mock_database.dart';

/// Servidor MOCKADO que implementa o protocolo [ApiClient].
///
/// Responde exatamente como o backend descrito em `docs/API.md`: mesmos
/// caminhos, códigos HTTP e corpos JSON. Cada resposta passa por
/// `jsonEncode`/`jsonDecode` para simular a serialização da rede.
class MockApiClient implements ApiClient {
  MockApiClient({
    MockDatabase? database,
    this.latency = const Duration(milliseconds: 450),
  }) : _db = database ?? MockDatabase();

  final MockDatabase _db;
  final Duration latency;

  @override
  Future<ApiResponse> send(ApiRequest request) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    final response = _route(request);
    final body = response.body == null ? null : jsonDecode(jsonEncode(response.body)) as Json;
    return ApiResponse(response.statusCode, body);
  }

  ApiResponse _route(ApiRequest r) {
    final segments = r.path.split('/').where((s) => s.isNotEmpty).toList();
    final route = '${r.method.name.toUpperCase()} /${segments.join('/')}';

    // Rotas públicas
    if (route == 'POST /auth/login') return _login(r.body ?? const {});

    // Rotas autenticadas
    final userId = _authenticate(r);
    if (userId == null) {
      return _error(401, 'unauthorized', 'Sessão expirada. Faça login novamente.');
    }

    return switch ((r.method, segments)) {
      (HttpMethod.post, ['auth', 'logout']) => _logout(r),
      (HttpMethod.get, ['me']) => ApiResponse(200, _db.userJson(userId)),
      (HttpMethod.get, ['categories']) => ApiResponse(200, {'items': _db.categories}),
      (HttpMethod.get, ['products']) => _products(r.query),
      (HttpMethod.get, ['products', final id]) => _product(id),
      (HttpMethod.get, ['promotions']) => ApiResponse(200, {'items': _db.promotions}),
      (HttpMethod.post, ['orders', 'quote']) => _quote(r.body ?? const {}),
      (HttpMethod.post, ['orders']) => _createOrder(userId, r.body ?? const {}),
      (HttpMethod.get, ['orders', final id]) => _getOrder(userId, id),
      _ => _error(404, 'not_found', 'Rota não encontrada: $route'),
    };
  }

  // ---------------------------------------------------------------- auth

  String? _authenticate(ApiRequest r) {
    final header = r.headers['Authorization'];
    if (header == null || !header.startsWith('Bearer ')) return null;
    return _db.tokens[header.substring(7)];
  }

  ApiResponse _login(Json body) {
    final email = (body['email'] as String? ?? '').trim().toLowerCase();
    final password = body['password'] as String? ?? '';
    if (email.isEmpty || password.isEmpty) {
      return _error(400, 'validation_error', 'E-mail e senha são obrigatórios.');
    }
    final user = _db.findUserByEmail(email);
    if (user == null || user['password'] != password) {
      return _error(401, 'invalid_credentials', 'E-mail ou senha incorretos.');
    }
    final token = _db.issueToken(user['id'] as String);
    return ApiResponse(200, {'token': token, 'user': _db.userJson(user['id'] as String)});
  }

  ApiResponse _logout(ApiRequest r) {
    _db.tokens.remove(r.headers['Authorization']!.substring(7));
    return const ApiResponse(204);
  }

  // ------------------------------------------------------------- catalog

  ApiResponse _products(Map<String, String> query) {
    final categoryId = query['categoryId'];
    final q = query['q']?.toLowerCase();
    final items = _db.products.where((p) {
      final matchesCategory = categoryId == null || p['categoryId'] == categoryId;
      final matchesQuery = q == null ||
          (p['name'] as String).toLowerCase().contains(q) ||
          (p['subtitle'] as String).toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
    return ApiResponse(200, {'items': items});
  }

  ApiResponse _product(String id) {
    final product = _db.findProduct(id);
    return product == null
        ? _error(404, 'product_not_found', 'Produto não encontrado.')
        : ApiResponse(200, product);
  }

  // -------------------------------------------------------------- orders

  /// Valida itens e calcula valores. Retorna o erro ou o resumo.
  (ApiResponse? error, Json summary, List<Json> lines) _price(Json body) {
    final rawItems = (body['items'] as List? ?? const []).cast<Json>();
    if (rawItems.isEmpty) {
      return (_error(400, 'empty_cart', 'Adicione ao menos um item.'), const {}, const []);
    }
    final lines = <Json>[];
    var subtotal = 0.0;
    for (final item in rawItems) {
      final product = _db.findProduct(item['productId'] as String? ?? '');
      final quantity = item['quantity'] as int? ?? 0;
      if (product == null || quantity <= 0) {
        return (_error(422, 'invalid_item', 'Item inválido no pedido.'), const {}, const []);
      }
      final size = item['size'] as String? ?? 'M';
      final sizes = (product['sizes'] as List).cast<Json>();
      final match = sizes.where((s) => s['code'] == size);
      if (match.isEmpty) {
        return (_error(422, 'invalid_size', 'Tamanho indisponível.'), const {}, const []);
      }
      final unitPrice = (match.first['price'] as num).toDouble();
      subtotal += unitPrice * quantity;
      lines.add({
        'productId': product['id'],
        'name': product['name'],
        'size': size,
        'quantity': quantity,
        'unitPrice': unitPrice,
      });
    }

    final isDelivery = body['deliveryType'] != DeliveryType.pickUp.apiValue;
    final feeOriginal = isDelivery ? 2.0 : 0.0;
    final fee = isDelivery ? 1.0 : 0.0;
    double r2(double v) => (v * 100).roundToDouble() / 100;

    return (
      null,
      {
        'subtotal': r2(subtotal),
        'deliveryFeeOriginal': feeOriginal,
        'deliveryFee': fee,
        'discount': r2(feeOriginal - fee),
        'discountLabel': isDelivery ? '1 desconto aplicado' : null,
        'total': r2(subtotal + fee),
      },
      lines,
    );
  }

  ApiResponse _quote(Json body) {
    final (error, summary, _) = _price(body);
    return error ?? ApiResponse(200, summary);
  }

  ApiResponse _createOrder(String userId, Json body) {
    final (error, summary, lines) = _price(body);
    if (error != null) return error;

    final isDelivery = body['deliveryType'] != DeliveryType.pickUp.apiValue;
    if (isDelivery && body['address'] == null) {
      return _error(422, 'address_required', 'Informe o endereço de entrega.');
    }
    final order = _db.createOrder(
      userId: userId,
      deliveryType: isDelivery ? DeliveryType.deliver.apiValue : DeliveryType.pickUp.apiValue,
      address: body['address'] as Json?,
      paymentMethod: body['paymentMethod'] as String? ?? 'Dinheiro/Carteira',
      items: lines,
      summary: summary,
    );
    return ApiResponse(201, order);
  }

  ApiResponse _getOrder(String userId, String id) {
    final order = _db.advanceOrder(id);
    if (order == null || order['userId'] != userId) {
      return _error(404, 'order_not_found', 'Pedido não encontrado.');
    }
    return ApiResponse(200, order);
  }

  ApiResponse _error(int status, String code, String message) =>
      ApiResponse(status, {'error': {'code': code, 'message': message}});
}
