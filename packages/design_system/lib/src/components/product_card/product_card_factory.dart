import 'package:flutter/widgets.dart';

import 'product_card_view_model.dart';

abstract final class ProductCardFactory {
  static ProductCardViewModel make({
    required String title,
    required String subtitle,
    required String priceLabel,
    required double rating,
    String? imageSource,
    VoidCallback? onTap,
    VoidCallback? onAdd,
  }) {
    return ProductCardViewModel(
      title: title,
      subtitle: subtitle,
      priceLabel: priceLabel,
      rating: rating,
      imageSource: imageSource,
      onTap: onTap,
      onAdd: onAdd,
    );
  }

  /// Produto indisponível: botão "+" desabilitado.
  static ProductCardViewModel unavailable({
    required String title,
    required String subtitle,
    required String priceLabel,
    required double rating,
    String? imageSource,
    VoidCallback? onTap,
  }) {
    return ProductCardViewModel(
      title: title,
      subtitle: subtitle,
      priceLabel: priceLabel,
      rating: rating,
      imageSource: imageSource,
      isAddEnabled: false,
      onTap: onTap,
    );
  }
}
