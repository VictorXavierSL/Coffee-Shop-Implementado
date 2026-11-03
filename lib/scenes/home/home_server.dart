import 'package:core/core.dart';

/// Tudo o que a Home precisa na primeira carga.
class HomeData {
  const HomeData({
    required this.user,
    required this.categories,
    required this.promotions,
    required this.products,
  });

  final User user;
  final List<ProductCategory> categories;
  final List<Promotion> promotions;
  final List<Product> products;
}

abstract interface class HomeServer {
  /// `GET /me` + `GET /categories` + `GET /promotions` + `GET /products`.
  Future<HomeData> load();

  /// `GET /products?categoryId=&q=`
  Future<List<Product>> products({String? categoryId, String? query});

  /// `POST /auth/logout`
  Future<void> logout();
}

class DefaultHomeServer implements HomeServer {
  DefaultHomeServer({
    required CatalogRepository catalogRepository,
    required AuthRepository authRepository,
  })  : _catalog = catalogRepository,
        _auth = authRepository;

  final CatalogRepository _catalog;
  final AuthRepository _auth;

  @override
  Future<HomeData> load() async {
    final user = _auth.currentUser ?? await _auth.me();
    final results = await Future.wait<Object>([
      _catalog.categories(),
      _catalog.promotions(),
      _catalog.products(),
    ]);
    return HomeData(
      user: user,
      categories: results[0] as List<ProductCategory>,
      promotions: results[1] as List<Promotion>,
      products: results[2] as List<Product>,
    );
  }

  @override
  Future<List<Product>> products({String? categoryId, String? query}) =>
      _catalog.products(categoryId: categoryId, query: query);

  @override
  Future<void> logout() => _auth.logout();
}
