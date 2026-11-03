import 'package:flutter/widgets.dart';

/// Linha clicável com ícone, texto e seta.
/// Figma: "1 Discount is Applies" (com borda) e "Cash/Wallet" (sem borda).
@immutable
class ActionTileViewModel {
  const ActionTileViewModel({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailingIcon,
    this.isBordered = true,
    this.onTap,
  });

  final IconData icon;
  final String title;

  /// Destacado na cor de marca (ex.: "$ 5.53").
  final String? subtitle;
  final IconData? trailingIcon;
  final bool isBordered;
  final VoidCallback? onTap;
}
