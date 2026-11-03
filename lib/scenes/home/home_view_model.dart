import 'dart:async';

import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../app/safe_change_notifier.dart';
import 'home_coordinator.dart';
import 'home_server.dart';

enum HomeStatus { loading, ready, error }

class HomeViewModel extends ChangeNotifier with SafeChangeNotifier {
  HomeViewModel({
    required HomeServer server,
    required HomeCoordinator coordinator,
    required CartStore cartStore,
    required FavoritesStore favoritesStore,
    required ThemeController themeController,
    this.searchDebounce = const Duration(milliseconds: 300),
  })  : _server = server,
        _coordinator = coordinator,
        _cart = cartStore,
        _favorites = favoritesStore,
        _theme = themeController {
    _cart.addListener(notifyListeners);
    _favorites.addListener(notifyListeners);
    _theme.addListener(notifyListeners);
  }

  final HomeServer _server;
  final HomeCoordinator _coordinator;
  final CartStore _cart;
  final FavoritesStore _favorites;
  final ThemeController _theme;
  final Duration searchDebounce;

  HomeStatus _status = HomeStatus.loading;
  String _errorMessage = '';
  User? _user;
  List<ProductCategory> _categories = const [];
  Promotion? _promotion;
  List<Product> _products = const [];
  int _selectedCategory = 0;
  String _query = '';
  CoffeeTab _tab = CoffeeTab.home;
  bool _isRefreshing = false;
  Timer? _debounce;
  int _requestId = 0;

  HomeStatus get status => _status;
  bool get isRefreshing => _isRefreshing;
  CoffeeTab get tab => _tab;
  String get query => _query;
  List<Product> get products => _products;

  List<Product> get visibleProducts => _tab == CoffeeTab.favorites
      ? _products.where((p) => _favorites.contains(p.id)).toList()
      : _products;

  String get locationLabel => _user?.address?.title ?? 'Definir endereço';

  String? get _selectedCategoryId =>
      _selectedCategory == 0 ? null : _categories[_selectedCategory - 1].id;

  // ------------------------------------------------------------- ações

  Future<void> load() async {
    _status = HomeStatus.loading;
    notifyListeners();
    try {
      final data = await _server.load();
      _user = data.user;
      _categories = data.categories;
      _promotion = data.promotions.isEmpty ? null : data.promotions.first;
      _products = data.products;
      _status = HomeStatus.ready;
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        _coordinator.goToLogin();
        return;
      }
      _errorMessage = e.message;
      _status = HomeStatus.error;
    }
    notifyListeners();
  }

  void selectCategory(int index) {
    if (index == _selectedCategory) return;
    _selectedCategory = index;
    notifyListeners();
    _reloadProducts();
  }

  void onSearchChanged(String value) {
    _query = value;
    _debounce?.cancel();
    _debounce = Timer(searchDebounce, _reloadProducts);
  }

  void openProduct(Product product) => _coordinator.goToProductDetail(product.id);

  void addToCart(Product product) {
    if (!product.isAvailable) {
      _coordinator.showMessage(AppMessageFactory.error('${product.name} está indisponível.'));
      return;
    }
    _cart.add(product);
    _coordinator.showMessage(AppMessageFactory.success('${product.name} (M) adicionado à sacola.'));
  }

  void selectTab(CoffeeTab tab) {
    switch (tab) {
      case CoffeeTab.bag:
        _coordinator.goToOrder();
      case CoffeeTab.notifications:
        _coordinator.showMessage(AppMessageFactory.info('Nenhuma notificação por enquanto.'));
      case CoffeeTab.home:
      case CoffeeTab.favorites:
        _tab = tab;
        notifyListeners();
    }
  }

  void openFilters() => _coordinator.showMessage(
        AppMessageFactory.info('Filtros avançados chegam na próxima versão.'),
      );

  void toggleTheme() => _theme.toggle();

  Future<void> logout() async {
    await _server.logout();
    _cart.clear();
    _coordinator.goToLogin();
  }

  Future<void> _reloadProducts() async {
    final requestId = ++_requestId;
    _isRefreshing = true;
    notifyListeners();
    try {
      final list = await _server.products(categoryId: _selectedCategoryId, query: _query);
      if (requestId == _requestId) _products = list;
    } on ApiException catch (e) {
      _coordinator.showMessage(AppMessageFactory.error(e.message));
    } finally {
      if (requestId == _requestId) {
        _isRefreshing = false;
        notifyListeners();
      }
    }
  }

  // ------------------------------------- ViewModels dos componentes do DS

  late final AppTextFieldViewModel searchField =
      AppTextFieldFactory.search(onChanged: onSearchChanged);

  ActionButtonViewModel get filterButton => ActionButtonFactory.filter(onPressed: openFilters);

  ActionButtonViewModel get themeButton => ActionButtonFactory.heroIcon(
        icon: _theme.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        semanticLabel: _theme.isDark ? 'Usar tema claro' : 'Usar tema escuro',
        onPressed: toggleTheme,
      );

  ActionButtonViewModel get logoutButton => ActionButtonFactory.heroIcon(
        icon: Icons.logout_rounded,
        semanticLabel: 'Sair da conta',
        onPressed: logout,
      );

  PromoBannerViewModel? get promoBanner => _promotion == null
      ? null
      : PromoBannerFactory.make(
          tag: _promotion!.tag,
          title: _promotion!.title,
          imageSource: _promotion!.imageUrl,
        );

  CategoryTabsViewModel get categoryTabs => CategoryTabsFactory.make(
        labels: ['Todos', ..._categories.map((c) => c.name)],
        selectedIndex: _selectedCategory,
        onSelected: selectCategory,
      );

  List<ProductCardViewModel> get productCards => [
        for (final p in visibleProducts)
          p.isAvailable
              ? ProductCardFactory.make(
                  title: p.name,
                  subtitle: p.subtitle,
                  priceLabel: Formatters.money(p.displayPrice),
                  rating: p.rating,
                  imageSource: p.imageUrl,
                  onTap: () => openProduct(p),
                  onAdd: () => addToCart(p),
                )
              : ProductCardFactory.unavailable(
                  title: p.name,
                  subtitle: 'Indisponível',
                  priceLabel: Formatters.money(p.displayPrice),
                  rating: p.rating,
                  imageSource: p.imageUrl,
                  onTap: () => openProduct(p),
                ),
      ];

  BottomNavBarViewModel get bottomNav => BottomNavBarFactory.coffeeShop(
        selected: _tab,
        bagCount: _cart.count,
        onSelected: selectTab,
      );

  /// `null` quando há produtos para mostrar.
  StateViewViewModel? get contentState {
    if (_status == HomeStatus.loading) return StateViewFactory.loading;
    if (_status == HomeStatus.error) {
      return StateViewFactory.error(message: _errorMessage, onRetry: load);
    }
    if (visibleProducts.isNotEmpty) return null;
    return _tab == CoffeeTab.favorites
        ? StateViewFactory.empty(
            title: 'Nenhum favorito ainda',
            message: 'Toque no coração na página de um café para salvá-lo aqui.',
          )
        : StateViewFactory.empty(
            title: 'Nenhum café encontrado',
            message: 'Tente outra categoria ou outro termo de busca.',
          );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _cart.removeListener(notifyListeners);
    _favorites.removeListener(notifyListeners);
    _theme.removeListener(notifyListeners);
    super.dispose();
  }
}
