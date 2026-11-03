import 'package:flutter/material.dart';

/// Escala de espaçamento (múltiplos de 4, como no Figma).
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Margem lateral padrão das telas (24 no Figma, telas de 375 → conteúdo de 327).
  static const EdgeInsets screen = EdgeInsets.symmetric(horizontal: lg);
}

/// Raios de borda usados no Figma.
abstract final class AppRadius {
  /// Abas de categoria.
  static const double xs = 6;

  /// Botão "+" do card, miniatura do carrinho.
  static const double sm = 8;

  /// Campo de busca, chip de tamanho, foto do card.
  static const double md = 12;

  /// Card de produto, botão principal, banner.
  static const double lg = 16;

  /// Cantos superiores da barra de navegação.
  static const double xl = 24;

  /// Pílula.
  static const double pill = 999;
}

/// Sombras.
abstract final class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> bottomBar = [
    BoxShadow(color: Color(0x14000000), blurRadius: 24, offset: Offset(0, -4)),
  ];
}

/// Durações de animação.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
}
