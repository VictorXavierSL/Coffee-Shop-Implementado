import 'package:flutter/widgets.dart';

import '../../app/app_dependencies.dart';
import 'product_detail_coordinator.dart';
import 'product_detail_server.dart';
import 'product_detail_view.dart';
import 'product_detail_view_model.dart';

abstract final class ProductDetailFactory {
  static Widget make(String productId) {
    final deps = AppDependencies.instance;
    final server = DefaultProductDetailServer(catalogRepository: deps.catalogRepository);
    final coordinator = DefaultProductDetailCoordinator();
    final viewModel = ProductDetailViewModel(
      productId: productId,
      server: server,
      coordinator: coordinator,
      cartStore: deps.cartStore,
      favoritesStore: deps.favoritesStore,
    );
    return ProductDetailView(viewModel: viewModel);
  }
}
