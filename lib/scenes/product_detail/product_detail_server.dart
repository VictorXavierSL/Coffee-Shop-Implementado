import 'package:core/core.dart';

abstract interface class ProductDetailServer {
  /// `GET /products/{id}`
  Future<Product> product(String id);
}

class DefaultProductDetailServer implements ProductDetailServer {
  DefaultProductDetailServer({required CatalogRepository catalogRepository})
      : _catalog = catalogRepository;

  final CatalogRepository _catalog;

  @override
  Future<Product> product(String id) => _catalog.product(id);
}
