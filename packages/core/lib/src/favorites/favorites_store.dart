import 'package:flutter/foundation.dart';

/// Favoritos locais (ids de produto). Observer, como o [CartStore].
class FavoritesStore extends ChangeNotifier {
  final Set<String> _ids = {};

  Set<String> get ids => Set.unmodifiable(_ids);

  bool contains(String productId) => _ids.contains(productId);

  void toggle(String productId) {
    if (!_ids.remove(productId)) _ids.add(productId);
    notifyListeners();
  }
}
