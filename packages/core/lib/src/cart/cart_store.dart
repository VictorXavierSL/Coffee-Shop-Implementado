import 'package:flutter/foundation.dart';

import '../models/models.dart';

/// Carrinho compartilhado entre Home, Detail e Order.
///
/// Observer: é um `ChangeNotifier`; quem escuta (a barra inferior, a tela
/// Order) é avisado a cada mudança.
class CartStore extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  /// Quantidade total de unidades (badge da sacola).
  int get count => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);

  void add(Product product, {String sizeCode = 'M', int quantity = 1}) {
    final index = _items.indexWhere((i) => i.key == '${product.id}:$sizeCode');
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + quantity);
    } else {
      _items.add(CartItem(product: product, sizeCode: sizeCode, quantity: quantity));
    }
    notifyListeners();
  }

  void increment(String key) => _change(key, 1);

  /// Diminui 1; ao chegar a zero o item sai do carrinho.
  void decrement(String key) => _change(key, -1);

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void _change(String key, int delta) {
    final index = _items.indexWhere((i) => i.key == key);
    if (index < 0) return;
    final quantity = _items[index].quantity + delta;
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = _items[index].copyWith(quantity: quantity);
    }
    notifyListeners();
  }
}
