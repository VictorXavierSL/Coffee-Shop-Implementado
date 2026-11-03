import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';

import '../../app/safe_change_notifier.dart';
import 'product_detail_coordinator.dart';
import 'product_detail_server.dart';

class ProductDetailViewModel extends ChangeNotifier with SafeChangeNotifier {
  ProductDetailViewModel({
    required this.productId,
    required ProductDetailServer server,
    required ProductDetailCoordinator coordinator,
    required CartStore cartStore,
    required FavoritesStore favoritesStore,
  })  : _server = server,
        _coordinator = coordinator,
        _cart = cartStore,
        _favorites = favoritesStore {
    _favorites.addListener(notifyListeners);
  }

  final String productId;
  final ProductDetailServer _server;
  final ProductDetailCoordinator _coordinator;
  final CartStore _cart;
  final FavoritesStore _favorites;

  Product? _product;
  String? _errorMessage;
  bool _isLoading = true;
  String _selectedSize = 'M';
  bool _isDescriptionExpanded = false;

  Product? get product => _product;
  bool get isLoading => _isLoading;
  String get selectedSize => _selectedSize;
  bool get isDescriptionExpanded => _isDescriptionExpanded;
  bool get isFavorite => _favorites.contains(productId);

  double get price => _product?.priceFor(_selectedSize) ?? 0;
  String get priceLabel => Formatters.money(price);

  // ------------------------------------------------------------- ações

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _product = await _server.product(productId);
      final sizes = _product!.sizes.map((s) => s.code);
      if (!sizes.contains(_selectedSize)) _selectedSize = sizes.first;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectSize(String code) {
    _selectedSize = code;
    notifyListeners();
  }

  void toggleDescription() {
    _isDescriptionExpanded = !_isDescriptionExpanded;
    notifyListeners();
  }

  void toggleFavorite() {
    _favorites.toggle(productId);
    _coordinator.showMessage(AppMessageFactory.info(
      isFavorite ? 'Salvo nos favoritos.' : 'Removido dos favoritos.',
    ));
  }

  void buyNow() {
    final p = _product;
    if (p == null || !p.isAvailable) return;
    _cart.add(p, sizeCode: _selectedSize);
    _coordinator.goToOrder();
  }

  void back() => _coordinator.back();

  // ------------------------------------- ViewModels dos componentes do DS

  TopBarViewModel get topBar => TopBarFactory.detail(
        title: 'Detalhes',
        isFavorite: isFavorite,
        onBack: back,
        onFavorite: toggleFavorite,
      );

  StateViewViewModel? get contentState {
    if (_isLoading) return StateViewFactory.loading;
    if (_errorMessage != null) return StateViewFactory.error(message: _errorMessage!, onRetry: load);
    return null;
  }

  List<FeatureBadgeViewModel> get features => [
        for (final code in _product?.features ?? const <String>[])
          if (FeatureBadgeFactory.fromCode(code) case final badge?) badge,
      ];

  List<SelectableChipViewModel> get sizeOptions => [
        for (final size in _product?.sizes ?? const <ProductSize>[])
          SelectableChipFactory.size(
            label: size.code,
            isSelected: size.code == _selectedSize,
            onSelected: () => selectSize(size.code),
          ),
      ];

  ActionButtonViewModel get buyButton {
    final available = _product?.isAvailable ?? false;
    return ActionButtonFactory.primary(
      label: available ? 'Comprar agora' : 'Indisponível',
      isEnabled: available,
      onPressed: buyNow,
    );
  }

  @override
  void dispose() {
    _favorites.removeListener(notifyListeners);
    super.dispose();
  }
}
