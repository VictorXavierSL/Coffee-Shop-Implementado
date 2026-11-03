import '../models/models.dart';

/// "Banco de dados" em memória do servidor mockado.
///
/// Os produtos, preços e textos vêm das telas do Figma
/// (Caffe Mocha $4.53, Flat White $3.53, Mocha Fusi $7.53, Caffe Panna $5.53).
class MockDatabase {
  MockDatabase();

  /// Usuário de demonstração.
  static const demoEmail = 'ana@coffee.dev';
  static const demoPassword = '123456';

  final List<Json> users = [
    {
      'id': 'u_1',
      'name': 'Ana Souza',
      'email': demoEmail,
      'password': demoPassword,
      'avatarUrl': null,
      'memberSince': '2026-03-14T10:00:00Z',
      'address': {
        'title': 'Jl. Kpg Sutoyo',
        'line': 'Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai.',
      },
    },
  ];

  /// token → userId
  final Map<String, String> tokens = {};

  final List<Json> categories = const [
    {'id': 'machiato', 'name': 'Machiato'},
    {'id': 'latte', 'name': 'Latte'},
    {'id': 'americano', 'name': 'Americano'},
  ];

  final List<Json> promotions = const [
    {
      'id': 'promo_bogo',
      'tag': 'Promo',
      'title': 'Leve 2, pague 1',
      'imageUrl': 'assets/images/banner.png',
    },
  ];

  static const _cappuccino =
      'A cappuccino is an approximately 150 ml (5 oz) beverage, with 25 ml of '
      'espresso coffee and 85ml of fresh milk the foam on top gives it its '
      'silky texture and the classic latte art finish.';

  static double _r2(double v) => (v * 100).roundToDouble() / 100;

  static List<Json> _sizes(double medium) => [
        {'code': 'S', 'price': _r2(medium - 0.5)},
        {'code': 'M', 'price': medium},
        {'code': 'L', 'price': _r2(medium + 1.0)},
      ];

  final List<Json> products = [
    {
      'id': 'p_caffe_mocha',
      'name': 'Caffe Mocha',
      'subtitle': 'Deep Foam',
      'description': _cappuccino,
      'categoryId': 'latte',
      'rating': 4.8,
      'reviewCount': 230,
      'imageUrl': 'assets/images/coffee_1.png',
      'sizes': _sizes(4.53),
      'features': ['fast_delivery', 'quality_bean', 'extra_milk'],
      'isAvailable': true,
    },
    {
      'id': 'p_flat_white',
      'name': 'Flat White',
      'subtitle': 'Espresso',
      'description': 'Espresso duplo com uma fina camada de leite vaporizado e microespuma aveludada.',
      'categoryId': 'latte',
      'rating': 4.8,
      'reviewCount': 184,
      'imageUrl': 'assets/images/coffee_2.png',
      'sizes': _sizes(3.53),
      'features': ['fast_delivery', 'quality_bean'],
      'isAvailable': true,
    },
    {
      'id': 'p_mocha_fusi',
      'name': 'Mocha Fusi',
      'subtitle': 'Ice/Hot',
      'description': 'Fusão de espresso, chocolate meio amargo e leite, servido quente ou gelado.',
      'categoryId': 'machiato',
      'rating': 4.8,
      'reviewCount': 97,
      'imageUrl': 'assets/images/coffee_3.png',
      'sizes': _sizes(7.53),
      'features': ['quality_bean', 'extra_milk'],
      'isAvailable': true,
    },
    {
      'id': 'p_caffe_panna',
      'name': 'Caffe Panna',
      'subtitle': 'Ice/Hot',
      'description': 'Espresso coberto com chantilly fresco — doce, intenso e cremoso.',
      'categoryId': 'americano',
      'rating': 4.8,
      'reviewCount': 121,
      'imageUrl': 'assets/images/coffee_4.png',
      'sizes': _sizes(5.53),
      'features': ['fast_delivery', 'extra_milk'],
      'isAvailable': true,
    },
    {
      'id': 'p_caramel_machiato',
      'name': 'Caramel Machiato',
      'subtitle': 'Caramel Drizzle',
      'description': 'Leite vaporizado com baunilha, marcado com espresso e finalizado com calda de caramelo.',
      'categoryId': 'machiato',
      'rating': 4.7,
      'reviewCount': 152,
      'imageUrl': 'assets/images/coffee_1.png',
      'sizes': _sizes(4.98),
      'features': ['quality_bean', 'extra_milk'],
      'isAvailable': true,
    },
    {
      'id': 'p_americano',
      'name': 'Americano',
      'subtitle': 'Long Black',
      'description': 'Espresso diluído em água quente: encorpado, aromático e sem leite.',
      'categoryId': 'americano',
      'rating': 4.6,
      'reviewCount': 88,
      'imageUrl': 'assets/images/coffee_2.png',
      'sizes': _sizes(3.20),
      'features': ['fast_delivery', 'quality_bean'],
      'isAvailable': true,
    },
    {
      'id': 'p_iced_latte',
      'name': 'Iced Latte',
      'subtitle': 'With Oat Milk',
      'description': 'Espresso sobre gelo com leite de aveia cremoso.',
      'categoryId': 'latte',
      'rating': 4.5,
      'reviewCount': 64,
      'imageUrl': 'assets/images/coffee_3.png',
      'sizes': _sizes(4.10),
      'features': ['extra_milk'],
      'isAvailable': false,
    },
  ];

  final Map<String, Json> _orders = {};
  int _tokenSeq = 0;
  int _orderSeq = 1000;

  Json? findUserByEmail(String email) {
    for (final u in users) {
      if (u['email'] == email) return u;
    }
    return null;
  }

  /// Dados públicos do usuário (sem senha).
  Json userJson(String id) {
    final u = users.firstWhere((u) => u['id'] == id);
    return {
      'id': u['id'],
      'name': u['name'],
      'email': u['email'],
      'avatarUrl': u['avatarUrl'],
      'memberSince': u['memberSince'],
      'address': u['address'],
    };
  }

  String issueToken(String userId) {
    final token = 'tok_${userId}_${++_tokenSeq}';
    tokens[token] = userId;
    return token;
  }

  Json? findProduct(String id) {
    for (final p in products) {
      if (p['id'] == id) return p;
    }
    return null;
  }

  Json createOrder({
    required String userId,
    required String deliveryType,
    required String paymentMethod,
    required List<Json> items,
    required Json summary,
    Json? address,
  }) {
    final id = 'ord_${++_orderSeq}';
    final isDelivery = deliveryType == DeliveryType.deliver.apiValue;
    final order = <String, dynamic>{
      'id': id,
      'userId': userId,
      'status': OrderStatus.placed.apiValue,
      'deliveryType': deliveryType,
      'address': isDelivery ? address : null,
      'paymentMethod': paymentMethod,
      'items': items,
      'summary': summary,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'estimatedMinutes': isDelivery ? 10 : 5,
      'courier': isDelivery ? {'name': 'Brooklyn Simmons', 'phone': '+62 812 0000 0000'} : null,
    };
    _orders[id] = order;
    return order;
  }

  final Map<String, int> _orderReads = {};

  /// Simula o andamento: a 1ª consulta devolve o pedido como criado; cada
  /// consulta seguinte avança uma etapa (placed → preparing → on_the_way → delivered).
  Json? advanceOrder(String id) {
    final order = _orders[id];
    if (order == null) return null;
    final reads = _orderReads[id] = (_orderReads[id] ?? 0) + 1;
    if (reads == 1) return order;
    final current = OrderStatus.fromApi(order['status'] as String);
    if (current != OrderStatus.delivered) {
      final next = OrderStatus.values[current.index + 1];
      order['status'] = next.apiValue;
      final minutes = (order['estimatedMinutes'] as int) - 3;
      order['estimatedMinutes'] = next == OrderStatus.delivered ? 0 : (minutes < 1 ? 1 : minutes);
    }
    return order;
  }
}
