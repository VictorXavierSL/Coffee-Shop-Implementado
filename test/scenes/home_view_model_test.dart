import 'package:coffee_shop/scenes/home/home_coordinator.dart';
import 'package:coffee_shop/scenes/home/home_server.dart';
import 'package:coffee_shop/scenes/home/home_view_model.dart';
import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

class FakeHomeServer implements HomeServer {
  final catalog = [
    testProduct(),
    testProduct(id: 'p_2', name: 'Americano', categoryId: 'americano'),
    testProduct(id: 'p_3', name: 'Iced Latte', isAvailable: false),
  ];
  String? lastCategoryId;
  ApiException? loadError;

  @override
  Future<HomeData> load() async {
    if (loadError != null) throw loadError!;
    return HomeData(
      user: testUser,
      categories: const [
        ProductCategory(id: 'latte', name: 'Latte'),
        ProductCategory(id: 'americano', name: 'Americano'),
      ],
      promotions: const [Promotion(id: 'p', tag: 'Promo', title: 'Leve 2, pague 1')],
      products: catalog,
    );
  }

  @override
  Future<List<Product>> products({String? categoryId, String? query}) async {
    lastCategoryId = categoryId;
    return catalog.where((p) => categoryId == null || p.categoryId == categoryId).toList();
  }

  @override
  Future<void> logout() async {}
}

class FakeHomeCoordinator implements HomeCoordinator {
  final events = <String>[];
  final messages = <AppMessageViewModel>[];

  @override
  void goToLogin() => events.add('login');

  @override
  void goToOrder() => events.add('order');

  @override
  void goToProductDetail(String productId) => events.add('detail:$productId');

  @override
  void showMessage(AppMessageViewModel message) => messages.add(message);
}

void main() {
  late FakeHomeServer server;
  late FakeHomeCoordinator coordinator;
  late CartStore cart;
  late HomeViewModel vm;

  setUp(() {
    server = FakeHomeServer();
    coordinator = FakeHomeCoordinator();
    cart = CartStore();
    vm = HomeViewModel(
      server: server,
      coordinator: coordinator,
      cartStore: cart,
      favoritesStore: FavoritesStore(),
      themeController: ThemeController(),
      searchDebounce: Duration.zero,
    );
  });

  test('carrega dados e monta os cards do Design System', () async {
    await vm.load();

    expect(vm.status, HomeStatus.ready);
    expect(vm.productCards, hasLength(3));
    expect(vm.productCards.first.priceLabel, r'$ 4.53');
    expect(vm.categoryTabs.labels, ['Todos', 'Latte', 'Americano']);
    expect(vm.promoBanner?.title, 'Leve 2, pague 1');
    expect(vm.locationLabel, 'Rua A, 10');
    expect(vm.contentState, isNull);
  });

  test('produto indisponível tem o botão + desabilitado', () async {
    await vm.load();
    expect(vm.productCards.last.isAddEnabled, isFalse);
  });

  test('sessão expirada leva ao login', () async {
    server.loadError = unauthorized;
    await vm.load();
    expect(coordinator.events, ['login']);
  });

  test('selecionar categoria recarrega os produtos filtrados', () async {
    await vm.load();
    vm.selectCategory(2);
    await Future<void>.delayed(Duration.zero);

    expect(server.lastCategoryId, 'americano');
    expect(vm.products.map((p) => p.name), ['Americano']);
  });

  test('"+" adiciona à sacola e atualiza o badge', () async {
    await vm.load();
    vm.addToCart(server.catalog.first);

    expect(cart.count, 1);
    expect(vm.bottomNav.items[CoffeeTab.bag.index].badgeCount, 1);
    expect(coordinator.messages.single.kind, AppMessageKind.success);
  });

  test('aba Sacola abre o pedido e card abre o detalhe', () async {
    await vm.load();
    vm.selectTab(CoffeeTab.bag);
    vm.openProduct(server.catalog.first);
    expect(coordinator.events, ['order', 'detail:p_1']);
  });
}
