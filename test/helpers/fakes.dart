import 'package:core/core.dart';

/// Dados de teste reutilizados pelos testes das cenas.
final testUser = User(
  id: 'u_test',
  name: 'Teste',
  email: 'teste@coffee.dev',
  memberSince: DateTime(2026, 1, 1),
  address: const Address(title: 'Rua A, 10', line: 'Centro, Palmas.'),
);

Product testProduct({
  String id = 'p_1',
  String name = 'Caffe Mocha',
  double medium = 4.53,
  String categoryId = 'latte',
  bool isAvailable = true,
}) {
  return Product(
    id: id,
    name: name,
    subtitle: 'Deep Foam',
    description: 'Descrição',
    categoryId: categoryId,
    rating: 4.8,
    reviewCount: 10,
    isAvailable: isAvailable,
    sizes: [
      ProductSize(code: 'S', price: medium - 0.5),
      ProductSize(code: 'M', price: medium),
      ProductSize(code: 'L', price: medium + 1),
    ],
  );
}

const unauthorized = ApiException(statusCode: 401, code: 'unauthorized', message: 'Sessão expirada.');
const invalidCredentials =
    ApiException(statusCode: 401, code: 'invalid_credentials', message: 'E-mail ou senha incorretos.');
