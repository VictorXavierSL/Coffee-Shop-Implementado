import 'package:flutter/material.dart';

import 'action_button_view_model.dart';

/// Factory: centraliza TODAS as combinações válidas de botão do Figma.
///
/// Telas nunca montam um [ActionButtonViewModel] "na mão": pedem uma
/// variante pelo nome do papel que ela cumpre.
abstract final class ActionButtonFactory {
  /// Botão principal largo — "Get Started", "Buy Now", "Order", "Entrar".
  static ActionButtonViewModel primary({
    required String label,
    VoidCallback? onPressed,
    bool isEnabled = true,
    bool isLoading = false,
    bool expand = true,
  }) {
    return ActionButtonViewModel(
      label: label,
      onPressed: onPressed,
      isEnabled: isEnabled,
      isLoading: isLoading,
      expand: expand,
    );
  }

  /// Ação alternativa em superfície escura.
  static ActionButtonViewModel secondary({
    required String label,
    VoidCallback? onPressed,
    bool isEnabled = true,
    bool expand = true,
  }) {
    return ActionButtonViewModel(
      label: label,
      style: ActionButtonStyle.secondary,
      onPressed: onPressed,
      isEnabled: isEnabled,
      expand: expand,
    );
  }

  /// Pílula pequena com contorno — "Edit Address", "Add Note".
  static ActionButtonViewModel outline({
    required String label,
    IconData? icon,
    VoidCallback? onPressed,
  }) {
    return ActionButtonViewModel(
      label: label,
      icon: icon,
      style: ActionButtonStyle.outline,
      size: ActionButtonSize.small,
      onPressed: onPressed,
    );
  }

  /// Botão "+" do card de produto (32×32, raio 8).
  static ActionButtonViewModel addItem({VoidCallback? onPressed, bool isEnabled = true}) {
    return ActionButtonViewModel(
      icon: Icons.add_rounded,
      size: ActionButtonSize.small,
      onPressed: onPressed,
      isEnabled: isEnabled,
      semanticLabel: 'Adicionar ao carrinho',
    );
  }

  /// Botão de filtro ao lado da busca (52×52, raio 12).
  static ActionButtonViewModel filter({VoidCallback? onPressed}) {
    return ActionButtonViewModel(
      icon: Icons.tune_rounded,
      size: ActionButtonSize.large,
      onPressed: onPressed,
      semanticLabel: 'Filtrar',
    );
  }

  /// Voltar no cabeçalho.
  static ActionButtonViewModel back({VoidCallback? onPressed}) {
    return ActionButtonViewModel(
      icon: Icons.arrow_back_ios_new_rounded,
      style: ActionButtonStyle.ghost,
      size: ActionButtonSize.medium,
      onPressed: onPressed,
      semanticLabel: 'Voltar',
    );
  }

  /// Favoritar no cabeçalho do Detail.
  static ActionButtonViewModel favorite({
    required bool isFavorite,
    VoidCallback? onPressed,
  }) {
    return ActionButtonViewModel(
      icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
      style: ActionButtonStyle.ghost,
      size: ActionButtonSize.medium,
      onPressed: onPressed,
      semanticLabel: isFavorite ? 'Remover dos favoritos' : 'Favoritar',
    );
  }

  /// Ícone genérico sem fundo (ex.: sair, alternar tema).
  static ActionButtonViewModel ghostIcon({
    required IconData icon,
    required String semanticLabel,
    VoidCallback? onPressed,
  }) {
    return ActionButtonViewModel(
      icon: icon,
      style: ActionButtonStyle.ghost,
      size: ActionButtonSize.medium,
      onPressed: onPressed,
      semanticLabel: semanticLabel,
    );
  }

  /// Ícone sobre o cabeçalho escuro da Home (tema, sair).
  static ActionButtonViewModel heroIcon({
    required IconData icon,
    required String semanticLabel,
    VoidCallback? onPressed,
  }) {
    return ActionButtonViewModel(
      icon: icon,
      style: ActionButtonStyle.hero,
      size: ActionButtonSize.medium,
      onPressed: onPressed,
      semanticLabel: semanticLabel,
    );
  }
}
