import 'package:flutter/widgets.dart';

/// Estilo visual do botão de ação.
///
/// - [primary]   → sólido, cor de marca ("Get Started", "Buy Now", "Order", "+").
/// - [secondary] → sólido, superfície escura (ação alternativa).
/// - [outline]   → pílula com contorno ("Edit Address", "Add Note").
/// - [ghost]     → sem fundo (voltar e favoritar no cabeçalho).
/// - [hero]      → superfície do cabeçalho escuro da Home (mesma do campo de busca).
enum ActionButtonStyle { primary, secondary, outline, ghost, hero }

enum ActionButtonSize { small, medium, large }

/// Dados + estado de UM botão.
///
/// O clique é DELEGADO: o botão não sabe o que acontece ao ser tocado,
/// apenas chama [onPressed], que vem da ViewModel da cena.
@immutable
class ActionButtonViewModel {
  const ActionButtonViewModel({
    this.label,
    this.icon,
    this.style = ActionButtonStyle.primary,
    this.size = ActionButtonSize.large,
    this.isEnabled = true,
    this.isLoading = false,
    this.expand = false,
    this.onPressed,
    this.semanticLabel,
  }) : assert(label != null || icon != null, 'Informe label e/ou icon.');

  final String? label;
  final IconData? icon;
  final ActionButtonStyle style;
  final ActionButtonSize size;
  final bool isEnabled;
  final bool isLoading;

  /// Ocupa toda a largura disponível.
  final bool expand;
  final VoidCallback? onPressed;

  /// Texto para leitores de tela (obrigatório na prática para botões só de ícone).
  final String? semanticLabel;

  bool get isIconOnly => label == null;

  bool get isInteractive => isEnabled && !isLoading && onPressed != null;

  ActionButtonViewModel copyWith({
    String? label,
    IconData? icon,
    ActionButtonStyle? style,
    ActionButtonSize? size,
    bool? isEnabled,
    bool? isLoading,
    bool? expand,
    VoidCallback? onPressed,
    String? semanticLabel,
  }) {
    return ActionButtonViewModel(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      style: style ?? this.style,
      size: size ?? this.size,
      isEnabled: isEnabled ?? this.isEnabled,
      isLoading: isLoading ?? this.isLoading,
      expand: expand ?? this.expand,
      onPressed: onPressed ?? this.onPressed,
      semanticLabel: semanticLabel ?? this.semanticLabel,
    );
  }
}
