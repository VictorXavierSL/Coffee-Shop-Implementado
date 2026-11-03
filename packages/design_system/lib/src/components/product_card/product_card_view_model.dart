import 'package:flutter/widgets.dart';

/// Card de produto da grade da Home (156×238 no Figma).
@immutable
class ProductCardViewModel {
  const ProductCardViewModel({
    required this.title,
    required this.subtitle,
    required this.priceLabel,
    required this.rating,
    this.imageSource,
    this.isAddEnabled = true,
    this.onTap,
    this.onAdd,
  });

  final String title;
  final String subtitle;

  /// Preço JÁ formatado ("$ 4.53"). Formatar é papel da ViewModel da cena.
  final String priceLabel;
  final double rating;
  final String? imageSource;
  final bool isAddEnabled;

  /// Abre o detalhe.
  final VoidCallback? onTap;

  /// Botão "+": adiciona ao carrinho.
  final VoidCallback? onAdd;
}
