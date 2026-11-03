import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Garante que o servidor mockado cumpre o contrato de `docs/API.md`.
void main() {
  late InMemorySessionStore session;
  late ApiClient api;
  late AuthRepository auth;

  setUp(() {
    session = InMemorySessionStore();
    api = AuthorizedApiClient(
      inner: MockApiClient(latency: Duration.zero),
      sessionStore: session,
    );
    auth = AuthRepository(api: api, sessionStore: session);
  });

  test('POST /auth/login com credenciais válidas salva a sessão', () async {
    final s = await auth.login(email: MockDatabase.demoEmail, password: MockDatabase.demoPassword);
    expect(s.token, isNotEmpty);
    expect(s.user.name, 'Ana Souza');
    expect(session.hasSession, isTrue);
  });

  test('POST /auth/login com senha errada → 401 invalid_credentials', () async {
    expect(
      () => auth.login(email: MockDatabase.demoEmail, password: 'errada'),
      throwsA(isA<ApiException>()
          .having((e) => e.statusCode, 'status', 401)
          .having((e) => e.code, 'code', 'invalid_credentials')),
    );
  });

  test('rota protegida sem token → 401 unauthorized', () async {
    expect(
      () => CatalogRepository(api: api).products(),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'unauthorized')),
    );
  });

  group('autenticado', () {
    setUp(() => auth.login(email: MockDatabase.demoEmail, password: MockDatabase.demoPassword));

    test('GET /products filtra por categoria e busca', () async {
      final catalog = CatalogRepository(api: api);
      final lattes = await catalog.products(categoryId: 'latte');
      expect(lattes.every((p) => p.categoryId == 'latte'), isTrue);

      final mocha = await catalog.products(query: 'mocha');
      expect(mocha.map((p) => p.name), containsAll(['Caffe Mocha', 'Mocha Fusi']));
    });

    test('GET /products/{id} inexistente → 404', () async {
      expect(
        () => CatalogRepository(api: api).product('nao_existe'),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 404)),
      );
    });

    test('POST /orders/quote reproduz os valores do Figma', () async {
      final mocha = await CatalogRepository(api: api).product('p_caffe_mocha');
      final summary = await OrderRepository(api: api).quote(
        deliveryType: DeliveryType.deliver,
        items: [CartItem(product: mocha, sizeCode: 'M', quantity: 1)],
      );
      expect(summary.subtotal, 4.53);
      expect(summary.deliveryFeeOriginal, 2.0);
      expect(summary.deliveryFee, 1.0);
      expect(summary.total, 5.53);
    });

    test('POST /orders e GET /orders/{id} avançam o status', () async {
      final mocha = await CatalogRepository(api: api).product('p_caffe_mocha');
      final orders = OrderRepository(api: api);
      final created = await orders.place(
        deliveryType: DeliveryType.deliver,
        items: [CartItem(product: mocha, sizeCode: 'L', quantity: 2)],
        paymentMethod: 'Dinheiro/Carteira',
        address: const Address(title: 'Rua A', line: 'Centro'),
      );
      expect(created.status, OrderStatus.placed);
      expect(created.summary.subtotal, closeTo((4.53 + 1) * 2, 0.001));

      expect((await orders.order(created.id)).status, OrderStatus.placed);
      expect((await orders.order(created.id)).status, OrderStatus.preparing);
    });

    test('POST /auth/logout invalida o token', () async {
      await auth.logout();
      expect(session.hasSession, isFalse);
    });
  });
}
