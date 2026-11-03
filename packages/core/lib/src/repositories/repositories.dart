import '../api/api_client.dart';
import '../models/models.dart';
import '../session/session_store.dart';

/// Repository: traduz JSON da API em modelos de domínio. As cenas (Servers)
/// falam com repositórios, nunca com o [ApiClient] diretamente.

class AuthRepository {
  AuthRepository({required ApiClient api, required SessionStore sessionStore})
      : _api = api,
        _sessionStore = sessionStore;

  final ApiClient _api;
  final SessionStore _sessionStore;

  /// `POST /auth/login` — salva a sessão em caso de sucesso.
  Future<Session> login({required String email, required String password}) async {
    final json = await _api.post('/auth/login', {'email': email, 'password': password});
    final session = Session(
      token: json!['token'] as String,
      user: User.fromJson(json['user'] as Json),
    );
    _sessionStore.save(session);
    return session;
  }

  /// `GET /me` — valida o token salvo e devolve o usuário atual.
  Future<User> me() async {
    final json = await _api.get('/me');
    final user = User.fromJson(json!);
    _sessionStore.updateUser(user);
    return user;
  }

  /// `POST /auth/logout` — a sessão local é apagada mesmo se a API falhar.
  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } on ApiException {
      // Ignorado: o importante é limpar a sessão local.
    } finally {
      _sessionStore.clear();
    }
  }

  bool get hasSession => _sessionStore.hasSession;
  User? get currentUser => _sessionStore.user;
}

class CatalogRepository {
  CatalogRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  /// `GET /categories`
  Future<List<ProductCategory>> categories() async {
    final json = await _api.get('/categories');
    return _items(json).map(ProductCategory.fromJson).toList();
  }

  /// `GET /products?categoryId=&q=`
  Future<List<Product>> products({String? categoryId, String? query}) async {
    final json = await _api.get('/products', query: {
      if (categoryId != null) 'categoryId': categoryId,
      if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
    });
    return _items(json).map(Product.fromJson).toList();
  }

  /// `GET /products/{id}`
  Future<Product> product(String id) async {
    final json = await _api.get('/products/$id');
    return Product.fromJson(json!);
  }

  /// `GET /promotions`
  Future<List<Promotion>> promotions() async {
    final json = await _api.get('/promotions');
    return _items(json).map(Promotion.fromJson).toList();
  }
}

class OrderRepository {
  OrderRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  /// `POST /orders/quote` — calcula valores sem criar o pedido.
  Future<PriceSummary> quote({
    required DeliveryType deliveryType,
    required List<CartItem> items,
  }) async {
    final json = await _api.post('/orders/quote', {
      'deliveryType': deliveryType.apiValue,
      'items': items.map((i) => i.toOrderJson()).toList(),
    });
    return PriceSummary.fromJson(json!);
  }

  /// `POST /orders` — cria o pedido.
  Future<Order> place({
    required DeliveryType deliveryType,
    required List<CartItem> items,
    required String paymentMethod,
    Address? address,
  }) async {
    final json = await _api.post('/orders', {
      'deliveryType': deliveryType.apiValue,
      'paymentMethod': paymentMethod,
      if (address != null) 'address': address.toJson(),
      'items': items.map((i) => i.toOrderJson()).toList(),
    });
    return Order.fromJson(json!);
  }

  /// `GET /orders/{id}`
  Future<Order> order(String id) async {
    final json = await _api.get('/orders/$id');
    return Order.fromJson(json!);
  }
}

List<Json> _items(Json? json) => ((json?['items'] as List?) ?? const []).cast<Json>();
